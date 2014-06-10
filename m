Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaFJTv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:51:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35265 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbaFJTvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:51:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 103/160] ASoC: dapm: Fix widget double free with auto-disable DAPM kcontrol
Date: Tue, 10 Jun 2014 12:45:43 -0700
Message-Id: <1402429600-20477-104-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

commit 2697e4fb9209dfe1d1b24c92d254158f63d4bc8e upstream.

Commit 9e1fda4ae158 ("ASoC: dapm: Implement mixer input auto-disable")
is trying to free the widget it allocated by snd_soc_dapm_new_control()
call in dapm_kcontrol_data_alloc() by adding kfree(data->widget) to
dapm_kcontrol_free().

This is causing a widget double free with auto-disabled DAPM kcontrols
in sound card unregistration because widgets are already freed before
dapm_kcontrol_free() is called.

Reason for that is all widgets are added into dapm->card->widgets list
in snd_soc_dapm_new_control() and freed in dapm_free_widgets() during
execution of snd_soc_dapm_free().

Now snd_soc_dapm_free() calls for different DAPM contexts happens before
snd_card_free() call from where the call chain to dapm_kcontrol_free()
begins:

soc_cleanup_card_resources()
  soc_remove_dai_links()
    soc_remove_link_dais()
      snd_soc_dapm_free(&cpu_dai->dapm)
    soc_remove_link_components()
      soc_remove_platform()
        snd_soc_dapm_free(&platform->dapm)
      soc_remove_codec()
        snd_soc_dapm_free(&codec->dapm)
  snd_soc_dapm_free(&card->dapm)
  snd_card_free()
    snd_card_do_free()
      snd_device_free_all()
        snd_device_free()
          snd_ctl_dev_free()
            snd_ctl_remove()
              snd_ctl_free_one()
                dapm_kcontrol_free()

This wasn't making harm with ordinary DAPM kcontrols since data->widget is NULL for
them.

Fixes: 9e1fda4ae158 (ASoC: dapm: Implement mixer input auto-disable)
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/soc-dapm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index dcade13..2e6f4ec 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -251,7 +251,6 @@ static int dapm_kcontrol_data_alloc(struct snd_soc_dapm_widget *widget,
 static void dapm_kcontrol_free(struct snd_kcontrol *kctl)
 {
 	struct dapm_kcontrol_data *data = snd_kcontrol_chip(kctl);
-	kfree(data->widget);
 	kfree(data->wlist);
 	kfree(data);
 }
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbaEMJaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:30:22 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60781 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759958AbaEMJ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:29:13 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 139/182] ASoC: dapm: Fix widget double free with auto-disable DAPM kcontrol
Date: Tue, 13 May 2014 11:28:11 +0200
Message-Id: <2aef6e4bbb69ea1e5010e06f665cccbf7991df81.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/soc-dapm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index b2949aed1ac2..4136cc25154e 100644
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
1.9.3


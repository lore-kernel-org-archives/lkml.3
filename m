Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbaEKTWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:22:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbaEKTWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:22:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 23/83] ASoC: dapm: Fix widget double free with auto-disable DAPM kcontrol
Date: Sun, 11 May 2014 21:19:24 +0200
Message-Id: <20140511191910.210736188@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -251,7 +251,6 @@ static int dapm_kcontrol_data_alloc(stru
 static void dapm_kcontrol_free(struct snd_kcontrol *kctl)
 {
 	struct dapm_kcontrol_data *data = snd_kcontrol_chip(kctl);
-	kfree(data->widget);
 	kfree(data->wlist);
 	kfree(data);
 }



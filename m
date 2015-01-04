Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbbADNjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 08:39:13 -0500
Received: from mout.web.de ([212.227.15.14]:64917 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbbADNjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 08:39:11 -0500
Message-ID: <54A9425E.1030107@users.sourceforge.net>
Date: Sun, 04 Jan 2015 14:38:38 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 12/13] ALSA: msnd: One function call less in snd_msnd_attach()
 after error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A9355F.4050102@users.sourceforge.net>
In-Reply-To: <54A9355F.4050102@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:RAgZNG8SfkNrYQCajHW7QHmGF6OrQm0gZqOcT6dMy0FyHwasoCG
 g6dZwuBBREJIVOl/rYYpySO0cm1mDGtnEX1uVx/ApSeanc/7PEuplRJLCO2y6D4dbQbzbzL
 hY318xUujAN3cEyb5J4YeAd8/RRcqdLy5MHaIjrSQEt/cPLP3PXjDn1uepiHQrRjdrFF/VP
 TshV6V4iLcbu8hwEPGg0g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 4 Jan 2015 11:00:11 +0100

The iounmap() function was called in one case by the snd_msnd_attach() function
even if a previous call of the ioremap_nocache() function failed.

This implementation detail could be improved by the introduction of another
jump label.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/isa/msnd/msnd_pinnacle.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/sound/isa/msnd/msnd_pinnacle.c b/sound/isa/msnd/msnd_pinnacle.c
index 4c07266..e2e940d 100644
--- a/sound/isa/msnd/msnd_pinnacle.c
+++ b/sound/isa/msnd/msnd_pinnacle.c
@@ -575,23 +575,23 @@ static int snd_msnd_attach(struct snd_card *card)
 
 	err = snd_msnd_dsp_full_reset(card);
 	if (err < 0)
-		goto err_release_region;
+		goto io_unmap;
 
 	/* Register device */
 	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops);
 	if (err < 0)
-		goto err_release_region;
+		goto io_unmap;
 
 	err = snd_msnd_pcm(card, 0);
 	if (err < 0) {
 		printk(KERN_ERR LOGNAME ": error creating new PCM device\n");
-		goto err_release_region;
+		goto io_unmap;
 	}
 
 	err = snd_msndmix_new(card);
 	if (err < 0) {
 		printk(KERN_ERR LOGNAME ": error creating new Mixer device\n");
-		goto err_release_region;
+		goto io_unmap;
 	}
 
 
@@ -607,7 +607,7 @@ static int snd_msnd_attach(struct snd_card *card)
 		if (err < 0) {
 			printk(KERN_ERR LOGNAME
 				": error creating new Midi device\n");
-			goto err_release_region;
+			goto io_unmap;
 		}
 		mpu = chip->rmidi->private_data;
 
@@ -622,12 +622,13 @@ static int snd_msnd_attach(struct snd_card *card)
 
 	err = snd_card_register(card);
 	if (err < 0)
-		goto err_release_region;
+		goto io_unmap;
 
 	return 0;
 
-err_release_region:
+io_unmap:
 	iounmap(chip->mappedbase);
+err_release_region:
 	release_mem_region(chip->base, BUFFSIZE);
 	release_region(chip->io, DSP_NUMIO);
 	free_irq(chip->irq, chip);
-- 
2.2.1


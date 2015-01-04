Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbbADNlr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 08:41:47 -0500
Received: from mout.web.de ([212.227.17.12]:52794 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbbADNlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 08:41:45 -0500
Message-ID: <54A94313.1070207@users.sourceforge.net>
Date: Sun, 04 Jan 2015 14:41:39 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 13/13] ALSA: msnd: Fix centralized exiting from snd_msnd_attach()
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A9355F.4050102@users.sourceforge.net>
In-Reply-To: <54A9355F.4050102@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:NESZ7L0JZyIrfaUcuTPsnxwlZNj+h0IZ3Bd/hYv16oYD/ojTi4L
 r4I7ZgHD5IwY7trJ7keFzuWHIHc1jvu9DCAkKA0wRwaXPyI9lDVo2Ti3oyvqUu3krafxbEp
 9/aI05c1a5LBmKpmeiZSn2mcpAwEk8HVurdvWWu3td3YOB2fQ33z2crWSA5Ug9VFItafXoY
 YaC+eXr8LzWEDBnuGBX2w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 4 Jan 2015 11:47:17 +0100

Two return statements were used by the snd_msnd_attach() function at source
code places where the Linux coding style recommends an alternative approach.

Let us improve the affected implementation details with adjustments for
corresponding jump targets.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/isa/msnd/msnd_pinnacle.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/sound/isa/msnd/msnd_pinnacle.c b/sound/isa/msnd/msnd_pinnacle.c
index e2e940d..0e66e5e 100644
--- a/sound/isa/msnd/msnd_pinnacle.c
+++ b/sound/isa/msnd/msnd_pinnacle.c
@@ -552,17 +552,16 @@ static int snd_msnd_attach(struct snd_card *card)
 		return err;
 	}
 	if (request_region(chip->io, DSP_NUMIO, card->shortname) == NULL) {
-		free_irq(chip->irq, chip);
-		return -EBUSY;
+		err = -EBUSY;
+		goto free_an_irq;
 	}
 
 	if (!request_mem_region(chip->base, BUFFSIZE, card->shortname)) {
 		printk(KERN_ERR LOGNAME
 			": unable to grab memory region 0x%lx-0x%lx\n",
 			chip->base, chip->base + BUFFSIZE - 1);
-		release_region(chip->io, DSP_NUMIO);
-		free_irq(chip->irq, chip);
-		return -EBUSY;
+		err = -EBUSY;
+		goto release_resource_region;
 	}
 	chip->mappedbase = ioremap_nocache(chip->base, 0x8000);
 	if (!chip->mappedbase) {
@@ -570,7 +569,7 @@ static int snd_msnd_attach(struct snd_card *card)
 			": unable to map memory region 0x%lx-0x%lx\n",
 			chip->base, chip->base + BUFFSIZE - 1);
 		err = -EIO;
-		goto err_release_region;
+		goto release_memory_region;
 	}
 
 	err = snd_msnd_dsp_full_reset(card);
@@ -628,9 +627,11 @@ static int snd_msnd_attach(struct snd_card *card)
 
 io_unmap:
 	iounmap(chip->mappedbase);
-err_release_region:
+release_memory_region:
 	release_mem_region(chip->base, BUFFSIZE);
+release_resource_region:
 	release_region(chip->io, DSP_NUMIO);
+free_an_irq:
 	free_irq(chip->irq, chip);
 	return err;
 }
-- 
2.2.1


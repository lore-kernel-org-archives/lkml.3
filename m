Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaKBS1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 13:27:42 -0500
Received: from mout.web.de ([212.227.17.12]:52191 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaKBS1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 13:27:40 -0500
Message-ID: <54567788.9060008@users.sourceforge.net>
Date: Sun, 02 Nov 2014 19:27:20 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] PCI: EMU10K1: Deletion of unnecessary checks before three
 function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:o57+CyZWRX8yN9NRj78n3d2etIIBUtQZyj0I4TQoS/DoQ+YKy/9
 3pS1/x8/b5b9ZOYUHA9gJZEYmruayXAW8VKf62tQPqj2Pz+pDzOBBhcnxXnWdqaur7DhdOa
 89anp4rkVKRLJuKE2oi9HuKwL9Sq5svyAXxfqu2Cqnau/L3Xf16GlVsZO3ta6OF0s350RHM
 nzCemOQK9JEiLooPQP9ug==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions kfree(), release_firmware() and snd_util_memhdr_free() test
whether their argument is NULL and then return immediately. Thus the test
around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/pci/emu10k1/emu10k1_main.c | 9 +++------
 sound/pci/emu10k1/emufx.c        | 3 +--
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/sound/pci/emu10k1/emu10k1_main.c b/sound/pci/emu10k1/emu10k1_main.c
index 2292697..b4458a6 100644
--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -1289,10 +1289,8 @@ static int snd_emu10k1_free(struct snd_emu10k1 *emu)
 	}
 	if (emu->emu1010.firmware_thread)
 		kthread_stop(emu->emu1010.firmware_thread);
-	if (emu->firmware)
-		release_firmware(emu->firmware);
-	if (emu->dock_fw)
-		release_firmware(emu->dock_fw);
+	release_firmware(emu->firmware);
+	release_firmware(emu->dock_fw);
 	if (emu->irq >= 0)
 		free_irq(emu->irq, emu);
 	/* remove reserved page */
@@ -1301,8 +1299,7 @@ static int snd_emu10k1_free(struct snd_emu10k1 *emu)
 			(struct snd_util_memblk *)emu->reserved_page);
 		emu->reserved_page = NULL;
 	}
-	if (emu->memhdr)
-		snd_util_memhdr_free(emu->memhdr);
+	snd_util_memhdr_free(emu->memhdr);
 	if (emu->silent_page.area)
 		snd_dma_free_pages(&emu->silent_page);
 	if (emu->ptb_pages.area)
diff --git a/sound/pci/emu10k1/emufx.c b/sound/pci/emu10k1/emufx.c
index 745f062..eb5c0ab 100644
--- a/sound/pci/emu10k1/emufx.c
+++ b/sound/pci/emu10k1/emufx.c
@@ -777,8 +777,7 @@ static void snd_emu10k1_ctl_private_free(struct snd_kcontrol
*kctl)
 	kctl->private_value = 0;
 	list_del(&ctl->list);
 	kfree(ctl);
-	if (kctl->tlv.p)
-		kfree(kctl->tlv.p);
+	kfree(kctl->tlv.p);
 }

 static int snd_emu10k1_add_controls(struct snd_emu10k1 *emu,
-- 
2.1.3



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab3KGTzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:55:14 -0500
Received: from smtprelay0005.hostedemail.com ([216.40.44.5]:36873 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752191Ab3KGTzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:55:10 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:3872:5007:6119:6120:7652:10004:10400:10848:11026:11658:11914:12517:12519:12555:12740:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: floor42_f93e81a76760
X-Filterd-Recvd-Size: 1862
Message-ID: <1383854115.9263.21.camel@joe-AO722>
Subject: [RFC PATCH] hda_intel: ratelimit "spurious response" message
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel <alsa-devel@alsa-project.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 07 Nov 2013 11:55:15 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmesg here has a 100+ consecutive lines of:

[ 1464.219446] hda-intel 0000:00:14.2: spurious response 0x0:0x0, last cmd=0x170500
[ 1464.219451] hda-intel 0000:00:14.2: spurious response 0x0:0x0, last cmd=0x170500
[ 1464.219454] hda-intel 0000:00:14.2: spurious response 0x0:0x0, last cmd=0x170500
...

Ratelimit the message to reduce the dmesg log noise.

Coalesce the format while at it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/pci/hda/hda_intel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 6e61a01..6e444ca 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -906,12 +906,12 @@ static void azx_update_rirb(struct azx *chip)
 			chip->rirb.res[addr] = res;
 			smp_wmb();
 			chip->rirb.cmds[addr]--;
-		} else
-			snd_printk(KERN_ERR SFX "%s: spurious response %#x:%#x, "
-				   "last cmd=%#08x\n",
+		} else if (printk_ratelimit()) {
+			snd_printk(KERN_ERR SFX "%s: spurious response %#x:%#x, last cmd=%#08x\n",
 				   pci_name(chip->pci),
 				   res, res_ex,
 				   chip->last_cmd[addr]);
+		}
 	}
 }
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaJ1VXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:23:55 -0400
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:56522 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751377AbaJ1VXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:23:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3866:3867:3874:4321:5007:6261:6742:7808:7903:7904:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12555:12740:13069:13311:13357:14196:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: actor33_36067225e591d
X-Filterd-Recvd-Size: 2942
Message-ID: <1414531369.10912.14.camel@perches.com>
Subject: [PATCH] 6fire: Convert byte_rev_table uses to bitrev8
From: Joe Perches <joe@perches.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Will Deacon <Will.Deacon@arm.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        alsa-devel <alsa-devel@alsa-project.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Will Deacon <Will.Deacon@arm.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        alsa-devel <alsa-devel@alsa-project.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 28 Oct 2014 14:22:49 -0700
In-Reply-To: <1414392371.8884.2.camel@perches.com>
References: <35FD53F367049845BC99AC72306C23D103E010D18254@CNBJMBX05.corpusers.net>
	 <35FD53F367049845BC99AC72306C23D103E010D18257@CNBJMBX05.corpusers.net>
	 <1414392371.8884.2.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the inline function instead of directly indexing the array.

This allows some architectures with hardware instructions
for bit reversals to eliminate the array.

Signed-off-by: Joe Perches <joe@perches.com>
---
On Sun, 2014-10-26 at 23:46 -0700, Joe Perches wrote:
> On Mon, 2014-10-27 at 14:37 +0800, Wang, Yalin wrote:
> > this change add CONFIG_HAVE_ARCH_BITREVERSE config option,
> > so that we can use arm/arm64 rbit instruction to do bitrev operation
> > by hardware.
[]
> > diff --git a/include/linux/bitrev.h b/include/linux/bitrev.h
> > index 7ffe03f..ef5b2bb 100644
> > --- a/include/linux/bitrev.h
> > +++ b/include/linux/bitrev.h
> > @@ -3,6 +3,14 @@
> >  
> >  #include <linux/types.h>
> >  
> > +#ifdef CONFIG_HAVE_ARCH_BITREVERSE
> > +#include <asm/bitrev.h>
> > +
> > +#define bitrev32 __arch_bitrev32
> > +#define bitrev16 __arch_bitrev16
> > +#define bitrev8 __arch_bitrev8
> > +
> > +#else
> >  extern u8 const byte_rev_table[256];

 sound/usb/6fire/firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/6fire/firmware.c b/sound/usb/6fire/firmware.c
index 3b02e54..62c25e7 100644
--- a/sound/usb/6fire/firmware.c
+++ b/sound/usb/6fire/firmware.c
@@ -316,7 +316,7 @@ static int usb6fire_fw_fpga_upload(
 
 	while (c != end) {
 		for (i = 0; c != end && i < FPGA_BUFSIZE; i++, c++)
-			buffer[i] = byte_rev_table[(u8) *c];
+			buffer[i] = bitrev8((u8)*c);
 
 		ret = usb6fire_fw_fpga_write(device, buffer, i);
 		if (ret < 0) {



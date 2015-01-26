Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbbAZS5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:57:14 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:56831 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbbAZS5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:57:12 -0500
Date: Mon, 26 Jan 2015 13:57:08 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Tony Lindgren <tony@atomide.com>
cc: =?ISO-8859-15?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: Re: N900 v3.19-rc5 arm atags_to_fdt.c is broken
In-Reply-To: <20150126170323.GF28663@atomide.com>
Message-ID: <alpine.LFD.2.11.1501261318590.1322@knanqh.ubzr>
References: <201501232239.55801@pali> <201501232336.36187@pali> <20150126161454.GE28663@atomide.com> <201501261723.10505@pali> <20150126170323.GF28663@atomide.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1818631455-1422298629=:1322"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1818631455-1422298629=:1322
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 26 Jan 2015, Tony Lindgren wrote:

> * Pali Rohár <pali.rohar@gmail.com> [150126 08:26]:
> > On Monday 26 January 2015 17:14:55 Tony Lindgren wrote:
> > > * Pali Rohár <pali.rohar@gmail.com> [150123 14:39]:
> > > > On Friday 23 January 2015 22:39:55 Pali Rohár wrote:
> > > > > Hello,
> > > > > 
> > > > > when I boot zImage with appended DT n900 in qemu
> > > > > fdt_open_into() function called from file
> > > > > arch/arm/boot/compressed/atags_to_fdt.c (in function
> > > > > atags_to_fdt) always returns -FDT_ERR_NOSPACE.
> > > > > 
> > > > > It means that all ATAGS (including cmdline arguments)
> > > > > passed by bootloader are ignored.
> > > > > 
> > > > > On real n900 device I see that booted DT version also
> > > > > ignore cmdline arguments from bootloader. I cannot debug
> > > > > decompress code on real device, but I think it is same
> > > > > problem as in qemu.
> > > > 
> > > > Looks like this quick patch is fixing above problem:
> > > > 
> > > > diff --git a/arch/arm/boot/compressed/head.S
> > > > b/arch/arm/boot/compressed/head.S index 68be901..4a7d75b
> > > > 100644
> > > > --- a/arch/arm/boot/compressed/head.S
> > > > +++ b/arch/arm/boot/compressed/head.S
> > > > @@ -268,7 +268,7 @@ restart:	adr	r0, LC0
> > > > 
> > > >  		 * area.  No GOT fixup has occurred yet, but none of 
> > the
> > > >  		 * code we're about to call uses any global variable.
> > > >  		
> > > >  		*/
> > > > 
> > > > -		add	sp, sp, #0x10000
> > > > +		add	sp, sp, #0x20000
> > > > 
> > > >  		stmfd	sp!, {r0-r3, ip, lr}
> > > >  		mov	r0, r8
> > > >  		mov	r1, r6
> > > > 
> > > > @@ -289,7 +289,7 @@ restart:	adr	r0, LC0
> > > > 
> > > >  		bleq	atags_to_fdt
> > > >  		
> > > >  		ldmfd	sp!, {r0-r3, ip, lr}
> > > > 
> > > > -		sub	sp, sp, #0x10000
> > > > +		sub	sp, sp, #0x20000
> > > > 
> > > >  #endif
> > > >  
> > > >  		mov	r8, r6			@ use the appended device tree
> > > 
> > > Nico, got any ideas about this one? This seems like a
> > > regression somewhere..
> > > 
> > > Regards,
> > > 
> > > Tony
> > 
> > $ du -b arch/arm/boot/dts/omap3-n900.dtb 
> > 70212   arch/arm/boot/dts/omap3-n900.dtb
> > 
> > $ echo $((0x10000))
> > 65536
> > 
> > I would say, problem is because omap3-n900 binary DT is too large

I agree.

> OK if that's the case, then your patch makes sense to me. It also
> seems we can have the temporary stack be larger than the initial
> stack just for atags_to_fdt.

The stack size isn't the issue, but rather its location.  We need to 
position it away from the DT data.  The DT size is known and we could 
use that, plus some room for the insertion of new data coming from the
ATAG conversion.

Something like the following would be a more robust solution:

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 68be901759..89718de9dd 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -263,16 +263,37 @@ restart:	adr	r0, LC0
 		 * OK... Let's do some funky business here.
 		 * If we do have a DTB appended to zImage, and we do have
 		 * an ATAG list around, we want the later to be translated
-		 * and folded into the former here.  To be on the safe side,
-		 * let's temporarily move  the stack away into the malloc
-		 * area.  No GOT fixup has occurred yet, but none of the
-		 * code we're about to call uses any global variable.
+		 * and folded into the former here. No GOT fixup has occurred
+		 * yet, but none of the code we're about to call uses any
+		 * global variable.
 		*/
-		add	sp, sp, #0x10000
+
+		/* Get the initial DTB size */
+		ldr	r5, [r6, #4]
+#ifndef __ARMEB__
+		/* convert to little endian */
+		eor	r1, r5, r5, ror #16
+		bic	r1, r1, #0x00ff0000
+		mov	r5, r5, ror #8
+		eor	r5, r5, r1, lsr #8
+#endif
+		/* 50% DTB growth should be good enough */
+		add	r5, r5, r5, lsr #1
+		/* preserve 64-bit alignment */
+		add	r5, r5, #7
+		bic	r5, r5, #7
+		/* clamp to 32KB min and 1MB max */
+		movs	r1, r5, lsr #15
+		moveq	r5, #(1 << 15)
+		movs	r1, r5, lsr #20
+		movne	r5, #(1 << 20)
+
+		/* Temporarily relocate the stack past the DTB work space */
+		add	sp, sp, r5
 		stmfd	sp!, {r0-r3, ip, lr}
 		mov	r0, r8
 		mov	r1, r6
-		sub	r2, sp, r6
+		mov	r2, r5
 		bl	atags_to_fdt
 
 		/*
@@ -285,11 +306,11 @@ restart:	adr	r0, LC0
 		bic	r0, r0, #1
 		add	r0, r0, #0x100
 		mov	r1, r6
-		sub	r2, sp, r6
+		mov	r2, r5
 		bleq	atags_to_fdt
 
 		ldmfd	sp!, {r0-r3, ip, lr}
-		sub	sp, sp, #0x10000
+		sub	sp, sp, r5
 #endif
 
 		mov	r8, r6			@ use the appended device tree
@@ -306,7 +327,7 @@ restart:	adr	r0, LC0
 		subs	r1, r5, r1
 		addhi	r9, r9, r1
 
-		/* Get the dtb's size */
+		/* Get the current DTB size */
 		ldr	r5, [r6, #4]
 #ifndef __ARMEB__
 		/* convert r5 (dtb size) to little endian */
--8323328-1818631455-1422298629=:1322--

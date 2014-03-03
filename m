Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaCCNAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 08:00:07 -0500
Received: from mailscanner02.zoner.fi ([84.34.166.11]:53410 "EHLO
	mailscanner02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaCCNAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 08:00:05 -0500
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Mar 2014 08:00:04 EST
Date: Mon, 3 Mar 2014 14:51:37 +0200
From: Lasse Collin <lasse.collin@tukaani.org>
To: Kyle McMartin <kyle@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, Florian Fainelli <florian@openwrt.org>
Subject: Re: [PATCH] xz: make XZ_DEC_BCJ filters non-optional
Message-ID: <20140303145137.70819698@tukaani.org>
In-Reply-To: <20140228230017.GE14970@merlin.infradead.org>
References: <20140228230017.GE14970@merlin.infradead.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-28 Kyle McMartin wrote:
> Having these optional is more trouble than is justified by the
> negligible increase in code size to lib/xz/ if they're all compiled
> in. Their optional status ends up necessitating rebuilds of the kernel
> in order to be able to decompress XZ-compressed squashfs images which
> use non-native BCJ filters (ie: you need to enable XZ_DEC_POWERPC on
> x86_64 in order to loop-mount a ppc64 squashfs that uses it.)

Originally all BCJ filters were enabled by default and CONFIG_EXPERT
allowed disabling them one by one. It was changed a year ago to the
current state because I wasn't against it when it was suggested:

    http://lkml.org/lkml/2013/1/15/449

It seems that I should have been against it. I suggest things are
rolled back like they were: all BCJ filters enabled by default and
CONFIG_EXPERT makes them deselectable. This time I have a somewhat
strong opinion that this is the best way to go, even if it means that
the embedded people must remember to deselect the unnneeded filters.

An alternative could be that with CONFIG_EXPERT only the BCJ filter for
the current arch would be selected by default. Without CONFIG_EXPERT
all filters would be forced on. I guess this could be confusing since
the level of XZ support they get by default when they enable Squashfs'
XZ support would depend on CONFIG_EXPERT. So I think my first suggestion
is better.

> So save ourselves the trouble and build them all into xz_dec_bcj.o to
> begin with. (I could conceivably see a case where CONFIG_EXPERT made
> these selectable, but again, even on embedded platforms, the .text
> increase we're talking about is noise...)
> 
> text	data	bss	dec	hex	filename
> 1239	0	0	1239	4d7	xz_dec_bcj.o
> 2263	0	0	2263	8d7	xz_dec_bcj.o.2

No, let's not unconditionally build them all:

  - 1 KiB might be noise, but since on embedded systems that 1 KiB
    really is completely useless code and it's very easy to omit it,
    the option to omit such code should be kept.

  - If the kernel image is compressed with XZ, a separate copy of
    the decompressor is built for the pre-boot environment.
    Conditional compilation of the BCJ filters is also used for
    pre-boot environments which your patch doesn't touch. The
    1 KiB increase would affect the copy in the pre-boot code too.

  - This XZ decompressor was written with the Linux kernel in mind,
    but it's used elsewhere too. It would be nice to minimize the
    differences between the code in Linux and the out-of-kernel tree.
    Outside Linux I will keep the BCJ filters optional anyway.

Below are two alternative patches matching my two suggestions. I prefer
the first patch and I will submit it in a day or two unless people
have better ideas.

diff -Nru linux-3.14-rc5.orig/lib/xz/Kconfig linux-3.14-rc5/lib/xz/Kconfig
--- linux-3.14-rc5.orig/lib/xz/Kconfig	2014-03-03 04:56:16.000000000 +0200
+++ linux-3.14-rc5/lib/xz/Kconfig	2014-03-03 13:26:58.402872951 +0200
@@ -9,33 +9,33 @@
 if XZ_DEC
 
 config XZ_DEC_X86
-	bool "x86 BCJ filter decoder"
-	default y if X86
+	bool "x86 BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_POWERPC
-	bool "PowerPC BCJ filter decoder"
-	default y if PPC
+	bool "PowerPC BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_IA64
-	bool "IA-64 BCJ filter decoder"
-	default y if IA64
+	bool "IA-64 BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARM
-	bool "ARM BCJ filter decoder"
-	default y if ARM
+	bool "ARM BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARMTHUMB
-	bool "ARM-Thumb BCJ filter decoder"
-	default y if (ARM && ARM_THUMB)
+	bool "ARM-Thumb BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_SPARC
-	bool "SPARC BCJ filter decoder"
-	default y if SPARC
+	bool "SPARC BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 endif

The second version enables the BCJ filter only for the current arch by
default if CONFIG_EXPERT; without CONFIG_EXPERT all filters are forced
on:

diff -Nru linux-3.14-rc5.orig/lib/xz/Kconfig linux-3.14-rc5/lib/xz/Kconfig
--- linux-3.14-rc5.orig/lib/xz/Kconfig	2014-03-03 04:56:16.000000000 +0200
+++ linux-3.14-rc5/lib/xz/Kconfig	2014-03-03 14:15:42.196209325 +0200
@@ -9,33 +9,33 @@
 if XZ_DEC
 
 config XZ_DEC_X86
-	bool "x86 BCJ filter decoder"
-	default y if X86
+	bool "x86 BCJ filter decoder" if EXPERT
+	default y if !EXPERT || X86
 	select XZ_DEC_BCJ
 
 config XZ_DEC_POWERPC
-	bool "PowerPC BCJ filter decoder"
-	default y if PPC
+	bool "PowerPC BCJ filter decoder" if EXPERT
+	default y if !EXPERT || PPC
 	select XZ_DEC_BCJ
 
 config XZ_DEC_IA64
-	bool "IA-64 BCJ filter decoder"
-	default y if IA64
+	bool "IA-64 BCJ filter decoder" if EXPERT
+	default y if !EXPERT || IA64
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARM
-	bool "ARM BCJ filter decoder"
-	default y if ARM
+	bool "ARM BCJ filter decoder" if EXPERT
+	default y if !EXPERT || ARM
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARMTHUMB
-	bool "ARM-Thumb BCJ filter decoder"
-	default y if (ARM && ARM_THUMB)
+	bool "ARM-Thumb BCJ filter decoder" if EXPERT
+	default y if !EXPERT || (ARM && ARM_THUMB)
 	select XZ_DEC_BCJ
 
 config XZ_DEC_SPARC
-	bool "SPARC BCJ filter decoder"
-	default y if SPARC
+	bool "SPARC BCJ filter decoder" if EXPERT
+	default y if !EXPERT || SPARC
 	select XZ_DEC_BCJ
 
 endif

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode

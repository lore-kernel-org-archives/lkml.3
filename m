Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964813Ab3BTQA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:00:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63596 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934060Ab3BTQAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:00:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/11] ARM: disable virt_to_bus/virt_to_bus almost everywhere
Date: Wed, 20 Feb 2013 16:00:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de> <1360849767-1463135-2-git-send-email-arnd@arndb.de> <CAAG0J9_VqCGJJJZjSWGfFggALHU=vdWsSBeS39-DtxV=VXcJwQ@mail.gmail.com>
In-Reply-To: <CAAG0J9_VqCGJJJZjSWGfFggALHU=vdWsSBeS39-DtxV=VXcJwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302201600.47522.arnd@arndb.de>
X-Provags-ID: V02:K0:e7zmS6TT/6ElWBnWoSonHbgR5U58yEIjZM+CfaEVqJj
 MpEBnlAPvZelrX6Md83OPc7O6+usexAGJM2/rjiSU3Y9fSQiht
 /tMAbL53PakMEIp5vuZp9OVi7rFs5T0HPWrdtdUNU8OXD1fq4J
 fVFMcf6U01BJdWpJMa2dvzr+bEYEjnc0EeBOdP9I902uDwWXe9
 6nx+Aj1yb8jv09Lu00ZX3eLSbmWYnsnE9oDUuVsdJwQT+2wou7
 alv9IYhRrkE3fV3umz+BHigb5BCjlRxP6c0Zw96wcuLy1PepxX
 NqMuL6qWvWWeG+bPTkSV3M9Ct3J5rmgb32YOkYtGw98/6QiDBc
 89sCpa2LCW1Viba+nB2U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2013, James Hogan wrote:
> There's a patch in linux-next by Stephen Rothwell "Centralise
> CONFIG_ARCH_NO_VIRT_TO_BUS" that removes this Kconfig symbol,
> inverting/replacing it with "select HAVE_VIRT_TO_BUS" (including for
> arch/arm) which will undo the effects of this.

Ah, thanks for pointing that out. At least my patch is harmless then
although also useless. I'll leave it in for now so I don't have to
rebase all the other bug fixes that are queued for 3.9, but I'm making
a note that I'll have to replace this with a proper one. I also
don't think that anything breaks if we apply both patches for a while,
it will just make my patch useless.

I guess you'll have to do something similar for arch/metag, and Vineet
will do it for arch/arc.

Stephen's patch is currently in Andrew's tree, and I don't see an easy
way to coordinate this. The patch we will need once both are merged
is below.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 4fef29f..5829b67 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -76,9 +76,6 @@ config HAVE_LATENCYTOP_SUPPORT
 config NO_DMA
 	def_bool n
 
-config ARCH_NO_VIRT_TO_BUS
-	def_bool y
-
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index dedf02b..7b35b39 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -49,7 +49,6 @@ config ARM
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16
-	select HAVE_VIRT_TO_BUS
 	select KTIME_SCALAR
 	select PERF_USE_VMALLOC
 	select RTC_LIB
@@ -744,6 +743,7 @@ config ARCH_RPC
 	select NEED_MACH_IO_H
 	select NEED_MACH_MEMORY_H
 	select NO_IOPORT
+	select HAVE_VIRT_TO_BUS
 	help
 	  On the Acorn Risc-PC, Linux can support the internal IDE disk and
 	  CD-ROM interface, serial and parallel port, and the floppy drive.
@@ -880,6 +880,7 @@ config ARCH_SHARK
 	select NEED_MACH_MEMORY_H
 	select PCI
 	select ZONE_DMA
+	select HAVE_VIRT_TO_BUS
 	help
 	  Support for the StrongARM based Digital DNARD machine, also known
 	  as "Shark" (<http://www.shark-linux.de/shark.html>).
@@ -1462,10 +1463,6 @@ config ISA_DMA
 	bool
 	select ISA_DMA_API
 
-config ARCH_NO_VIRT_TO_BUS
-	def_bool y
-	depends on !ARCH_RPC && !ARCH_NETWINDER && !ARCH_SHARK
-
 # Select ISA DMA interface
 config ISA_DMA_API
 	bool
diff --git a/arch/arm/mach-footbridge/Kconfig b/arch/arm/mach-footbridge/Kconfig
index abda5a1..42bf587 100644
--- a/arch/arm/mach-footbridge/Kconfig
+++ b/arch/arm/mach-footbridge/Kconfig
@@ -67,6 +67,7 @@ config ARCH_NETWINDER
 	select ISA
 	select ISA_DMA
 	select PCI
+	select HAVE_VIRT_TO_BUS
 	help
 	  Say Y here if you intend to run this kernel on the Rebel.COM
 	  NetWinder.  Information about this machine can be found at:
diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index 30adc78..03e216e 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -35,9 +35,6 @@ config METAG
 	select OF_EARLY_FLATTREE
 	select SPARSE_IRQ
 
-config ARCH_NO_VIRT_TO_BUS
-	def_bool y
-
 config STACKTRACE_SUPPORT
 	def_bool y
 

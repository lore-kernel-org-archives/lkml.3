Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaEHPOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:14:07 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56287 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaEHPOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:14:04 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: git@xilinx.com, monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ARM: zynq: Enable big-endian
Date: Thu,  8 May 2014 17:13:39 +0200
Message-Id: <c0fa40614e2bec826fe825f75d00ae927d1197c4.1399562009.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <5e4fb08db4f6a436fc4593b22c3ae611ba545967.1399562009.git.michal.simek@xilinx.com>
References: <5e4fb08db4f6a436fc4593b22c3ae611ba545967.1399562009.git.michal.simek@xilinx.com>
In-Reply-To: <5e4fb08db4f6a436fc4593b22c3ae611ba545967.1399562009.git.michal.simek@xilinx.com>
References: <5e4fb08db4f6a436fc4593b22c3ae611ba545967.1399562009.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-708-1399562040-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-708-1399562040-0001

Enable ARCH_SUPPORTS_BIG_ENDIAN in Kconfig.

zynq_secondary_trampoline is the first function
that is called on secondary CPU.
Reference:
"ARM: mcpm: fix big endian issue in mcpm startup code"
(sha1: 519ceb9fd10cd7e836d0aa97b2068cc9e97f463b)

Fix early printk support. Based on:
"ARM: pl01x debug code endian fix"
(sha1: 76e3faf156fa95b6465e747d702b94faf67117fc)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/arm/include/debug/zynq.S | 2 ++
 arch/arm/mach-zynq/Kconfig    | 1 +
 arch/arm/mach-zynq/headsmp.S  | 5 ++++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/debug/zynq.S b/arch/arm/include/debug/zynq.S
index 0b762fafa758..3895146341f3 100644
--- a/arch/arm/include/debug/zynq.S
+++ b/arch/arm/include/debug/zynq.S
@@ -43,12 +43,14 @@

 		.macro	waituart,rd,rx
 1001:		ldr	\rd, [\rx, #UART_SR_OFFSET]
+ARM_BE8(	rev	\rd, \rd )
 		tst	\rd, #UART_SR_TXEMPTY
 		beq	1001b
 		.endm

 		.macro	busyuart,rd,rx
 1002:		ldr	\rd, [\rx, #UART_SR_OFFSET]	@ get status register
+ARM_BE8(	rev	\rd, \rd )
 		tst	\rd, #UART_SR_TXFULL		@
 		bne	1002b			@ wait if FIFO is full
 		.endm
diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
index 1daa5c220d1d..ff03a71bb9a3 100644
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@ -2,6 +2,7 @@ config ARCH_ZYNQ
 	bool "Xilinx Zynq ARM Cortex A9 Platform" if ARCH_MULTI_V7
 	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_OPP
+	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ARM_AMBA
 	select ARM_GIC
 	select ARM_GLOBAL_TIMER if !CPU_FREQ
diff --git a/arch/arm/mach-zynq/headsmp.S b/arch/arm/mach-zynq/headsmp.S
index 57a32869f0aa..dd8c071941e7 100644
--- a/arch/arm/mach-zynq/headsmp.S
+++ b/arch/arm/mach-zynq/headsmp.S
@@ -8,9 +8,12 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <asm/assembler.h>

 ENTRY(zynq_secondary_trampoline)
-	ldr	r0, [pc]
+ARM_BE8(setend	be)				@ ensure we are in BE8 mode
+	ldr	r0, zynq_secondary_trampoline_jump
+ARM_BE8(rev	r0, r0)
 	bx	r0
 .globl zynq_secondary_trampoline_jump
 zynq_secondary_trampoline_jump:
--
1.8.2.3


--=_mimegpg-monstr-desktop-708-1399562040-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlNrnzgACgkQykllyylKDCGECgCfccUDWsDdl+DZtvx1fJw6WoSX
DeEAoJ4/i+Zj9u+OhejA6z8+0ZYQkAXg
=hwJJ
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-708-1399562040-0001--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaETIk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:40:56 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:60869 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750945AbaETIkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:40:53 -0400
Message-ID: <1400575250.4912.12.camel@x220>
Subject: [PATCH] m32r: remove checks for a few processor family macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-kernel@vger.kernel.org
Date: Tue, 20 May 2014 10:40:50 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2014 08:40:50.0365 (UTC) FILETIME=[340946D0:01CF7407]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ever since m32r got added in v2.6.9 there have been checks for
    CONFIG_CHIP_M32310
    CONFIG_CHIP_MP
    CONFIG_CHIP_XNUX2
    CONFIG_CHIP_XNUX2_MP
    CONFIG_CHIP_XNUX_MP

But the Kconfig symbols for these processor families have never been
added. Remove these checks. Also remove a header that now is not
mentioned anymore (the #include involved wasn't used anyway).

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Eyeball tested only!

 arch/m32r/boot/compressed/head.S     |   2 -
 arch/m32r/boot/setup.S               |   7 +-
 arch/m32r/include/asm/m32r.h         |   4 +-
 arch/m32r/include/asm/m32r_mp_fpga.h | 313 -----------------------------------
 arch/m32r/kernel/head.S              |   2 -
 arch/m32r/kernel/setup.c             |   5 +-
 arch/m32r/kernel/time.c              |   8 +-
 arch/m32r/mm/cache.c                 |   2 +-
 8 files changed, 6 insertions(+), 337 deletions(-)
 delete mode 100644 arch/m32r/include/asm/m32r_mp_fpga.h

diff --git a/arch/m32r/boot/compressed/head.S b/arch/m32r/boot/compressed/head.S
index 95a0563ff076..e2ecab840aeb 100644
--- a/arch/m32r/boot/compressed/head.S
+++ b/arch/m32r/boot/compressed/head.S
@@ -73,10 +73,8 @@ startup:
 	srli	r4, #4		    ||	addi	r2, #-4
 	beqz	r4, .Lendloop1
 .Lloop1:
-#ifndef CONFIG_CHIP_M32310
 	; Touch memory for the no-write-allocating cache.
 	ld	r0, @(4,r2)
-#endif
 	st	r1, @+r2	    ||	addi	r4, #-1
 	st	r1, @+r2
 	st	r1, @+r2
diff --git a/arch/m32r/boot/setup.S b/arch/m32r/boot/setup.S
index ef843d63083d..ce5049babecc 100644
--- a/arch/m32r/boot/setup.S
+++ b/arch/m32r/boot/setup.S
@@ -62,12 +62,7 @@
 ENTRY(boot)
 
 /* Set cache mode */
-#if defined(CONFIG_CHIP_XNUX2)
-	ldi	r0, #-2              ;LDIMM	(r0, M32R_MCCR)
-	ldi	r1, #0x0101		; cache on (with invalidation)
-;	ldi	r1, #0x00		; cache off
-	sth	r1, @r0
-#elif defined(CONFIG_CHIP_M32700) || defined(CONFIG_CHIP_VDEC2) \
+#if defined(CONFIG_CHIP_M32700) || defined(CONFIG_CHIP_VDEC2) \
     || defined(CONFIG_CHIP_OPSP)
 	ldi	r0, #-4              ;LDIMM	(r0, M32R_MCCR)
 	ldi	r1, #0x73		; cache on (with invalidation)
diff --git a/arch/m32r/include/asm/m32r.h b/arch/m32r/include/asm/m32r.h
index 38fa946d1ebf..b12766cf2976 100644
--- a/arch/m32r/include/asm/m32r.h
+++ b/arch/m32r/include/asm/m32r.h
@@ -9,9 +9,7 @@
 

 /* Chip type */
-#if defined(CONFIG_CHIP_XNUX_MP) || defined(CONFIG_CHIP_XNUX2_MP)
-#include <asm/m32r_mp_fpga.h>
-#elif defined(CONFIG_CHIP_VDEC2) || defined(CONFIG_CHIP_XNUX2) \
+#if defined(CONFIG_CHIP_VDEC2) \
 	|| defined(CONFIG_CHIP_M32700) || defined(CONFIG_CHIP_M32102) \
         || defined(CONFIG_CHIP_OPSP) || defined(CONFIG_CHIP_M32104)
 #include <asm/m32102.h>
diff --git a/arch/m32r/include/asm/m32r_mp_fpga.h b/arch/m32r/include/asm/m32r_mp_fpga.h
deleted file mode 100644
index 976d2b995919..000000000000
--- a/arch/m32r/include/asm/m32r_mp_fpga.h
+++ /dev/null
@@ -1,313 +0,0 @@
-#ifndef _ASM_M32R_M32R_MP_FPGA_
-#define _ASM_M32R_M32R_MP_FPGA_
-
-/*
- * Renesas M32R-MP-FPGA
- *
- * Copyright (c) 2002  Hitoshi Yamamoto
- * Copyright (c) 2003, 2004  Renesas Technology Corp.
- */
-
-/*
- * ========================================================
- * M32R-MP-FPGA Memory Map
- * ========================================================
- * 0x00000000 : Block#0 : 64[MB]
- *              0x03E00000 : SFR
- *                           0x03E00000 : reserved
- *                           0x03EF0000 : FPGA
- *                           0x03EF1000 : reserved
- *                           0x03EF4000 : CKM
- *                           0x03EF4000 : BSELC
- *                           0x03EF5000 : reserved
- *                           0x03EFC000 : MFT
- *                           0x03EFD000 : SIO
- *                           0x03EFE000 : reserved
- *                           0x03EFF000 : ICU
- *              0x03F00000 : Internal SRAM 64[KB]
- *              0x03F10000 : reserved
- * --------------------------------------------------------
- * 0x04000000 : Block#1 : 64[MB]
- *              0x04000000 : Debug board SRAM 4[MB]
- *              0x04400000 : reserved
- * --------------------------------------------------------
- * 0x08000000 : Block#2 : 64[MB]
- * --------------------------------------------------------
- * 0x0C000000 : Block#3 : 64[MB]
- * --------------------------------------------------------
- * 0x10000000 : Block#4 : 64[MB]
- * --------------------------------------------------------
- * 0x14000000 : Block#5 : 64[MB]
- * --------------------------------------------------------
- * 0x18000000 : Block#6 : 64[MB]
- * --------------------------------------------------------
- * 0x1C000000 : Block#7 : 64[MB]
- * --------------------------------------------------------
- * 0xFE000000 : TLB
- *              0xFE000000 : ITLB
- *              0xFE000080 : reserved
- *              0xFE000800 : DTLB
- *              0xFE000880 : reserved
- * --------------------------------------------------------
- * 0xFF000000 : System area
- *              0xFFFF0000 : MMU
- *              0xFFFF0030 : reserved
- *              0xFFFF8000 : Debug function
- *              0xFFFFA000 : reserved
- *              0xFFFFC000 : CPU control
- * 0xFFFFFFFF
- * ========================================================
- */
-
-/*======================================================================*
- * Special Function Register
- *======================================================================*/
-#define M32R_SFR_OFFSET  (0x00E00000)  /* 0x03E00000-0x03EFFFFF 1[MB] */
-
-/*
- * FPGA registers.
- */
-#define M32R_FPGA_TOP  (0x000F0000+M32R_SFR_OFFSET)
-
-#define M32R_FPGA_NUM_OF_CPUS_PORTL  (0x00+M32R_FPGA_TOP)
-#define M32R_FPGA_CPU_NAME0_PORTL    (0x10+M32R_FPGA_TOP)
-#define M32R_FPGA_CPU_NAME1_PORTL    (0x14+M32R_FPGA_TOP)
-#define M32R_FPGA_CPU_NAME2_PORTL    (0x18+M32R_FPGA_TOP)
-#define M32R_FPGA_CPU_NAME3_PORTL    (0x1C+M32R_FPGA_TOP)
-#define M32R_FPGA_MODEL_ID0_PORTL    (0x20+M32R_FPGA_TOP)
-#define M32R_FPGA_MODEL_ID1_PORTL    (0x24+M32R_FPGA_TOP)
-#define M32R_FPGA_MODEL_ID2_PORTL    (0x28+M32R_FPGA_TOP)
-#define M32R_FPGA_MODEL_ID3_PORTL    (0x2C+M32R_FPGA_TOP)
-#define M32R_FPGA_VERSION0_PORTL     (0x30+M32R_FPGA_TOP)
-#define M32R_FPGA_VERSION1_PORTL     (0x34+M32R_FPGA_TOP)
-
-/*
- * Clock and Power Manager registers.
- */
-#define M32R_CPM_OFFSET  (0x000F4000+M32R_SFR_OFFSET)
-
-#define M32R_CPM_CPUCLKCR_PORTL  (0x00+M32R_CPM_OFFSET)
-#define M32R_CPM_CLKMOD_PORTL    (0x04+M32R_CPM_OFFSET)
-#define M32R_CPM_PLLCR_PORTL     (0x08+M32R_CPM_OFFSET)
-
-/*
- * Block SELect Controller registers.
- */
-#define M32R_BSELC_OFFSET  (0x000F5000+M32R_SFR_OFFSET)
-
-#define M32R_BSEL0_CR0_PORTL  (0x000+M32R_BSELC_OFFSET)
-#define M32R_BSEL0_CR1_PORTL  (0x004+M32R_BSELC_OFFSET)
-#define M32R_BSEL1_CR0_PORTL  (0x100+M32R_BSELC_OFFSET)
-#define M32R_BSEL1_CR1_PORTL  (0x104+M32R_BSELC_OFFSET)
-#define M32R_BSEL2_CR0_PORTL  (0x200+M32R_BSELC_OFFSET)
-#define M32R_BSEL2_CR1_PORTL  (0x204+M32R_BSELC_OFFSET)
-#define M32R_BSEL3_CR0_PORTL  (0x300+M32R_BSELC_OFFSET)
-#define M32R_BSEL3_CR1_PORTL  (0x304+M32R_BSELC_OFFSET)
-#define M32R_BSEL4_CR0_PORTL  (0x400+M32R_BSELC_OFFSET)
-#define M32R_BSEL4_CR1_PORTL  (0x404+M32R_BSELC_OFFSET)
-#define M32R_BSEL5_CR0_PORTL  (0x500+M32R_BSELC_OFFSET)
-#define M32R_BSEL5_CR1_PORTL  (0x504+M32R_BSELC_OFFSET)
-#define M32R_BSEL6_CR0_PORTL  (0x600+M32R_BSELC_OFFSET)
-#define M32R_BSEL6_CR1_PORTL  (0x604+M32R_BSELC_OFFSET)
-#define M32R_BSEL7_CR0_PORTL  (0x700+M32R_BSELC_OFFSET)
-#define M32R_BSEL7_CR1_PORTL  (0x704+M32R_BSELC_OFFSET)
-
-/*
- * Multi Function Timer registers.
- */
-#define M32R_MFT_OFFSET        (0x000FC000+M32R_SFR_OFFSET)
-
-#define M32R_MFTCR_PORTL       (0x000+M32R_MFT_OFFSET)  /* MFT control */
-#define M32R_MFTRPR_PORTL      (0x004+M32R_MFT_OFFSET)  /* MFT real port */
-
-#define M32R_MFT0_OFFSET       (0x100+M32R_MFT_OFFSET)
-#define M32R_MFT0MOD_PORTL     (0x00+M32R_MFT0_OFFSET)  /* MFT0 mode */
-#define M32R_MFT0BOS_PORTL     (0x04+M32R_MFT0_OFFSET)  /* MFT0 b-port output status */
-#define M32R_MFT0CUT_PORTL     (0x08+M32R_MFT0_OFFSET)  /* MFT0 count */
-#define M32R_MFT0RLD_PORTL     (0x0C+M32R_MFT0_OFFSET)  /* MFT0 reload */
-#define M32R_MFT0CMPRLD_PORTL  (0x10+M32R_MFT0_OFFSET)  /* MFT0 compare reload */
-
-#define M32R_MFT1_OFFSET       (0x200+M32R_MFT_OFFSET)
-#define M32R_MFT1MOD_PORTL     (0x00+M32R_MFT1_OFFSET)  /* MFT1 mode */
-#define M32R_MFT1BOS_PORTL     (0x04+M32R_MFT1_OFFSET)  /* MFT1 b-port output status */
-#define M32R_MFT1CUT_PORTL     (0x08+M32R_MFT1_OFFSET)  /* MFT1 count */
-#define M32R_MFT1RLD_PORTL     (0x0C+M32R_MFT1_OFFSET)  /* MFT1 reload */
-#define M32R_MFT1CMPRLD_PORTL  (0x10+M32R_MFT1_OFFSET)  /* MFT1 compare reload */
-
-#define M32R_MFT2_OFFSET       (0x300+M32R_MFT_OFFSET)
-#define M32R_MFT2MOD_PORTL     (0x00+M32R_MFT2_OFFSET)  /* MFT2 mode */
-#define M32R_MFT2BOS_PORTL     (0x04+M32R_MFT2_OFFSET)  /* MFT2 b-port output status */
-#define M32R_MFT2CUT_PORTL     (0x08+M32R_MFT2_OFFSET)  /* MFT2 count */
-#define M32R_MFT2RLD_PORTL     (0x0C+M32R_MFT2_OFFSET)  /* MFT2 reload */
-#define M32R_MFT2CMPRLD_PORTL  (0x10+M32R_MFT2_OFFSET)  /* MFT2 compare reload */
-
-#define M32R_MFT3_OFFSET       (0x400+M32R_MFT_OFFSET)
-#define M32R_MFT3MOD_PORTL     (0x00+M32R_MFT3_OFFSET)  /* MFT3 mode */
-#define M32R_MFT3BOS_PORTL     (0x04+M32R_MFT3_OFFSET)  /* MFT3 b-port output status */
-#define M32R_MFT3CUT_PORTL     (0x08+M32R_MFT3_OFFSET)  /* MFT3 count */
-#define M32R_MFT3RLD_PORTL     (0x0C+M32R_MFT3_OFFSET)  /* MFT3 reload */
-#define M32R_MFT3CMPRLD_PORTL  (0x10+M32R_MFT3_OFFSET)  /* MFT3 compare reload */
-
-#define M32R_MFT4_OFFSET       (0x500+M32R_MFT_OFFSET)
-#define M32R_MFT4MOD_PORTL     (0x00+M32R_MFT4_OFFSET)  /* MFT4 mode */
-#define M32R_MFT4BOS_PORTL     (0x04+M32R_MFT4_OFFSET)  /* MFT4 b-port output status */
-#define M32R_MFT4CUT_PORTL     (0x08+M32R_MFT4_OFFSET)  /* MFT4 count */
-#define M32R_MFT4RLD_PORTL     (0x0C+M32R_MFT4_OFFSET)  /* MFT4 reload */
-#define M32R_MFT4CMPRLD_PORTL  (0x10+M32R_MFT4_OFFSET)  /* MFT4 compare reload */
-
-#define M32R_MFT5_OFFSET       (0x600+M32R_MFT_OFFSET)
-#define M32R_MFT5MOD_PORTL     (0x00+M32R_MFT5_OFFSET)  /* MFT4 mode */
-#define M32R_MFT5BOS_PORTL     (0x04+M32R_MFT5_OFFSET)  /* MFT4 b-port output status */
-#define M32R_MFT5CUT_PORTL     (0x08+M32R_MFT5_OFFSET)  /* MFT4 count */
-#define M32R_MFT5RLD_PORTL     (0x0C+M32R_MFT5_OFFSET)  /* MFT4 reload */
-#define M32R_MFT5CMPRLD_PORTL  (0x10+M32R_MFT5_OFFSET)  /* MFT4 compare reload */
-
-#define M32R_MFTCR_MFT0MSK  (1UL<<15)  /* b16 */
-#define M32R_MFTCR_MFT1MSK  (1UL<<14)  /* b17 */
-#define M32R_MFTCR_MFT2MSK  (1UL<<13)  /* b18 */
-#define M32R_MFTCR_MFT3MSK  (1UL<<12)  /* b19 */
-#define M32R_MFTCR_MFT4MSK  (1UL<<11)  /* b20 */
-#define M32R_MFTCR_MFT5MSK  (1UL<<10)  /* b21 */
-#define M32R_MFTCR_MFT0EN   (1UL<<7)   /* b24 */
-#define M32R_MFTCR_MFT1EN   (1UL<<6)   /* b25 */
-#define M32R_MFTCR_MFT2EN   (1UL<<5)   /* b26 */
-#define M32R_MFTCR_MFT3EN   (1UL<<4)   /* b27 */
-#define M32R_MFTCR_MFT4EN   (1UL<<3)   /* b28 */
-#define M32R_MFTCR_MFT5EN   (1UL<<2)   /* b29 */
-
-#define M32R_MFTMOD_CC_MASK    (1UL<<15)  /* b16 */
-#define M32R_MFTMOD_TCCR       (1UL<<13)  /* b18 */
-#define M32R_MFTMOD_GTSEL000   (0UL<<8)   /* b21-23 : 000 */
-#define M32R_MFTMOD_GTSEL001   (1UL<<8)   /* b21-23 : 001 */
-#define M32R_MFTMOD_GTSEL010   (2UL<<8)   /* b21-23 : 010 */
-#define M32R_MFTMOD_GTSEL011   (3UL<<8)   /* b21-23 : 011 */
-#define M32R_MFTMOD_GTSEL110   (6UL<<8)   /* b21-23 : 110 */
-#define M32R_MFTMOD_GTSEL111   (7UL<<8)   /* b21-23 : 111 */
-#define M32R_MFTMOD_CMSEL      (1UL<<3)   /* b28 */
-#define M32R_MFTMOD_CSSEL000   (0UL<<0)   /* b29-b31 : 000 */
-#define M32R_MFTMOD_CSSEL001   (1UL<<0)   /* b29-b31 : 001 */
-#define M32R_MFTMOD_CSSEL010   (2UL<<0)   /* b29-b31 : 010 */
-#define M32R_MFTMOD_CSSEL011   (3UL<<0)   /* b29-b31 : 011 */
-#define M32R_MFTMOD_CSSEL100   (4UL<<0)   /* b29-b31 : 100 */
-#define M32R_MFTMOD_CSSEL110   (6UL<<0)   /* b29-b31 : 110 */
-
-/*
- * Serial I/O registers.
- */
-#define M32R_SIO_OFFSET  (0x000FD000+M32R_SFR_OFFSET)
-
-#define M32R_SIO0_CR_PORTL     (0x000+M32R_SIO_OFFSET)
-#define M32R_SIO0_MOD0_PORTL   (0x004+M32R_SIO_OFFSET)
-#define M32R_SIO0_MOD1_PORTL   (0x008+M32R_SIO_OFFSET)
-#define M32R_SIO0_STS_PORTL    (0x00C+M32R_SIO_OFFSET)
-#define M32R_SIO0_TRCR_PORTL   (0x010+M32R_SIO_OFFSET)
-#define M32R_SIO0_BAUR_PORTL   (0x014+M32R_SIO_OFFSET)
-#define M32R_SIO0_RBAUR_PORTL  (0x018+M32R_SIO_OFFSET)
-#define M32R_SIO0_TXB_PORTL    (0x01C+M32R_SIO_OFFSET)
-#define M32R_SIO0_RXB_PORTL    (0x020+M32R_SIO_OFFSET)
-
-/*
- * Interrupt Control Unit registers.
- */
-#define M32R_ICU_OFFSET  (0x000FF000+M32R_SFR_OFFSET)
-
-#define M32R_ICU_ISTS_PORTL     (0x004+M32R_ICU_OFFSET)
-#define M32R_ICU_IREQ0_PORTL    (0x008+M32R_ICU_OFFSET)
-#define M32R_ICU_IREQ1_PORTL    (0x00C+M32R_ICU_OFFSET)
-#define M32R_ICU_SBICR_PORTL    (0x018+M32R_ICU_OFFSET)
-#define M32R_ICU_IMASK_PORTL    (0x01C+M32R_ICU_OFFSET)
-#define M32R_ICU_CR1_PORTL      (0x200+M32R_ICU_OFFSET)  /* INT0 */
-#define M32R_ICU_CR2_PORTL      (0x204+M32R_ICU_OFFSET)  /* INT1 */
-#define M32R_ICU_CR3_PORTL      (0x208+M32R_ICU_OFFSET)  /* INT2 */
-#define M32R_ICU_CR4_PORTL      (0x20C+M32R_ICU_OFFSET)  /* INT3 */
-#define M32R_ICU_CR5_PORTL      (0x210+M32R_ICU_OFFSET)  /* INT4 */
-#define M32R_ICU_CR6_PORTL      (0x214+M32R_ICU_OFFSET)  /* INT5 */
-#define M32R_ICU_CR7_PORTL      (0x218+M32R_ICU_OFFSET)  /* INT6 */
-#define M32R_ICU_CR8_PORTL      (0x218+M32R_ICU_OFFSET)  /* INT7 */
-#define M32R_ICU_CR32_PORTL     (0x27C+M32R_ICU_OFFSET)  /* SIO0 RX */
-#define M32R_ICU_CR33_PORTL     (0x280+M32R_ICU_OFFSET)  /* SIO0 TX */
-#define M32R_ICU_CR40_PORTL     (0x29C+M32R_ICU_OFFSET)  /* DMAC0 */
-#define M32R_ICU_CR41_PORTL     (0x2A0+M32R_ICU_OFFSET)  /* DMAC1 */
-#define M32R_ICU_CR48_PORTL     (0x2BC+M32R_ICU_OFFSET)  /* MFT0 */
-#define M32R_ICU_CR49_PORTL     (0x2C0+M32R_ICU_OFFSET)  /* MFT1 */
-#define M32R_ICU_CR50_PORTL     (0x2C4+M32R_ICU_OFFSET)  /* MFT2 */
-#define M32R_ICU_CR51_PORTL     (0x2C8+M32R_ICU_OFFSET)  /* MFT3 */
-#define M32R_ICU_CR52_PORTL     (0x2CC+M32R_ICU_OFFSET)  /* MFT4 */
-#define M32R_ICU_CR53_PORTL     (0x2D0+M32R_ICU_OFFSET)  /* MFT5 */
-#define M32R_ICU_IPICR0_PORTL   (0x2DC+M32R_ICU_OFFSET)  /* IPI0 */
-#define M32R_ICU_IPICR1_PORTL   (0x2E0+M32R_ICU_OFFSET)  /* IPI1 */
-#define M32R_ICU_IPICR2_PORTL   (0x2E4+M32R_ICU_OFFSET)  /* IPI2 */
-#define M32R_ICU_IPICR3_PORTL   (0x2E8+M32R_ICU_OFFSET)  /* IPI3 */
-#define M32R_ICU_IPICR4_PORTL   (0x2EC+M32R_ICU_OFFSET)  /* IPI4 */
-#define M32R_ICU_IPICR5_PORTL   (0x2F0+M32R_ICU_OFFSET)  /* IPI5 */
-#define M32R_ICU_IPICR6_PORTL   (0x2F4+M32R_ICU_OFFSET)  /* IPI6 */
-#define M32R_ICU_IPICR7_PORTL   (0x2FC+M32R_ICU_OFFSET)  /* IPI7 */
-
-#define M32R_ICUISTS_VECB(val)  ((val>>28) & 0xF)
-#define M32R_ICUISTS_ISN(val)   ((val>>22) & 0x3F)
-#define M32R_ICUISTS_PIML(val)  ((val>>16) & 0x7)
-
-#define M32R_ICUIMASK_IMSK0  (0UL<<16)  /* b13-b15: Disable interrupt */
-#define M32R_ICUIMASK_IMSK1  (1UL<<16)  /* b13-b15: Enable level 0 interrupt */
-#define M32R_ICUIMASK_IMSK2  (2UL<<16)  /* b13-b15: Enable level 0,1 interrupt */
-#define M32R_ICUIMASK_IMSK3  (3UL<<16)  /* b13-b15: Enable level 0-2 interrupt */
-#define M32R_ICUIMASK_IMSK4  (4UL<<16)  /* b13-b15: Enable level 0-3 interrupt */
-#define M32R_ICUIMASK_IMSK5  (5UL<<16)  /* b13-b15: Enable level 0-4 interrupt */
-#define M32R_ICUIMASK_IMSK6  (6UL<<16)  /* b13-b15: Enable level 0-5 interrupt */
-#define M32R_ICUIMASK_IMSK7  (7UL<<16)  /* b13-b15: Enable level 0-6 interrupt */
-
-#define M32R_ICUCR_IEN      (1UL<<12)  /* b19: Interrupt enable */
-#define M32R_ICUCR_IRQ      (1UL<<8)   /* b23: Interrupt request */
-#define M32R_ICUCR_ISMOD00  (0UL<<4)   /* b26-b27: Interrupt sense mode Edge HtoL */
-#define M32R_ICUCR_ISMOD01  (1UL<<4)   /* b26-b27: Interrupt sense mode Level L */
-#define M32R_ICUCR_ISMOD10  (2UL<<4)   /* b26-b27: Interrupt sense mode Edge LtoH*/
-#define M32R_ICUCR_ISMOD11  (3UL<<4)   /* b26-b27: Interrupt sense mode Level H */
-#define M32R_ICUCR_ILEVEL0  (0UL<<0)   /* b29-b31: Interrupt priority level 0 */
-#define M32R_ICUCR_ILEVEL1  (1UL<<0)   /* b29-b31: Interrupt priority level 1 */
-#define M32R_ICUCR_ILEVEL2  (2UL<<0)   /* b29-b31: Interrupt priority level 2 */
-#define M32R_ICUCR_ILEVEL3  (3UL<<0)   /* b29-b31: Interrupt priority level 3 */
-#define M32R_ICUCR_ILEVEL4  (4UL<<0)   /* b29-b31: Interrupt priority level 4 */
-#define M32R_ICUCR_ILEVEL5  (5UL<<0)   /* b29-b31: Interrupt priority level 5 */
-#define M32R_ICUCR_ILEVEL6  (6UL<<0)   /* b29-b31: Interrupt priority level 6 */
-#define M32R_ICUCR_ILEVEL7  (7UL<<0)   /* b29-b31: Disable interrupt */
-#define M32R_ICUCR_ILEVEL_MASK  (7UL)
-
-#define M32R_IRQ_INT0    (1)   /* INT0 */
-#define M32R_IRQ_INT1    (2)   /* INT1 */
-#define M32R_IRQ_INT2    (3)   /* INT2 */
-#define M32R_IRQ_INT3    (4)   /* INT3 */
-#define M32R_IRQ_INT4    (5)   /* INT4 */
-#define M32R_IRQ_INT5    (6)   /* INT5 */
-#define M32R_IRQ_INT6    (7)   /* INT6 */
-#define M32R_IRQ_INT7    (8)   /* INT7 */
-#define M32R_IRQ_MFT0    (16)  /* MFT0 */
-#define M32R_IRQ_MFT1    (17)  /* MFT1 */
-#define M32R_IRQ_MFT2    (18)  /* MFT2 */
-#define M32R_IRQ_MFT3    (19)  /* MFT3 */
-#define M32R_IRQ_MFT4    (20)  /* MFT4 */
-#define M32R_IRQ_MFT5    (21)  /* MFT5 */
-#define M32R_IRQ_DMAC0   (32)  /* DMAC0 */
-#define M32R_IRQ_DMAC1   (33)  /* DMAC1 */
-#define M32R_IRQ_SIO0_R  (48)  /* SIO0 receive */
-#define M32R_IRQ_SIO0_S  (49)  /* SIO0 send    */
-#define M32R_IRQ_SIO1_R  (50)  /* SIO1 send    */
-#define M32R_IRQ_SIO1_S  (51)  /* SIO1 receive */
-#define M32R_IRQ_IPI0    (56)  /* IPI0 */
-#define M32R_IRQ_IPI1    (57)  /* IPI1 */
-#define M32R_IRQ_IPI2    (58)  /* IPI2 */
-#define M32R_IRQ_IPI3    (59)  /* IPI3 */
-#define M32R_IRQ_IPI4    (60)  /* IPI4 */
-#define M32R_IRQ_IPI5    (61)  /* IPI5 */
-#define M32R_IRQ_IPI6    (62)  /* IPI6 */
-#define M32R_IRQ_IPI7    (63)  /* IPI7 */
-
-/*======================================================================*
- * CPU
- *======================================================================*/
-
-#define M32R_CPUID_PORTL   (0xFFFFFFE0)
-#define M32R_MCICAR_PORTL  (0xFFFFFFF0)
-#define M32R_MCDCAR_PORTL  (0xFFFFFFF4)
-#define M32R_MCCR_PORTL    (0xFFFFFFFC)
-
-#endif  /* _ASM_M32R_M32R_MP_FPGA_ */
diff --git a/arch/m32r/kernel/head.S b/arch/m32r/kernel/head.S
index a46652dd83e6..387f8700c91c 100644
--- a/arch/m32r/kernel/head.S
+++ b/arch/m32r/kernel/head.S
@@ -57,10 +57,8 @@ ENTRY(_stext)
 	srli	r4, #4		    ||	addi	r2, #-4
 	beqz	r4, .Lendloop1
 .Lloop1:
-#ifndef CONFIG_CHIP_M32310
 	; Touch memory for the no-write-allocating cache.
 	ld	r0, @(4,r2)
-#endif
 	st	r1, @+r2	    ||	addi	r4, #-1
 	st	r1, @+r2
 	st	r1, @+r2
diff --git a/arch/m32r/kernel/setup.c b/arch/m32r/kernel/setup.c
index 4975c4555fe8..222b7d90ce79 100644
--- a/arch/m32r/kernel/setup.c
+++ b/arch/m32r/kernel/setup.c
@@ -302,9 +302,6 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 #elif defined(CONFIG_CHIP_OPSP)
 	seq_printf(m,"cpu family\t: OPSP\n"
 		"cache size\t: I-8KB/D-8KB\n");
-#elif defined(CONFIG_CHIP_MP)
-	seq_printf(m, "cpu family\t: M32R-MP\n"
-		"cache size\t: I-xxKB/D-xxKB\n");
 #elif  defined(CONFIG_CHIP_M32104)
 	seq_printf(m,"cpu family\t: M32104\n"
 		"cache size\t: I-8KB/D-8KB\n");
@@ -377,7 +374,7 @@ unsigned long cpu_initialized __initdata = 0;
  * We reload them nevertheless, this function acts as a
  * 'CPU state barrier', nothing should get across.
  */
-#if defined(CONFIG_CHIP_VDEC2) || defined(CONFIG_CHIP_XNUX2)	\
+#if defined(CONFIG_CHIP_VDEC2) \
 	|| defined(CONFIG_CHIP_M32700) || defined(CONFIG_CHIP_M32102) \
 	|| defined(CONFIG_CHIP_OPSP) || defined(CONFIG_CHIP_M32104)
 void __init cpu_init (void)
diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index 1a15f81ea1bd..abf6aac647b9 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -61,7 +61,7 @@ static u32 m32r_gettimeoffset(void)
 {
 	unsigned long  elapsed_time = 0;  /* [us] */
 
-#if defined(CONFIG_CHIP_M32102) || defined(CONFIG_CHIP_XNUX2) \
+#if defined(CONFIG_CHIP_M32102) \
 	|| defined(CONFIG_CHIP_VDEC2) || defined(CONFIG_CHIP_M32700) \
 	|| defined(CONFIG_CHIP_OPSP) || defined(CONFIG_CHIP_M32104)
 #ifndef CONFIG_SMP
@@ -96,8 +96,6 @@ static u32 m32r_gettimeoffset(void)
 	elapsed_time = DIV_ROUND_CLOSEST(count, latch);
 	/* NOTE: LATCH is equal to the "interval" value (= reload count). */
 #endif /* CONFIG_SMP */
-#elif defined(CONFIG_CHIP_M32310)
-#warning do_gettimeoffse not implemented
 #else
 #error no chip configuration
 #endif
@@ -167,7 +165,7 @@ void __init time_init(void)
 {
 	arch_gettimeoffset = m32r_gettimeoffset;
 
-#if defined(CONFIG_CHIP_M32102) || defined(CONFIG_CHIP_XNUX2) \
+#if defined(CONFIG_CHIP_M32102) \
 	|| defined(CONFIG_CHIP_VDEC2) || defined(CONFIG_CHIP_M32700) \
 	|| defined(CONFIG_CHIP_OPSP) || defined(CONFIG_CHIP_M32104)
 
@@ -191,8 +189,6 @@ void __init time_init(void)
 		outl((M32R_MFTCR_MFT2MSK|M32R_MFTCR_MFT2EN), M32R_MFTCR_PORTL);
 	}
 
-#elif defined(CONFIG_CHIP_M32310)
-#warning time_init not implemented
 #else
 #error no chip configuration
 #endif
diff --git a/arch/m32r/mm/cache.c b/arch/m32r/mm/cache.c
index fac759584875..7d42a632193b 100644
--- a/arch/m32r/mm/cache.c
+++ b/arch/m32r/mm/cache.c
@@ -8,7 +8,7 @@
 
 #undef MCCR
 
-#if defined(CONFIG_CHIP_XNUX2) || defined(CONFIG_CHIP_M32700) \
+#if defined(CONFIG_CHIP_M32700) \
 	|| defined(CONFIG_CHIP_VDEC2) || defined(CONFIG_CHIP_OPSP)
 /* Cache Control Register */
 #define MCCR		((volatile unsigned long*)0xfffffffc)
-- 
1.9.0


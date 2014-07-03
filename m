Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbaGCNXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:23:55 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:39663 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877AbaGCNXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:23:13 -0400
From: Manuel Lauss <manuel.lauss@gmail.com>
To: Linux-MIPS <linux-mips@linux-mips.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Manuel Lauss <manuel.lauss@gmail.com>
Subject: [RFC PATCH v2 11/11] MIPS: Alchemy: remove old clock support
Date: Thu,  3 Jul 2014 15:22:42 +0200
Message-Id: <1404393762-858019-12-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
References: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the clock framework in place, remove unused functions and bits.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
---
 arch/mips/alchemy/common/Makefile          |  2 +-
 arch/mips/alchemy/common/clocks.c          | 87 ------------------------------
 arch/mips/alchemy/common/setup.c           | 15 ------
 arch/mips/include/asm/mach-au1x00/au1000.h | 68 -----------------------
 4 files changed, 1 insertion(+), 171 deletions(-)
 delete mode 100644 arch/mips/alchemy/common/clocks.c

diff --git a/arch/mips/alchemy/common/Makefile b/arch/mips/alchemy/common/Makefile
index c8dedcb..f64744f 100644
--- a/arch/mips/alchemy/common/Makefile
+++ b/arch/mips/alchemy/common/Makefile
@@ -5,7 +5,7 @@
 # Makefile for the Alchemy Au1xx0 CPUs, generic files.
 #
 
-obj-y += prom.o time.o clock.o clocks.o platform.o power.o \
+obj-y += prom.o time.o clock.o platform.o power.o \
 	 setup.o sleeper.o dma.o dbdma.o vss.o irq.o usb.o
 
 # optional gpiolib support
diff --git a/arch/mips/alchemy/common/clocks.c b/arch/mips/alchemy/common/clocks.c
deleted file mode 100644
index e77fa9b..0000000
--- a/arch/mips/alchemy/common/clocks.c
+++ /dev/null
@@ -1,87 +0,0 @@
-/*
- * BRIEF MODULE DESCRIPTION
- *	Simple Au1xx0 clocks routines.
- *
- * Copyright 2001, 2008 MontaVista Software Inc.
- * Author: MontaVista Software, Inc. <source@mvista.com>
- *
- *  This program is free software; you can redistribute	 it and/or modify it
- *  under  the terms of	 the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the	License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED	  ``AS	IS'' AND   ANY	EXPRESS OR IMPLIED
- *  WARRANTIES,	  INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO	EVENT  SHALL   THE AUTHOR  BE	 LIABLE FOR ANY	  DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED	  TO, PROCUREMENT OF  SUBSTITUTE GOODS	OR SERVICES; LOSS OF
- *  USE, DATA,	OR PROFITS; OR	BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN	 CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <asm/time.h>
-#include <asm/mach-au1x00/au1000.h>
-
-/*
- * I haven't found anyone that doesn't use a 12 MHz source clock,
- * but just in case.....
- */
-#define AU1000_SRC_CLK	12000000
-
-static unsigned int au1x00_clock; /*  Hz */
-
-/*
- * Set the au1000_clock
- */
-void set_au1x00_speed(unsigned int new_freq)
-{
-	au1x00_clock = new_freq;
-}
-
-unsigned int get_au1x00_speed(void)
-{
-	return au1x00_clock;
-}
-EXPORT_SYMBOL(get_au1x00_speed);
-
-/*
- * We read the real processor speed from the PLL.  This is important
- * because it is more accurate than computing it from the 32 KHz
- * counter, if it exists.  If we don't have an accurate processor
- * speed, all of the peripherals that derive their clocks based on
- * this advertised speed will introduce error and sometimes not work
- * properly.  This function is further convoluted to still allow configurations
- * to do that in case they have really, really old silicon with a
- * write-only PLL register.			-- Dan
- */
-unsigned long au1xxx_calc_clock(void)
-{
-	unsigned long cpu_speed;
-
-	/*
-	 * On early Au1000, sys_cpupll was write-only. Since these
-	 * silicon versions of Au1000 are not sold by AMD, we don't bend
-	 * over backwards trying to determine the frequency.
-	 */
-	if (au1xxx_cpu_has_pll_wo())
-		cpu_speed = 396000000;
-	else
-		cpu_speed = (AU1X_RDSYS(AU1000_SYS_CPUPLL) & 0x0000003f)
-				* AU1000_SRC_CLK;
-
-	/* On Alchemy CPU:counter ratio is 1:1 */
-	mips_hpt_frequency = cpu_speed;
-
-	set_au1x00_speed(cpu_speed);
-
-	return cpu_speed;
-}
diff --git a/arch/mips/alchemy/common/setup.c b/arch/mips/alchemy/common/setup.c
index 6f8b91d..f635934 100644
--- a/arch/mips/alchemy/common/setup.c
+++ b/arch/mips/alchemy/common/setup.c
@@ -27,12 +27,9 @@
 
 #include <linux/init.h>
 #include <linux/ioport.h>
-#include <linux/jiffies.h>
-#include <linux/module.h>
 
 #include <asm/dma-coherence.h>
 #include <asm/mipsregs.h>
-#include <asm/time.h>
 
 #include <asm/mach-au1x00/au1000.h>
 
@@ -40,18 +37,6 @@ extern void __init board_setup(void);
 
 void __init plat_mem_setup(void)
 {
-	unsigned long est_freq;
-
-	/* determine core clock */
-	est_freq = au1xxx_calc_clock();
-	est_freq += 5000;    /* round */
-	est_freq -= est_freq % 10000;
-	printk(KERN_INFO "(PRId %08x) @ %lu.%02lu MHz\n", read_c0_prid(),
-	       est_freq / 1000000, ((est_freq % 1000000) * 100) / 1000000);
-
-	/* this is faster than wasting cycles trying to approximate it */
-	preset_lpj = (est_freq >> 1) / HZ;
-
 	if (au1xxx_cpu_needs_config_od())
 		/* Various early Au1xx0 errata corrected by this */
 		set_c0_config(1 << 19); /* Set Config[OD] */
diff --git a/arch/mips/include/asm/mach-au1x00/au1000.h b/arch/mips/include/asm/mach-au1x00/au1000.h
index 46ce1fe..a582a5e 100644
--- a/arch/mips/include/asm/mach-au1x00/au1000.h
+++ b/arch/mips/include/asm/mach-au1x00/au1000.h
@@ -480,69 +480,6 @@
 #define AU1000_SYS_AUXPLL	0x0064
 #define AU1300_SYS_AUXPLL2	0x0068
 
-/* SYS_FREQCTRLx bits */
-#  define SYS_FC_FRDIV2_BIT	22
-#  define SYS_FC_FRDIV2_MASK	(0xff << SYS_FC_FRDIV2_BIT)
-#  define SYS_FC_FE2		(1 << 21)
-#  define SYS_FC_FS2		(1 << 20)
-#  define SYS_FC_FRDIV1_BIT	12
-#  define SYS_FC_FRDIV1_MASK	(0xff << SYS_FC_FRDIV1_BIT)
-#  define SYS_FC_FE1		(1 << 11)
-#  define SYS_FC_FS1		(1 << 10)
-#  define SYS_FC_FRDIV0_BIT	2
-#  define SYS_FC_FRDIV0_MASK	(0xff << SYS_FC_FRDIV0_BIT)
-#  define SYS_FC_FE0		(1 << 1)
-#  define SYS_FC_FS0		(1 << 0)
-#  define SYS_FC_FRDIV5_BIT	22
-#  define SYS_FC_FRDIV5_MASK	(0xff << SYS_FC_FRDIV5_BIT)
-#  define SYS_FC_FE5		(1 << 21)
-#  define SYS_FC_FS5		(1 << 20)
-#  define SYS_FC_FRDIV4_BIT	12
-#  define SYS_FC_FRDIV4_MASK	(0xff << SYS_FC_FRDIV4_BIT)
-#  define SYS_FC_FE4		(1 << 11)
-#  define SYS_FC_FS4		(1 << 10)
-#  define SYS_FC_FRDIV3_BIT	2
-#  define SYS_FC_FRDIV3_MASK	(0xff << SYS_FC_FRDIV3_BIT)
-#  define SYS_FC_FE3		(1 << 1)
-#  define SYS_FC_FS3		(1 << 0)
-
-/* SYS_CLKSRC bits */
-#  define SYS_CS_ME1_BIT	27
-#  define SYS_CS_ME1_MASK	(0x7 << SYS_CS_ME1_BIT)
-#  define SYS_CS_DE1		(1 << 26)
-#  define SYS_CS_CE1		(1 << 25)
-#  define SYS_CS_ME0_BIT	22
-#  define SYS_CS_ME0_MASK	(0x7 << SYS_CS_ME0_BIT)
-#  define SYS_CS_DE0		(1 << 21)
-#  define SYS_CS_CE0		(1 << 20)
-#  define SYS_CS_MI2_BIT	17
-#  define SYS_CS_MI2_MASK	(0x7 << SYS_CS_MI2_BIT)
-#  define SYS_CS_DI2		(1 << 16)
-#  define SYS_CS_CI2		(1 << 15)
-#  define SYS_CS_ML_BIT		7
-#  define SYS_CS_ML_MASK	(0x7 << SYS_CS_ML_BIT)
-#  define SYS_CS_DL		(1 << 6)
-#  define SYS_CS_CL		(1 << 5)
-#  define SYS_CS_MUH_BIT	12
-#  define SYS_CS_MUH_MASK	(0x7 << SYS_CS_MUH_BIT)
-#  define SYS_CS_DUH		(1 << 11)
-#  define SYS_CS_CUH		(1 << 10)
-#  define SYS_CS_MUD_BIT	7
-#  define SYS_CS_MUD_MASK	(0x7 << SYS_CS_MUD_BIT)
-#  define SYS_CS_DUD		(1 << 6)
-#  define SYS_CS_CUD		(1 << 5)
-#  define SYS_CS_MIR_BIT	2
-#  define SYS_CS_MIR_MASK	(0x7 << SYS_CS_MIR_BIT)
-#  define SYS_CS_DIR		(1 << 1)
-#  define SYS_CS_CIR		(1 << 0)
-#  define SYS_CS_MUX_AUX	0x1
-#  define SYS_CS_MUX_FQ0	0x2
-#  define SYS_CS_MUX_FQ1	0x3
-#  define SYS_CS_MUX_FQ2	0x4
-#  define SYS_CS_MUX_FQ3	0x5
-#  define SYS_CS_MUX_FQ4	0x6
-#  define SYS_CS_MUX_FQ5	0x7
-
 
 /* Au15x0 PCI *********************************************************/
 
@@ -826,11 +763,6 @@ static inline int alchemy_get_macs(int type)
 	return 0;
 }
 
-/* arch/mips/au1000/common/clocks.c */
-extern void set_au1x00_speed(unsigned int new_freq);
-extern unsigned int get_au1x00_speed(void);
-extern unsigned long au1xxx_calc_clock(void);
-
 /* PM: arch/mips/alchemy/common/sleeper.S, power.c, irq.c */
 void alchemy_sleep_au1000(void);
 void alchemy_sleep_au1550(void);
-- 
2.0.0


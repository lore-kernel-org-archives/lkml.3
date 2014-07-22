Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbaGVKJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:09:07 -0400
Received: from mail.aswsp.com ([193.34.35.150]:10712 "EHLO mail.aswsp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbaGVKJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:09:05 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2014 06:09:05 EDT
Date: Tue, 22 Jul 2014 12:03:46 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, Lee Jones <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mtd: nand: define struct nand_timings
Message-ID: <20140722120346.0f2d0e77@parrot.com>
In-Reply-To: <1405064982-11456-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1405064982-11456-1-git-send-email-boris.brezillon@free-electrons.com>
	<1405064982-11456-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [46.218.109.88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Do you know if all these timings will be used by the nand drivers ?

I did a similar patch [1] (that wasn't merged :( ), and I used reduced
timing info.

I also have support for the omap driver
(http://article.gmane.org/gmane.linux.ports.arm.omap/88606/match=) and
a controller we use in our chip (not upstream).

Matthieu

[1]
[PATCH 2/3] mtd nand : get timings from onfi

We get from onfi param the max speed supported by the chip.
A precomputed table for ONFI timings is generated.

Signed-off-by: Matthieu CASTET <matthieu.castet@parrot.com>
---
 drivers/mtd/nand/Makefile      |    2 +-
 drivers/mtd/nand/nand_base.c   |    1 +
 drivers/mtd/nand/nand_timing.c |  170 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mtd/nand.h       |   56 +++++++++++++
 4 files changed, 228 insertions(+), 1 deletion(-)
 create mode 100644 drivers/mtd/nand/nand_timing.c

diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index 2cbd091..2fc1a99 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -54,4 +54,4 @@ obj-$(CONFIG_MTD_NAND_JZ4740)		+= jz4740_nand.o
 obj-$(CONFIG_MTD_NAND_GPMI_NAND)	+= gpmi-nand/
 obj-$(CONFIG_MTD_NAND_XWAY)		+= xway_nand.o
 
-nand-objs := nand_base.o nand_bbt.o
+nand-objs := nand_base.o nand_bbt.o nand_timing.o
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 8916bc6..0d6bd88 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3238,6 +3238,7 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
 	if (*maf_id != NAND_MFR_SAMSUNG && !type->pagesize)
 		chip->options &= ~NAND_SAMSUNG_LP_OPTIONS;
 ident_done:
+	nand_select_speed(chip, *maf_id, *dev_id);
 
 	/* Try to identify manufacturer */
 	for (maf_idx = 0; nand_manuf_ids[maf_idx].id != 0x0; maf_idx++) {
diff --git a/drivers/mtd/nand/nand_timing.c b/drivers/mtd/nand/nand_timing.c
new file mode 100644
index 0000000..7211c9c
--- /dev/null
+++ b/drivers/mtd/nand/nand_timing.c
@@ -0,0 +1,170 @@
+/*
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
+
+/*
+ * this table is precomputed from onfi timings with the following program
+ */
+#if 0
+int print_timing(const struct onfi_timings *timings, int edo_off)
+{
+	struct reduced_onfi t;
+	int tmp;
+	int edo = timings->tRC < 30 && !edo_off;
+
+	/* nWE low */
+	t.twp = max(timings->tWP, timings->tDS);
+
+	/* nCS low to nWE low */
+	tmp = max(timings->tCLS, timings->tCS);
+	tmp = max(tmp, timings->tALS);
+	t.twsetup = tmp - t.twp;
+	assert(t.twsetup >= 0);
+
+	/* nWE high */
+	tmp = max(timings->tWH, timings->tDH); /* nWE high & data hold */
+	tmp = max(tmp, timings->tCH); /* cs hold */
+	tmp = max(tmp, timings->tCLH); /* cmd hold */
+	t.twh = max(tmp, timings->tALH); /* addr hold */
+
+	assert(t.twp + t.twh <= timings->tWC);
+	t.twc = timings->tWC;
+
+	t.edo = edo;
+	if (edo == 0) {
+
+		/* nRE low */
+		t.trp = max(timings->tRP, timings->tREA);
+
+		/* nRE high */
+		t.treh = timings->tREH;
+		t.trc = max(timings->tRC, t.trp + t.treh);
+	}
+	else {
+		/* nRE low */
+		t.trp = timings->tRP;
+
+		/* nRE high */
+		t.treh = timings->tREH;
+
+		t.trc = max(timings->tRC, timings->tREA);
+	}
+
+	/* nCS low to nRE low */
+	t.trsetup = max(timings->tCEA - timings->tREA, timings->tCLR);
+
+	/* Min time from rdn rising edge to output hi-Z */
+	t.bta = timings->tRHZ;
+
+	/* Min time from busy rising edge and rdn falling edge (read).*/
+	t.tbusy = timings->tRR;
+
+	/* Min time from wrn rising edge to rdn falling edge. */
+	t.twhr = timings->tWHR;
+	assert(t.twhr >= 0);
+
+	t.tceh = 0;
+
+	printf("{\n");
+	printf("/* %s edo=%d */\n", timings->name, t.edo);
+	printf(".twp = %3d,  .twh = %3d, .twc = %3d, .twsetup = %d,\n",
+			t.twp, t.twh, t.twc, t.twsetup);
+	printf(".trp = %3d,  .treh = %3d, .trc = %3d, .trsetup = %d,\n",
+			t.trp, t.treh, t.trc, t.trsetup);
+	printf(".twhr = %d, .tceh = %d,  .bta = %d, .tbusy = %d, .edo = %d,\n",
+			t.twhr, t.tceh, t.bta, t.tbusy, t.edo);
+	printf("},\n");
+#endif
+
+static struct reduced_onfi nand_timing[] =
+{
+	{
+		/* onfi mode 0 edo=0 */
+		.twp =  50,  .twh =  30, .twc = 100, .twsetup = 20,
+		.trp =  50,  .treh =  30, .trc = 100, .trsetup = 60,
+		.twhr = 120, .tceh = 0,  .bta = 200, .tbusy = 39, .edo = 0,
+	},
+	{
+		/* onfi mode 1 edo=0 */
+		.twp =  25,  .twh =  15, .twc =  45, .twsetup = 10,
+		.trp =  30,  .treh =  15, .trc =  50, .trsetup = 15,
+		.twhr = 80, .tceh = 0,  .bta = 100, .tbusy = 20, .edo = 0,
+	},
+	{
+		/* onfi mode 2 edo=0 */
+		.twp =  17,  .twh =  15, .twc =  35, .twsetup = 8,
+		.trp =  25,  .treh =  15, .trc =  40, .trsetup = 10,
+		.twhr = 80, .tceh = 0,  .bta = 100, .tbusy = 20, .edo = 0,
+	},
+	{
+		/* onfi mode 3 edo=0 */
+		.twp =  15,  .twh =  10, .twc =  30, .twsetup = 10,
+		.trp =  20,  .treh =  10, .trc =  30, .trsetup = 10,
+		.twhr = 60, .tceh = 0,  .bta = 100, .tbusy = 20, .edo = 0,
+	},
+	{
+		/* onfi mode 4 edo=1 */
+		.twp =  12,  .twh =  10, .twc =  25, .twsetup = 8,
+		.trp =  12,  .treh =  10, .trc =  25, .trsetup = 10,
+		.twhr = 60, .tceh = 0,  .bta = 100, .tbusy = 20, .edo = 1,
+	},
+	{
+		/* onfi mode 5 edo=1 */
+		.twp =  10,  .twh =   7, .twc =  20, .twsetup = 5,
+		.trp =  10,  .treh =   7, .trc =  20, .trsetup = 10,
+		.twhr = 60, .tceh = 0,  .bta = 100, .tbusy = 20, .edo = 1,
+	},
+	{
+		/* onfi mode 4 edo=0 */
+		.twp =  12,  .twh =  10, .twc =  25, .twsetup = 8,
+		.trp =  20,  .treh =  10, .trc =  30, .trsetup = 10,
+		.twhr = 60, .tceh = 0,  .bta = 100, .tbusy = 20, .edo = 0,
+	},
+	{
+		/* onfi mode 5 edo=0 */
+		.twp =  10,  .twh =   7, .twc =  20, .twsetup = 5,
+		.trp =  16,  .treh =   7, .trc =  23, .trsetup = 10,
+		.twhr = 60, .tceh = 0,  .bta = 100, .tbusy = 20, .edo = 0,
+	},
+};
+
+void nand_select_speed(struct nand_chip *chip, int maf_id, int dev_id)
+{
+	int i;
+	chip->onfi_speed = -1;
+	if (chip->onfi_version) {
+		int mode = le16_to_cpu(chip->onfi_params.async_timing_mode);
+		int max_mode = 0;
+		for (i = 0; i <= 5; i++) {
+			if (mode & (1 << i))
+				max_mode = i;
+		}
+		chip->onfi_speed = max_mode;
+	}
+	/*
+	 * For flash that are not ONFI we could use maf_id and dev_id to select a
+	 * speed. But we need to make sure to select a speed compatible with all
+	 * flash generation that share the same ids.
+	 */
+}
+
+const struct reduced_onfi *nand_get_timing(int mode, int edo)
+{
+	if (mode < 0)
+		mode = 0;
+	if (!edo && mode >= 4)
+		mode += 2;
+	if (mode >  ARRAY_SIZE(nand_timing))
+		mode = 0;
+	return &(nand_timing[mode]);
+}
+EXPORT_SYMBOL_GPL(nand_get_timing);
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index c8518d4..95f2871 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -474,6 +474,7 @@ struct nand_buffers {
  * @pagebuf_bitflips:	[INTERN] holds the bitflip count for the page which is
  *			currently in data_buf.
  * @subpagesize:	[INTERN] holds the subpagesize
+ * @onfi_speed:		[INTERN] holds the ONFI speed, -1 if not supported.
  * @onfi_version:	[INTERN] holds the chip ONFI version (BCD encoded),
  *			non 0 if ONFI supported.
  * @onfi_params:	[INTERN] holds the ONFI page parameter when ONFI is
@@ -545,6 +546,7 @@ struct nand_chip {
 	int badblockpos;
 	int badblockbits;
 
+	int	onfi_speed;
 	int onfi_version;
 	struct nand_onfi_params	onfi_params;
 
@@ -691,6 +693,60 @@ struct platform_nand_data {
 	struct platform_nand_ctrl ctrl;
 };
 
+/**
+ * timing in ns,
+ *  there are computed from onfi table :
+ *  twsetup = max(tCLS, tCS, tALS) - twp
+ *  twp = max(tWP, tDS)
+ *  twh = max(tCLH, tCH, tALH, tDH, tWH)
+ *  twc = tWC
+ *  trsetup = max(tCEA-tREA, tCLR)
+ *  treh = tREH
+ *  if (edo == 0) {
+ *    trp = max(tRP, tREA)
+ *    trc = max(tRC, trp + treh)
+ *  }
+ *  else {
+ *    trp = tRP
+ *    trc = max(tRC, tREA)
+ *  }
+ *
+ *  bta = max(tRHZ, tCHZ)
+ *  busy = tRR
+ *  twhr = tWHR
+ *
+ *  Note that twp + twh can be smaller than twc, so you should do :
+ *  twp_clk = ns_to_ticks(twp)
+ *  twh_clk = ns_to_ticks(max(twh, twc - ticks_to_ns(twp_clk)))
+ *  or
+ *  twh_clk = ps_to_ticks(max(ns_to_ps(twh), ns_to_ps(twc) - ticks_to_ps(twp_clk)))
+ *  using picosecond can help for rounding. For example a 156Mhz, mode=4 edo=1
+ *  with ps we got twp_clk=twh_clk=2 (12820 ps)
+ *  without ps we got twp_clk = 2 (12 ns) and twh_clk=3 (18 ns)
+ *  This is because 12820 + 12820 > 15000 but 12 + 12 < 15.
+ */
+struct reduced_onfi {
+	u8 twsetup; /* nCS low to nWE low */
+	u8 twp; /* nWE low */
+	u8 twh; /* nWE high */
+	u8 twc; /* write cyle */
+
+	u8 trsetup; /* nCS low to nRE low */
+	u8 trp; /* nRE low */
+	u8 treh; /* nRE high */
+	u8 trc; /* read cycle */
+
+	u8 bta; /* Min time from nRE rising edge to output hi-Z */
+	u8 tbusy; /* Min time from busy rising edge and nRE falling edge */
+	u8 twhr; /* Min time from nWE rising edge to nRE falling edge. */
+	u8 tceh; /* Min time for nCE high */
+
+	u8 edo; /* edo mode */
+};
+
+void nand_select_speed(struct nand_chip *chip, int maf_id, int dev_id);
+const struct reduced_onfi *nand_get_timing(int mode, int edo);
+
 /* Some helpers to access the data structures */
 static inline
 struct platform_nand_chip *get_platform_nandchip(struct mtd_info *mtd)
-- 
1.7.10.4
Le Fri, 11 Jul 2014 09:49:41 +0200,
Boris BREZILLON <boris.brezillon@free-electrons.com> a écrit :

> Define a struct containing the standard NAND timings as described in NAND
> datasheets.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  include/linux/mtd/nand.h | 49 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
> index 2f0af28..a3a45f2 100644
> --- a/include/linux/mtd/nand.h
> +++ b/include/linux/mtd/nand.h
> @@ -947,4 +947,53 @@ static inline int jedec_feature(struct nand_chip *chip)
>  	return chip->jedec_version ? le16_to_cpu(chip->jedec_params.features)
>  		: 0;
>  }
> +
> +/**
> + * struct nand_sdr_timings - SDR NAND chip timings
> + *
> + * This struct defines the timing requirements of a SDR NAND chip.
> + * These informations can be found in every NAND datasheets and the timings
> + * meaning are described in the ONFI specifications:
> + * www.onfi.org/~/media/ONFI/specs/onfi_3_1_spec.pdf (chapter 4.15 Timing
> + * Parameters)
> + *
> + * All these timings are expressed in picoseconds.
> + */
> +
> +struct nand_sdr_timings {
> +	u32 tALH_min;
> +	u32 tADL_min;
> +	u32 tALS_min;
> +	u32 tAR_min;
> +	u32 tCEA_max;
> +	u32 tCEH_min;
> +	u32 tCH_min;
> +	u32 tCHZ_max;
> +	u32 tCLH_min;
> +	u32 tCLR_min;
> +	u32 tCLS_min;
> +	u32 tCOH_min;
> +	u32 tCS_min;
> +	u32 tDH_min;
> +	u32 tDS_min;
> +	u32 tFEAT_max;
> +	u32 tIR_min;
> +	u32 tITC_max;
> +	u32 tRC_min;
> +	u32 tREA_max;
> +	u32 tREH_min;
> +	u32 tRHOH_min;
> +	u32 tRHW_min;
> +	u32 tRHZ_max;
> +	u32 tRLOH_min;
> +	u32 tRP_min;
> +	u32 tRR_min;
> +	u64 tRST_max;
> +	u32 tWB_max;
> +	u32 tWC_min;
> +	u32 tWH_min;
> +	u32 tWHR_min;
> +	u32 tWP_min;
> +	u32 tWW_min;
> +};
>  #endif /* __LINUX_MTD_NAND_H */


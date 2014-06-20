Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935042AbaFTP4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:56:33 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:36126 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbaFTP4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:56:30 -0400
MIME-Version: 1.0
Date: Fri, 20 Jun 2014 21:26:27 +0530
Message-ID: <CAA_L+UPtA9ahtF4oeGCeR27e-q=tCtoKfXqDhrJR_UgVGu9Aaw@mail.gmail.com>
Subject: [PATCH 3.15.1] i82975x_edac: fix dram layout inits and style
From: Arvind R <arvino55@gmail.com>
To: linux-edac <linux-edac@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 3.15.1] i82975x_edac: fix dram layout inits and style

rewrite dram layout initialisation differently based on symmetry
of organisation. And a long pending cleanup.
Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 i82975x_edac.c |  408 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 207 insertions(+), 201 deletions(-)

--- a/drivers/edac/i82975x_edac.c	2014-06-08 23:49:54.000000000 +0530
+++ b/drivers/edac/i82975x_edac.c	2014-06-20 19:18:28.608312592 +0530
@@ -16,7 +16,7 @@
 #include <linux/edac.h>
 #include "edac_core.h"

-#define I82975X_REVISION	" Ver: 1.0.0"
+#define I82975X_REVISION	" Ver: 2.0.1"
 #define EDAC_MOD_STR		"i82975x_edac"

 #define i82975x_printk(level, fmt, arg...) \
@@ -29,8 +29,11 @@
 #define PCI_DEVICE_ID_INTEL_82975_0	0x277c
 #endif				/* PCI_DEVICE_ID_INTEL_82975_0 */

-#define I82975X_NR_DIMMS		8
-#define I82975X_NR_CSROWS(nr_chans)	(I82975X_NR_DIMMS / (nr_chans))
+#define I82975X_NR_CHANNELS	2
+#define	I82975X_NR_CSROWS_PER_CHANNEL	4
+#define	I82975X_NR_CSROWS_PER_DIMM	2
+
+#define	I82975X_ECC_GRAIN	(1 << 7)

 /* Intel 82975X register addresses - device 0 function 0 - DRAM Controller */
 #define I82975X_EAP		0x58	/* Dram Error Address Pointer (32b)
@@ -48,7 +51,7 @@
 #define I82975X_DES		0x5d	/* Dram ERRor DeSTination (8b)
 					 * 0h:    Processor Memory Reads
 					 * 1h:7h  reserved
-					 * More - See Page 65 of Intel DocSheet.
+					 * More - See Pg.65 of Intel DocSheet.
 					 */

 #define I82975X_ERRSTS		0xc8	/* Error Status Register (16b)
@@ -98,7 +101,7 @@
 #define I82975X_XEAP	0xfc	/* Extended Dram Error Address Pointer (8b)
 					 *
 					 * 7:1   reserved
-					 * 0     Bit32 of the Dram Error Address
+					 * 0     Bit32 of Dram Error Address
 					 */

 #define I82975X_MCHBAR		0x44	/*
@@ -167,7 +170,8 @@
 #define I82975X_C0BNKARC	0x10e
 #define I82975X_C1BNKARC	0x18e

-
+#define I82975X_C0DRT1		0x114
+#define I82975X_C1DRT1		0x194

 #define I82975X_DRC		0x120 /* DRAM Controller Mode0 (32b)
 					 *
@@ -202,12 +206,16 @@
 #define I82975X_DRC_CH0M1		0x124
 #define I82975X_DRC_CH1M1		0x1A4

+#define	I82975X_BIT_ERROR_CE	0x01
+#define	I82975X_BIT_ERROR_UE	0x02
+#define	I82975X_BITS_ERROR		0x03
+
 enum i82975x_chips {
-	I82975X = 0,
+	I82975X_chip = 0,
 };

 struct i82975x_pvt {
-	void __iomem *mch_window;
+	enum i82975x_chips chip;
 };

 struct i82975x_dev_info {
@@ -225,7 +233,7 @@
 };

 static const struct i82975x_dev_info i82975x_devs[] = {
-	[I82975X] = {
+	[I82975X_chip] = {
 		.ctl_name = "i82975x"
 	},
 };
@@ -236,7 +244,7 @@

 static int i82975x_registered = 1;

-static void i82975x_get_error_info(struct mem_ctl_info *mci,
+static bool i82975x_get_error_info(struct mem_ctl_info *mci,
 		struct i82975x_error_info *info)
 {
 	struct pci_dev *pdev;
@@ -255,7 +263,8 @@
 	pci_read_config_byte(pdev, I82975X_DERRSYN, &info->derrsyn);
 	pci_read_config_word(pdev, I82975X_ERRSTS, &info->errsts2);

-	pci_write_bits16(pdev, I82975X_ERRSTS, 0x0003, 0x0003);
+	pci_write_bits16(pdev, I82975X_ERRSTS, I82975X_BITS_ERROR,
+				I82975X_BITS_ERROR);

 	/*
 	 * If the error is the same then we can for both reads then
@@ -263,31 +272,30 @@
 	 * there is a CE no info and the second set of reads is valid
 	 * and should be UE info.
 	 */
-	if (!(info->errsts2 & 0x0003))
-		return;
+	if (!(info->errsts2 & I82975X_BITS_ERROR))
+		return false;

-	if ((info->errsts ^ info->errsts2) & 0x0003) {
+	if ((info->errsts ^ info->errsts2) & I82975X_BITS_ERROR) {
 		pci_read_config_dword(pdev, I82975X_EAP, &info->eap);
 		pci_read_config_byte(pdev, I82975X_XEAP, &info->xeap);
 		pci_read_config_byte(pdev, I82975X_DES, &info->des);
 		pci_read_config_byte(pdev, I82975X_DERRSYN,
 				&info->derrsyn);
 	}
+	return true;
 }

 static int i82975x_process_error_info(struct mem_ctl_info *mci,
 		struct i82975x_error_info *info, int handle_errors)
 {
+	enum hw_event_mc_err_type err_type;
 	int row, chan;
 	unsigned long offst, page;

-	if (!(info->errsts2 & 0x0003))
-		return 0;
-
 	if (!handle_errors)
 		return 1;

-	if ((info->errsts ^ info->errsts2) & 0x0003) {
+	if ((info->errsts ^ info->errsts2) & I82975X_BITS_ERROR) {
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1, 0, 0, 0,
 				     -1, -1, -1, "UE overwrote CE", "");
 		info->errsts = info->errsts2;
@@ -299,30 +307,15 @@
 		page |= 0x80000000;
 	page >>= (PAGE_SHIFT - 1);
 	row = edac_mc_find_csrow_by_page(mci, page);
+	chan = (mci->num_cschannel == 1 ? 0 : (info->eap & 1));
+	offst = info->eap & ((1 << PAGE_SHIFT) - I82975X_ECC_GRAIN);

-	if (row == -1)	{
-		i82975x_mc_printk(mci, KERN_ERR, "error processing EAP:\n"
-			"\tXEAP=%u\n"
-			"\t EAP=0x%08x\n"
-			"\tPAGE=0x%08x\n",
-			(info->xeap & 1) ? 1 : 0, info->eap, (unsigned int) page);
-		return 0;
-	}
-	chan = (mci->csrows[row]->nr_channels == 1) ? 0 : info->eap & 1;
-	offst = info->eap
-			& ((1 << PAGE_SHIFT) -
-			   (1 << mci->csrows[row]->channels[chan]->dimm->grain));
-
-	if (info->errsts & 0x0002)
-		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci, 1,
-				     page, offst, 0,
-				     row, -1, -1,
-				     "i82975x UE", "");
-	else
-		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, 1,
+	err_type = (info->errsts & I82975X_BIT_ERROR_UE) ?
+			HW_EVENT_ERR_UNCORRECTED : HW_EVENT_ERR_CORRECTED;
+	edac_mc_handle_error(err_type, mci, 1,
 				     page, offst, info->derrsyn,
-				     row, chan ? chan : 0, -1,
-				     "i82975x CE", "");
+				     row, chan, -1,
+				     "i82975x", "");

 	return 1;
 }
@@ -331,52 +324,20 @@
 {
 	struct i82975x_error_info info;

-	edac_dbg(1, "MC%d\n", mci->mc_idx);
-	i82975x_get_error_info(mci, &info);
-	i82975x_process_error_info(mci, &info, 1);
-}
-
-/* Return 1 if dual channel mode is active.  Else return 0. */
-static int dual_channel_active(void __iomem *mch_window)
-{
-	/*
-	 * We treat interleaved-symmetric configuration as dual-channel - EAP's
-	 * bit-0 giving the channel of the error location.
-	 *
-	 * All other configurations are treated as single channel - the EAP's
-	 * bit-0 will resolve ok in symmetric area of mixed
-	 * (symmetric/asymmetric) configurations
-	 */
-	u8	drb[4][2];
-	int	row;
-	int    dualch;
-
-	for (dualch = 1, row = 0; dualch && (row < 4); row++) {
-		drb[row][0] = readb(mch_window + I82975X_DRB + row);
-		drb[row][1] = readb(mch_window + I82975X_DRB + row + 0x80);
-		dualch = dualch && (drb[row][0] == drb[row][1]);
-	}
-	return dualch;
-}
-
-static enum dev_type i82975x_dram_type(void __iomem *mch_window, int rank)
-{
-	/*
-	 * ECC is possible on i92975x ONLY with DEV_X8
-	 */
-	return DEV_X8;
+	edac_dbg(4, "MC%d\n", mci->mc_idx);
+	if (i82975x_get_error_info(mci, &info))
+		i82975x_process_error_info(mci, &info, 1);
 }

 static void i82975x_init_csrows(struct mem_ctl_info *mci,
-		struct pci_dev *pdev, void __iomem *mch_window)
+			void __iomem *mch_window, bool is_symmetric)
 {
 	struct csrow_info *csrow;
 	unsigned long last_cumul_size;
 	u8 value;
 	u32 cumul_size, nr_pages;
-	int index, chan;
+	unsigned index, chan, asym_index, asym_offst;
 	struct dimm_info *dimm;
-	enum dev_type dtype;

 	last_cumul_size = 0;

@@ -389,73 +350,149 @@
 	 *
 	 */

-	for (index = 0; index < mci->nr_csrows; index++) {
+	for (index = 0; index < I82975X_NR_CSROWS_PER_CHANNEL; index++) {
 		csrow = mci->csrows[index];
-
-		value = readb(mch_window + I82975X_DRB + index +
-					((index >= 4) ? 0x80 : 0));
-		cumul_size = value;
+		if (is_symmetric)	{
+			value = readb(mch_window + I82975X_DRB + index);
+			cumul_size = (((u32) value) << 1);
+		} else	{
+			asym_index = index * I82975X_NR_CSROWS_PER_DIMM;
+			asym_offst = 0;
+			if (asym_index >= I82975X_NR_CSROWS_PER_CHANNEL) {
+				asym_index -= I82975X_NR_CSROWS_PER_CHANNEL;
+				asym_offst = 0x80;
+			}
+			/* Values are cumulative, so read last reg. of rank */
+			value = readb(mch_window + I82975X_DRB + asym_index
+					+ asym_offst
+					+ (I82975X_NR_CSROWS_PER_DIMM - 1));
+			cumul_size = value;
+		}
 		cumul_size <<= (I82975X_DRB_SHIFT - PAGE_SHIFT);
-		/*
-		 * Adjust cumul_size w.r.t number of channels
-		 *
-		 */
-		if (csrow->nr_channels > 1)
-			cumul_size <<= 1;
 		edac_dbg(3, "(%d) cumul_size 0x%x\n", index, cumul_size);

 		nr_pages = cumul_size - last_cumul_size;
 		if (!nr_pages)
 			continue;

-		/*
-		 * Initialise dram labels
-		 * index values:
-		 *   [0-7] for single-channel; i.e. csrow->nr_channels = 1
-		 *   [0-3] for dual-channel; i.e. csrow->nr_channels = 2
-		 */
-		dtype = i82975x_dram_type(mch_window, index);
-		for (chan = 0; chan < csrow->nr_channels; chan++) {
-			dimm = mci->csrows[index]->channels[chan]->dimm;
-
-			dimm->nr_pages = nr_pages / csrow->nr_channels;
-
-			snprintf(csrow->channels[chan]->dimm->label, EDAC_MC_LABEL_LEN, "DIMM %c%d",
-				 (chan == 0) ? 'A' : 'B',
-				 index);
-			dimm->grain = 1 << 7;	/* 128Byte cache-line resolution */
-			dimm->dtype = i82975x_dram_type(mch_window, index);
-			dimm->mtype = MEM_DDR2; /* I82975x supports only DDR2 */
-			dimm->edac_mode = EDAC_SECDED; /* only supported */
-		}
-
 		csrow->first_page = last_cumul_size;
 		csrow->last_page = cumul_size - 1;
 		last_cumul_size = cumul_size;
+
+		/*
+		* Initialise dram labels
+		*/
+		if (is_symmetric)	{
+			for (chan = 0; chan < I82975X_NR_CHANNELS; chan++) {
+				dimm = csrow->channels[chan]->dimm;
+				dimm->nr_pages = nr_pages / I82975X_NR_CHANNELS;
+				snprintf(dimm->label, EDAC_MC_LABEL_LEN,
+					"DIMM %c%d", chan + 'A',
+					 ((index / I82975X_NR_CSROWS_PER_DIMM)
+						+ 1));
+			}
+		} else	{
+			dimm = mci->dimms[index];
+			dimm->nr_pages = nr_pages;
+			snprintf(dimm->label,
+					 EDAC_MC_LABEL_LEN, "DIMM %c%d",
+					 ((index / 2) + 'A'),
+					 ((index % 2) + 1));
+		}
+		dimm->grain = I82975X_ECC_GRAIN;	/* always */
+		dimm->dtype = DEV_X8;	/* only with ECC */
+		dimm->mtype = MEM_DDR2; /* only supported */
+		dimm->edac_mode = EDAC_SECDED; /* only supported */
 	}
 }

-/* #define  i82975x_DEBUG_IOMEM */
-
-#ifdef i82975x_DEBUG_IOMEM
-static void i82975x_print_dram_timings(void __iomem *mch_window)
-{
-	/*
-	 * The register meanings are from Intel specs;
-	 * (shows 13-5-5-5 for 800-DDR2)
-	 * Asus P5W Bios reports 15-5-4-4
-	 * What's your religion?
-	 */
+#ifdef CONFIG_EDAC_DEBUG
+static void i82975x_print_dram_settings(void __iomem *mch_window,
+				u32 mchbar, u32 *drc, bool is_symmetric)
+{
+	static const char *refresh_modes[8] = {
+			"disabled",
+			"15.6 uSec", "7.8 uSec", "3.9 uSec", "1.95 uSec",
+			"reserved", "reserved",
+			"fast refresh (64 clocks)"
+			};
+	static const char *rank_attr[8] = {
+			"empty   ", "reserved",
+			"4 Kb    ", "8 Kb    ", "16 Kb   ",
+			"reserved", "reserved", "reserved"
+			};
 	static const int caslats[4] = { 5, 4, 3, 6 };
 	u32	dtreg[2];
+	u8 drb[4];
+	u8 dra[2][2];
+
+	/* Show memory config if debug level is 1 or upper */
+	if (!edac_debug_level)
+		return;
+
+	i82975x_printk(KERN_INFO, "MCHBAR real = %0x, remapped = %p\n",
+					mchbar, mch_window);
+
+	drb[0] = readb(mch_window + I82975X_DRB_CH0R0);
+	drb[1] = readb(mch_window + I82975X_DRB_CH0R1);
+	drb[2] = readb(mch_window + I82975X_DRB_CH0R2);
+	drb[3] = readb(mch_window + I82975X_DRB_CH0R3);
+	i82975x_printk(KERN_INFO, "DRBCH0R0 = 0x%02x\n", drb[0]);
+	i82975x_printk(KERN_INFO, "DRBCH0R1 = 0x%02x\n", drb[1]);
+	i82975x_printk(KERN_INFO, "DRBCH0R2 = 0x%02x\n", drb[2]);
+	i82975x_printk(KERN_INFO, "DRBCH0R3 = 0x%02x\n\n", drb[3]);
+	drb[0] = readb(mch_window + I82975X_DRB_CH1R0);
+	drb[1] = readb(mch_window + I82975X_DRB_CH1R1);
+	drb[2] = readb(mch_window + I82975X_DRB_CH1R2);
+	drb[3] = readb(mch_window + I82975X_DRB_CH1R3);
+	i82975x_printk(KERN_INFO, "DRBCH1R0 = 0x%02x\n", drb[0]);
+	i82975x_printk(KERN_INFO, "DRBCH1R1 = 0x%02x\n", drb[1]);
+	i82975x_printk(KERN_INFO, "DRBCH1R2 = 0x%02x\n", drb[2]);
+	i82975x_printk(KERN_INFO, "DRBCH1R3 = 0x%02x\n", drb[3]);
+	i82975x_printk(KERN_INFO, "Memory in %ssymmetric mode\n",
+			is_symmetric ? "" : "as");

-	dtreg[0] = readl(mch_window + 0x114);
-	dtreg[1] = readl(mch_window + 0x194);
+	i82975x_printk(KERN_INFO, "DRC_CH0 = %0x, %s\n", drc[0],
+			((drc[0] >> 21) & 3) == 1 ?
+				"ECC enabled" : "ECC disabled");
+	i82975x_printk(KERN_INFO, "DRC_CH1 = %0x, %s\n", drc[1],
+			((drc[1] >> 21) & 3) == 1 ?
+				"ECC enabled" : "ECC disabled");
+
+	dra[0][0] = readb(mch_window + I82975X_DRA_CH0R01);
+	dra[0][1] = readb(mch_window + I82975X_DRA_CH0R23);
+	dra[1][0] = readb(mch_window + I82975X_DRA_CH1R01);
+	dra[1][1] = readb(mch_window + I82975X_DRA_CH1R23);
+	i82975x_printk(KERN_INFO, "Rank Attribute:\n"
+		"     Rank:  0            1            2            3\n"
+		"      Ch0:  %s   %s   %s   %s\n"
+		"      Ch1:  %s   %s   %s   %s\n",
+		rank_attr[dra[0][0] & 7],
+		rank_attr[(dra[0][0] >> 4) & 7],
+		rank_attr[dra[0][1] & 7],
+		rank_attr[(dra[0][1] >> 4) & 7],
+		rank_attr[dra[1][0] & 7],
+		rank_attr[(dra[1][0] >> 4) & 7],
+		rank_attr[dra[1][1] & 7],
+		rank_attr[(dra[1][1] >> 4) & 7]);
+
+	i82975x_printk(KERN_INFO, "Bank Architecture:\n"
+		"      2 bits / rank, 0 => 4 banks, 1 => 8 banks\n"
+		"           Channel A: %02x B: %02x\n",
+		readw(mch_window + I82975X_C0BNKARC),
+		readw(mch_window + I82975X_C1BNKARC));
+
+	i82975x_printk(KERN_INFO, "Memory Refresh: Ch0: %s, Ch1: %s\n",
+					refresh_modes[(drc[0] >> 8) & 7],
+					refresh_modes[(drc[1] >> 8) & 7]);
+
+	dtreg[0] = readl(mch_window + I82975X_C0DRT1);
+	dtreg[1] = readl(mch_window + I82975X_C1DRT1);
 	i82975x_printk(KERN_INFO, "DRAM Timings :     Ch0    Ch1\n"
-		"                RAS Active Min = %d     %d\n"
+		"                RAS Active Min =  %d     %d\n"
 		"                CAS latency    =  %d      %d\n"
-		"                RAS to CAS     =  %d      %d\n"
-		"                RAS precharge  =  %d      %d\n",
+		"                RAS to CAS     =  %d      %d  (2-6 valid)\n"
+		"                RAS precharge  =  %d      %d  (2-6 valid)\n",
 		(dtreg[0] >> 19 ) & 0x0f,
 			(dtreg[1] >> 19) & 0x0f,
 		caslats[(dtreg[0] >> 8) & 0x03],
@@ -469,6 +506,27 @@
 }
 #endif

+/* Return 1 if symmetric mode is active.  Else return 0. */
+static bool symmetric_channel_mode(void __iomem *mch_window)
+{
+	/*
+	 * We treat interleaved-symmetric configuration as dual-channel.
+	 * All other configurations are virtual single channel mode.
+	 * bit-0 of EAP always provides the real channel in error.
+	 */
+	u8	drb[2];
+	int	row;
+	bool    is_symmetric;
+
+	for (is_symmetric = 1, row = 0; is_symmetric &&
+			(row < I82975X_NR_CSROWS_PER_CHANNEL); row++) {
+		drb[0] = readb(mch_window + I82975X_DRB + row);
+		drb[1] = readb(mch_window + I82975X_DRB + row + 0x80);
+		is_symmetric &= (drb[0] == drb[1]);
+	}
+	return is_symmetric;
+}
+
 static int i82975x_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	int rc = -ENODEV;
@@ -479,82 +537,47 @@
 	u32 mchbar;
 	u32 drc[2];
 	struct i82975x_error_info discard;
-	int	chans;
-#ifdef i82975x_DEBUG_IOMEM
-	u8 c0drb[4];
-	u8 c1drb[4];
-#endif
+	bool	is_symmetric_mode;

-	edac_dbg(0, "\n");
+	edac_dbg(0, "MC%d probe\n", dev_idx);

 	pci_read_config_dword(pdev, I82975X_MCHBAR, &mchbar);
 	if (!(mchbar & 1)) {
-		edac_dbg(3, "failed, MCHBAR disabled!\n");
+		edac_dbg(0, "MC%d MCHBAR disabled!\n", dev_idx);
 		goto fail0;
 	}
 	mchbar &= 0xffffc000;	/* bits 31:14 used for 16K window */
 	mch_window = ioremap_nocache(mchbar, 0x1000);

-#ifdef i82975x_DEBUG_IOMEM
-	i82975x_printk(KERN_INFO, "MCHBAR real = %0x, remapped = %p\n",
-					mchbar, mch_window);
-
-	c0drb[0] = readb(mch_window + I82975X_DRB_CH0R0);
-	c0drb[1] = readb(mch_window + I82975X_DRB_CH0R1);
-	c0drb[2] = readb(mch_window + I82975X_DRB_CH0R2);
-	c0drb[3] = readb(mch_window + I82975X_DRB_CH0R3);
-	c1drb[0] = readb(mch_window + I82975X_DRB_CH1R0);
-	c1drb[1] = readb(mch_window + I82975X_DRB_CH1R1);
-	c1drb[2] = readb(mch_window + I82975X_DRB_CH1R2);
-	c1drb[3] = readb(mch_window + I82975X_DRB_CH1R3);
-	i82975x_printk(KERN_INFO, "DRBCH0R0 = 0x%02x\n", c0drb[0]);
-	i82975x_printk(KERN_INFO, "DRBCH0R1 = 0x%02x\n", c0drb[1]);
-	i82975x_printk(KERN_INFO, "DRBCH0R2 = 0x%02x\n", c0drb[2]);
-	i82975x_printk(KERN_INFO, "DRBCH0R3 = 0x%02x\n", c0drb[3]);
-	i82975x_printk(KERN_INFO, "DRBCH1R0 = 0x%02x\n", c1drb[0]);
-	i82975x_printk(KERN_INFO, "DRBCH1R1 = 0x%02x\n", c1drb[1]);
-	i82975x_printk(KERN_INFO, "DRBCH1R2 = 0x%02x\n", c1drb[2]);
-	i82975x_printk(KERN_INFO, "DRBCH1R3 = 0x%02x\n", c1drb[3]);
-#endif
-
 	drc[0] = readl(mch_window + I82975X_DRC_CH0M0);
 	drc[1] = readl(mch_window + I82975X_DRC_CH1M0);
-#ifdef i82975x_DEBUG_IOMEM
-	i82975x_printk(KERN_INFO, "DRC_CH0 = %0x, %s\n", drc[0],
-			((drc[0] >> 21) & 3) == 1 ?
-				"ECC enabled" : "ECC disabled");
-	i82975x_printk(KERN_INFO, "DRC_CH1 = %0x, %s\n", drc[1],
-			((drc[1] >> 21) & 3) == 1 ?
-				"ECC enabled" : "ECC disabled");
-
-	i82975x_printk(KERN_INFO, "C0 BNKARC = %0x\n",
-		readw(mch_window + I82975X_C0BNKARC));
-	i82975x_printk(KERN_INFO, "C1 BNKARC = %0x\n",
-		readw(mch_window + I82975X_C1BNKARC));
-	i82975x_print_dram_timings(mch_window);
-	goto fail1;
+	is_symmetric_mode = symmetric_channel_mode(mch_window);
+#ifdef CONFIG_EDAC_DEBUG
+	i82975x_print_dram_settings(mch_window, mchbar, drc,
+			is_symmetric_mode);
 #endif
+
+	/* Obey BIOS setting for enabling ECC */
+	/* FIXME: what about partial setting? possible in BIOS? */
 	if (!(((drc[0] >> 21) & 3) == 1 || ((drc[1] >> 21) & 3) == 1)) {
 		i82975x_printk(KERN_INFO, "ECC disabled on both channels.\n");
 		goto fail1;
 	}

-	chans = dual_channel_active(mch_window) + 1;
-
-	/* assuming only one controller, index thus is 0 */
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
-	layers[0].size = I82975X_NR_DIMMS;
+	layers[0].size = I82975X_NR_CSROWS_PER_CHANNEL;
 	layers[0].is_virt_csrow = true;
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
-	layers[1].size = I82975X_NR_CSROWS(chans);
+	layers[1].size = I82975X_NR_CHANNELS;
 	layers[1].is_virt_csrow = false;
-	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, sizeof(*pvt));
+	/* assuming only one controller, controller index is 0 */
+	mci = edac_mc_alloc(0, is_symmetric_mode + 1, layers, sizeof(*pvt));
 	if (!mci) {
+		edac_dbg(0, "MC%d failed mc_alloc\n", dev_idx);
 		rc = -ENOMEM;
 		goto fail1;
 	}

-	edac_dbg(3, "init mci\n");
 	mci->pdev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_DDR2;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED;
@@ -565,25 +588,22 @@
 	mci->dev_name = pci_name(pdev);
 	mci->edac_check = i82975x_check;
 	mci->ctl_page_to_phys = NULL;
-	edac_dbg(3, "init pvt\n");
 	pvt = (struct i82975x_pvt *) mci->pvt_info;
-	pvt->mch_window = mch_window;
-	i82975x_init_csrows(mci, pdev, mch_window);
-	mci->scrub_mode = SCRUB_HW_SRC;
+	pvt->chip = dev_idx;
+	i82975x_init_csrows(mci, mch_window, is_symmetric_mode);
+	mci->scrub_mode = SCRUB_SW_SRC;
 	i82975x_get_error_info(mci, &discard);  /* clear counters */

 	/* finalize this instance of memory controller with edac core */
 	if (edac_mc_add_mc(mci)) {
-		edac_dbg(3, "failed edac_mc_add_mc()\n");
-		goto fail2;
+		edac_dbg(0, "MC%d failed add_mc()\n", dev_idx);
+		edac_mc_free(mci);
+		goto fail1;
 	}

 	/* get this far and it's successful */
-	edac_dbg(3, "success\n");
-	return 0;
-
-fail2:
-	edac_mc_free(mci);
+	edac_dbg(3, "MC%d setup with driver%s\n", dev_idx, I82975X_REVISION);
+	rc = 0;

 fail1:
 	iounmap(mch_window);
@@ -597,8 +617,6 @@
 {
 	int rc;

-	edac_dbg(0, "\n");
-
 	if (pci_enable_device(pdev) < 0)
 		return -EIO;

@@ -613,25 +631,17 @@
 static void i82975x_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
-	struct i82975x_pvt *pvt;
-
-	edac_dbg(0, "\n");

 	mci = edac_mc_del_mc(&pdev->dev);
 	if (mci  == NULL)
 		return;
-
-	pvt = mci->pvt_info;
-	if (pvt->mch_window)
-		iounmap( pvt->mch_window );
-
 	edac_mc_free(mci);
 }

 static const struct pci_device_id i82975x_pci_tbl[] = {
 	{
 		PCI_VEND_DEV(INTEL, 82975_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		I82975X
+		I82975X_chip
 	},
 	{
 		0,
@@ -651,8 +661,6 @@
 {
 	int pci_rc;

-	edac_dbg(3, "\n");
-
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();

@@ -693,8 +701,6 @@

 static void __exit i82975x_exit(void)
 {
-	edac_dbg(3, "\n");
-
 	pci_unregister_driver(&i82975x_driver);

 	if (!i82975x_registered) {

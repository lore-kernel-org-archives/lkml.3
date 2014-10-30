Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbaJ3Mpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:45:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50081 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759020AbaJ3Mph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:45:37 -0400
Date: Thu, 30 Oct 2014 13:45:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, bp@suse.de, dan.carpenter@oracle.com,
        dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 4/4] edac, amd64_edac: Add F15h M60h support
Message-ID: <20141030124528.GB11178@pd.tnic>
References: <1414617483-4941-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1414617483-4941-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 04:18:03PM -0500, Aravind Gopalakrishnan wrote:
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index bbd6514..1092ddd 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -692,9 +692,19 @@ static void debug_dump_dramcfg_low(struct amd64_pvt *pvt, u32 dclr, int chan)
>  {
>  	edac_dbg(1, "F2x%d90 (DRAM Cfg Low): 0x%08x\n", chan, dclr);
>  
> -	edac_dbg(1, "  DIMM type: %sbuffered; all DIMMs support ECC: %s\n",
> -		 (dclr & BIT(16)) ?  "un" : "",

Why did we drop bit 16 about the unbuffered-ness of the DIMMs?

> -		 (dclr & BIT(19)) ? "yes" : "no");
> +	if (pvt->dram_type == MEM_LRDDR3) {
> +		u32 dcsm = pvt->csels[chan].csmasks[0];
> +		/*
> +		 * It's assumed all LRDIMMs in a DCT are going to be of
> +		 * same 'type' until proven otherwise. So, use a cs
> +		 * value of '0' here to get dcsm value.
> +		 */
> +		edac_dbg(1, " LRDIMM %dx rank multiply\n", (dcsm & 0x3));
> +	}
> +
> +	edac_dbg(1, "All DIMMs support ECC:%s\n",
> +		    (dclr & BIT(19)) ? "yes" : "no");

...

> @@ -813,25 +823,57 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
>  	}
>  }
>  
> -static enum mem_type determine_memory_type(struct amd64_pvt *pvt, int cs)
> +static void determine_memory_type(struct amd64_pvt *pvt)
>  {
> -	enum mem_type type;
> -
> -	/* F15h supports only DDR3 */
> -	if (pvt->fam >= 0x15)
> -		type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
> -	else if (pvt->fam == 0x10 || pvt->ext_model >= K8_REV_F) {
> -		if (pvt->dchr0 & DDR3_MODE)
> -			type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
> -		else
> -			type = (pvt->dclr0 & BIT(16)) ? MEM_DDR2 : MEM_RDDR2;
> -	} else {
> -		type = (pvt->dclr0 & BIT(18)) ? MEM_DDR : MEM_RDDR;
> +	switch (pvt->fam) {
> +	case 0xf:
> +		if (pvt->ext_model < K8_REV_F) {
> +			pvt->dram_type = (pvt->dclr0 & BIT(18)) ?
> +					 MEM_DDR : MEM_RDDR;
> +			break;
> +		}
> +		/* ext_model >= k8_rev_f, fall down below */
> +	case 0x10:
> +		if (!(pvt->dchr0 & DDR3_MODE)) {
> +			pvt->dram_type = (pvt->dclr0 & BIT(16)) ?
> +					 MEM_DDR2 : MEM_RDDR2;
> +			break;
> +		}
> +		/* If f10h supports DDR3, it will be handled by cases below */
> +	case 0x15:
> +		/* F15h supports only DDR3 */
> +		if (pvt->model == 0x60) {
> +			/*
> +			 * We use a Chip Select value of '0' to obtain dcsm.
> +			 * Theoretically, it is possible to populate LRDIMMs
> +			 * of different 'Rank' value on a DCT. But this is not
> +			 * a common case. So, it's reasonable to assume all
> +			 * DIMMs are going to be of same 'type' until proven
> +			 * otherwise.
> +			 */
> +			u32 dram_ctrl;
> +			u32 dcsm = pvt->csels[0].csmasks[0];
> +
> +			amd64_read_dct_pci_cfg(pvt, 0, DRAM_CONTROL,
> +					       &dram_ctrl);
> +			if (((dram_ctrl >> 8) & 0x7) == 0x2)
> +				pvt->dram_type = MEM_DDR4;
> +			else if (pvt->dclr0 & BIT(16))
> +				pvt->dram_type = MEM_DDR3;
> +			else if (dcsm & 0x3)
> +				pvt->dram_type = MEM_LRDDR3;
> +			else
> +				pvt->dram_type = MEM_RDDR3;
> +			break;
> +		}
> +		/* other f15h models fall down below */
> +	case 0x16:
> +		pvt->dram_type = (pvt->dclr0 & BIT(16)) ?
> +				 MEM_DDR3 : MEM_RDDR3;
> +		break;
> +	default:
> +		pvt->dram_type = MEM_EMPTY;
>  	}

Ok, I went and did cleanup that version here by flipping the logic
in the tests and thus saving an indentation level. Also, I've added
explicit "return"s in the respective cases in order to follow through
the code more easily. Here's how the whole function looks like now - I
think it is a bit better readable this way. Full patch below:

static void determine_memory_type(struct amd64_pvt *pvt)
{
        u32 dram_ctrl, dcsm;

        switch (pvt->fam) {
        case 0xf:
                if (pvt->ext_model >= K8_REV_F)
                        goto ddr3;

                pvt->dram_type = (pvt->dclr0 & BIT(18)) ? MEM_DDR : MEM_RDDR;
                return;

        case 0x10:
                if (pvt->dchr0 & DDR3_MODE)
                        goto ddr3;

                pvt->dram_type = (pvt->dclr0 & BIT(16)) ? MEM_DDR2 : MEM_RDDR2;
                return;

        case 0x15:
                if (pvt->model < 0x60)
                        goto ddr3;

                /*
                 * Model 0x60h needs special handling:
                 *
                 * We use a Chip Select value of '0' to obtain dcsm.
                 * Theoretically, it is possible to populate LRDIMMs of different
                 * 'Rank' value on a DCT. But this is not the common case. So,
                 * it's reasonable to assume all DIMMs are going to be of same
                 * 'type' until proven otherwise.
                 */
                amd64_read_dct_pci_cfg(pvt, 0, DRAM_CONTROL, &dram_ctrl);
                dcsm = pvt->csels[0].csmasks[0];

                if (((dram_ctrl >> 8) & 0x7) == 0x2)
                        pvt->dram_type = MEM_DDR4;
                else if (pvt->dclr0 & BIT(16))
                        pvt->dram_type = MEM_DDR3;
                else if (dcsm & 0x3)
                        pvt->dram_type = MEM_LRDDR3;
                else
                        pvt->dram_type = MEM_RDDR3;

                return;

        case 0x16:
                goto ddr3;

        default:
                WARN(1, KERN_ERR "%s: Family??? 0x%x\n", __func__, pvt->fam);
                pvt->dram_type = MEM_EMPTY;
        }
        return;

ddr3:
        pvt->dram_type = (pvt->dclr0 & BIT(16)) ? MEM_DDR3 : MEM_RDDR3;
}

---
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH] amd64_edac: Add F15h M60h support

This patch adds support for ECC error decoding for F15h M60h processor.
Aside from the usual changes, the patch adds support for some new features
in the processor:
 - DDR4(unbuffered, registered); LRDIMM DDR3 support
   - relevant debug messages have been modified/added to report these
     memory types
 - new dbam_to_cs mappers
   - if (F15h M60h && LRDIMM); we need a 'multiplier' value to find
     cs_size. This multiplier value is obtained from the per-dimm
     DCSM register. So, change the interface to accept a 'cs_mask_nr'
     value to facilitate this calculation
 - switch-casing determine_memory_type()
   - done to cleanse the function of too many if-else statements
     and improve readability
   - This is now called early in read_mc_regs() to cache dram_type

Misc cleanup:
 - amd64_pci_table[] is condensed by using PCI_VDEVICE macro.

Testing details:
Tested the patch by injecting 'ECC' type errors using mce_amd_inj
and error decoding works fine.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Link: http://lkml.kernel.org/r/1414617483-4941-1-git-send-email-Aravind.Gopalakrishnan@amd.com
[ Boris: determine_memory_type() cleanups ]
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/edac/amd64_edac.c | 255 ++++++++++++++++++++++++++++++++--------------
 drivers/edac/amd64_edac.h |  15 ++-
 2 files changed, 188 insertions(+), 82 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index bbd65149cdb2..1a1d7c43a20f 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -692,9 +692,19 @@ static void debug_dump_dramcfg_low(struct amd64_pvt *pvt, u32 dclr, int chan)
 {
 	edac_dbg(1, "F2x%d90 (DRAM Cfg Low): 0x%08x\n", chan, dclr);
 
-	edac_dbg(1, "  DIMM type: %sbuffered; all DIMMs support ECC: %s\n",
-		 (dclr & BIT(16)) ?  "un" : "",
-		 (dclr & BIT(19)) ? "yes" : "no");
+	if (pvt->dram_type == MEM_LRDDR3) {
+		u32 dcsm = pvt->csels[chan].csmasks[0];
+		/*
+		 * It's assumed all LRDIMMs in a DCT are going to be of
+		 * same 'type' until proven otherwise. So, use a cs
+		 * value of '0' here to get dcsm value.
+		 */
+		edac_dbg(1, " LRDIMM %dx rank multiply\n", (dcsm & 0x3));
+	}
+
+	edac_dbg(1, "All DIMMs support ECC:%s\n",
+		    (dclr & BIT(19)) ? "yes" : "no");
+
 
 	edac_dbg(1, "  PAR/ERR parity: %s\n",
 		 (dclr & BIT(8)) ?  "enabled" : "disabled");
@@ -756,7 +766,7 @@ static void prep_chip_selects(struct amd64_pvt *pvt)
 	if (pvt->fam == 0xf && pvt->ext_model < K8_REV_F) {
 		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
 		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 8;
-	} else if (pvt->fam == 0x15 && pvt->model >= 0x30) {
+	} else if (pvt->fam == 0x15 && pvt->model == 0x30) {
 		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 4;
 		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 2;
 	} else {
@@ -813,25 +823,63 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
 	}
 }
 
-static enum mem_type determine_memory_type(struct amd64_pvt *pvt, int cs)
+static void determine_memory_type(struct amd64_pvt *pvt)
 {
-	enum mem_type type;
+	u32 dram_ctrl, dcsm;
 
-	/* F15h supports only DDR3 */
-	if (pvt->fam >= 0x15)
-		type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
-	else if (pvt->fam == 0x10 || pvt->ext_model >= K8_REV_F) {
+	switch (pvt->fam) {
+	case 0xf:
+		if (pvt->ext_model >= K8_REV_F)
+			goto ddr3;
+
+		pvt->dram_type = (pvt->dclr0 & BIT(18)) ? MEM_DDR : MEM_RDDR;
+		return;
+
+	case 0x10:
 		if (pvt->dchr0 & DDR3_MODE)
-			type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
+			goto ddr3;
+
+		pvt->dram_type = (pvt->dclr0 & BIT(16)) ? MEM_DDR2 : MEM_RDDR2;
+		return;
+
+	case 0x15:
+		if (pvt->model < 0x60)
+			goto ddr3;
+
+		/*
+		 * Model 0x60h needs special handling:
+		 *
+		 * We use a Chip Select value of '0' to obtain dcsm.
+		 * Theoretically, it is possible to populate LRDIMMs of different
+		 * 'Rank' value on a DCT. But this is not the common case. So,
+		 * it's reasonable to assume all DIMMs are going to be of same
+		 * 'type' until proven otherwise.
+		 */
+		amd64_read_dct_pci_cfg(pvt, 0, DRAM_CONTROL, &dram_ctrl);
+		dcsm = pvt->csels[0].csmasks[0];
+
+		if (((dram_ctrl >> 8) & 0x7) == 0x2)
+			pvt->dram_type = MEM_DDR4;
+		else if (pvt->dclr0 & BIT(16))
+			pvt->dram_type = MEM_DDR3;
+		else if (dcsm & 0x3)
+			pvt->dram_type = MEM_LRDDR3;
 		else
-			type = (pvt->dclr0 & BIT(16)) ? MEM_DDR2 : MEM_RDDR2;
-	} else {
-		type = (pvt->dclr0 & BIT(18)) ? MEM_DDR : MEM_RDDR;
-	}
+			pvt->dram_type = MEM_RDDR3;
 
-	amd64_info("CS%d: %s\n", cs, edac_mem_types[type]);
+		return;
+
+	case 0x16:
+		goto ddr3;
+
+	default:
+		WARN(1, KERN_ERR "%s: Family??? 0x%x\n", __func__, pvt->fam);
+		pvt->dram_type = MEM_EMPTY;
+	}
+	return;
 
-	return type;
+ddr3:
+	pvt->dram_type = (pvt->dclr0 & BIT(16)) ? MEM_DDR3 : MEM_RDDR3;
 }
 
 /* Get the number of DCT channels the memory controller is using. */
@@ -958,8 +1006,12 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 	if (WARN_ON(!nb))
 		return;
 
-	pci_func = (pvt->model == 0x30) ? PCI_DEVICE_ID_AMD_15H_M30H_NB_F1
-					: PCI_DEVICE_ID_AMD_15H_NB_F1;
+	if (pvt->model == 0x60)
+		pci_func = PCI_DEVICE_ID_AMD_15H_M60H_NB_F1;
+	else if (pvt->model == 0x30)
+		pci_func = PCI_DEVICE_ID_AMD_15H_M30H_NB_F1;
+	else
+		pci_func = PCI_DEVICE_ID_AMD_15H_NB_F1;
 
 	f1 = pci_get_related_function(nb->misc->vendor, pci_func, nb->misc);
 	if (WARN_ON(!f1))
@@ -1049,7 +1101,7 @@ static int ddr2_cs_size(unsigned i, bool dct_width)
 }
 
 static int k8_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
-				  unsigned cs_mode)
+				  unsigned cs_mode, int cs_mask_nr)
 {
 	u32 dclr = dct ? pvt->dclr1 : pvt->dclr0;
 
@@ -1167,8 +1219,43 @@ static int ddr3_cs_size(unsigned i, bool dct_width)
 	return cs_size;
 }
 
+static int ddr3_lrdimm_cs_size(unsigned i, unsigned rank_multiply)
+{
+	unsigned shift = 0;
+	int cs_size = 0;
+
+	if (i < 4 || i == 6)
+		cs_size = -1;
+	else if (i == 12)
+		shift = 7;
+	else if (!(i & 0x1))
+		shift = i >> 1;
+	else
+		shift = (i + 1) >> 1;
+
+	if (cs_size != -1)
+		cs_size = rank_multiply * (128 << shift);
+
+	return cs_size;
+}
+
+static int ddr4_cs_size(unsigned i)
+{
+	int cs_size = 0;
+
+	if (i == 0)
+		cs_size = -1;
+	else if (i == 1)
+		cs_size = 1024;
+	else
+		/* Min cs_size = 1G */
+		cs_size = 1024 * (1 << (i >> 1));
+
+	return cs_size;
+}
+
 static int f10_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
-				   unsigned cs_mode)
+				   unsigned cs_mode, int cs_mask_nr)
 {
 	u32 dclr = dct ? pvt->dclr1 : pvt->dclr0;
 
@@ -1184,18 +1271,49 @@ static int f10_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
  * F15h supports only 64bit DCT interfaces
  */
 static int f15_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
-				   unsigned cs_mode)
+				   unsigned cs_mode, int cs_mask_nr)
 {
 	WARN_ON(cs_mode > 12);
 
 	return ddr3_cs_size(cs_mode, false);
 }
 
+/* F15h M60h supports DDR4 mapping as well.. */
+static int f15_m60h_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
+					unsigned cs_mode, int cs_mask_nr)
+{
+	int cs_size;
+	u32 dcsm = pvt->csels[dct].csmasks[cs_mask_nr];
+
+	WARN_ON(cs_mode > 12);
+
+	if (pvt->dram_type == MEM_DDR4) {
+		if (cs_mode > 9)
+			return -1;
+
+		cs_size = ddr4_cs_size(cs_mode);
+	} else if (pvt->dram_type == MEM_LRDDR3) {
+		unsigned rank_multiply = dcsm & 0xf;
+
+		if (rank_multiply == 3)
+			rank_multiply = 4;
+		cs_size = ddr3_lrdimm_cs_size(cs_mode, rank_multiply);
+	} else {
+		/* Minimum cs size is 512mb for F15hM60h*/
+		if (cs_mode == 0x1)
+			return -1;
+
+		cs_size = ddr3_cs_size(cs_mode, false);
+	}
+
+	return cs_size;
+}
+
 /*
  * F16h and F15h model 30h have only limited cs_modes.
  */
 static int f16_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
-				unsigned cs_mode)
+				unsigned cs_mode, int cs_mask_nr)
 {
 	WARN_ON(cs_mode > 12);
 
@@ -1757,13 +1875,20 @@ static void debug_display_dimm_sizes(struct amd64_pvt *pvt, u8 ctrl)
 
 		size0 = 0;
 		if (dcsb[dimm*2] & DCSB_CS_ENABLE)
+			/* For f15m60h, need multiplier for LRDIMM cs_size
+			 * calculation. We pass 'dimm' value to the dbam_to_cs
+			 * mapper so we can find the multiplier from the
+			 * corresponding DCSM.
+			 */
 			size0 = pvt->ops->dbam_to_cs(pvt, ctrl,
-						     DBAM_DIMM(dimm, dbam));
+						     DBAM_DIMM(dimm, dbam),
+						     dimm);
 
 		size1 = 0;
 		if (dcsb[dimm*2 + 1] & DCSB_CS_ENABLE)
 			size1 = pvt->ops->dbam_to_cs(pvt, ctrl,
-						     DBAM_DIMM(dimm, dbam));
+						     DBAM_DIMM(dimm, dbam),
+						     dimm);
 
 		amd64_info(EDAC_MC ": %d: %5dMB %d: %5dMB\n",
 				dimm * 2,     size0,
@@ -1812,6 +1937,16 @@ static struct amd64_family_type family_types[] = {
 			.dbam_to_cs		= f16_dbam_to_chip_select,
 		}
 	},
+	[F15_M60H_CPUS] = {
+		.ctl_name = "F15h_M60h",
+		.f1_id = PCI_DEVICE_ID_AMD_15H_M60H_NB_F1,
+		.f3_id = PCI_DEVICE_ID_AMD_15H_M60H_NB_F3,
+		.ops = {
+			.early_channel_count	= f1x_early_channel_count,
+			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
+			.dbam_to_cs		= f15_m60h_dbam_to_chip_select,
+		}
+	},
 	[F16_CPUS] = {
 		.ctl_name = "F16h",
 		.f1_id = PCI_DEVICE_ID_AMD_16H_NB_F1,
@@ -2175,6 +2310,8 @@ static void read_mc_regs(struct amd64_pvt *pvt)
 	}
 
 	pvt->ecc_sym_sz = 4;
+	determine_memory_type(pvt);
+	edac_dbg(1, "  DIMM type: %s\n", edac_mem_types[pvt->dram_type]);
 
 	if (pvt->fam >= 0x10) {
 		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
@@ -2238,7 +2375,8 @@ static u32 get_csrow_nr_pages(struct amd64_pvt *pvt, u8 dct, int csrow_nr)
 	 */
 	cs_mode = DBAM_DIMM(csrow_nr / 2, dbam);
 
-	nr_pages = pvt->ops->dbam_to_cs(pvt, dct, cs_mode) << (20 - PAGE_SHIFT);
+	nr_pages = pvt->ops->dbam_to_cs(pvt, dct, cs_mode, (csrow_nr / 2))
+							   << (20 - PAGE_SHIFT);
 
 	edac_dbg(0, "csrow: %d, channel: %d, DBAM idx: %d\n",
 		    csrow_nr, dct,  cs_mode);
@@ -2257,7 +2395,6 @@ static int init_csrows(struct mem_ctl_info *mci)
 	struct csrow_info *csrow;
 	struct dimm_info *dimm;
 	enum edac_type edac_mode;
-	enum mem_type mtype;
 	int i, j, empty = 1;
 	int nr_pages = 0;
 	u32 val;
@@ -2302,8 +2439,6 @@ static int init_csrows(struct mem_ctl_info *mci)
 			nr_pages += row_dct1_pages;
 		}
 
-		mtype = determine_memory_type(pvt, i);
-
 		edac_dbg(1, "Total csrow%d pages: %u\n", i, nr_pages);
 
 		/*
@@ -2317,7 +2452,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 
 		for (j = 0; j < pvt->channel_count; j++) {
 			dimm = csrow->channels[j]->dimm;
-			dimm->mtype = mtype;
+			dimm->mtype = pvt->dram_type;
 			dimm->edac_mode = edac_mode;
 		}
 	}
@@ -2604,6 +2739,10 @@ static struct amd64_family_type *per_family_init(struct amd64_pvt *pvt)
 			fam_type = &family_types[F15_M30H_CPUS];
 			pvt->ops = &family_types[F15_M30H_CPUS].ops;
 			break;
+		} else if (pvt->model == 0x60) {
+			fam_type = &family_types[F15_M60H_CPUS];
+			pvt->ops = &family_types[F15_M60H_CPUS].ops;
+			break;
 		}
 
 		fam_type	= &family_types[F15_CPUS];
@@ -2828,55 +2967,13 @@ static void remove_one_instance(struct pci_dev *pdev)
  * inquiry this table to see if this driver is for a given device found.
  */
 static const struct pci_device_id amd64_pci_table[] = {
-	{
-		.vendor		= PCI_VENDOR_ID_AMD,
-		.device		= PCI_DEVICE_ID_AMD_K8_NB_MEMCTL,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.class		= 0,
-		.class_mask	= 0,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_AMD,
-		.device		= PCI_DEVICE_ID_AMD_10H_NB_DRAM,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.class		= 0,
-		.class_mask	= 0,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_AMD,
-		.device		= PCI_DEVICE_ID_AMD_15H_NB_F2,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.class		= 0,
-		.class_mask	= 0,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_AMD,
-		.device		= PCI_DEVICE_ID_AMD_15H_M30H_NB_F2,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.class		= 0,
-		.class_mask	= 0,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_AMD,
-		.device		= PCI_DEVICE_ID_AMD_16H_NB_F2,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.class		= 0,
-		.class_mask	= 0,
-	},
-	{
-		.vendor		= PCI_VENDOR_ID_AMD,
-		.device		= PCI_DEVICE_ID_AMD_16H_M30H_NB_F2,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.class		= 0,
-		.class_mask	= 0,
-	},
-
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_K8_NB_MEMCTL) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_10H_NB_DRAM) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F2) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F2) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M60H_NB_F2) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F2) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F2) },
 	{0, }
 };
 MODULE_DEVICE_TABLE(pci, amd64_pci_table);
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 55fb5941c6d4..d8468c667925 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -162,10 +162,12 @@
 /*
  * PCI-defined configuration space registers
  */
-#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F1 0x141b
-#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F2 0x141c
 #define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
 #define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
+#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F1 0x141b
+#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F2 0x141c
+#define PCI_DEVICE_ID_AMD_15H_M60H_NB_F1 0x1571
+#define PCI_DEVICE_ID_AMD_15H_M60H_NB_F2 0x1572
 #define PCI_DEVICE_ID_AMD_16H_NB_F1	0x1531
 #define PCI_DEVICE_ID_AMD_16H_NB_F2	0x1532
 #define PCI_DEVICE_ID_AMD_16H_M30H_NB_F1 0x1581
@@ -221,6 +223,8 @@
 
 #define csrow_enabled(i, dct, pvt)	((pvt)->csels[(dct)].csbases[(i)] & DCSB_CS_ENABLE)
 
+#define DRAM_CONTROL			0x78
+
 #define DBAM0				0x80
 #define DBAM1				0x180
 
@@ -301,6 +305,7 @@ enum amd_families {
 	F10_CPUS,
 	F15_CPUS,
 	F15_M30H_CPUS,
+	F15_M60H_CPUS,
 	F16_CPUS,
 	F16_M30H_CPUS,
 	NUM_FAMILIES,
@@ -379,6 +384,9 @@ struct amd64_pvt {
 
 	/* place to store error injection parameters prior to issue */
 	struct error_injection injection;
+
+	/* cache the dram_type */
+	enum mem_type dram_type;
 };
 
 enum err_codes {
@@ -480,7 +488,8 @@ struct low_ops {
 	int (*early_channel_count)	(struct amd64_pvt *pvt);
 	void (*map_sysaddr_to_csrow)	(struct mem_ctl_info *mci, u64 sys_addr,
 					 struct err_info *);
-	int (*dbam_to_cs)		(struct amd64_pvt *pvt, u8 dct, unsigned cs_mode);
+	int (*dbam_to_cs)		(struct amd64_pvt *pvt, u8 dct,
+					 unsigned cs_mode, int cs_mask_nr);
 };
 
 struct amd64_family_type {
-- 
2.0.0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

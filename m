Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaIOMJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:09:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33344 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbaIOMJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:09:29 -0400
Date: Mon, 15 Sep 2014 14:09:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4] edac, amd64_edac: Modify usage of
 amd64_read_dct_pci_cfg()
Message-ID: <20140915120925.GD3340@nazgul.tnic>
References: <1410292346-3352-1-git-send-email-aravind.gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1410292346-3352-1-git-send-email-aravind.gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 02:52:26PM -0500, Aravind Gopalakrishnan wrote:
> Rationale behind this change:
>  - F2x1xx addresses were stopped from being mapped explicitly to DCT1
>    from F15h (OR) onwards. They use _dct[0:1] mechanism to access the
>    registers. So we should move away from using address ranges to select
>    DCT for these families.
>  - On newer processors, the address ranges used to indicate DCT1 (0x140,
>    0x1a0) have different meanings than what is assumed currently.
> 
> Changes introduced:
>  - amd64_read_dct_pci_cfg() now takes in dct value and uses it for
>    'selecting the dct'
>  - Update usage of the function. Keep in mind that different families
>    have specific handling requirements
>  - Remove [k8|f10]_read_dct_pci_cfg() as they don't do much different
>    from amd64_read_pci_cfg()
>    - Move the k8 specific check to amd64_read_pci_cfg
>  - Remove f15_read_dct_pci_cfg() and move logic to amd64_read_dct_pci_cfg()
>  - Remove now needless .read_dct_pci_cfg
> 
> Testing:
>  - Tested on Fam 10h; Fam15h Models: 00h, 30h; Fam16h using 'EDAC_DEBUG'
>    and mce_amd_inj
>  - driver obtains info from F2x registers and caches it in pvt
>    structures correctly
>  - ECC decoding works fine
> 
> Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
> ---
> Change in V4:
>  - move amd64_read_dct_pci_cfg() to amd64_edac.c and save exporting
>    f15h_select_dct() in the process
> 
> Changes in V3:
>  - per Boris suggestion
>    - move dct selection logic to amd64_read_dct_pci_cfg()
>    - remove f15_read_dct_pci_cfg() and move logic to amd64_read_dct_pci_cfg()
>  - misc
>    - modify logic in amd64_read_dct_pci_cfg() to keep in mind the specific
>      read handling requirements of different families. Previous version had
>      failed to do that.
> 
> Changes in V2: (per Boris suggestion)
>  - Hide family checks in amd64_read_dct_pci_cfg()
>  - Use pvt structure for family checks and not boot_cpu_data
> 
>  drivers/edac/amd64_edac.c | 138 +++++++++++++++++++++++-----------------------
>  drivers/edac/amd64_edac.h |   5 --
>  2 files changed, 68 insertions(+), 75 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index f8bf000..b39d1b0 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -87,35 +87,6 @@ int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
>  }
>  
>  /*
> - *
> - * Depending on the family, F2 DCT reads need special handling:
> - *
> - * K8: has a single DCT only
> - *
> - * F10h: each DCT has its own set of regs
> - *	DCT0 -> F2x040..
> - *	DCT1 -> F2x140..
> - *
> - * F15h: we select which DCT we access using F1x10C[DctCfgSel]
> - *
> - * F16h: has only 1 DCT
> - */
> -static int k8_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
> -			       const char *func)
> -{
> -	if (addr >= 0x100)
> -		return -EINVAL;
> -
> -	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
> -}
> -
> -static int f10_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
> -				 const char *func)
> -{
> -	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
> -}
> -
> -/*
>   * Select DCT to which PCI cfg accesses are routed
>   */
>  static void f15h_select_dct(struct amd64_pvt *pvt, u8 dct)
> @@ -123,25 +94,51 @@ static void f15h_select_dct(struct amd64_pvt *pvt, u8 dct)
>  	u32 reg = 0;
>  
>  	amd64_read_pci_cfg(pvt->F1, DCT_CFG_SEL, &reg);
> -	reg &= (pvt->model >= 0x30) ? ~3 : ~1;
> +	reg &= (pvt->model == 0x30) ? ~3 : ~1;
>  	reg |= dct;
>  	amd64_write_pci_cfg(pvt->F1, DCT_CFG_SEL, reg);
>  }
>  
> -static int f15_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
> -				 const char *func)
> +/*
> + *
> + * Depending on the family, F2 DCT reads need special handling:
> + *
> + * K8: has a single DCT only and no address offsets >= 0x100
> + *
> + * F10h: each DCT has its own set of regs
> + *	DCT0 -> F2x040..
> + *	DCT1 -> F2x140..
> + *
> + * F16h: has only 1 DCT
> + */
> +static inline int amd64_read_dct_pci_cfg(struct amd64_pvt *pvt, u8 dct,
> +					 int offset, u32 *val)
>  {
> -	u8 dct  = 0;
> +	if (pvt->fam == 0xf) {
> +		if (dct || offset >= 0x100)
> +			return -EINVAL;
> +	} else if (pvt->fam == 0x10 && dct) {
> +		/*
> +		 * Note: If ganging is enabled, barring the regs
> +		 * F2x[1,0]98 and F2x[1,0]9C; reads reads to F2x1xx

Why aren't we dealing with those registers here then?

Btw, let's do this function with a switch-case, for better
readability:

static inline int amd64_read_dct_pci_cfg(struct amd64_pvt *pvt, u8 dct,
                                         int offset, u32 *val)
{
        switch (pvt->fam) {
        case 0xf:
                if (dct || offset >= 0x100)
                        return -EINVAL;
                break;

        case 0x10:
                if (dct) {
                        /*
                         * Note: If ganging is enabled, barring the regs
                         * F2x[1,0]98 and F2x[1,0]9C; reads reads to F2x1xx
                         * return 0. (cf. Section 2.8.1 F10h BKDG)
                         */
                        if (dct_ganging_enabled(pvt))
                                return 0;

                        offset += 0x100;
                }
                break;

        case 0x15:
                /*
                 * F15h: F2x1xx addresses do not map explicitly to DCT1.
                 * We should select which DCT we access using F1x10C[DctCfgSel]
                 */
                dct = (dct && pvt->model == 0x30) ? 3 : dct;
                f15h_select_dct(pvt, dct);
                break;

        case 0x16:
                if (dct)
                        return -EINVAL;
                break;

        default:
                break;
        }
        return amd64_read_pci_cfg(pvt->F2, offset, val);
}


> +		 * return 0. (cf. Section 2.8.1 F10h BKDG)
> +		 */
> +		if (dct_ganging_enabled(pvt))
> +			return 0;
>  
> -	/* For F15 M30h, the second dct is DCT 3, refer to BKDG Section 2.10 */
> -	if (addr >= 0x140 && addr <= 0x1a0) {
> -		dct   = (pvt->model >= 0x30) ? 3 : 1;
> -		addr -= 0x100;
> -	}
> +		offset += 0x100;
> +	} else if (pvt->fam == 0x15) {
> +		/*
> +		 * F15h: F2x1xx addresses do not map explicitly to DCT1.
> +		 * We should select which DCT we access using F1x10C[DctCfgSel]
> +		 */
> +		dct = (dct && pvt->model == 0x30) ? 3 : dct;
> +		f15h_select_dct(pvt, dct);
>  
> -	f15h_select_dct(pvt, dct);
> +	} else if (pvt->fam == 0x16 && dct)
> +		return -EINVAL;
>  
> -	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
> +	return amd64_read_pci_cfg(pvt->F2, offset, val);
>  }
>  

...

> @@ -768,16 +765,17 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
>  		u32 *base0 = &pvt->csels[0].csbases[cs];
>  		u32 *base1 = &pvt->csels[1].csbases[cs];
>  
> -		if (!amd64_read_dct_pci_cfg(pvt, reg0, base0))
> +		if (!amd64_read_dct_pci_cfg(pvt, 0, reg0, base0))
>  			edac_dbg(0, "  DCSB0[%d]=0x%08x reg: F2x%x\n",
>  				 cs, *base0, reg0);
>  
> -		if (pvt->fam == 0xf || dct_ganging_enabled(pvt))
> +		if (pvt->fam == 0xf)
>  			continue;
>  
> -		if (!amd64_read_dct_pci_cfg(pvt, reg1, base1))
> +		if (!amd64_read_dct_pci_cfg(pvt, 1, reg0, base1))
>  			edac_dbg(0, "  DCSB1[%d]=0x%08x reg: F2x%x\n",
> -				 cs, *base1, reg1);
> +				 cs, *base1, (pvt->fam == 0x10) ? reg1
> +								: reg0);
>  	}
>  
>  	for_each_chip_select_mask(cs, 0, pvt) {
> @@ -786,16 +784,17 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
>  		u32 *mask0 = &pvt->csels[0].csmasks[cs];
>  		u32 *mask1 = &pvt->csels[1].csmasks[cs];
>  
> -		if (!amd64_read_dct_pci_cfg(pvt, reg0, mask0))
> +		if (!amd64_read_dct_pci_cfg(pvt, 0, reg0, mask0))
>  			edac_dbg(0, "    DCSM0[%d]=0x%08x reg: F2x%x\n",
>  				 cs, *mask0, reg0);
>  
> -		if (pvt->fam == 0xf || dct_ganging_enabled(pvt))
> +		if (pvt->fam == 0xf)
>  			continue;
>  
> -		if (!amd64_read_dct_pci_cfg(pvt, reg1, mask1))
> +		if (!amd64_read_dct_pci_cfg(pvt, 1, reg0, mask1))
>  			edac_dbg(0, "    DCSM1[%d]=0x%08x reg: F2x%x\n",
> -				 cs, *mask1, reg1);
> +				 cs, *mask1, (pvt->fam == 0x10) ? reg1
> +								: reg0);
>  	}
>  }
>  
> @@ -1198,7 +1197,7 @@ static void read_dram_ctl_register(struct amd64_pvt *pvt)
>  	if (pvt->fam == 0xf)
>  		return;
>  
> -	if (!amd64_read_dct_pci_cfg(pvt, DCT_SEL_LO, &pvt->dct_sel_lo)) {
> +	if (!amd64_read_pci_cfg(pvt->F2, DCT_SEL_LO, &pvt->dct_sel_lo)) {
>  		edac_dbg(0, "F2x110 (DCTSelLow): 0x%08x, High range addrs at: 0x%x\n",
>  			 pvt->dct_sel_lo, dct_sel_baseaddr(pvt));
>  
> @@ -1219,7 +1218,7 @@ static void read_dram_ctl_register(struct amd64_pvt *pvt)
>  			 dct_sel_interleave_addr(pvt));
>  	}
>  
> -	amd64_read_dct_pci_cfg(pvt, DCT_SEL_HI, &pvt->dct_sel_hi);
> +	amd64_read_pci_cfg(pvt->F2, DCT_SEL_HI, &pvt->dct_sel_hi);
>  }
>  
>  /*
> @@ -1430,7 +1429,7 @@ static u64 f1x_swap_interleaved_region(struct amd64_pvt *pvt, u64 sys_addr)
>  			return sys_addr;
>  	}
>  
> -	amd64_read_dct_pci_cfg(pvt, SWAP_INTLV_REG, &swap_reg);
> +	amd64_read_pci_cfg(pvt->F2, SWAP_INTLV_REG, &swap_reg);
>  
>  	if (!(swap_reg & 0x1))
>  		return sys_addr;
> @@ -1723,9 +1722,16 @@ static void debug_display_dimm_sizes(struct amd64_pvt *pvt, u8 ctrl)
>  		       WARN_ON(ctrl != 0);
>  	}
>  
> -	dbam = (ctrl && !dct_ganging_enabled(pvt)) ? pvt->dbam1 : pvt->dbam0;
> -	dcsb = (ctrl && !dct_ganging_enabled(pvt)) ? pvt->csels[1].csbases
> -						   : pvt->csels[0].csbases;
> +	if (pvt->fam == 0x10) {
> +		dbam = (ctrl && !dct_ganging_enabled(pvt)) ? pvt->dbam1
> +							   : pvt->dbam0;
> +		dcsb = (ctrl && !dct_ganging_enabled(pvt)) ?
> +				 pvt->csels[1].csbases :
> +				 pvt->csels[0].csbases;
> +	} else if (ctrl) {
> +		dbam = pvt->dbam0;
> +		dcsb = pvt->csels[1].csbases;
> +	}
>  
>  	edac_dbg(1, "F2x%d80 (DRAM Bank Address Mapping): 0x%08x\n",
>  		 ctrl, dbam);
> @@ -1760,7 +1766,6 @@ static struct amd64_family_type family_types[] = {
>  			.early_channel_count	= k8_early_channel_count,
>  			.map_sysaddr_to_csrow	= k8_map_sysaddr_to_csrow,
>  			.dbam_to_cs		= k8_dbam_to_chip_select,
> -			.read_dct_pci_cfg	= k8_read_dct_pci_cfg,
>  		}
>  	},
>  	[F10_CPUS] = {
> @@ -1771,7 +1776,6 @@ static struct amd64_family_type family_types[] = {
>  			.early_channel_count	= f1x_early_channel_count,
>  			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
>  			.dbam_to_cs		= f10_dbam_to_chip_select,
> -			.read_dct_pci_cfg	= f10_read_dct_pci_cfg,
>  		}
>  	},
>  	[F15_CPUS] = {
> @@ -1782,7 +1786,6 @@ static struct amd64_family_type family_types[] = {
>  			.early_channel_count	= f1x_early_channel_count,
>  			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
>  			.dbam_to_cs		= f15_dbam_to_chip_select,
> -			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
>  		}
>  	},
>  	[F15_M30H_CPUS] = {
> @@ -1793,7 +1796,6 @@ static struct amd64_family_type family_types[] = {
>  			.early_channel_count	= f1x_early_channel_count,
>  			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
>  			.dbam_to_cs		= f16_dbam_to_chip_select,
> -			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
>  		}
>  	},
>  	[F16_CPUS] = {
> @@ -1804,7 +1806,6 @@ static struct amd64_family_type family_types[] = {
>  			.early_channel_count	= f1x_early_channel_count,
>  			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
>  			.dbam_to_cs		= f16_dbam_to_chip_select,
> -			.read_dct_pci_cfg	= f10_read_dct_pci_cfg,
>  		}
>  	},
>  	[F16_M30H_CPUS] = {
> @@ -1815,7 +1816,6 @@ static struct amd64_family_type family_types[] = {
>  			.early_channel_count	= f1x_early_channel_count,
>  			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
>  			.dbam_to_cs		= f16_dbam_to_chip_select,
> -			.read_dct_pci_cfg	= f10_read_dct_pci_cfg,
>  		}
>  	},
>  };
> @@ -2148,25 +2148,23 @@ static void read_mc_regs(struct amd64_pvt *pvt)
>  	read_dct_base_mask(pvt);
>  
>  	amd64_read_pci_cfg(pvt->F1, DHAR, &pvt->dhar);
> -	amd64_read_dct_pci_cfg(pvt, DBAM0, &pvt->dbam0);
> +	amd64_read_dct_pci_cfg(pvt, 0, DBAM0, &pvt->dbam0);
>  
>  	amd64_read_pci_cfg(pvt->F3, F10_ONLINE_SPARE, &pvt->online_spare);
>  
> -	amd64_read_dct_pci_cfg(pvt, DCLR0, &pvt->dclr0);
> -	amd64_read_dct_pci_cfg(pvt, DCHR0, &pvt->dchr0);
> -
> -	if (!dct_ganging_enabled(pvt)) {
> -		amd64_read_dct_pci_cfg(pvt, DCLR1, &pvt->dclr1);
> -		amd64_read_dct_pci_cfg(pvt, DCHR1, &pvt->dchr1);
> -	}
> +	amd64_read_dct_pci_cfg(pvt, 0, DCLR0, &pvt->dclr0);
> +	amd64_read_dct_pci_cfg(pvt, 0, DCHR0, &pvt->dchr0);
>  
>  	pvt->ecc_sym_sz = 4;
>  
>  	if (pvt->fam >= 0x10) {
> +		amd64_read_dct_pci_cfg(pvt, 1, DCLR0, &pvt->dclr1);
> +		amd64_read_dct_pci_cfg(pvt, 1, DCHR0, &pvt->dchr1);

This doesn't look equivalent - above we're checking whether we're ganged
now you're doing it for >= F10h. Why?

Because only F10h supports ganging?

> +
>  		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
> +		/* F16h has only DCT0, so no need to read dbam1 */
>  		if (pvt->fam != 0x16)
> -			/* F16h has only DCT0 */
> -			amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
> +			amd64_read_dct_pci_cfg(pvt, 1, DBAM0, &pvt->dbam1);
>  
>  		/* F10h, revD and later can do x8 ECC too */
>  		if ((pvt->fam > 0x10 || pvt->model > 7) && tmp & BIT(25))
> diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
> index d903e0c..55fb594 100644
> --- a/drivers/edac/amd64_edac.h
> +++ b/drivers/edac/amd64_edac.h
> @@ -481,8 +481,6 @@ struct low_ops {
>  	void (*map_sysaddr_to_csrow)	(struct mem_ctl_info *mci, u64 sys_addr,
>  					 struct err_info *);
>  	int (*dbam_to_cs)		(struct amd64_pvt *pvt, u8 dct, unsigned cs_mode);
> -	int (*read_dct_pci_cfg)		(struct amd64_pvt *pvt, int offset,
> -					 u32 *val, const char *func);
>  };
>  
>  struct amd64_family_type {
> @@ -502,9 +500,6 @@ int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
>  #define amd64_write_pci_cfg(pdev, offset, val)	\
>  	__amd64_write_pci_cfg_dword(pdev, offset, val, __func__)
>  
> -#define amd64_read_dct_pci_cfg(pvt, offset, val) \
> -	pvt->ops->read_dct_pci_cfg(pvt, offset, val, __func__)
> -
>  int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
>  			     u64 *hole_offset, u64 *hole_size);
>  
> -- 
> 2.0.3
> 
> 

-- 
Regards/Gruss,
    Boris.
--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967560Ab3HINSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:18:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47213 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967335Ab3HINS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:18:26 -0400
Date: Fri, 9 Aug 2013 15:18:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dougthompson@xmission.com, bhelgaas@google.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/3 V3] EDAC, AMD64_EDAC: Add ECC decoding support for
 newer F15h models.
Message-ID: <20130809131823.GB14926@pd.tnic>
References: <1375982204-2806-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375982204-2806-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 12:16:44PM -0500, Aravind Gopalakrishnan wrote:
> On newer models, support has been included for upto 4 DCT's, however,
> only DCT0 and DCT3 are currently configured. (Refer BKDG Section 2.10)
> Routing DRAM Requests algorithm is different for F15h M30h.
> It is cleaner to use a brand new function rather than
> adding quirks in the more generic 'f1x_match_to_this_node'
> Refer "2.10.5 DRAM Routing Requests" in BKDG for info.
> 
> Tested on Fam15h M30h with ECC turned on using mce_amd_inj facility
> and verified to be functionally correct.
> 
> Changes from V2:
>         - Indentation cleanups
>         - Remove unecessary comments
>         - Remove F15H_M30H_CPU macro and directly use pvt->[fam|model]
>         - Verify if erratum workarounds for E505 and E637 still hold.
>           - From email conversations within AMD, the current status of the errata are:
>             * Erratum 505: Should not be carried over to newer Fam15h models.
>             * Erratum 637: Not fixed.
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 8b6a034..2f05f62 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -123,7 +123,7 @@ static void f15h_select_dct(struct amd64_pvt *pvt, u8 dct)
>  	u32 reg = 0;
>  
>  	amd64_read_pci_cfg(pvt->F1, DCT_CFG_SEL, &reg);
> -	reg &= 0xfffffffe;
> +	reg &= (pvt->model >= 0x30) ? ~3 : ~1;
>  	reg |= dct;
>  	amd64_write_pci_cfg(pvt->F1, DCT_CFG_SEL, reg);
>  }
> @@ -133,8 +133,12 @@ static int f15_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
>  {
>  	u8 dct  = 0;
>  
> +	/*
> +	 * For F15 M30h, the second dct is DCT 3.
> +	 * Refer BKDG Section 2.10
> +	 */
>  	if (addr >= 0x140 && addr <= 0x1a0) {
> -		dct   = 1;
> +		dct = (pvt->model >= 0x30) ? 3 : 1;
>  		addr -= 0x100;
>  	}
>  
> @@ -205,8 +209,9 @@ static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 bw)
>  	if (boot_cpu_data.x86 == 0xf)
>  		min_scrubrate = 0x0;
>  
> -	/* F15h Erratum #505 */
> -	if (boot_cpu_data.x86 == 0x15)
> +	/* F15h Models 0x00 - 0x0f Erratum #505 */
> +	if (boot_cpu_data.x86 == 0x15 &&
> +		boot_cpu_data.x86_model != 0x30)

This check leaves holes in the model space:

You want:

		boot_cpu_data.x86_model < 0x30)

provided everything below 0x30 is affected. But you say models 0x0-0xf
are only affected, which means:


		boot_cpu_data.x86_model < 0x10)

Please recheck which is it.

>  		f15h_select_dct(pvt, 0);
>  
>  	return __amd64_set_scrub_rate(pvt->F3, bw, min_scrubrate);
> @@ -218,8 +223,9 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
>  	u32 scrubval = 0;
>  	int i, retval = -EINVAL;
>  
> -	/* F15h Erratum #505 */
> -	if (boot_cpu_data.x86 == 0x15)
> +	/* F15h Models 0x00 - 0x0f Erratum #505 */
> +	if (boot_cpu_data.x86 == 0x15 &&
> +		boot_cpu_data.x86_model != 0x30)

Ditto.

>  		f15h_select_dct(pvt, 0);
>  
>  	amd64_read_pci_cfg(pvt->F3, SCRCTRL, &scrubval);
> @@ -343,10 +349,11 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
>  		addr_shift	= 4;
>  
>  	/*
> -	* F16h needs two addr_shift values: 8 for high and 6 for low
> -	* (cf. F16h BKDG).
> +	* F16h and F15h(model 30h) needs two addr_shift values:
> +	* 8 for high and 6 for low (cf. F16h BKDG).
>  	*/
> -	} else if (boot_cpu_data.x86 == 0x16) {
> +	} else if (boot_cpu_data.x86 == 0x16 ||

You might just as well make this:

		pvt->fam == 0x16

too.

> +		  (pvt->fam == 0x15 && pvt->model >= 0x30)) {
>  		csbase          = pvt->csels[dct].csbases[csrow];
>  		csmask          = pvt->csels[dct].csmasks[csrow >> 1];
>  
> @@ -743,6 +750,10 @@ static void prep_chip_selects(struct amd64_pvt *pvt)
>  	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < K8_REV_F) {
>  		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
>  		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 8;
> +	}
> +	  else if (pvt->fam == 0x15 && pvt->model >= 0x30) {
> +		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 4;
> +		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 2;
>  	} else {
>  		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
>  		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 4;
> @@ -918,6 +929,7 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
>  	struct amd_northbridge *nb;
>  	struct pci_dev *misc, *f1 = NULL;
>  	struct cpuinfo_x86 *c = &boot_cpu_data;
> +	unsigned int pci_func;
>  	int off = range << 3;
>  	u32 llim;
>  
> @@ -942,7 +954,12 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
>  		return;
>  
>  	misc = nb->misc;

Btw, while you're at it, you can drop the local 'misc' variable and use
nb->misc in that function instead.

> -	f1 = pci_get_related_function(misc->vendor, PCI_DEVICE_ID_AMD_15H_NB_F1, misc);
> +
> +	pci_func = (c->x86_model == 0x30) ? PCI_DEVICE_ID_AMD_15H_M30H_NB_F1
> +					  : PCI_DEVICE_ID_AMD_15H_NB_F1;
> +
> +	f1 = pci_get_related_function(misc->vendor, pci_func, misc);
> +
>  	if (WARN_ON(!f1))
>  		return;
>  
> @@ -1173,7 +1190,8 @@ static int f15_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
>  }
>  
>  /*
> - * F16h has only limited cs_modes
> + * F16h has only limited cs_modes.
> + * F15 M30h follows the same pattern.
>   */
>  static int f16_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
>  				unsigned cs_mode)
> @@ -1218,6 +1236,30 @@ static void read_dram_ctl_register(struct amd64_pvt *pvt)
>  }
>  
>  /*
> + * Determine channel (DCT) based on the interleaving mode:
> + * F15h M30h BKDG, 2.10.12 Memory Interleaving Modes.
> + */
> +static u8 f15_m30h_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
> +				      u8 intlv_en, int num_dcts_intlv,
> +				      u32 dct_sel)
> +{
> +	u8 channel = 0;
> +	u8 select;
> +	u8 intlv_addr = dct_sel_interleave_addr(pvt);

drivers/edac/amd64_edac.c: In function ‘f15_m30h_determine_channel’:
drivers/edac/amd64_edac.c:1245:5: warning: unused variable ‘intlv_addr’ [-Wunused-variable]

Next time, before sending a patch, do a build and look at the warnings
the compiler spits out and whether you've introduced them. In this case,
you've done that and those need to be fixed before sending out the
patch.

Also, you need not only build but also test that it still works, with
the last changes you did unless those changes are trivial.

> +
> +	if (!(intlv_en))
> +		return (u8)(dct_sel);
> +
> +	if (num_dcts_intlv == 2) {
> +		select = (sys_addr >> 8) & 0x3;
> +		channel = select ? 0x3 : 0;
> +	} else if (num_dcts_intlv == 4)
> +		channel = (sys_addr >> 8) & 0x7;
> +
> +	return channel;
> +}
> +
> +/*
>   * Determine channel (DCT) based on the interleaving mode: F10h BKDG, 2.8.9 Memory
>   * Interleaving Modes.
>   */
> @@ -1366,6 +1408,10 @@ static int f1x_lookup_addr_in_dct(u64 in_addr, u8 nid, u8 dct)
>  			 (in_addr & cs_mask), (cs_base & cs_mask));
>  
>  		if ((in_addr & cs_mask) == (cs_base & cs_mask)) {
> +			if (pvt->fam == 0x15 && pvt->model >= 0x30) {
> +				cs_found =  csrow;
> +				break;
> +			}
>  			cs_found = f10_process_possible_spare(pvt, dct, csrow);
>  
>  			edac_dbg(1, " MATCH csrow=%d\n", cs_found);
> @@ -1492,20 +1538,140 @@ static int f1x_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
>  	return cs_found;
>  }
>  
> -static int f1x_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
> -				       int *chan_sel)
> +static int f15_m30h_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
> +					u64 sys_addr, int *chan_sel)
> +{
> +	int cs_found = -EINVAL;
> +	int num_dcts_intlv = 0;
> +	u64 chan_addr, chan_offset, high_addr_offset;

drivers/edac/amd64_edac.c:1543:30: warning: unused variable ‘high_addr_offset’ [-Wunused-variable]

> +	u64 dct_base, dct_limit;
> +	u32 dct_cont_base_reg, dct_cont_limit_reg, tmp;
> +	u8 channel, alias_channel, leg_mmio_hole;
> +
> +
> +	amd64_read_pci_cfg(pvt->F1, DRAM_CONT_BASE, &dct_cont_base_reg);
> +	amd64_read_pci_cfg(pvt->F1, DRAM_CONT_LIMIT, &dct_cont_limit_reg);
> +
> +	u64 dhar_offset		= f10_dhar_offset(pvt);

drivers/edac/amd64_edac.c: In function ‘f15_m30h_match_to_this_node’:
drivers/edac/amd64_edac.c:1552:2: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]

> +	u8 dct_offset_en	= (u8) ((dct_cont_base_reg >> 3) & BIT(0));
> +	u8 dct_sel		= (u8) ((dct_cont_base_reg >> 4) & 0x7);
> +	u8 intlv_addr		= dct_sel_interleave_addr(pvt);
> +	u8 node_id		= dram_dst_node(pvt, range);
> +	u8 intlv_en		= dram_intlv_en(pvt, range);
> +
> +	edac_dbg(1, "(range %d) SystemAddr= 0x%llx Limit=0x%llx\n",
> +		 range, sys_addr, get_dram_limit(pvt, range));

…

The rest looks ok.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaJJRuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 13:50:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57928 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbaJJRuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 13:50:07 -0400
Date: Fri, 10 Oct 2014 19:49:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, bp@suse.de, dan.carpenter@oracle.com,
        dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 4/4] edac, amd64_edac: Add F15h M60h support
Message-ID: <20141010174954.GA13017@pd.tnic>
References: <1412640280-11452-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1412640280-11452-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 07:04:40PM -0500, Aravind Gopalakrishnan wrote:
> This patch adds support for ECC error decoding for F15h M60h processor.
> Aside from the usual changes, the patch adds support for some new features
> in the processor:
>  - DDR4(unbuffered, registered); LRDIMM DDR3 support
>    - relevant debug messages have been modified/added to report these
>      memory types
>  - new dbam_to_cs mappers
>    - if (F15h M60h && LRDIMM); we need a 'multiplier' value to find
>      cs_size. This multiplier value is obtained from the per-dimm
>      DCSM register. So, change the interface to accept a 'cs_mask_nr'
>      value to facilitate this calculation
>  - new determine_memory_type low_ops
>    - introduced to remove too many if-else conditions in
>      determine_memory_type().
>    - This is now called early in read_mc_regs() to cache dram_type
> 
> Misc cleanup:
>  - amd64_pci_table[] is condensed by using PCI_VDEVICE macro.
> 
> Testing details:
> Tested the patch by injecting 'ECC' type errors using mce_amd_inj
> and error decoding works fine.
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> ---
> Changes in V2
>  - Cache dram_type in amd64_pvt structure (per Boris suggestion)
>  - Introduce per-family low_ops for determine_memory_type() to reduce
>    number of if-else statements
>    - Call this early in read_mc_regs() to cache dram_type
>    - The debug messages are moved around a bit as a result to print
>      dram_type immediately
> 
>  drivers/edac/amd64_edac.c | 253 ++++++++++++++++++++++++++++++++--------------
>  drivers/edac/amd64_edac.h |  16 ++-
>  2 files changed, 188 insertions(+), 81 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index bbd6514..6cc3243 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -692,9 +692,18 @@ static void debug_dump_dramcfg_low(struct amd64_pvt *pvt, u32 dclr, int chan)
>  {
>  	edac_dbg(1, "F2x%d90 (DRAM Cfg Low): 0x%08x\n", chan, dclr);
>  
> -	edac_dbg(1, "  DIMM type: %sbuffered; all DIMMs support ECC: %s\n",
> -		 (dclr & BIT(16)) ?  "un" : "",
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
>  
>  	edac_dbg(1, "  PAR/ERR parity: %s\n",
>  		 (dclr & BIT(8)) ?  "enabled" : "disabled");
> @@ -756,7 +765,7 @@ static void prep_chip_selects(struct amd64_pvt *pvt)
>  	if (pvt->fam == 0xf && pvt->ext_model < K8_REV_F) {
>  		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
>  		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 8;
> -	} else if (pvt->fam == 0x15 && pvt->model >= 0x30) {
> +	} else if (pvt->fam == 0x15 && pvt->model == 0x30) {
>  		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 4;
>  		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 2;
>  	} else {
> @@ -813,25 +822,57 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
>  	}
>  }
>  
> -static enum mem_type determine_memory_type(struct amd64_pvt *pvt, int cs)
> +void determine_memory_type_k8(struct amd64_pvt *pvt)
>  {
> -	enum mem_type type;
> -
> -	/* F15h supports only DDR3 */
> -	if (pvt->fam >= 0x15)
> -		type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
> -	else if (pvt->fam == 0x10 || pvt->ext_model >= K8_REV_F) {
> +	if (pvt->ext_model >= K8_REV_F) {
>  		if (pvt->dchr0 & DDR3_MODE)
> -			type = (pvt->dclr0 & BIT(16)) ?	MEM_DDR3 : MEM_RDDR3;
> +			pvt->dram_type = (pvt->dclr0 & BIT(16)) ?
> +					 MEM_DDR3 : MEM_RDDR3;
>  		else
> -			type = (pvt->dclr0 & BIT(16)) ? MEM_DDR2 : MEM_RDDR2;
> +			pvt->dram_type = (pvt->dclr0 & BIT(16)) ?
> +					 MEM_DDR2 : MEM_RDDR2;

If you want to do separate ->determine_memory_type() per family, you can
at least avoid code duplication here above ^^^ by doing

	return determine_memory_type_f10(pvt);

for the K8-revF and later at least.

Or, you can do a nice clean switch/case and keep the logic for the
memory type in one function. See which one looks cleaner but from where
I'm standing, the per-family pointers are a bit too much for this case,
IMHO.

Oh, btw, they all should be static declarations, of course.

>  	} else {
> -		type = (pvt->dclr0 & BIT(18)) ? MEM_DDR : MEM_RDDR;
> +		pvt->dram_type = (pvt->dclr0 & BIT(18)) ? MEM_DDR : MEM_RDDR;
>  	}
> +}
>  
> -	amd64_info("CS%d: %s\n", cs, edac_mem_types[type]);
> +void determine_memory_type_f10(struct amd64_pvt *pvt)
> +{
> +	if (pvt->dchr0 & DDR3_MODE)
> +		pvt->dram_type = (pvt->dclr0 & BIT(16)) ?
> +				 MEM_DDR3 : MEM_RDDR3;
> +	else
> +		pvt->dram_type = (pvt->dclr0 & BIT(16)) ?
> +				 MEM_DDR2 : MEM_RDDR2;
> +}
>  
> -	return type;
> +void determine_memory_type_f15(struct amd64_pvt *pvt)
> +{
> +	if (pvt->model == 0x60) {
> +		/*
> +		 * We use a Chip Select value of '0' to obtain dcsm.
> +		 * Theoretically, it is possible to populate LRDIMMs
> +		 * of different 'Rank' value on a DCT. But this is
> +		 * not a common case. So, it's reasonable to assume
> +		 * all DIMMs are going to be of same 'type' until
> +		 * proven otherwise.
> +		 */
> +		u32 dram_ctrl;
> +		u32 dcsm = pvt->csels[0].csmasks[0];
> +
> +		amd64_read_dct_pci_cfg(pvt, 0, DRAM_CONTROL,
> +				       &dram_ctrl);
> +		pvt->dram_type = (((dram_ctrl >> 8) & 0x7) == 0x2) ? MEM_DDR4 :
> +				 (pvt->dclr0 & BIT(16)) ? MEM_DDR3 :
> +				 (dcsm & 0x3) ? MEM_LRDDR3 : MEM_RDDR3;

This is pretty unreadable, please do a simpler if-else instead.

> +	} else {
> +		pvt->dram_type = (pvt->dclr0 & BIT(16)) ? MEM_DDR3 : MEM_RDDR3;
> +	}
> +}
> +
> +void determine_memory_type_f16(struct amd64_pvt *pvt)
> +{
> +	pvt->dram_type = (pvt->dclr0 & BIT(16)) ? MEM_DDR3 : MEM_RDDR3;

This line tends to repeat a lot - the switch/case version starts to
sound much better all of a sudden... :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

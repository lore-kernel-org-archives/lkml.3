Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaHYFnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 01:43:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36076 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbaHYFnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 01:43:41 -0400
Date: Mon, 25 Aug 2014 07:43:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] edac, amd64_edac: Modify usage of
 amd64_read_dct_pci_cfg()
Message-ID: <20140825054339.GA13911@nazgul.tnic>
References: <1408659586-4736-1-git-send-email-aravind.gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1408659586-4736-1-git-send-email-aravind.gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 05:19:46PM -0500, Aravind Gopalakrishnan wrote:
> @@ -767,17 +750,25 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
>  		int reg1   = DCSB1 + (cs * 4);
>  		u32 *base0 = &pvt->csels[0].csbases[cs];
>  		u32 *base1 = &pvt->csels[1].csbases[cs];
> +		u8 dct = 0;
>  
> -		if (!amd64_read_dct_pci_cfg(pvt, reg0, base0))
> +		if (!amd64_read_dct_pci_cfg(pvt, dct, reg0, base0))
>  			edac_dbg(0, "  DCSB0[%d]=0x%08x reg: F2x%x\n",
>  				 cs, *base0, reg0);
>  
> -		if (pvt->fam == 0xf || dct_ganging_enabled(pvt))
> +		if (pvt->fam == 0xf) {
>  			continue;
> -
> -		if (!amd64_read_dct_pci_cfg(pvt, reg1, base1))
> -			edac_dbg(0, "  DCSB1[%d]=0x%08x reg: F2x%x\n",
> -				 cs, *base1, reg1);
> +		} else if (pvt->fam == 0x10 && !dct_ganging_enabled(pvt)) {
> +			if (!amd64_read_pci_cfg(pvt->F2, reg1, base1))
> +				edac_dbg(0, "  DCSB1[%d]=0x%08x reg: F2x%x\n",
> +					 cs, *base1, reg1);
> +		} else {
> +			dct = ((pvt->fam == 0x15)
> +				&& (pvt->model == 0x30)) ? 3 : 1;
> +			if (!amd64_read_dct_pci_cfg(pvt, dct, reg0, base1))
> +				edac_dbg(0, "  DCSB1[%d]=0x%08x reg: F2x%x\n",
> +					 cs, *base1, reg0);
> +		}
>  	}
>  
>  	for_each_chip_select_mask(cs, 0, pvt) {
> @@ -785,17 +776,25 @@ static void read_dct_base_mask(struct amd64_pvt *pvt)
>  		int reg1   = DCSM1 + (cs * 4);
>  		u32 *mask0 = &pvt->csels[0].csmasks[cs];
>  		u32 *mask1 = &pvt->csels[1].csmasks[cs];
> +		u8 dct = 0;
>  
> -		if (!amd64_read_dct_pci_cfg(pvt, reg0, mask0))
> +		if (!amd64_read_dct_pci_cfg(pvt, dct, reg0, mask0))
>  			edac_dbg(0, "    DCSM0[%d]=0x%08x reg: F2x%x\n",
>  				 cs, *mask0, reg0);
>  
> -		if (pvt->fam == 0xf || dct_ganging_enabled(pvt))
> +		if (pvt->fam == 0xf) {
>  			continue;
> -
> -		if (!amd64_read_dct_pci_cfg(pvt, reg1, mask1))
> -			edac_dbg(0, "    DCSM1[%d]=0x%08x reg: F2x%x\n",
> -				 cs, *mask1, reg1);
> +		} else if (pvt->fam == 0x10 && !dct_ganging_enabled(pvt)) {
> +			if (!amd64_read_pci_cfg(pvt->F2, reg1, mask1))
> +				edac_dbg(0, "    DCSM1[%d]=0x%08x reg: F2x%x\n",
> +					 cs, *mask1, reg1);
> +		} else {
> +			dct = ((pvt->fam == 0x15)
> +				&& (pvt->model == 0x30)) ? 3 : 1;
> +			if (!amd64_read_dct_pci_cfg(pvt, dct, reg0, mask1))
> +				edac_dbg(0, "    DCSM1[%d]=0x%08x reg: F2x%x\n",
> +					 cs, *mask1, reg0);
> +		}

This is almost unreadable now with all the family checks everywhere.
You need to hide all that per-family logic into the function and have a
single

amd_read_pci_cfg_dct(pvt, dct, ...)

which contains all that logic. Calling code doesn't need to care about
details like on which family it is running, etc, etc.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

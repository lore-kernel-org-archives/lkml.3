Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbaIILm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:42:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44255 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbaIILm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:42:56 -0400
Date: Tue, 9 Sep 2014 13:42:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] edac, amd64_edac: Modify usage of
 amd64_read_dct_pci_cfg()
Message-ID: <20140909114250.GA30662@nazgul.tnic>
References: <1409679957-3536-1-git-send-email-aravind.gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1409679957-3536-1-git-send-email-aravind.gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 12:45:57PM -0500, Aravind Gopalakrishnan wrote:
> @@ -495,15 +493,56 @@ int __amd64_read_pci_cfg_dword(struct pci_dev *pdev, int offset,
>  			       u32 *val, const char *func);
>  int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
>  				u32 val, const char *func);
> -
> +void f15h_select_dct(struct amd64_pvt *pvt, u8 dct);
>  #define amd64_read_pci_cfg(pdev, offset, val)	\
>  	__amd64_read_pci_cfg_dword(pdev, offset, val, __func__)
>  
>  #define amd64_write_pci_cfg(pdev, offset, val)	\
>  	__amd64_write_pci_cfg_dword(pdev, offset, val, __func__)
>  
> -#define amd64_read_dct_pci_cfg(pvt, offset, val) \
> -	pvt->ops->read_dct_pci_cfg(pvt, offset, val, __func__)
> +/*
> + * Depending on the family, F2 DCT reads need special handling:
> + *
> + * K8: has a single DCT only and no address offsets >= 0x100
> + *
> + * F10h: each DCT has its own set of regs
> + *	DCT0 -> F2x040..
> + *	DCT1 -> F2x140..
> + *
> + * F16h: has only 1 DCT
> + *
> + * For all above families, we should use the 'raw' version
> + * i.e, amd64_read_pci_cfg() function
> + */
> +static inline int amd64_read_dct_pci_cfg(struct amd64_pvt *pvt, u8 dct,
> +					 int offset, u32 *val)

Why is this function in the header since it is being used only in
amd64_edac.c, AFAICT?

This makes you export f15h_select_dct() too, for no apparent reason.

> +{
> +	if (pvt->fam == 0xf) {
> +		if (dct || offset >= 0x100)
> +			return -EINVAL;
> +	} else if (pvt->fam == 0x10 && dct) {
> +		/*
> +		 * Note: If ganging is enabled, barring the regs
> +		 * F2x[1,0]98 and F2x[1,0]9C; reads reads to F2x1xx
> +		 * return 0. (cf. Section 2.8.1 F10h BKDG)
> +		 */
> +		if (dct_ganging_enabled(pvt))
> +			return 0;
> +
> +		offset += 0x100;
> +	} else if (pvt->fam == 0x15) {
> +		/*
> +		 * F15h: F2x1xx addresses do not map explicitly to DCT1.
> +		 * We should select which DCT we access using F1x10C[DctCfgSel]
> +		 */
> +		dct = (dct && pvt->model == 0x30) ? 3 : dct;
> +		f15h_select_dct(pvt, dct);
> +
> +	} else if (pvt->fam == 0x16 && dct)
> +		return -EINVAL;
> +
> +	return amd64_read_pci_cfg(pvt->F2, offset, val);
> +}
>  
>  int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
>  			     u64 *hole_offset, u64 *hole_size);

-- 
Regards/Gruss,
    Boris.
--

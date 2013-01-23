Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab3AWSVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 13:21:03 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46681 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab3AWSVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 13:21:02 -0500
Date: Wed, 23 Jan 2013 19:23:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org, udovdh@xs4all.nl,
        ssg.sos.patches@mpdtxmail.amd.com
Subject: Re: [PATCH 1/1 V2] AMD Family15h Model10-1Fh erratum 746 Workaround
Message-ID: <20130123182352.GD4256@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	suravee.suthikulpanit@amd.com, iommu@lists.linux-foundation.org,
	joro@8bytes.org, linux-kernel@vger.kernel.org, udovdh@xs4all.nl,
	ssg.sos.patches@mpdtxmail.amd.com
References: <1358964808-2124-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1358964808-2124-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 12:13:28PM -0600, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> Changes from V1:
> * Fix logic that check the processor model.
> * Clear writing enable bit after apply the workaround
> * Change function name

You need a proper commit message...

> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index 81837b0..a04b20a 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -975,6 +975,37 @@ static void __init free_iommu_all(void)
>  }
>  
>  /*
> + * AMD family15h Model 10h-1fh erratum 746 (IOMMU Logging May Stall Translations)
> + * Workaround:
> + *     BIOS should disable L2B micellaneous clock gating by setting
> + *     L2_L2B_CK_GATE_CONTROL[CKGateL2BMiscDisable](D0F2xF4_x90[2]) = 1b
> + */

... like this one, for example. You could explain what the erratum does
and what the workaround is in the commit message.

> +static void __init amd_iommu_erratum_746_workaround(struct amd_iommu *iommu)
> +{
> +	u32 value;
> +
> +	if ((boot_cpu_data.x86 != 0x15) || 
> +	    (boot_cpu_data.x86_model < 0x10) ||
> +	    (boot_cpu_data.x86_model > 0x1f))
> +		return;
> +	
> +	pci_write_config_dword(iommu->dev, 0xf0, 0x90);
> +	pci_read_config_dword(iommu->dev, 0xf4, &value); 
> +
> +	if (!(value & 0x4)) {

Save an indentation level by reversing the logic here:

	if (value & BIT(2))
		return;

	/* Select NB...

> +		/* Select Northbridge indirect register 0x90 and enable writing */
> +		pci_write_config_dword(iommu->dev, 0xf0, 0x90 | (1 << 8));
> +
> +		pci_write_config_dword(iommu->dev, 0xf4, value | 0x4);
> +		pr_info("AMD-Vi: Applying erratum 746 workaround for IOMMU at %s\n",
> +		 dev_name(&iommu->dev->dev));
> +
> +		/* Clear the enable writing bit */
> +		pci_write_config_dword(iommu->dev, 0xf0, 0x90);
> +	}
> +}
> +
> +/*
>   * This function clues the initialization function for one IOMMU
>   * together and also allocates the command buffer and programs the
>   * hardware. It does NOT enable the IOMMU. This is done afterwards.
> @@ -1171,6 +1202,8 @@ static int iommu_init_pci(struct amd_iommu *iommu)
>  		for (i = 0; i < 0x83; i++)
>  			iommu->stored_l2[i] = iommu_read_l2(iommu, i);
>  	}
> +	
> +	amd_iommu_erratum_746_workaround(iommu);
>  
>  	return pci_enable_device(iommu->dev);

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

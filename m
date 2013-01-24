Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3AXNJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:09:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46570 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab3AXNJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:09:32 -0500
Date: Thu, 24 Jan 2013 14:12:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org, udovdh@xs4all.nl,
        ssg.sos.patches@mpdtxmail.amd.com
Subject: Re: [PATCH 1/1 V3] AMD Family15h Model10-1Fh erratum 746 Workaround
Message-ID: <20130124131222.GF13463@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	suravee.suthikulpanit@amd.com, iommu@lists.linux-foundation.org,
	joro@8bytes.org, linux-kernel@vger.kernel.org, udovdh@xs4all.nl,
	ssg.sos.patches@mpdtxmail.amd.com
References: <1359030615-2145-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1359030615-2145-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 06:30:15AM -0600, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> Changes in V3:
> 	* Add proper commit message
> 	* Change logic to avoid unnecessary indentaion
> 
> Changes in V2:
> 	* Fix logic that check the processor model.
> 	* Clear write enable bit after apply workaround
> 	* Change function name 

Changelogs need to be after the diffstat, see below. They should be
part of the commit message only when they contain important information
pertaining to the fix itself and those pieces which are needed for patch
tracking and not to be in changelog should go after the "---" so that
git doesn't pick them up in the commit message.

> Commit Message:
> Erratum 746: IOMMU Logging May Stall Transaction
> Workaround:  BIOS should disable L2B micellaneous clock gating by setting 
>              L2_L2B_CK_GATE_CONTROL[CKGateL2BMiscDisable](D0F2xF4_x90[2]) = 1b

This commit message is kinda laconic: it says it all for AMD folk who
stare at RGs all the time but not to normal users. I've attached a
corrected version of this patch so that you can see what I mean. And
I've taken the text from the RG and made it a bit more readable so that
I can piss off Eric again :-).

> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

This patch is adding trailing whitespace:

Apply? [y]es/[n]o/[e]dit/[v]iew patch/[a]ccept all y
Applying: AMD Family15h Model10-1Fh erratum 746 Workaround
/w/kernel/linux-2.6/.git/rebase-apply/patch:18: trailing whitespace.
        if ((boot_cpu_data.x86 != 0x15) || 
/w/kernel/linux-2.6/.git/rebase-apply/patch:22: trailing whitespace.

/w/kernel/linux-2.6/.git/rebase-apply/patch:24: trailing whitespace.
        pci_read_config_dword(iommu->dev, 0xf4, &value); 
/w/kernel/linux-2.6/.git/rebase-apply/patch:48: trailing whitespace.

warning: 4 lines add whitespace errors.

You can catch stuff like that when running your patch through
scripts/checkpatch.pl:

ERROR: trailing whitespace
#36: FILE: drivers/iommu/amd_iommu_init.c:987:
+^Iif ((boot_cpu_data.x86 != 0x15) || $

ERROR: trailing whitespace
#40: FILE: drivers/iommu/amd_iommu_init.c:991:
+^I$

ERROR: trailing whitespace
#42: FILE: drivers/iommu/amd_iommu_init.c:993:
+^Ipci_read_config_dword(iommu->dev, 0xf4, &value); $

ERROR: trailing whitespace
#66: FILE: drivers/iommu/amd_iommu_init.c:1206:
+^I$

total: 4 errors, 2 warnings, 46 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

Your patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.


> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index 81837b0..934b017 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -975,6 +975,38 @@ static void __init free_iommu_all(void)
>  }
>  
>  /*
> + * AMD family15h Model 10h-1fh erratum 746 (IOMMU Logging May Stall Translations)
> + * Workaround:
> + *     BIOS should disable L2B micellaneous clock gating by setting
> + *     L2_L2B_CK_GATE_CONTROL[CKGateL2BMiscDisable](D0F2xF4_x90[2]) = 1b
> + */
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
> +	if (value & BIT(2))
> +		return;
> +
> +	/* Select NB indirect register 0x90 and enable writing */
> +	pci_write_config_dword(iommu->dev, 0xf0, 0x90 | (1 << 8));
> +
> +	pci_write_config_dword(iommu->dev, 0xf4, value | 0x4);
> +	pr_info("AMD-Vi: Applying erratum 746 workaround for IOMMU at %s\n",
> +	 dev_name(&iommu->dev->dev));

This should be aligned with "AMD-Vi... " above.

> +
> +	/* Clear the enable writing bit */
> +	pci_write_config_dword(iommu->dev, 0xf0, 0x90);
> +}
> +
> +/*
>   * This function clues the initialization function for one IOMMU
>   * together and also allocates the command buffer and programs the
>   * hardware. It does NOT enable the IOMMU. This is done afterwards.
> @@ -1171,6 +1203,8 @@ static int iommu_init_pci(struct amd_iommu *iommu)
>  		for (i = 0; i < 0x83; i++)
>  			iommu->stored_l2[i] = iommu_read_l2(iommu, i);
>  	}
> +	
> +	amd_iommu_erratum_746_workaround(iommu);
>  
>  	return pci_enable_device(iommu->dev);

Ok, here it is, take a look.

---
>From 6ed43106e7fbe32c84e07f3c50591b8577964009 Mon Sep 17 00:00:00 2001
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Date: Thu, 24 Jan 2013 06:30:15 -0600
Subject: [PATCH] iommu, AMD: Add an erratum 746 workaround

The IOMMU may stop processing page translations due to a perceived lack
of credits for writing upstream peripheral page service request (PPR)
or event logs. If the L2B miscellaneous clock gating feature is enabled
the IOMMU does not properly register credits after the log request has
completed, leading to a potential system hang.

BIOSes are supposed to disable L2B micellaneous clock gating by setting
L2_L2B_CK_GATE_CONTROL[CKGateL2BMiscDisable](D0F2xF4_x90[2]) = 1b. This
patch corrects that for those which do not enable this workaround.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
Changelog:

v3:
      * Add proper commit message
      * Change logic to avoid unnecessary indentaion

v2:
      * Fix logic that check the processor model.
      * Clear write enable bit after apply workaround
      * Change function name

 drivers/iommu/amd_iommu_init.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 81837b0710a9..ed3539b1e460 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -975,6 +975,38 @@ static void __init free_iommu_all(void)
 }
 
 /*
+ * AMD family15h Model 10h-1fh erratum 746 (IOMMU Logging May Stall Translations)
+ * Workaround:
+ *     BIOS should disable L2B micellaneous clock gating by setting
+ *     L2_L2B_CK_GATE_CONTROL[CKGateL2BMiscDisable](D0F2xF4_x90[2]) = 1b
+ */
+static void __init amd_iommu_erratum_746_workaround(struct amd_iommu *iommu)
+{
+	u32 value;
+
+	if ((boot_cpu_data.x86 != 0x15) ||
+	    (boot_cpu_data.x86_model < 0x10) ||
+	    (boot_cpu_data.x86_model > 0x1f))
+		return;
+
+	pci_write_config_dword(iommu->dev, 0xf0, 0x90);
+	pci_read_config_dword(iommu->dev, 0xf4, &value);
+
+	if (value & BIT(2))
+		return;
+
+	/* Select NB indirect register 0x90 and enable writing */
+	pci_write_config_dword(iommu->dev, 0xf0, 0x90 | (1 << 8));
+
+	pci_write_config_dword(iommu->dev, 0xf4, value | 0x4);
+	pr_info("AMD-Vi: Applying erratum 746 workaround for IOMMU at %s\n",
+		dev_name(&iommu->dev->dev));
+
+	/* Clear the enable writing bit */
+	pci_write_config_dword(iommu->dev, 0xf0, 0x90);
+}
+
+/*
  * This function clues the initialization function for one IOMMU
  * together and also allocates the command buffer and programs the
  * hardware. It does NOT enable the IOMMU. This is done afterwards.
@@ -1172,6 +1204,8 @@ static int iommu_init_pci(struct amd_iommu *iommu)
 			iommu->stored_l2[i] = iommu_read_l2(iommu, i);
 	}
 
+	amd_iommu_erratum_746_workaround(iommu);
+
 	return pci_enable_device(iommu->dev);
 }
 
-- 
1.8.1.rc3

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

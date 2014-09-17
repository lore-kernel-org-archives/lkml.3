Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbaIQCJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:09:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:65006 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbaIQCJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:09:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,537,1406617200"; 
   d="scan'208";a="574187392"
Message-ID: <5418ED4A.2030607@linux.intel.com>
Date: Wed, 17 Sep 2014 10:09:14 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Martin Kelly <martin@martingkelly.com>, x86@kernel.org, mingo@redhat.com
CC: vishwesh.m.rudramuni@intel.com, joe@perches.com, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH v2] x86/pmc_atom: Fix warning when CONFIG_DEBUG_FS=n
References: <1410914975-23285-1-git-send-email-martin@martingkelly.com>
In-Reply-To: <1410914975-23285-1-git-send-email-martin@martingkelly.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/17 8:49, Martin Kelly wrote:
> When compiling with CONFIG_DEBUG_FS=n, gcc emits an unused variable
> warning for pmc_atom.c because "ret" is used only within the
> CONFIG_DEBUG_FS block. This patch adds a dummy #ifdef for
> pmc_dbgfs_register when CONFIG_DEBUG_FS=n to simplify the code and
> remove the warning.
> 
> Signed-off-by: Martin Kelly <martkell@amazon.com>

Thanks to take care of this warning. How about this version?

diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index 0c424a6..cd91b57 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -240,7 +240,7 @@ err:
 static int pmc_setup_dev(struct pci_dev *pdev)
 {
 	struct pmc_dev *pmc = &pmc_device;
-	int ret;
+	int ret = 0;
 
 	/* Obtain ACPI base address */
 	pci_read_config_dword(pdev, ACPI_BASE_ADDR_OFFSET, &acpi_base_addr);
@@ -269,7 +269,7 @@ static int pmc_setup_dev(struct pci_dev *pdev)
 		return ret;
 	}
 #endif /* CONFIG_DEBUG_FS */
-	return 0;
+	return ret;
 }
 
 /*

Thanks,
-Aubrey


> ---
> Changes in v2:
>   - Implemented Ingo Molnar's suggestion to #ifdef the function rather
>     than the lines.
> ---
>  arch/x86/kernel/pmc_atom.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
> index 0c424a6..d06527a 100644
> --- a/arch/x86/kernel/pmc_atom.c
> +++ b/arch/x86/kernel/pmc_atom.c
> @@ -235,6 +235,11 @@ err:
>  	pmc_dbgfs_unregister(pmc);
>  	return -ENODEV;
>  }
> +#else
> +static int pmc_dbgfs_register(struct pmc_dev *pmc, struct pci_dev *pdev)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_DEBUG_FS */
>  
>  static int pmc_setup_dev(struct pci_dev *pdev)
> @@ -262,13 +267,11 @@ static int pmc_setup_dev(struct pci_dev *pdev)
>  	/* PMC hardware registers setup */
>  	pmc_hw_reg_setup(pmc);
>  
> -#ifdef CONFIG_DEBUG_FS
>  	ret = pmc_dbgfs_register(pmc, pdev);
>  	if (ret) {
>  		iounmap(pmc->regmap);
>  		return ret;
>  	}
> -#endif /* CONFIG_DEBUG_FS */
>  	return 0;
>  }
>  
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaIRXww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 19:52:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:15705 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaIRXwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 19:52:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,550,1406617200"; 
   d="scan'208";a="575407297"
Message-ID: <541B7051.2040803@linux.intel.com>
Date: Fri, 19 Sep 2014 07:52:49 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Martin Kelly <martin@martingkelly.com>, x86@kernel.org, mingo@redhat.com
CC: vishwesh.m.rudramuni@intel.com, joe@perches.com, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH v3] x86/pmc_atom: Fix warning when CONFIG_DEBUG_FS=n
References: <1410963476-8360-1-git-send-email-martin@martingkelly.com>
In-Reply-To: <1410963476-8360-1-git-send-email-martin@martingkelly.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/17 22:17, Martin Kelly wrote:
> When compiling with CONFIG_DEBUG_FS=n, gcc emits an unused variable
> warning for pmc_atom.c because "ret" is used only within the
> CONFIG_DEBUG_FS block. This patch adds a dummy #ifdef for
> pmc_dbgfs_register when CONFIG_DEBUG_FS=n to simplify the code and
> remove the warning.
> 
> Signed-off-by: Martin Kelly <martkell@amazon.com>

Looks good to me, thanks Martin!

> ---
> Changes in v3:
>   - Further unified the return code logic, as suggested by Ingo Molnar
> 
> Changes in v2:
>   - Implemented Ingo Molnar's suggestion to #ifdef the function rather
>     than the lines.
> ---
>  arch/x86/kernel/pmc_atom.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
> index 0c424a6..0ee5025e 100644
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
> @@ -262,14 +267,12 @@ static int pmc_setup_dev(struct pci_dev *pdev)
>  	/* PMC hardware registers setup */
>  	pmc_hw_reg_setup(pmc);
>  
> -#ifdef CONFIG_DEBUG_FS
>  	ret = pmc_dbgfs_register(pmc, pdev);
>  	if (ret) {
>  		iounmap(pmc->regmap);
> -		return ret;
>  	}
> -#endif /* CONFIG_DEBUG_FS */
> -	return 0;
> +
> +	return ret;
>  }
>  
>  /*
> 


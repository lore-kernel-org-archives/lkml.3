Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbaIQMYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:24:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55152 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbaIQMYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:24:31 -0400
Date: Wed, 17 Sep 2014 14:24:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Martin Kelly <martin@martingkelly.com>
Cc: x86@kernel.org, mingo@redhat.com, vishwesh.m.rudramuni@intel.com,
        joe@perches.com, hpa@linux.intel.com, aubrey.li@linux.intel.com,
        linux-kernel@vger.kernel.org, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH v2] x86/pmc_atom: Fix warning when CONFIG_DEBUG_FS=n
Message-ID: <20140917122427.GB2704@gmail.com>
References: <1410914975-23285-1-git-send-email-martin@martingkelly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410914975-23285-1-git-send-email-martin@martingkelly.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Kelly <martin@martingkelly.com> wrote:

> When compiling with CONFIG_DEBUG_FS=n, gcc emits an unused variable
> warning for pmc_atom.c because "ret" is used only within the
> CONFIG_DEBUG_FS block. This patch adds a dummy #ifdef for
> pmc_dbgfs_register when CONFIG_DEBUG_FS=n to simplify the code and
> remove the warning.
> 
> Signed-off-by: Martin Kelly <martkell@amazon.com>
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

Ok, that part is good.

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

Just to paint the bike shed a bit, this could be further 
simplified to something like:

	...

  	ret = pmc_dbgfs_register(pmc, pdev);
  	if (ret)
  		iounmap(pmc->regmap);

  	return ret;

and then your patch will be perfect! :-)

Thanks,

	Ingo

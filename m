Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbaKSLgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:36:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:44162 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaKSLgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:36:13 -0500
Date: Wed, 19 Nov 2014 12:36:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
cc: "H . Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Aubrey Li <aubrey.li@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] x86: pmc_atom: don't check for NULL twice
In-Reply-To: <1415812689-17326-3-git-send-email-andriy.shevchenko@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1411191224220.3909@nanos>
References: <1415812689-17326-1-git-send-email-andriy.shevchenko@linux.intel.com> <1415812689-17326-3-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014, Andy Shevchenko wrote:

> debugfs_remove_recursive() is NULL-aware, thus, we may safely remove the check
> here. There is no need to assing NULL to variable since it will be not used
> anywhere.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Aubrey Li <aubrey.li@linux.intel.com>
> ---
>  arch/x86/kernel/pmc_atom.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
> index 19b8efa..bcc91ea 100644
> --- a/arch/x86/kernel/pmc_atom.c
> +++ b/arch/x86/kernel/pmc_atom.c
> @@ -202,11 +202,7 @@ static const struct file_operations pmc_sleep_tmr_ops = {
>  
>  static void pmc_dbgfs_unregister(struct pmc_dev *pmc)
>  {
> -	if (!pmc->dbgfs_dir)
> -		return;
> -
>  	debugfs_remove_recursive(pmc->dbgfs_dir);
> -	pmc->dbgfs_dir = NULL;
>  }

So while the patch is correct per se, the whole function is useless.

pmc_dbgfs_register()

	dir = debugfs_create_dir("pmc_atom", NULL);

	....
	if (!f)
		goto err;

	pmc->dbgfs_dir = dir;
	return 0;
err:
	pmc_dbgfs_unregister(pmc);

So pmc->dbgfs_dir is always NULL when this is called....

Aside of that, if DEBUGFS=n the code keeps pmc->regmap ioremapped for
no reason.

Looking deeper:

The pmc_power_off function is installed _BEFORE_ pmc_hw_reg_setup() is
called, which might not be called if the ioremap fails ....

Thanks,

	tglx



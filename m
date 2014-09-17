Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaIQM0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:26:49 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40000 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbaIQM0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:26:48 -0400
Date: Wed, 17 Sep 2014 14:26:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: iosf: Make debugfs addition a separate config
 option
Message-ID: <20140917122643.GC2704@gmail.com>
References: <1409175640-32426-1-git-send-email-david.e.box@linux.intel.com>
 <1410924386-16977-4-git-send-email-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410924386-16977-4-git-send-email-david.e.box@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David E. Box <david.e.box@linux.intel.com> wrote:

> Signed-off-by: David E. Box <david.e.box@linux.intel.com>
> ---
>  arch/x86/Kconfig           | 6 ++++++
>  arch/x86/kernel/iosf_mbi.c | 8 ++++++--
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 2db4b1d..3afcac3 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -494,6 +494,12 @@ config IOSF_MBI
>  	  You should say Y if you are running a kernel on one of these
>  	  platforms.
>  
> +config IOSF_MBI_DEBUG
> +	bool "Enable debugfs access to IOSF"
> +	depends on IOSF_MBI && DEBUG_FS
> +	---help---
> +	  Select this option to enable iosf sideband debugging through debugfs.

Please also mention where the debug info is.

> -/********************** debugfs begin ****************************/
> +#if (IS_ENABLED(CONFIG_IOSF_MBI_DEBUG))
>  static u32	dbg_mdr;
>  static u32	dbg_mcr;
>  static u32	dbg_mcrx;
> @@ -257,7 +257,7 @@ static void iosf_sideband_debug_init(void)
>  cleanup:
>  	debugfs_remove_recursive(d);
>  }
> -/********************** debugfs end ****************************/
> +#endif /* CONFIG_IOSF_MBI_DEBUG */
>  
>  static int iosf_mbi_probe(struct pci_dev *pdev,
>  			  const struct pci_device_id *unused)
> @@ -290,13 +290,17 @@ static struct pci_driver iosf_mbi_pci_driver = {
>  
>  static int __init iosf_mbi_init(void)
>  {
> +#if IS_ENABLED(CONFIG_IOSF_MBI_DEBUG)
>  	iosf_sideband_debug_init();
> +#endif
>  	return pci_register_driver(&iosf_mbi_pci_driver);
>  }
>  
>  static void __exit iosf_mbi_exit(void)
>  {
> +#if IS_ENABLED(CONFIG_IOSF_MBI_DEBUG)
>  	debugfs_remove_recursive(iosf_dbg);
> +#endif

The last two #ifdefs are pretty ugly, please make dummy !DEBUG 
versions of those methods, so that the regular code is not 
uglified with debugging details.

Also, because COFIG_IOSF_MBI_DEBUG is a bool, using:

	#ifdef CONFIG_IOSF_MBI_DEBUG

should be enough in general.

Thanks,

	Ingo

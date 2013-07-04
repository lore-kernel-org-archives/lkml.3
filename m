Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab3GDJZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:25:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51944 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3GDJZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:25:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support 'COMPILE_TEST' in 'asm-generic'.
Date: Thu, 4 Jul 2013 11:25:14 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        David Sharp <dhsharp@google.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Ingo Molnar <mingo@kernel.org>,
        "uml-devel" <user-mode-linux-devel@lists.sourceforge.net>,
        "uml-user" <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Linux-Arch" <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>, Jiri Slaby <jslaby@suse.cz>
References: <20130704011221.GA11230@kroah.com> <20130704061204.GA12148@kroah.com> <51D517A7.6030908@asianux.com>
In-Reply-To: <51D517A7.6030908@asianux.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307041125.15083.arnd@arndb.de>
X-Provags-ID: V02:K0:L/wsz7vNBNFyA8dPNBlEAhenSJpjB9daKuBjTG3aDou
 5FKuFKckiKD4ZGKpkqzFsMZD41D67IrcbyEN2uzky0kl8yNNln
 t9/mulbWVJx4/R5dR+gChJ7fRunKGMHq9c95Ls84KDOfBqd3TX
 xoIRWE3DicJHEsvBGtjvJbA9QeVAWLpKtsrIMxa9t3XsE+/BXM
 2iXP1p3ZeVO56eitAvwNPdBe2KiZK8At75UnMff4u/1lRQqWgz
 qohawL+Ys3rRhBFnn+FAlK6U/PiFQ6dz3qnVYXyltCwasMrC0/
 x4mrhLzqvXYVQjTeghq+Vn5e3ZwtqIGhqvIP/HRq3eK5t2jnYW
 bru+Qt4+stH5haXPszhk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 July 2013, Chen Gang wrote:

> --------------------------patch begin----------------------------------
> 
> 'asm-generic' need provide necessary configuration checking, if can't
> pass checking, 'asm-generic' shouldn't implement it.
> 
> For 'COMPILE_TEST', according to its help contents, 'asm-generic' need
> let it pass configuration checking, and provide related dummy contents
> for it.
> 
> Part of 'COMPLE_TEST' help contents in "init/Kconfig":
> 
>   "...Despite they cannot be loaded there (or even when they load they cannot be used due to missing HW support)..."
> 
> One sample for using 'COMPILE_TEST':
> 
>   'PTP_1588_CLOCK_PCH' in drivers/ptp/Kconfig, which need depend on 'HAS_IOMEM'.

Then please submit a patch that adds the 'depends on HAS_IOMEM' line there.
That line was clearly left out by accident.

> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  include/asm-generic/io.h |   22 ++++++++++++++++++----
>  1 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
> index d5afe96..301ce80 100644
> --- a/include/asm-generic/io.h
> +++ b/include/asm-generic/io.h
> @@ -303,13 +303,18 @@ static inline void *phys_to_virt(unsigned long address)
>  /*
>   * Change "struct page" to physical address.
>   *
> - * This implementation is for the no-MMU case only... if you have an MMU
> - * you'll need to provide your own definitions.
> + * This for the no-MMU, or no-IOMEM but still try to COMPILE_TEST cases.
> + * if you have an MMU and IOMEM, you'll need to provide your own definitions.
>   */
> -#ifndef CONFIG_MMU
> +#if !defined(CONFIG_MMU) || \
> +	(!defined(CONFIG_HAS_IOMEM) && defined(CONFIG_COMPILE_TEST))
>  static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
>  {
> +#if !defined(CONFIG_MMU)
>  	return (void __iomem*) (unsigned long)offset;
> +#else
> +	return NULL;
> +#endif
>  }
>  
>  #define __ioremap(offset, size, flags)	ioremap(offset, size)

This is wrong for multiple reasons, all of which have been discussed in
this thread before.

NAK

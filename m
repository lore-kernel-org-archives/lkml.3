Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbaHFPQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 11:16:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52324 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaHFPQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 11:16:26 -0400
Date: Wed, 6 Aug 2014 16:16:20 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Brian Gerst <brgerst@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@alien8.de>, Andrew Lutomriski <amluto@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dirk Hohndel <dirk@hohndel.org>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        comex <comexk@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 3.10 12/27] x86-64, espfix: Dont leak bits 31:16 of %esp
 returning to 16-bit stack
Message-ID: <20140806151620.GD12150@hercules>
References: <20140805181344.268039690@linuxfoundation.org>
 <20140805181344.629775899@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140805181344.629775899@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 11:14:04AM -0700, Greg Kroah-Hartman wrote:
<...>
> @@ -188,17 +193,21 @@ static void note_page(struct seq_file *m
>  		/*
>  		 * Now print the actual finished series
>  		 */
> -		seq_printf(m, "0x%0*lx-0x%0*lx   ",
> -			   width, st->start_address,
> -			   width, st->current_address);
> -
> -		delta = (st->current_address - st->start_address) >> 10;
> -		while (!(delta & 1023) && unit[1]) {
> -			delta >>= 10;
> -			unit++;
> +		if (!st->marker->max_lines ||
> +		    st->lines < st->marker->max_lines) {
> +			seq_printf(m, "0x%0*lx-0x%0*lx   ",
> +				   width, st->start_address,
> +				   width, st->current_address);
> +
> +			delta = (st->current_address - st->start_address) >> 10;
> +			while (!(delta & 1023) && unit[1]) {
> +				delta >>= 10;
> +				unit++;
> +			}
> +			seq_printf(m, "%9lu%c ", delta, *unit);
> +			printk_prot(m, st->current_prot, st->level);
>  		}
> -		seq_printf(m, "%9lu%c ", delta, *unit);
> -		printk_prot(m, st->current_prot, st->level);
> +		st->lines++;
>  
>  		/*
>  		 * We print markers for special areas of address space,

Hmm... the original commit has a 2nd hunk here that does seem to be
applicable to 3.10.  Was this dropped accidentally or on purpose?

Cheers,
--
Luís

> --- a/init/main.c
> +++ b/init/main.c
> @@ -606,6 +606,10 @@ asmlinkage void __init start_kernel(void
>  	if (efi_enabled(EFI_RUNTIME_SERVICES))
>  		efi_enter_virtual_mode();
>  #endif
> +#ifdef CONFIG_X86_64
> +	/* Should be run before the first non-init thread is created */
> +	init_espfix_bsp();
> +#endif
>  	thread_info_cache_init();
>  	cred_init();
>  	fork_init(totalram_pages);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


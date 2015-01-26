Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbbA0AiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:38:05 -0500
Received: from ozlabs.org ([103.22.144.67]:40413 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757931AbbA0Ah5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:37:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Rabin Vincent <rabin.vincent@axis.com>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabinv@axis.com>
Subject: Re: [PATCH] module: set ksymtab/kcrctab* section addresses to 0x0
In-Reply-To: <1422305155-23136-1-git-send-email-rabin.vincent@axis.com>
References: <1422305155-23136-1-git-send-email-rabin.vincent@axis.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 27 Jan 2015 10:20:32 +1030
Message-ID: <87d261rtiv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rabin Vincent <rabin.vincent@axis.com> writes:
> These __ksymtab*/__kcrctab* sections currently have non-zero addresses.
> Non-zero section addresses in a relocatable ELF confuse GDB and it ends
> up not relocating all symbols when add-symbol-file is used on modules
> which have exports.  The kernel's module loader does not care about
> these addresses, so let's just set them to zero.

Hi Rabin,

        You're right, we don't use sh_addr.  This should be safe, I've
applied it for the next merge window.

AFAICT this would have always been a problem; wonder if it should be
CC:stable?  I don't use gdb on modules so haven't got a good feel for
how many people this would be hurting.

Thanks,
Rusty.

>  Before:
>
>   $ readelf -S lib/notifier-error-inject.ko   | grep 'Name\| __ksymtab_gpl'
>     [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
>     [ 8] __ksymtab_gpl     PROGBITS        0000000c 0001b4 000010 00   A  0   0  4
>
>   (gdb) add-symbol-file lib/notifier-error-inject.ko 0x500000 -s .bss 0x700000
>   add symbol table from file "lib/notifier-error-inject.ko" at
>      .text_addr = 0x500000
>      .bss_addr = 0x700000
>   (gdb) p &notifier_err_inject_dir
>   $3 = (struct dentry **) 0x0
>
>  After:
>
>   $ readelf -S lib/notifier-error-inject.ko   | grep 'Name\| __ksymtab_gpl'
>     [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
>     [ 8] __ksymtab_gpl     PROGBITS        00000000 0001b4 000010 00   A  0   0  4
>
>   (gdb) add-symbol-file lib/notifier-error-inject.ko 0x500000 -s .bss 0x700000
>   add symbol table from file "lib/notifier-error-inject.ko" at
>      .text_addr = 0x500000
>      .bss_addr = 0x700000
>   (gdb) p &notifier_err_inject_dir
>   $3 = (struct dentry **) 0x700000
>
> Signed-off-by: Rabin Vincent <rabin.vincent@axis.com>
> ---
>  scripts/module-common.lds |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/scripts/module-common.lds b/scripts/module-common.lds
> index 0865b3e..bec15f9 100644
> --- a/scripts/module-common.lds
> +++ b/scripts/module-common.lds
> @@ -6,14 +6,14 @@
>  SECTIONS {
>  	/DISCARD/ : { *(.discard) }
>  
> -	__ksymtab		: { *(SORT(___ksymtab+*)) }
> -	__ksymtab_gpl		: { *(SORT(___ksymtab_gpl+*)) }
> -	__ksymtab_unused	: { *(SORT(___ksymtab_unused+*)) }
> -	__ksymtab_unused_gpl	: { *(SORT(___ksymtab_unused_gpl+*)) }
> -	__ksymtab_gpl_future	: { *(SORT(___ksymtab_gpl_future+*)) }
> -	__kcrctab		: { *(SORT(___kcrctab+*)) }
> -	__kcrctab_gpl		: { *(SORT(___kcrctab_gpl+*)) }
> -	__kcrctab_unused	: { *(SORT(___kcrctab_unused+*)) }
> -	__kcrctab_unused_gpl	: { *(SORT(___kcrctab_unused_gpl+*)) }
> -	__kcrctab_gpl_future	: { *(SORT(___kcrctab_gpl_future+*)) }
> +	__ksymtab		0 : { *(SORT(___ksymtab+*)) }
> +	__ksymtab_gpl		0 : { *(SORT(___ksymtab_gpl+*)) }
> +	__ksymtab_unused	0 : { *(SORT(___ksymtab_unused+*)) }
> +	__ksymtab_unused_gpl	0 : { *(SORT(___ksymtab_unused_gpl+*)) }
> +	__ksymtab_gpl_future	0 : { *(SORT(___ksymtab_gpl_future+*)) }
> +	__kcrctab		0 : { *(SORT(___kcrctab+*)) }
> +	__kcrctab_gpl		0 : { *(SORT(___kcrctab_gpl+*)) }
> +	__kcrctab_unused	0 : { *(SORT(___kcrctab_unused+*)) }
> +	__kcrctab_unused_gpl	0 : { *(SORT(___kcrctab_unused_gpl+*)) }
> +	__kcrctab_gpl_future	0 : { *(SORT(___kcrctab_gpl_future+*)) }
>  }
> -- 
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

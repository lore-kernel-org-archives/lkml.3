Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3ENCQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:16:59 -0400
Received: from intranet.asianux.com ([58.214.24.6]:23102 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab3ENCQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:16:57 -0400
X-Spam-Score: -100.8
Message-ID: <51919E64.8020409@asianux.com>
Date: Tue, 14 May 2013 10:16:04 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/module.c: cleanup patch for looping, let return
 'bool' value instead of real error number.
References: <51889EE4.4070504@asianux.com> <87ip2unwkt.fsf@rustcorp.com.au> <5189C1D6.1040209@asianux.com> <87li7j3cgw.fsf@rustcorp.com.au> <51905EEF.2050901@asianux.com> <5190DB74.6050100@asianux.com>
In-Reply-To: <5190DB74.6050100@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Oh, sorry, my fix is incorrect !!

The return value is used by caller of caller ... it seems the user mode
can sense it !! So we still should return the correct error code to
outside when error occurs.

I think we can reference 'using compiler': it prints all errors and
warnings as far as it can, but the user usually mainly focus on the
first error or warning.

So I think the suitable fix is to still print all problems, but should
return the first error code (not return the last error code).

Please help check, thanks.


On 05/13/2013 08:24 PM, Chen Gang wrote:
> 
> For looping in simplify_symbols(), when multiple errors occur, the
> original error number will be override (the original related commit
> "1da177e Linux-2.6.12-rc").
> 
> We focus on printing all errors as much as possible, and not focus on
> the return error number (only know whether succeed or not is enough),
> 
> So when error occurs during looping, it is correct to only mark "need
> return failure" and continue looping.
> 
> Since simplify_symbols() is a static function (not an API to outside),
> it is better to change the function return type to 'bool', so that can
> skip processing error number details incorrectly.
> 
> 
> Signed-off-by: root <root@dhcp122.asianux.net>
> ---
>  kernel/module.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index b049939..445a960 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1956,14 +1956,18 @@ static int verify_export_symbols(struct module *mod)
>  	return 0;
>  }
>  
> -/* Change all symbols so that st_value encodes the pointer directly. */
> -static int simplify_symbols(struct module *mod, const struct load_info *info)
> +/*
> + * Change all symbols so that st_value encodes the pointer directly.
> + *
> + * Return true if succeed, or false if at least 1 failure occurs.
> + */
> +static bool simplify_symbols(struct module *mod, const struct load_info *info)
>  {
>  	Elf_Shdr *symsec = &info->sechdrs[info->index.sym];
>  	Elf_Sym *sym = (void *)symsec->sh_addr;
>  	unsigned long secbase;
>  	unsigned int i;
> -	int ret = 0;
> +	bool ret = true;
>  	const struct kernel_symbol *ksym;
>  
>  	for (i = 1; i < symsec->sh_size / sizeof(Elf_Sym); i++) {
> @@ -1976,7 +1980,8 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>  			pr_debug("Common symbol: %s\n", name);
>  			printk("%s: please compile with -fno-common\n",
>  			       mod->name);
> -			ret = -ENOEXEC;
> +			/* Mark return result and continue looping */
> +			ret = false;
>  			break;
>  
>  		case SHN_ABS:
> @@ -1999,7 +2004,8 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>  
>  			printk(KERN_WARNING "%s: Unknown symbol %s (err %li)\n",
>  			       mod->name, name, PTR_ERR(ksym));
> -			ret = PTR_ERR(ksym) ?: -ENOENT;
> +			/* Mark return result and continue looping */
> +			ret = false;
>  			break;
>  
>  		default:
> @@ -3267,8 +3273,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  	setup_modinfo(mod, info);
>  
>  	/* Fix up syms, so that st_value is a pointer to location. */
> -	err = simplify_symbols(mod, info);
> -	if (err < 0)
> +	if (!simplify_symbols(mod, info))
>  		goto free_modinfo;
>  
>  	err = apply_relocations(mod, info);
> 


-- 
Chen Gang

Asianux Corporation

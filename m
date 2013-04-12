Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3DLJtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 05:49:17 -0400
Received: from intranet.asianux.com ([58.214.24.6]:38181 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab3DLJtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 05:49:16 -0400
X-Spam-Score: -100.8
Message-ID: <5167D879.8030808@asianux.com>
Date: Fri, 12 Apr 2013 17:48:41 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel: kallsyms: memory override issue, need check
 destination buffer length
References: <51662AC7.1090004@asianux.com> <87eheh4sls.fsf@rustcorp.com.au> <51664B04.7000207@asianux.com>
In-Reply-To: <51664B04.7000207@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rusty Russell:

  please help to review this patch whether is OK, when you have time.

  thanks.

gchen.

On 2013年04月11日 13:32, Chen Gang wrote:
> 
>   We don't export any symbols > 128 characters, but if we did then
>   kallsyms_expand_symbol() would overflow the buffer handed to it.
>   So we need check destination buffer length when copying.
> 
>   the related test:
>     if we define an EXPORT function which name more than 128.
>     will panic when call kallsyms_lookup_name by init_kprobes on booting.
>     after check the length (provide this patch), it is ok.
> 
>   Implementaion:
>     add additional destination buffer length parameter (maxlen)
>     if uncompressed string is too long (>= maxlen), it will be truncated.
>     not check the parameters whether valid, since it is a static function.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/kallsyms.c |   26 ++++++++++++++++++--------
>  1 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 2169fee..43d8150 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -84,9 +84,11 @@ static int is_ksym_addr(unsigned long addr)
>  
>  /*
>   * Expand a compressed symbol data into the resulting uncompressed string,
> + * if uncompressed string is too long (>= maxlen), it will be truncated,
>   * given the offset to where the symbol is in the compressed stream.
>   */
> -static unsigned int kallsyms_expand_symbol(unsigned int off, char *result)
> +static unsigned int kallsyms_expand_symbol(unsigned int off,
> +					   char *result, size_t maxlen)
>  {
>  	int len, skipped_first = 0;
>  	const u8 *tptr, *data;
> @@ -113,15 +115,20 @@ static unsigned int kallsyms_expand_symbol(unsigned int off, char *result)
>  
>  		while (*tptr) {
>  			if (skipped_first) {
> +				if (maxlen <= 1)
> +					goto tail;
>  				*result = *tptr;
>  				result++;
> +				maxlen--;
>  			} else
>  				skipped_first = 1;
>  			tptr++;
>  		}
>  	}
>  
> -	*result = '\0';
> +tail:
> +	if (maxlen)
> +		*result = '\0';
>  
>  	/* Return to offset to the next symbol. */
>  	return off;
> @@ -176,7 +183,7 @@ unsigned long kallsyms_lookup_name(const char *name)
>  	unsigned int off;
>  
>  	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
> -		off = kallsyms_expand_symbol(off, namebuf);
> +		off = kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
>  
>  		if (strcmp(namebuf, name) == 0)
>  			return kallsyms_addresses[i];
> @@ -195,7 +202,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
>  	int ret;
>  
>  	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
> -		off = kallsyms_expand_symbol(off, namebuf);
> +		off = kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
>  		ret = fn(data, namebuf, NULL, kallsyms_addresses[i]);
>  		if (ret != 0)
>  			return ret;
> @@ -294,7 +301,8 @@ const char *kallsyms_lookup(unsigned long addr,
>  
>  		pos = get_symbol_pos(addr, symbolsize, offset);
>  		/* Grab name */
> -		kallsyms_expand_symbol(get_symbol_offset(pos), namebuf);
> +		kallsyms_expand_symbol(get_symbol_offset(pos),
> +				       namebuf, ARRAY_SIZE(namebuf));
>  		if (modname)
>  			*modname = NULL;
>  		return namebuf;
> @@ -315,7 +323,8 @@ int lookup_symbol_name(unsigned long addr, char *symname)
>  
>  		pos = get_symbol_pos(addr, NULL, NULL);
>  		/* Grab name */
> -		kallsyms_expand_symbol(get_symbol_offset(pos), symname);
> +		kallsyms_expand_symbol(get_symbol_offset(pos),
> +				       symname, ARRAY_SIZE(symname));
>  		return 0;
>  	}
>  	/* See if it's in a module. */
> @@ -333,7 +342,8 @@ int lookup_symbol_attrs(unsigned long addr, unsigned long *size,
>  
>  		pos = get_symbol_pos(addr, size, offset);
>  		/* Grab name */
> -		kallsyms_expand_symbol(get_symbol_offset(pos), name);
> +		kallsyms_expand_symbol(get_symbol_offset(pos),
> +				       name, ARRAY_SIZE(name));
>  		modname[0] = '\0';
>  		return 0;
>  	}
> @@ -463,7 +473,7 @@ static unsigned long get_ksymbol_core(struct kallsym_iter *iter)
>  
>  	iter->type = kallsyms_get_symbol_type(off);
>  
> -	off = kallsyms_expand_symbol(off, iter->name);
> +	off = kallsyms_expand_symbol(off, iter->name, ARRAY_SIZE(iter->name));
>  
>  	return off - iter->nameoff;
>  }
> 


-- 
Chen Gang

Asianux Corporation

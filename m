Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbbASTVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 14:21:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbbASTVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 14:21:04 -0500
Date: Mon, 19 Jan 2015 20:19:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Prarit Bhargava <prarit@redhat.com>, Fabian Frederick <fabf@skynet.be>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] init/main.c: Simplify initcall_blacklisted()
Message-ID: <20150119191924.GA19153@redhat.com>
References: <1421454312-30505-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421454312-30505-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17, Rasmus Villemoes wrote:
>
> Using kasprintf to get the function name makes us look up the name
> twice, along with all the vsnprintf overhead of parsing the format
> string etc. It also means there is an allocation failure case to deal
> with. Since symbol_string in vsprintf.c would anyway allocate an array
> of size KSYM_SYMBOL_LEN on the stack, that might as well be done up
> here.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
> 
> Notes:
>     I don't know how expensive it is to do the symbol lookup for each
>     initcall. It might be worthwhile adding an
>     
>       if (list_empty(&blacklisted_initcalls))
>         return false;
>     
>     at the very beginning of initcall_blacklisted(), since this is a debug
>     feature and the blacklist is indeed usually empty.

If we want to optimize this... I am wondering if we can change
initcall_blacklist()

	-	entry->buf = alloc_bootmem(strlen(str_entry) + 1);
	+	ebtry->fn = kallsyms_lookup_name(str_entry);

and then change initcall_blacklisted() to just compare the pointers.

Oleg.

>  init/main.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index 61b993767db5..286602b677de 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -733,22 +733,18 @@ static bool __init_or_module initcall_blacklisted(initcall_t fn)
>  {
>  	struct list_head *tmp;
>  	struct blacklist_entry *entry;
> -	char *fn_name;
> +	char fn_name[KSYM_SYMBOL_LEN];
>  
> -	fn_name = kasprintf(GFP_KERNEL, "%pf", fn);
> -	if (!fn_name)
> -		return false;
> +	sprint_symbol_no_offset(fn_name, (unsigned long)fn);
>  
>  	list_for_each(tmp, &blacklisted_initcalls) {
>  		entry = list_entry(tmp, struct blacklist_entry, next);
>  		if (!strcmp(fn_name, entry->buf)) {
>  			pr_debug("initcall %s blacklisted\n", fn_name);
> -			kfree(fn_name);
>  			return true;
>  		}
>  	}
>  
> -	kfree(fn_name);
>  	return false;
>  }
>  #else
> -- 
> 2.1.3
> 


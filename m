Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbaGVMkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:40:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:24959 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750893AbaGVMks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:40:48 -0400
Date: Tue, 22 Jul 2014 08:40:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jiri Slaby <jslaby@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] module: add within_module() function
Message-ID: <20140722084046.13355492@gandalf.local.home>
In-Reply-To: <1406032090-16151-2-git-send-email-pmladek@suse.cz>
References: <1406032090-16151-1-git-send-email-pmladek@suse.cz>
	<1406032090-16151-2-git-send-email-pmladek@suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014 14:28:09 +0200
Petr Mladek <pmladek@suse.cz> wrote:

> It is just a small optimization that allows to replace few
> occurrences of within_module_init() || within_module_core()
> with a single call.

This looks like a nice clean up. Rusty, what do you think?

-- Steve

> 
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---
>  include/linux/module.h |  5 +++++
>  kernel/module.c        | 12 ++++--------
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index f520a767c86c..61d8fb2d0873 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -408,6 +408,11 @@ static inline int within_module_init(unsigned long addr, const struct module *mo
>  	       addr < (unsigned long)mod->module_init + mod->init_size;
>  }
>  
> +static inline int within_module(unsigned long addr, const struct module *mod)
> +{
> +	return within_module_init(addr, mod) || within_module_core(addr, mod);
> +}
> +
>  /* Search for module by name: must hold module_mutex. */
>  struct module *find_module(const char *name);
>  
> diff --git a/kernel/module.c b/kernel/module.c
> index ae79ce615cb9..be0e479ccb5c 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3444,8 +3444,7 @@ const char *module_address_lookup(unsigned long addr,
>  	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (mod->state == MODULE_STATE_UNFORMED)
>  			continue;
> -		if (within_module_init(addr, mod) ||
> -		    within_module_core(addr, mod)) {
> +		if (within_module(addr, mod)) {
>  			if (modname)
>  				*modname = mod->name;
>  			ret = get_ksymbol(mod, addr, size, offset);
> @@ -3469,8 +3468,7 @@ int lookup_module_symbol_name(unsigned long addr, char *symname)
>  	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (mod->state == MODULE_STATE_UNFORMED)
>  			continue;
> -		if (within_module_init(addr, mod) ||
> -		    within_module_core(addr, mod)) {
> +		if (within_module(addr, mod)) {
>  			const char *sym;
>  
>  			sym = get_ksymbol(mod, addr, NULL, NULL);
> @@ -3495,8 +3493,7 @@ int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
>  	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (mod->state == MODULE_STATE_UNFORMED)
>  			continue;
> -		if (within_module_init(addr, mod) ||
> -		    within_module_core(addr, mod)) {
> +		if (within_module(addr, mod)) {
>  			const char *sym;
>  
>  			sym = get_ksymbol(mod, addr, size, offset);
> @@ -3760,8 +3757,7 @@ struct module *__module_address(unsigned long addr)
>  	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (mod->state == MODULE_STATE_UNFORMED)
>  			continue;
> -		if (within_module_core(addr, mod)
> -		    || within_module_init(addr, mod))
> +		if (within_module(addr, mod))
>  			return mod;
>  	}
>  	return NULL;


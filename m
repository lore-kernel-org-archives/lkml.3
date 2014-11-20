Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbaKTNWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:22:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbaKTNWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:22:33 -0500
Date: Thu, 20 Nov 2014 14:22:38 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/3] kernel: add support for live patching
In-Reply-To: <20141119203430.GA12517@cerebellum.variantweb.net>
Message-ID: <alpine.LNX.2.00.1411201414140.21690@pobox.suse.cz>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com> <1416187764-3341-3-git-send-email-sjenning@redhat.com> <alpine.LNX.2.00.1411181540580.1117@pobox.suse.cz> <20141119203430.GA12517@cerebellum.variantweb.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Seth Jennings wrote:

> On Tue, Nov 18, 2014 at 03:45:22PM +0100, Miroslav Benes wrote:
> > 
> > On Sun, 16 Nov 2014, Seth Jennings wrote:
> > 
> > [...]
> > 
> > > diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> > > new file mode 100644
> > > index 0000000..8b68fef
> > > --- /dev/null
> > > +++ b/include/linux/livepatch.h
> > > @@ -0,0 +1,68 @@
> > > +/*
> > > + * livepatch.h - Live Kernel Patching Core
> > > + *
> > > + * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > + * modify it under the terms of the GNU General Public License
> > > + * as published by the Free Software Foundation; either version 2
> > > + * of the License, or (at your option) any later version.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + *
> > > + * You should have received a copy of the GNU General Public License
> > > + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> > > + */
> > > +
> > > +#ifndef _LINUX_LIVEPATCH_H_
> > > +#define _LINUX_LIVEPATCH_H_
> > > +
> > > +#include <linux/module.h>
> > > +
> > 
> > I think we need something like 
> > 
> > #if IS_ENABLED(CONFIG_LIVE_PATCHING)
> > 
> > here. Otherwise kernel module with live patch itself would be built 
> > even with live patching support disabled (as the structures and needed 
> > functions are declared).
> 
> What do you think of this (already includes s/lp/klp/ change)?
> 
> ====
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 0143b73..a9821f3 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -21,6 +21,7 @@
>  #define _LINUX_LIVEPATCH_H_
>  
>  #include <linux/module.h>
> +#include <asm/livepatch.h>
>  
>  /* TODO: add kernel-doc for structures once agreed upon */
>  
> @@ -58,11 +59,20 @@ struct klp_patch {
>         struct klp_object *objs;
>  };
>  
> -int klp_register_patch(struct klp_patch *);
> -int klp_unregister_patch(struct klp_patch *);
> -int klp_enable_patch(struct klp_patch *);
> -int klp_disable_patch(struct klp_patch *);
> +#ifdef CONFIG_LIVE_PATCHING
>  
> -#include <asm/livepatch.h>
> +extern int klp_register_patch(struct klp_patch *);
> +extern int klp_unregister_patch(struct klp_patch *);
> +extern int klp_enable_patch(struct klp_patch *);
> +extern int klp_disable_patch(struct klp_patch *);
> +
> +#else /* !CONFIG_LIVE_PATCHING */
> +
> +static int klp_register_patch(struct klp_patch *k) { return -ENOSYS; }
> +static int klp_unregister_patch(struct klp_patch *k) { return -ENOSYS; }
> +static int klp_enable_patch(struct klp_patch *k) { return -ENOSYS; }
> +static int klp_disable_patch(struct klp_patch *k) { return -ENOSYS; }
> +
> +#endif
> ====
> 
> This seems to be the way many headers handle this.  Patch modules built
> against a kernel that doesn't support live patching will build cleanly,
> but will always fail to load.
> 
> Seth

Hm, I would still vote for build failure. I think it doesn't make sense to 
build patch module against a kernel that doesn't support live patching and 
it is better to let the user know (and not potentially someone else who 
would load it and fail). Afaik the other headers handle it your way 
because otherwise the code would be spoiled by #ifdefs in .c files. 
However I think that our case is a bit different.

Anyway it is better to use #if (IS_ENABLED(CONFIG_LIVE_PATCHING)) than 
simple #ifdef (see Documentation/CodingStyle) and make the functions 
static inlined for !CONFIG_LIVE_PATCHING case.

Mira

> > 
> > > +/* TODO: add kernel-doc for structures once agreed upon */
> > > +
> > > +struct lp_func {
> > > +	const char *old_name; /* function to be patched */
> > > +	void *new_func; /* replacement function in patch module */
> > > +	/*
> > > +	 * The old_addr field is optional and can be used to resolve
> > > +	 * duplicate symbol names in the vmlinux object.  If this
> > > +	 * information is not present, the symbol is located by name
> > > +	 * with kallsyms. If the name is not unique and old_addr is
> > > +	 * not provided, the patch application fails as there is no
> > > +	 * way to resolve the ambiguity.
> > > +	 */
> > > +	unsigned long old_addr;
> > > +};
> > > +
> > > +struct lp_reloc {
> > > +	unsigned long dest;
> > > +	unsigned long src;
> > > +	unsigned long type;
> > > +	const char *name;
> > > +	int addend;
> > > +	int external;
> > > +};
> > > +
> > > +struct lp_object {
> > > +	const char *name; /* "vmlinux" or module name */
> > > +	struct lp_func *funcs;
> > > +	struct lp_reloc *relocs;
> > > +};
> > > +
> > > +struct lp_patch {
> > > +	struct module *mod; /* module containing the patch */
> > > +	struct lp_object *objs;
> > > +};
> > > +
> > > +int lp_register_patch(struct lp_patch *);
> > > +int lp_unregister_patch(struct lp_patch *);
> > > +int lp_enable_patch(struct lp_patch *);
> > > +int lp_disable_patch(struct lp_patch *);
> > > +
> > > +#include <asm/livepatch.h>
> > 
> > and #endif for CONFIG_LIVE_PATCHING here.
> > 
> > > +
> > > +#endif /* _LINUX_LIVEPATCH_H_ */
> > 
> > Thanks,
> > --
> > Miroslav Benes
> > SUSE Labs
> 

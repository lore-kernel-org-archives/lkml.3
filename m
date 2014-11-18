Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbaKROpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:45:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58598 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125AbaKROpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:45:19 -0500
Date: Tue, 18 Nov 2014 15:45:22 +0100 (CET)
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
In-Reply-To: <1416187764-3341-3-git-send-email-sjenning@redhat.com>
Message-ID: <alpine.LNX.2.00.1411181540580.1117@pobox.suse.cz>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com> <1416187764-3341-3-git-send-email-sjenning@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 16 Nov 2014, Seth Jennings wrote:

[...]

> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> new file mode 100644
> index 0000000..8b68fef
> --- /dev/null
> +++ b/include/linux/livepatch.h
> @@ -0,0 +1,68 @@
> +/*
> + * livepatch.h - Live Kernel Patching Core
> + *
> + * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef _LINUX_LIVEPATCH_H_
> +#define _LINUX_LIVEPATCH_H_
> +
> +#include <linux/module.h>
> +

I think we need something like 

#if IS_ENABLED(CONFIG_LIVE_PATCHING)

here. Otherwise kernel module with live patch itself would be built 
even with live patching support disabled (as the structures and needed 
functions are declared).

> +/* TODO: add kernel-doc for structures once agreed upon */
> +
> +struct lp_func {
> +	const char *old_name; /* function to be patched */
> +	void *new_func; /* replacement function in patch module */
> +	/*
> +	 * The old_addr field is optional and can be used to resolve
> +	 * duplicate symbol names in the vmlinux object.  If this
> +	 * information is not present, the symbol is located by name
> +	 * with kallsyms. If the name is not unique and old_addr is
> +	 * not provided, the patch application fails as there is no
> +	 * way to resolve the ambiguity.
> +	 */
> +	unsigned long old_addr;
> +};
> +
> +struct lp_reloc {
> +	unsigned long dest;
> +	unsigned long src;
> +	unsigned long type;
> +	const char *name;
> +	int addend;
> +	int external;
> +};
> +
> +struct lp_object {
> +	const char *name; /* "vmlinux" or module name */
> +	struct lp_func *funcs;
> +	struct lp_reloc *relocs;
> +};
> +
> +struct lp_patch {
> +	struct module *mod; /* module containing the patch */
> +	struct lp_object *objs;
> +};
> +
> +int lp_register_patch(struct lp_patch *);
> +int lp_unregister_patch(struct lp_patch *);
> +int lp_enable_patch(struct lp_patch *);
> +int lp_disable_patch(struct lp_patch *);
> +
> +#include <asm/livepatch.h>

and #endif for CONFIG_LIVE_PATCHING here.

> +
> +#endif /* _LINUX_LIVEPATCH_H_ */

Thanks,
--
Miroslav Benes
SUSE Labs

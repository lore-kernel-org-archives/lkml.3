Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106AbaKZJFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 04:05:45 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38392 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaKZJFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 04:05:41 -0500
Message-ID: <547597DB.5070602@hitachi.com>
Date: Wed, 26 Nov 2014 18:05:31 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 2/3] kernel: add support for live patching
References: <1416935709-404-1-git-send-email-sjenning@redhat.com> <1416935709-404-3-git-send-email-sjenning@redhat.com>
In-Reply-To: <1416935709-404-3-git-send-email-sjenning@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/26 2:15), Seth Jennings wrote:
> This commit introduces code for the live patching core.  It implements
> an ftrace-based mechanism and kernel interface for doing live patching
> of kernel and kernel module functions.
> 
> It represents the greatest common functionality set between kpatch and
> kgraft and can accept patches built using either method.
> 
> This first version does not implement any consistency mechanism that
> ensures that old and new code do not run together.  In practice, ~90% of
> CVEs are safe to apply in this way, since they simply add a conditional
> check.  However, any function change that can not execute safely with
> the old version of the function can _not_ be safely applied in this
> version.

Thank you for updating the patch :)

[...]

> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> new file mode 100644
> index 0000000..4e01b59
> --- /dev/null
> +++ b/include/linux/livepatch.h
> @@ -0,0 +1,121 @@
> +/*
> + * livepatch.h - Kernel Live Patching Core
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
> +#include <linux/ftrace.h>
> +
> +#if IS_ENABLED(CONFIG_LIVE_PATCHING)
> +
> +#include <asm/livepatch.h>
> +
> +enum klp_state {
> +	KLP_DISABLED,
> +	KLP_ENABLED
> +};
> +
> +/**
> + * struct klp_func - function structure for live patching
> + * @old_name:	name of the function to be patched
> + * @new_func:	pointer to the patched function code
> + * @old_addr:	a hint conveying at what address the old function
> + *		can be found (optional, vmlinux patches only)
> + */
> +struct klp_func {
> +	/* external */
> +	const char *old_name;
> +	void *new_func;
> +	/*
> +	 * The old_addr field is optional and can be used to resolve
> +	 * duplicate symbol names in the vmlinux object.  If this
> +	 * information is not present, the symbol is located by name
> +	 * with kallsyms. If the name is not unique and old_addr is
> +	 * not provided, the patch application fails as there is no
> +	 * way to resolve the ambiguity.
> +	 */
> +	unsigned long old_addr;
> +
> +	/* internal */
> +	struct kobject kobj;
> +	struct ftrace_ops *fops;
> +	enum klp_state state;
> +};
> +
> +/**
> + * struct klp_reloc - relocation structure for live patching
> + * @dest	address where the relocation will be written
> + * @src		address of the referenced symbol (optional,
> + *		vmlinux	patches only)
> + * @type	ELF relocation type
> + * @name	name of the referenced symbol (for lookup/verification)
> + * @addend	offset from the referenced symbol
> + * @external	symbol is either exported or within the	live patch module itself
> + */
> +struct klp_reloc {
> +	unsigned long dest;
> +	unsigned long src;
> +	unsigned long type;
> +	const char *name;
> +	int addend;

BTW, where would the "addend" come from? I guess we can use "offset" instead.

> +	int external;
> +};
> +
> +/* struct klp_object - kernel object structure for live patching
> + * @name	module name (or NULL for vmlinux)
> + * @relocs	relocation entries to be applied at load time
> + * @funcs	function entries for functions to be patched in the object
> + */
> +struct klp_object {
> +	/* external */
> +	const char *name;
> +	struct klp_reloc *relocs;
> +	struct klp_func *funcs;
> +
> +	/* internal */
> +	struct kobject *kobj;
> +	struct module *mod;
> +	enum klp_state state;
> +};
> +
> +/**
> + * struct klp_patch - patch structure for live patching
> + * @mod		reference to the live patch module
> + * @objs	object entries for kernel objects to be patched
> + */
> +struct klp_patch {
> +	/* external */
> +	struct module *mod;
> +	struct klp_object *objs;
> +
> +	/* internal */
> +	struct list_head list;
> +	struct kobject kobj;
> +	enum klp_state state;
> +};
> +
> +extern int klp_register_patch(struct klp_patch *);
> +extern int klp_unregister_patch(struct klp_patch *);
> +extern int klp_enable_patch(struct klp_patch *);
> +extern int klp_disable_patch(struct klp_patch *);
> +
> +#endif /* CONFIG_LIVE_PATCHING */
> +
> +#endif /* _LINUX_LIVEPATCH_H_ */
> diff --git a/kernel/Makefile b/kernel/Makefile
> index a59481a..616994f 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -26,6 +26,7 @@ obj-y += power/
>  obj-y += printk/
>  obj-y += irq/
>  obj-y += rcu/
> +obj-y += livepatch/
>  
>  obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
>  obj-$(CONFIG_FREEZER) += freezer.o
> diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
> new file mode 100644
> index 0000000..96da00f
> --- /dev/null
> +++ b/kernel/livepatch/Kconfig
> @@ -0,0 +1,18 @@
> +config ARCH_HAVE_LIVE_PATCHING
> +	boolean
> +	help
> +	  Arch supports kernel live patching
> +
> +config LIVE_PATCHING
> +	boolean "Kernel Live Patching"
> +	depends on DYNAMIC_FTRACE_WITH_REGS
> +	depends on MODULES
> +	depends on SYSFS
> +	depends on KALLSYMS_ALL
> +	depends on ARCH_HAVE_LIVE_PATCHING
> +	help
> +	  Say Y here if you want to support kernel live patching.
> +	  This option has no runtime impact until a kernel "patch"
> +	  module uses the interface provided by this option to register
> +	  a patch, causing calls to patched functions to be redirected
> +	  to new function code contained in the patch module.
> diff --git a/kernel/livepatch/Makefile b/kernel/livepatch/Makefile

BTW, until establishing the consistency models and engines, this would
better depend on EXPERIMENTAL flag :)

Thank you,



-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



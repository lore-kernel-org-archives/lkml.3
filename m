Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbaKURyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:54:09 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:35421 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaKURyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:54:07 -0500
MIME-Version: 1.0
In-Reply-To: <20141121164027.GB11339@cerebellum.variantweb.net>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com>
 <1416522580-5593-3-git-send-email-sjenning@redhat.com> <alpine.LNX.2.00.1411210102280.23174@pobox.suse.cz>
 <20141121164027.GB11339@cerebellum.variantweb.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 21 Nov 2014 09:53:44 -0800
Message-ID: <CALCETrXXGZ2bcT699ts5N+qeO80kh4-poZ800-Y6Rc_4+D6VtQ@mail.gmail.com>
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
To: Seth Jennings <sjenning@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, X86 ML <x86@kernel.org>,
        kpatch@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 8:40 AM, Seth Jennings <sjenning@redhat.com> wrote:
> On Fri, Nov 21, 2014 at 01:22:33AM +0100, Jiri Kosina wrote:
>> On Thu, 20 Nov 2014, Seth Jennings wrote:
>>
>> > This commit introduces code for the live patching core.  It implements
>> > an ftrace-based mechanism and kernel interface for doing live patching
>> > of kernel and kernel module functions.
>> >
>> > It represents the greatest common functionality set between kpatch and
>> > kgraft and can accept patches built using either method.
>> >
>> > This first version does not implement any consistency mechanism that
>> > ensures that old and new code do not run together.  In practice, ~90% of
>> > CVEs are safe to apply in this way, since they simply add a conditional
>> > check.  However, any function change that can not execute safely with
>> > the old version of the function can _not_ be safely applied in this
>> > version.
>> >
>> > Signed-off-by: Seth Jennings <sjenning@redhat.com>
>>
>> I think this is getting really close, which is awesome. A few rather minor
>> nits below.
>>
>> [ ... snip ... ]
>> > diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
>> > new file mode 100644
>> > index 0000000..2ed86ec
>> > --- /dev/null
>> > +++ b/arch/x86/include/asm/livepatch.h
>> > @@ -0,0 +1,37 @@
>> > +/*
>> > + * livepatch.h - x86-specific Kernel Live Patching Core
>> > + *
>> > + * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
>> > + *
>> > + * This program is free software; you can redistribute it and/or
>> > + * modify it under the terms of the GNU General Public License
>> > + * as published by the Free Software Foundation; either version 2
>> > + * of the License, or (at your option) any later version.
>> > + *
>> > + * This program is distributed in the hope that it will be useful,
>> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> > + * GNU General Public License for more details.
>> > + *
>> > + * You should have received a copy of the GNU General Public License
>> > + * along with this program; if not, see <http://www.gnu.org/licenses/>.
>> > + */
>> > +
>> > +#ifndef _ASM_X86_LIVEPATCH_H
>> > +#define _ASM_X86_LIVEPATCH_H
>> > +
>> > +#include <linux/module.h>
>> > +
>> > +#ifdef CONFIG_LIVE_PATCHING
>> > +extern int klp_write_module_reloc(struct module *mod, unsigned long type,
>> > +                             unsigned long loc, unsigned long value);
>> > +
>> > +#else
>> > +static int klp_write_module_reloc(struct module *mod, unsigned long type,
>>
>> static inline?
>
> I think the practice is to let the compiler handle inline determination
> unless you are sure that the compiler isn't inlining something you think
> it should.
>

It has to be static inline in a header, right?  Otherwise, in theory,
the header could generate code, and that's no good.  (The compiler
should optimize it out, but still.)

--Andy

> All other changes are accepted and queued for v4.
>
> Thanks,
> Seth
>
>>
>> [ ... snip ... ]
>> > --- /dev/null
>> > +++ b/kernel/livepatch/Kconfig
>> > @@ -0,0 +1,18 @@
>> > +config ARCH_HAVE_LIVE_PATCHING
>> > +   boolean
>> > +   help
>> > +     Arch supports kernel live patching
>> > +
>> > +config LIVE_PATCHING
>> > +   boolean "Kernel Live Patching"
>> > +   depends on DYNAMIC_FTRACE_WITH_REGS
>> > +   depends on MODULES
>> > +   depends on SYSFS
>> > +   depends on KALLSYMS_ALL
>> > +   depends on ARCH_HAVE_LIVE_PATCHING
>>
>> We have to refuse to build on x86_64 if the compiler doesn't support
>> fentry. mcount is not really usable (well, it would be possible to use it,
>> be the obstacles are too big to care).
>>
>> Something like [1] should be applicable here as well I believe.
>>
>> [1] https://git.kernel.org/cgit/linux/kernel/git/jirislaby/kgraft.git/commit/?h=kgraft&id=bd4bc097c72937d18036f1312a4d79ed0bea9991
>>
>> [ ... snip ... ]
>> > --- /dev/null
>> > +++ b/kernel/livepatch/core.c
>> > @@ -0,0 +1,828 @@
>> > +/*
>> > + * core.c - Kernel Live Patching Core
>> > + *
>> > + * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
>> > + *
>> > + * This program is free software; you can redistribute it and/or
>> > + * modify it under the terms of the GNU General Public License
>> > + * as published by the Free Software Foundation; either version 2
>> > + * of the License, or (at your option) any later version.
>> > + *
>> > + * This program is distributed in the hope that it will be useful,
>> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> > + * GNU General Public License for more details.
>> > + *
>> > + * You should have received a copy of the GNU General Public License
>> > + * along with this program; if not, see <http://www.gnu.org/licenses/>.
>> > + */
>> > +
>> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> > +
>> > +#include <linux/module.h>
>> > +#include <linux/kernel.h>
>> > +#include <linux/mutex.h>
>> > +#include <linux/slab.h>
>> > +#include <linux/ftrace.h>
>> > +#include <linux/list.h>
>> > +#include <linux/kallsyms.h>
>> > +#include <linux/livepatch.h>
>> > +
>> > +/*************************************
>> > + * Core structures
>> > + ************************************/
>>
>> I don't personally find such markers (especially with all the '*'s) too
>> tasteful, and I don't recall ever seeing this being common pattern used in
>> the kernel code ... ?
>>
>> > +static DEFINE_MUTEX(klp_mutex);
>> > +static LIST_HEAD(klp_patches);
>> > +
>> > +/*******************************************
>> > + * Helpers
>> > + *******************************************/
>> > +
>> > +/* sets obj->mod if object is not vmlinux and module is found */
>> > +static bool klp_find_object_module(struct klp_object *obj)
>> > +{
>> > +   if (!strcmp(obj->name, "vmlinux"))
>> > +           return 1;
>>
>> Rather a matter of taste again -- I personally would prefer "obj->name ==
>> NULL" to be the condition identifying core kernel code text. You can't
>> really forbid any lunetic out there calling his kernel module "vmlinux",
>> right? :)
>>
>> [ ... snip ... ]
>>
>> > +/***********************************
>> > + * ftrace registration
>> > + **********************************/
>> > +
>> > +static void klp_ftrace_handler(unsigned long ip, unsigned long parent_ip,
>> > +                          struct ftrace_ops *ops, struct pt_regs *regs)
>> > +{
>> > +   struct klp_func *func = ops->private;
>> > +
>> > +   regs->ip = (unsigned long)func->new_func;
>> > +}
>> > +
>> > +static int klp_enable_func(struct klp_func *func)
>> > +{
>> > +   int ret;
>> > +
>> > +   if (WARN_ON(!func->old_addr || func->state != LPC_DISABLED))
>> > +           return -EINVAL;
>>
>> If the WARN_ON triggers, there is no good way to find out which of the two
>> conditions triggered it.
>>
>> [ ... snip ... ]
>> > +static int klp_init_patch(struct klp_patch *patch)
>> > +{
>> > +   int ret;
>> > +
>> > +   mutex_lock(&klp_mutex);
>> > +
>> > +   /* init */
>> > +   patch->state = LPC_DISABLED;
>> > +
>> > +   /* sysfs */
>> > +   ret = kobject_init_and_add(&patch->kobj, &klp_ktype_patch,
>> > +                              klp_root_kobj, patch->mod->name);
>> > +   if (ret)
>> > +           return ret;
>>
>> klp_mutex is leaked locked here.
>>
>> > +
>> > +   /* create objects */
>> > +   ret = klp_init_objects(patch);
>> > +   if (ret) {
>> > +           kobject_put(&patch->kobj);
>> > +           return ret;
>>
>> And here as well.
>>
>> All in all, this is looking very good to me. I think we are really close
>> to having a code that all the parties would agree with. Thanks everybody,
>>
>> --
>> Jiri Kosina
>> SUSE Labs



-- 
Andy Lutomirski
AMA Capital Management, LLC

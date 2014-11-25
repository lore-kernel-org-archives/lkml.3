Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaKYQjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:39:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45616 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaKYQjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:39:43 -0500
Date: Tue, 25 Nov 2014 17:39:43 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/3] kernel: add support for live patching
Message-ID: <20141125163942.GD22487@pathway.suse.cz>
References: <1416522580-5593-1-git-send-email-sjenning@redhat.com>
 <1416522580-5593-3-git-send-email-sjenning@redhat.com>
 <546EA5DC.6000207@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546EA5DC.6000207@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-21 11:39:24, Masami Hiramatsu wrote:
> (2014/11/21 7:29), Seth Jennings wrote:
> > This commit introduces code for the live patching core.  It implements
> > an ftrace-based mechanism and kernel interface for doing live patching
> > of kernel and kernel module functions.
> > 
> > It represents the greatest common functionality set between kpatch and
> > kgraft and can accept patches built using either method.
> > 
> > This first version does not implement any consistency mechanism that
> > ensures that old and new code do not run together.  In practice, ~90% of
> > CVEs are safe to apply in this way, since they simply add a conditional
> > check.  However, any function change that can not execute safely with
> > the old version of the function can _not_ be safely applied in this
> > version.
> 
> Thanks for updating :)
> 
> BTW, this still have some LPC_XXX macros, those should be KLP_XXX.
> 
> Also, as I sent a series of IPMODIFY patches (just now), could you consider
> to use the flag? :)

Hmm, it would cause problems with the current LivePatch, kGraft
implementation, and probably also with kPatch. They register more
than one ftrace handler with IPMODIFY at the same time.

They pass pointer to the func-related structure via the "private" field
in struct ftrace_ops. The structure provides information where the old
and new code is.

They need to update the structure when new patch for the same functions
appears. It is done by registering a new ftrace function related to the
new patch and unregistering an old ftrace function from the old patch.

We would need to maintain some patch-independent list of ftrace_ops
and the related private fields to avoid the double registration.

[...]

> > diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> > new file mode 100644
> > index 0000000..eab84df
> > --- /dev/null
> > +++ b/include/linux/livepatch.h
[...]
> > +struct klp_func {
> > +	/* external */
> > +	const char *old_name; /* function to be patched */
> > +	void *new_func; /* replacement function in patch module */
> > +	/*
> > +	 * The old_addr field is optional and can be used to resolve
> > +	 * duplicate symbol names in the vmlinux object.  If this
> > +	 * information is not present, the symbol is located by name
> > +	 * with kallsyms. If the name is not unique and old_addr is
> > +	 * not provided, the patch application fails as there is no
> > +	 * way to resolve the ambiguity.
> > +	 */
> > +	unsigned long old_addr;
> > +
> > +	/* internal */
> > +	struct kobject *kobj;
> > +	struct ftrace_ops fops;
> > +	enum klp_state state;
> > +};

This is the func-related struct in LivePatch.

> > +
> > +struct klp_reloc {
> > +	unsigned long dest;
> > +	unsigned long src;
> > +	unsigned long type;
> > +	const char *name;
> > +	int addend;
> > +	int external;
> > +};
> > +
> > +struct klp_object {
> > +	/* external */
> > +	const char *name; /* "vmlinux" or module name */
> > +	struct klp_reloc *relocs;
> > +	struct klp_func *funcs;
> > +
> > +	/* internal */
> > +	struct kobject *kobj;
> > +	struct module *mod; /* module associated with object */
> > +	enum klp_state state;
> > +};
> > +
> > +struct klp_patch {
> > +	/* external */
> > +	struct module *mod; /* module containing the patch */
> > +	struct klp_object *objs;
> > +
> > +	/* internal */
> > +	struct list_head list;
> > +	struct kobject kobj;
> > +	enum klp_state state;
> > +};
> > +
[...]
> > --- /dev/null
> > +++ b/kernel/livepatch/core.c
[...]
> > +/***********************************
> > + * ftrace registration
> > + **********************************/
> > +
> > +static void klp_ftrace_handler(unsigned long ip, unsigned long parent_ip,
> > +			       struct ftrace_ops *ops, struct pt_regs *regs)
> > +{
> > +	struct klp_func *func = ops->private;
> > +
> > +	regs->ip = (unsigned long)func->new_func;
> > +}
> > +
> > +static int klp_enable_func(struct klp_func *func)
> > +{
> > +	int ret;
> > +
> > +	if (WARN_ON(!func->old_addr || func->state != LPC_DISABLED))
> > +		return -EINVAL;
> > +
> > +	ret = ftrace_set_filter_ip(&func->fops, func->old_addr, 0, 0);
> > +	if (ret) {
> > +		pr_err("failed to set ftrace filter for function '%s' (%d)\n",
> > +		       func->old_name, ret);
> > +		return ret;
> > +	}
> > +	ret = register_ftrace_function(&func->fops);
> > +	if (ret) {
> > +		pr_err("failed to register ftrace handler for function '%s' (%d)\n",
> > +		       func->old_name, ret);
> > +		ftrace_set_filter_ip(&func->fops, func->old_addr, 1, 0);
> > +	} else
> > +		func->state = LPC_ENABLED;
> > +
> > +	return ret;
> > +}

This is the sample of registration. Please, see that it is function-
and patch-specific.

> > +static int klp_disable_func(struct klp_func *func)
> > +{
> > +	int ret;
> > +
> > +	if (WARN_ON(func->state != LPC_ENABLED))
> > +		return -EINVAL;
> > +
> > +	if (!func->old_addr)
> > +		/* parent object is not loaded */
> > +		return 0;
> > +	ret = unregister_ftrace_function(&func->fops);
> > +	if (ret) {
> > +		pr_err("failed to unregister ftrace handler for function '%s' (%d)\n",
> > +		       func->old_name, ret);
> > +		return ret;
> > +	}
> > +	ret = ftrace_set_filter_ip(&func->fops, func->old_addr, 1, 0);
> > +	if (ret)
> > +		pr_warn("function unregister succeeded but failed to clear the filter\n");
> > +	func->state = LPC_DISABLED;
> > +
> > +	return 0;
> > +}

[...]

> > +static int klp_init_funcs(struct klp_object *obj)
> > +{
> > +	struct klp_func *func;
> > +	struct ftrace_ops *ops;
> > +
> > +	for (func = obj->funcs; func->old_name; func++) {
> > +		func->state = LPC_DISABLED;
> > +		ops = &func->fops;
> > +		ops->private = func;
> > +		ops->func = klp_ftrace_handler;
> > +		ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_DYNAMIC;
> > +
> > +		/* sysfs */
> > +		func->kobj = kobject_create_and_add(func->old_name, obj->kobj);
> > +		if (!func->kobj)
> > +			goto free;
> > +	}
> > +
> > +	return 0;
> > +free:
> > +	klp_free_funcs_limited(obj, func);
> > +	return -ENOMEM;
> > +}

This shows how the ftrace ops is initialized.


Note that it is even more complicated in kGraft. We use different ftrace
functions for the slow and fast handling. The slow handling needs to
do some checks and decide whether to use the old or new code. The fast
handling just sets regs->ip to the new address. See

	 kgr_stub_fast()
	 kgr_stub_slow()
	 kgr_patch_code()

at
https://git.kernel.org/cgit/linux/kernel/git/jirislaby/kgraft.git/tree/kernel/kgraft.c?h=kgraft&id=00803476a5c51bd281999a0b3e305c4081fccd6b


Best Regards,
Petr

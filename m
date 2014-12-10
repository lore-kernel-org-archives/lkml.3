Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbaLJNuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:50:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41921 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbaLJNuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:50:13 -0500
Date: Wed, 10 Dec 2014 14:50:54 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] livepatch v5: clean up usage of the old and new
 addresses
Message-ID: <20141210135054.GD2454@pathway.suse.cz>
References: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
 <1418148307-21434-7-git-send-email-pmladek@suse.cz>
 <20141209192009.GB3955@treble.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209192009.GB3955@treble.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-12-09 13:20:09, Josh Poimboeuf wrote:
> On Tue, Dec 09, 2014 at 07:05:07PM +0100, Petr Mladek wrote:
> > The situation with variables storing the address of the old and new code
> > is not ideal. One is called "func" and the other is called "addr".
> > The one is pointer and the other is unsigned long. It makes sense
> > from the point of how the values are defined. But it might make problems
> > to understand the code when the values are used.
> >
> > This patch introduces two new variables "old_ip" and "new_ip".
> > They have the same type and the name is symmetric.
> 
> I agree that the naming of addr vs func is a little weird, but I find
> that this patch makes the code more confusing.  Now we have "func",
> "addr" and "ip", all different words meaning "function address".
>
> Adding to the confusion is the existence of four variables instead of
> two.

Yup, I am not super happy about it as well. This is why I made this
change in the last patch, so that it is easier to ignore or rework.

Another solution would be to rename either new_func -> new_addr or
old_addr -> old_func. In this case, they should have the same type.

"unsigned long" is used on most locations, so I would prefer this
type. And it better fits with the *_addr names.

The problem is that it would mean to cast the pointer to the new
function in hand-made patches. But we could hide this under some macro
that would be handy anyway.

Ot we could leave it as is for now. I do not have strong opinion
about it.


> > They are supposed to carry the address of the mcount call-site that
> > ftrace framework operates with. The value is the same as the function
> > address on x86 but it might be different on another architectures.
>
> I didn't know the mcount call site address can differ from the function
> address for some architectures.  Can you give more details about this?

Only fentry is put at the beginning of the functions. The classic
mcount call is put after the function prologue.

AFAIK, fentry is supported only on x86_64. There is another usable
feature on s390x that can be enabled by -mhotpatch gcc option but
we do not use it with kGraft. Vojtech/JiriK told me that the important
code is at the beginning of the function on PPC. But I am pretty
sure that there will be architectures where the code won't be at
the beginning.

The current implementation supports only x86_64. s390 and PPC seems
to be solvable without the shifted address. I am not sure if we
want to make it ready for other architectures or keep is simple for
now.

Note that the _ip suffix was used because it is the name used by
ftrace stuff and the value is mostly used together with ftrace
functions.


> > The change is inspired by kGraft that even adds ftrace_function_to_fentry(),
> > see https://lkml.org/lkml/2014/4/30/688. The function allows to find the right
> > mcount call-site location. This patch uses ftrace_location() that just allows
> > to verify that the address is correct. It means that we detect potential problem
> > already when the patch in being initialized.
> > 
> > Signed-off-by: Petr Mladek <pmladek@suse.cz>
> > ---
> >  include/linux/livepatch.h | 24 ++++++++++++-----------
> >  kernel/livepatch/core.c   | 49 ++++++++++++++++++++++++++++++++++++++---------
> >  2 files changed, 53 insertions(+), 20 deletions(-)
> > 
> > diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> > index b61fe7402f1f..32f82d798c54 100644
> > --- a/include/linux/livepatch.h
> > +++ b/include/linux/livepatch.h
> > @@ -36,8 +36,16 @@ enum klp_state {
> >   * struct klp_func - function structure for live patching
> >   * @old_name:	name of the function to be patched
> >   * @new_func:	pointer to the patched function code
> > - * @old_addr:	a hint conveying at what address the old function
> > - *		can be found (optional, vmlinux patches only)
> > + * @old_addr:	address of the function to be patched; if predefined then
> > + *		the value is used as a hint conveying at what address
> > + *		the old function can be found; otherwise, the value is
> > + *		located by name with kallsyms; the predefined value makes
> > + *		sense only for vmlinux function and when randomization is
> > + *		disabled
> > + * @old_ip:	address of the mcount call-site for the old function;
> > + *		it is the address that ftrace works with
> > + * @new_ip:	address of the mcount call-sire for the new function;
> > + *		it is the address that ftrace works with
> >   * @kobj:	kobject for sysfs resources
> >   * @fops:	ftrace operations structure
> >   * @state:	tracks function-level patch application state
> > @@ -46,15 +54,9 @@ struct klp_func {
> >  	/* external */
> >  	const char *old_name;
> >  	void *new_func;
> > -	/*
> > -	 * The old_addr field is optional and can be used to resolve
> > -	 * duplicate symbol names in the vmlinux object.  If this
> > -	 * information is not present, the symbol is located by name
> > -	 * with kallsyms. If the name is not unique and old_addr is
> > -	 * not provided, the patch application fails as there is no
> > -	 * way to resolve the ambiguity.
> > -	 */
> >  	unsigned long old_addr;
> > +	unsigned long old_ip;
> > +	unsigned long new_ip;
> 
> old_ip and new_ip should be in the /* internal */ section.

Good catch!

Best Regards,
Petr

> >  
> >  	/* internal */
> >  	struct kobject kobj;
> > @@ -88,7 +90,7 @@ struct klp_reloc {
> >   * @funcs:	function entries for functions to be patched in the object
> >   * @kobj:	kobject for sysfs resources
> >   * @mod:	kernel module associated with the patched object
> > - * 		(NULL for vmlinux)
> > + *		(NULL for vmlinux)
> >   * @state:	tracks object-level patch application state
> >   */
> >  struct klp_object {
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index fe312b9ada78..c54230bf17fe 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -179,8 +179,8 @@ static int klp_verify_vmlinux_symbol(const char *name, unsigned long addr)
> >  	return -EINVAL;
> >  }
> >  
> > -static int klp_find_verify_func_addr(struct klp_object *obj,
> > -				     struct klp_func *func)
> > +static int klp_find_verify_func_old_addr(struct klp_object *obj,
> > +					 struct klp_func *func)
> >  {
> >  	int ret;
> >  
> > @@ -205,6 +205,36 @@ static int klp_find_verify_func_addr(struct klp_object *obj,
> >  	return ret;
> >  }
> >  
> > +static int klp_find_verify_func_addresses(struct klp_object *obj,
> > +				     struct klp_func *func)
> > +{
> > +	int ret;
> > +
> > +	ret = klp_find_verify_func_old_addr(obj, func);
> > +	if (ret)
> > +		return ret;
> > +
> > +	func->old_ip = ftrace_location(func->old_addr);
> > +	if (!func->old_ip) {
> > +		pr_err("function '%s' at the address '%lx' can not be patched\n",
> > +		       func->old_name, func->old_addr);
> > +		return -EINVAL;
> > +	}
> > +
> > +	/*
> > +	 * In fact, the new function need not be traceable. This check is
> > +	 * used to make sure that the address is a correct mcount call-site.
> > +	 */
> > +	func->new_ip = ftrace_location((unsigned long)func->new_func);
> > +	if (!func->old_ip) {
> > +		pr_err("function at the address '%p' can not be used for patching\n",
> > +		       func->new_func);
> > +		return -EINVAL;
> > +	}
> 
> Why does the new function need to have an mcount call site?  And why do
> we want to use that address rather than the real function address?
> 
> > +
> > +	return 0;
> > +}
> > +
> >  /*
> >   * external symbols are located outside the parent object (where the parent
> >   * object is either vmlinux or the kmod being patched).
> > @@ -277,7 +307,7 @@ static void notrace klp_ftrace_handler(unsigned long ip,
> >  {
> >  	struct klp_func *func = ops->private;
> >  
> > -	regs->ip = (unsigned long)func->new_func;
> > +	regs->ip = func->new_ip;
> >  }
> >  
> >  static int klp_disable_func(struct klp_func *func)
> > @@ -287,7 +317,7 @@ static int klp_disable_func(struct klp_func *func)
> >  	if (WARN_ON(func->state != KLP_ENABLED))
> >  		return -EINVAL;
> >  
> > -	if (WARN_ON(!func->old_addr))
> > +	if (WARN_ON(!func->old_ip))
> >  		return -EINVAL;
> >  
> >  	ret = unregister_ftrace_function(func->fops);
> > @@ -297,7 +327,7 @@ static int klp_disable_func(struct klp_func *func)
> >  		return ret;
> >  	}
> >  
> > -	ret = ftrace_set_filter_ip(func->fops, func->old_addr, 1, 0);
> > +	ret = ftrace_set_filter_ip(func->fops, func->old_ip, 1, 0);
> >  	if (ret)
> >  		pr_warn("function unregister succeeded but failed to clear the filter\n");
> >  
> > @@ -310,13 +340,13 @@ static int klp_enable_func(struct klp_func *func)
> >  {
> >  	int ret;
> >  
> > -	if (WARN_ON(!func->old_addr))
> > +	if (WARN_ON(!func->old_ip))
> >  		return -EINVAL;
> >  
> >  	if (WARN_ON(func->state != KLP_DISABLED))
> >  		return -EINVAL;
> >  
> > -	ret = ftrace_set_filter_ip(func->fops, func->old_addr, 0, 0);
> > +	ret = ftrace_set_filter_ip(func->fops, func->old_ip, 0, 0);
> >  	if (ret) {
> >  		pr_err("failed to set ftrace filter for function '%s' (%d)\n",
> >  		       func->old_name, ret);
> > @@ -327,7 +357,7 @@ static int klp_enable_func(struct klp_func *func)
> >  	if (ret) {
> >  		pr_err("failed to register ftrace handler for function '%s' (%d)\n",
> >  		       func->old_name, ret);
> > -		ftrace_set_filter_ip(func->fops, func->old_addr, 1, 0);
> > +		ftrace_set_filter_ip(func->fops, func->old_ip, 1, 0);
> >  	} else {
> >  		func->state = KLP_ENABLED;
> >  	}
> > @@ -594,6 +624,7 @@ static struct kobj_type klp_ktype_func = {
> >  static void klp_free_func_loaded(struct klp_func *func)
> >  {
> >  	func->old_addr = 0;
> > +	func->old_ip = 0;
> >  }
> >  
> >  /*
> > @@ -646,7 +677,7 @@ static void klp_free_patch(struct klp_patch *patch)
> >  /* parts of the initialization that is done only when the object is loaded */
> >  static int klp_init_func_loaded(struct klp_object *obj, struct klp_func *func)
> >  {
> > -	return klp_find_verify_func_addr(obj, func);
> > +	return klp_find_verify_func_addresses(obj, func);
> >  }
> >  
> >  static int klp_init_func(struct klp_object *obj, struct klp_func *func)
> > -- 
> > 1.8.5.2
> > 
> 
> -- 
> Josh

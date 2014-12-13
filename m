Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaLMUGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 15:06:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbaLMUGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 15:06:52 -0500
Date: Sat, 13 Dec 2014 14:06:15 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Slaby <jslaby@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 2/3] kernel: add support for live patching
Message-ID: <20141213200615.GA21557@treble.redhat.com>
References: <cover.1418248631.git.jpoimboe@redhat.com>
 <2e40fffcf2fb715c59e84d638bb8519c3837d1a6.1418248631.git.jpoimboe@redhat.com>
 <alpine.LNX.2.00.1412121737280.6587@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1412121737280.6587@pobox.suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 05:58:19PM +0100, Miroslav Benes wrote:
> 
> Hi, 
> 
> I think we are really close (or I hope so). I found few suspicious things 
> or nitpicks though. They might have applied also to v5, but I didn't 
> manage to look at that. Sorry about that.
> 
> On Wed, 10 Dec 2014, Josh Poimboeuf wrote:
> 
> > +/* klp_mutex must be held by caller */
> > +static bool klp_patch_is_registered(struct klp_patch *patch)
> 
> Maybe klp_is_patch_registered is more appropriate name (consistent with 
> other predicates in the file).

Ok.

> > +static int klp_disable_func(struct klp_func *func)
> > +{
> > +	int ret;
> > +
> > +	if (WARN_ON(func->state != KLP_ENABLED))
> > +		return -EINVAL;
> > +
> > +	if (WARN_ON(!func->old_addr))
> > +		return -EINVAL;
> > +
> > +	ret = unregister_ftrace_function(func->fops);
> > +	if (ret) {
> > +		pr_err("failed to unregister ftrace handler for function '%s' (%d)\n",
> > +		       func->old_name, ret);
> > +		return ret;
> > +	}
> > +
> > +	ret = ftrace_set_filter_ip(func->fops, func->old_addr, 1, 0);
> > +	if (ret)
> > +		pr_warn("function unregister succeeded but failed to clear the filter\n");
> > +
> > +	func->state = KLP_DISABLED;
> > +
> > +	return 0;
> > +}
> > +
> > +static int klp_enable_func(struct klp_func *func)
> > +{
> > +	int ret;
> > +
> > +	if (WARN_ON(!func->old_addr))
> > +		return -EINVAL;
> > +
> > +	if (WARN_ON(func->state != KLP_DISABLED))
> > +		return -EINVAL;
> > +
> > +	ret = ftrace_set_filter_ip(func->fops, func->old_addr, 0, 0);
> > +	if (ret) {
> > +		pr_err("failed to set ftrace filter for function '%s' (%d)\n",
> > +		       func->old_name, ret);
> > +		return ret;
> > +	}
> > +
> > +	ret = register_ftrace_function(func->fops);
> > +	if (ret) {
> > +		pr_err("failed to register ftrace handler for function '%s' (%d)\n",
> > +		       func->old_name, ret);
> > +		ftrace_set_filter_ip(func->fops, func->old_addr, 1, 0);
> > +	} else {
> > +		func->state = KLP_ENABLED;
> > +	}
> > +
> > +	return ret;
> > +}
> 
> Just to be sure about our policy. We want to be stricter during enabling 
> than in disabling process. Is that correct? Otherwise there is 
> inconsistency in pr_* macros and return values. Also fops could be 
> hypothetically registered back when ftrace_set_filter_ip fails in 
> klp_disable_func. I just want to be sure that we didn't overlook 
> anything...

The asymmetry in the enable/disable error handling is intentional.  In
klp_disable_func(), a ftrace_set_filter_ip() failure isn't a fatal
condition because we've already unregistered the fops and thus removed
the patch.

> > +static int klp_init_func(struct klp_object *obj, struct klp_func *func)
> > +{
> > +	struct ftrace_ops *ops;
> > +	int ret;
> > +
> > +	func->state = KLP_DISABLED;
> > +
> > +	ops = kzalloc(sizeof(*ops), GFP_KERNEL);
> > +	if (!ops)
> > +		ret = -ENOMEM;
> 
> There should be return -ENOMEM.

Agreed.

> > +static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
> > +{
> > +	struct klp_func *func;
> > +	int ret;
> > +	const char *name;
> > +
> > +	if (!obj->funcs)
> > +		return -EINVAL;
> > +
> > +	obj->state = KLP_DISABLED;
> > +
> > +	klp_find_object_module(obj);
> > +
> > +	name = klp_is_module(obj) ? obj->name : "vmlinux";
> > +	obj->kobj = kobject_create_and_add(name, &patch->kobj);
> > +	if (!obj->kobj)
> > +		return -ENOMEM;
> > +
> > +	for (func = obj->funcs; func->old_name; func++) {
> > +		ret = klp_init_func(obj, func);
> > +		if (ret)
> > +			goto free;
> > +	}
> > +
> > +	if (klp_is_object_loaded(obj)) {
> > +		ret = klp_init_object_loaded(patch, obj);
> > +		if (ret)
> > +			goto free;
> > +	}
> > +
> > +	return 0;
> > +
> > +free:
> > +	klp_free_funcs_limited(obj, func);
> > +	return ret;
> > +}
> 
> Shouldn't we call kobject_put(obj->kobj) in free branch? If I am not wrong 
> it is not freed anywhere else. We free only already initialized functions 
> and already initialized objects later in klp_init_patch, but not the 
> kobject of the currently failing object.

Agreed.

> And that is everything. I like it, it has improved a lot. I hope that 
> there are no other problems. I am getting blind looking at it all the 
> time :)

Thanks!  I'll send out the next patch set soon, maybe Monday.

-- 
Josh

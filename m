Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaLAMlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:41:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbaLAMlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:41:04 -0500
Date: Mon, 1 Dec 2014 13:40:55 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: clean up klp_find_object_module() usage: was:
 Re: [PATCHv4 2/3] kernel: add support for live patching
Message-ID: <20141201124055.GB18532@pathway.suse.cz>
References: <1416935709-404-1-git-send-email-sjenning@redhat.com>
 <1416935709-404-3-git-send-email-sjenning@redhat.com>
 <20141128170735.GD32376@dhcp128.suse.cz>
 <20141128171435.GE32376@dhcp128.suse.cz>
 <alpine.LNX.2.00.1412011256420.23443@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1412011256420.23443@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-12-01 13:08:50, Miroslav Benes wrote:
> On Fri, 28 Nov 2014, Petr Mladek wrote:
> 
> > On Fri 2014-11-28 18:07:37, Petr Mladek wrote:
> > > On Tue 2014-11-25 11:15:08, Seth Jennings wrote:
> > > > This commit introduces code for the live patching core.  It implements
> > > > an ftrace-based mechanism and kernel interface for doing live patching
> > > > of kernel and kernel module functions.
> > 
> > [...]
> > 
> > > > +/* sets obj->mod if object is not vmlinux and module is found */
> > > > +static bool klp_find_object_module(struct klp_object *obj)
> > > > +{
> > > > +	if (!obj->name)
> > > > +		return 1;
> > > > +
> > > > +	mutex_lock(&module_mutex);
> > > > +	/*
> > > > +	 * We don't need to take a reference on the module here because we have
> > > > +	 * the klp_mutex, which is also taken by the module notifier.  This
> > > > +	 * prevents any module from unloading until we release the klp_mutex.
> > > > +	 */
> > > > +	obj->mod = find_module(obj->name);
> > > > +	mutex_unlock(&module_mutex);
> > > > +
> > > > +	return !!obj->mod;
> > > 
> > > I know that this is effective to return boolean here because
> > > it handles also patch against the kernel core (vmlinux). But
> > > the logic looks tricky. I would prefer a cleaner design and
> > > use this function only to set obj->mod.
> > > 
> > > I wanted to see how it would look like, so I will send a patch for
> > > this in a separate mail.
> > 
> > The patch is below. Of course, merge it into the original
> > patch if you agree with the idea, please.
> > 
> > 
> > >From 93eb9f9a25ad8aa0301e246f7685d3e787037566 Mon Sep 17 00:00:00 2001
> > From: Petr Mladek <pmladek@suse.cz>
> > Date: Fri, 28 Nov 2014 15:32:27 +0100
> > Subject: [PATCH 1/2] livepatch: clean up klp_find_object_module() usage
> > 
> > The function klp_find_object_module() looks quite tricky. It has two effects:
> > sets obj->mod and decides whether the module is available or not. The second
> > effect is the tricky part because it handles also the code kernel code "vmlinux"
> > and is not module related. It causes returning bool, and doing the crazy double
> > negation.
> > 
> > This patch tries to make a bit cleaner design:
> > 
> > 1. klp_find_object_module() handles only obj->mod. It returns
> >    the pointer or NULL.
> > 
> > 2. It modifies klp_enable_object() to do nothing when the related
> >    module has not been loaded yet.
> > 
> > 3. The result is that the return value klp_find_object_module() is
> >    not used in the end.
> > 
> > We lose a check for potential klp_enable_object() misuse but it makes the code
> > easier. In fact, the check for unloaded module is rather long. We might want
> > to make it easier using some extra flag or another state of the object.
> > Such flag might be used for the check of misuse.
> > 
> > Signed-off-by: Petr Mladek <pmladek@suse.cz>
> 
> Hi, 
> 
> I agree with the idea but actually don't like the implementation. I'll try 
> to propose few changes which would hopefully preserve the effect but make 
> the end result slightly better.
> 
> > ---
> >  kernel/livepatch/core.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index 8e2e8cd242f5..9b1601729014 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -40,10 +40,10 @@ static LIST_HEAD(klp_patches);
> >  static struct kobject *klp_root_kobj;
> >  
> >  /* sets obj->mod if object is not vmlinux and module is found */
> > -static bool klp_find_object_module(struct klp_object *obj)
> > +static struct module *klp_find_object_module(struct klp_object *obj)
> >  {
> >  	if (!obj->name)
> > -		return 1;
> > +		return NULL;
> >  
> >  	mutex_lock(&module_mutex);
> >  	/*
> > @@ -54,7 +54,7 @@ static bool klp_find_object_module(struct klp_object *obj)
> >  	obj->mod = find_module(obj->name);
> >  	mutex_unlock(&module_mutex);
> >  
> > -	return !!obj->mod;
> > +	return obj->mod;
> >  }
> 
> As we do not need the return value in the end, we could maybe drop it 
> completely, leading to change in if condition
> 
> 	if (!obj->name)
> 		return;

Sounds good.

> >  struct klp_find_arg {
> > @@ -318,8 +318,9 @@ static int klp_enable_object(struct module *pmod, struct klp_object *obj)
> >  	struct klp_func *func;
> >  	int ret;
> >  
> > -	if (WARN_ON(!obj->mod && obj->name))
> > -		return -EINVAL;
> > +	/* nope when the patched module has not been loaded yet */
> > +	if (obj->name && !obj->mod)
> > +		return 0;
> 
> I have a problem with this one. In case the condition is true we do 
> nothing, return back and pretend that everything is alright (return 0). 
> I see that we would call klp_enable_object everytime in your proposal and 
> decide here whether we want to do something or not. But I think that we 
> should return some error and deal with it in the caller function. Thus 
> original WARN_ON should stay here.

I agree.


> >  	if (obj->relocs) {
> >  		ret = klp_write_object_relocations(pmod, obj);
> > @@ -401,8 +402,7 @@ static int __klp_enable_patch(struct klp_patch *patch)
> >  	pr_notice("enabling patch '%s'\n", patch->mod->name);
> >  
> >  	for (obj = patch->objs; obj->funcs; obj++) {
> > -		if (!klp_find_object_module(obj))
> > -			continue;
> > +		klp_find_object_module(obj);
> >  		ret = klp_enable_object(patch->mod, obj);
> >  		if (ret)
> >  			goto unregister;
> 
> I propose this piece of code
> 
> for (obj = patch->objs; obj->funcs; obj++) {
> 	klp_find_object_module(obj);
> 	if (obj->name && !obj->mod)
> 		continue;
> 	ret = klp_enable_object(patch->mod, obj);
> 	...
> }

I like this change, especially if we replace the condition with a
macro. It keeps klp_find_object_module() without the side effect
and it keeps the warning in klp_enable_object().


> What do you think? Also it could pay off to define inline function for the 
> check. Somethink like klp_is_module_and_loaded...

klp_is_object_loaded() is easier and still clear. Also we might want
to add a macro klp_is_module(obj).

Best Regards,
Petr

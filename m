Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaKGSzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:55:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbaKGSzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:55:35 -0500
Date: Fri, 7 Nov 2014 12:55:28 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: module notifier: was Re: [PATCH 2/2] kernel: add support for
 live patching
Message-ID: <20141107185528.GD2057@cerebellum.variantweb.net>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <20141107171307.GC1136@dhcp128.suse.cz>
 <20141107180711.GC2057@cerebellum.variantweb.net>
 <20141107184011.GF1136@dhcp128.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107184011.GF1136@dhcp128.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 07:40:11PM +0100, Petr Mladek wrote:
> On Fri 2014-11-07 12:07:11, Seth Jennings wrote:
> > On Fri, Nov 07, 2014 at 06:13:07PM +0100, Petr Mladek wrote:
> > > On Thu 2014-11-06 08:39:08, Seth Jennings wrote:
> > > > This commit introduces code for the live patching core.  It implements
> > > > an ftrace-based mechanism and kernel interface for doing live patching
> > > > of kernel and kernel module functions.
> > > > 
> > > > It represents the greatest common functionality set between kpatch and
> > > > kgraft and can accept patches built using either method.
> > > > 
> > > > This first version does not implement any consistency mechanism that
> > > > ensures that old and new code do not run together.  In practice, ~90% of
> > > > CVEs are safe to apply in this way, since they simply add a conditional
> > > > check.  However, any function change that can not execute safely with
> > > > the old version of the function can _not_ be safely applied in this
> > > > version.
> > > 
> > > [...]
> > >  
> > > > +/******************************
> > > > + * module notifier
> > > > + *****************************/
> > > > +
> > > > +static int lp_module_notify(struct notifier_block *nb, unsigned long action,
> > > > +			    void *data)
> > > > +{
> > > > +	struct module *mod = data;
> > > > +	struct lpc_patch *patch;
> > > > +	struct lpc_object *obj;
> > > > +	int ret = 0;
> > > > +
> > > > +	if (action != MODULE_STATE_COMING)
> > > > +		return 0;
> > > 
> > > IMHO, we should handle also MODULE_STATE_GOING. We should unregister
> > > the ftrace handlers and update the state of the affected objects
> > > (ENABLED -> DISABLED)
> > 
> > The mechanism we use to avoid this right now is taking a reference on
> > patched module.  We only release that reference after the patch is
> > disabled, which unregisters all the patched functions from ftrace.
> 
> I see. This was actually another thing that I noticed and wanted to
> investigate :-) I think that we should not force users to disable
> the entire patch if they want to remove some module.

I agree that would be better.

> 
> 
> > However, your comment reminded me of an idea I had to use
> > MODULE_STATE_GOING and let the lpc_mutex protect against races.  I think
> > it could be cleaner, but I haven't fleshed the idea out fully.
> 
> AFAIK, the going module is not longer used when the notifier is
> called. Therefore we could remove the patch fast way even when
> patching would require the slow path otherwise.

Yes (Josh just brought this to my attention) is that the notifiers are
call with GOING _after_ the module's exit function is called.

Thanks,
Seth

> 
> 
> > > 
> > > > +	down(&lpc_mutex);
> > > > +
> > > > +	list_for_each_entry(patch, &lpc_patches, list) {
> > > > +		if (patch->state == DISABLED)
> > > > +			continue;
> > > > +		list_for_each_entry(obj, &patch->objs, list) {
> > > > +			if (strcmp(obj->name, mod->name))
> > > > +				continue;
> > > > +			pr_notice("load of module '%s' detected, applying patch '%s'\n",
> > > > +				  mod->name, patch->mod->name);
> > > > +			obj->mod = mod;
> > > > +			ret = lpc_enable_object(patch->mod, obj);
> > > > +			if (ret)
> > > > +				goto out;
> > > > +			break;
> > > > +		}
> > > > +	}
> > > > +
> > > > +	up(&lpc_mutex);
> > > > +	return 0;
> > > > +out:
> > > 
> > > I would name this err_our or so to make it clear that it is used when
> > > something fails.
> > 
> > Just "err" good?
> 
> Fine with me.
>  
> > > > +	up(&lpc_mutex);
> > > > +	WARN("failed to apply patch '%s' to module '%s'\n",
> > > > +		patch->mod->name, mod->name);
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +static struct notifier_block lp_module_nb = {
> > > > +	.notifier_call = lp_module_notify,
> > > > +	.priority = INT_MIN, /* called last */
> > > 
> > > The handler for MODULE_STATE_COMMING would need have higger priority,
> > > if we want to cleanly unregister the ftrace handlers.
> > 
> > Yes, we might need two handlers at different priorities if we decide to
> > go that direction: one for MODULE_STATE_GOING at high/max and one for
> > MODULE_STATE_COMING at low/min.
> 
> kGraft has notifier only for the going state. The initialization is
> called directly from load_module() after ftrace_module_init()
> and complete_formation() before it is executed by parse_args().
> 
> I need to investigate if the notifier is more elegant and safe or not.
> 
> Best Regards,
> Petr

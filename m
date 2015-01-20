Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbbATPro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:47:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbbATPrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:47:42 -0500
Date: Tue, 20 Jan 2015 09:47:36 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: support for repatching a function
Message-ID: <20150120154736.GA4417@treble.redhat.com>
References: <cover.1421767360.git.jpoimboe@redhat.com>
 <da0d4d3c34441efcd8e830c4c978016581d7f055.1421767360.git.jpoimboe@redhat.com>
 <54BE7657.2010105@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54BE7657.2010105@suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 04:37:59PM +0100, Jiri Slaby wrote:
> On 01/20/2015, 04:26 PM, Josh Poimboeuf wrote:
> > Add support for patching a function multiple times.  If multiple patches
> > affect a function, the function in the most recently enabled patch
> > "wins".  This enables a cumulative patch upgrade path, where each patch
> > is a superset of previous patches.
> > 
> > This requires restructuring the data a little bit.  With the current
> > design, where each klp_func struct has its own ftrace_ops, we'd have to
> > unregister the old ops and then register the new ops, because
> > FTRACE_OPS_FL_IPMODIFY prevents us from having two ops registered for
> > the same function at the same time.  That would leave a regression
> > window where the function isn't patched at all (not good for a patch
> > upgrade path).
> > 
> > This patch replaces the per-klp_func ftrace_ops with a global klp_ops
> > list, with one ftrace_ops per original function.  A single ftrace_ops is
> > shared between all klp_funcs which have the same old_addr.  This allows
> > the switch between function versions to happen instantaneously by
> > updating the klp_ops struct's func_stack list.  The winner is the
> > klp_func at the top of the func_stack (front of the list).
> > 
> > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> 
> Reviewed-by: Jiri Slaby <jslaby@suse.cz>

Thanks for the review!

> But...
> 
> > @@ -267,16 +303,28 @@ static int klp_write_object_relocations(struct module *pmod,
> >  
> >  static void notrace klp_ftrace_handler(unsigned long ip,
> >  				       unsigned long parent_ip,
> > -				       struct ftrace_ops *ops,
> > +				       struct ftrace_ops *fops,
> >  				       struct pt_regs *regs)
> >  {
> > -	struct klp_func *func = ops->private;
> > +	struct klp_ops *ops;
> > +	struct klp_func *func;
> > +
> > +	ops = container_of(fops, struct klp_ops, fops);
> > +
> > +	rcu_read_lock();
> > +	func = list_first_or_null_rcu(&ops->func_stack, struct klp_func,
> > +				      stack_node);
> > +	rcu_read_unlock();
> > +
> > +	if (WARN_ON(!func))
> > +		return;
> 
> If it ever happens, the warn will drown the machine in the output splash.

Yeah, maybe, depending on the nature of the bug.

> WARN_ON_RATELIMIT?

Since this warning should never happen unless there's a code bug, I
think WARN_ON_ONCE should be sufficient?

-- 
Josh

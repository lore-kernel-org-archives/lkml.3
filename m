Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbaJUVOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:14:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933014AbaJUVOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:14:22 -0400
Date: Tue, 21 Oct 2014 16:14:09 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, Seth Jennings <sjenning@redhat.com>
Subject: Re: [PATCH] kprobes: add kprobe_is_function_probed()
Message-ID: <20141021211409.GA28989@treble.redhat.com>
References: <alpine.LNX.2.00.1410211744550.24255@pobox.suse.cz>
 <20141021164328.GG3978@treble.redhat.com>
 <alpine.LNX.2.00.1410212209560.22681@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1410212209560.22681@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 10:19:30PM +0200, Jiri Kosina wrote:
> On Tue, 21 Oct 2014, Josh Poimboeuf wrote:
> 
> > > Add a function that allows external users (such as live patching 
> > > mechanisms) to check whether a given function (identified by symbol name) 
> > > has a kprobe installed in it.
> > 
> > Functions aren't uniquely identifiable by name.  Perhaps it should be
> > something like kprobe_is_addr_range_probed()?
> 
> Hi Josh,
> 
> first, thanks a lot for the review.
> 
> This is a rather difficult call actually. I am of course aware of the fact 
> that kernel fucntions can't be uniquely identified by name, but when 
> thinking about this, one has to consider:
> 
> - ftrace primary userspace interface (set_ftrace_filter) is based on 
>   function names
> - kprobe tracer and uprobe trace primary userspace interface 
>   (/sys/kernel/debug/tracing/kprobe_events and uprobe_events respectively)
>   are primarily based on function names

True, the user space interfaces are done by name, but the kernel
interfaces aren't necessarily so (see ftrace_set_filter_ip and struct
kprobe.addr).  This is a kernel interface so we can be more precise.

> - the number of conflicts is probably zero, or very close to zero. Try to 
>   run this 
> 
> 	cut -f3 -d' ' /proc/kallsyms | sort  | uniq -c
> 
>   So it's questionable whether all the back and forth name->address->name 
>   translations all over the place are worth all the trouble.

On my kernel:

$ grep ' t \| T ' /proc/kallsyms | awk '{print $3}' |sort |uniq -d |wc -l
395

So there are at least 395 places where this could go wrong...

With kpatch, we're setting the ftrace filter by address so we don't
patch the wrong function.  So we already have the address.  We also have
the function length, which is needed for our backtrace safety checks.

I'm guessing kGraft doesn't have the address + length?  I think you
could call kallsyms_lookup() to get both values.

Maybe we should see what our unified live patching code ends up looking
like before deciding what interface(s) we need here?

> 
>   I do agree though that we should make it obvious that the lookup 
>   interface works on symbol names only ... perhaps by adding '_by_name()' 
>   or so?
> 
> > Should we refuse to patch a function which has a kprobe installed inside 
> > it?  
> 
> I think warning about it is a good thing to do.

I think that's probably ok.

> 
> > Is there a race-free way to do that?
> 
> Do we need to be race-free here? If userspace is both instantiating new 
> krpobe and initiating live kernel patching at the "same time", I don't 
> think kernel should try to solve such race ... it's simply there by 
> definition, depending on, for example, scheduling decisions.

If we're not preventing it, but instead just printing a warning, then
yeah, that sounds fine to me.

I think it would also be nice to do the reverse, i.e. have kprobes emit
a warning if someone tries to probe a replaced function.

-- 
Josh

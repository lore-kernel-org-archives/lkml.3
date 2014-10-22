Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaJVCkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 22:40:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbaJVCkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 22:40:43 -0400
Date: Tue, 21 Oct 2014 21:40:32 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, Seth Jennings <sjenning@redhat.com>
Subject: Re: [PATCH] kprobes: add kprobe_is_function_probed()
Message-ID: <20141022024032.GA8719@treble.redhat.com>
References: <alpine.LNX.2.00.1410211744550.24255@pobox.suse.cz>
 <20141021164328.GG3978@treble.redhat.com>
 <alpine.LNX.2.00.1410212209560.22681@pobox.suse.cz>
 <20141021211409.GA28989@treble.redhat.com>
 <alpine.LNX.2.00.1410212319100.22681@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1410212319100.22681@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 11:25:56PM +0200, Jiri Kosina wrote:
> On Tue, 21 Oct 2014, Josh Poimboeuf wrote:
> 
> > > This is a rather difficult call actually. I am of course aware of the fact 
> > > that kernel fucntions can't be uniquely identified by name, but when 
> > > thinking about this, one has to consider:
> > > 
> > > - ftrace primary userspace interface (set_ftrace_filter) is based on 
> > >   function names
> > > - kprobe tracer and uprobe trace primary userspace interface 
> > >   (/sys/kernel/debug/tracing/kprobe_events and uprobe_events respectively)
> > >   are primarily based on function names
> > 
> > True, the user space interfaces are done by name, but the kernel
> > interfaces aren't necessarily so (see ftrace_set_filter_ip and struct
> > kprobe.addr).  This is a kernel interface so we can be more precise.
> 
> We could probably have both interfaces available (i.e. allowing lookup by 
> name or by address range, and let the caller decide/handle the 
> potential duplicates).
> 
> > > - the number of conflicts is probably zero, or very close to zero. Try to 
> > >   run this 
> > > 
> > > 	cut -f3 -d' ' /proc/kallsyms | sort  | uniq -c
> > > 
> > >   So it's questionable whether all the back and forth name->address->name 
> > >   translations all over the place are worth all the trouble.
> > 
> > On my kernel:
> > 
> > $ grep ' t \| T ' /proc/kallsyms | awk '{print $3}' |sort |uniq -d |wc -l
> > 395
> > 
> > So there are at least 395 places where this could go wrong...
> 
> This is broken anyway ... this will add up a lot of unrelated things 
> together (umask_show, _iommu_cpumask_show, __uncore_umask_show, 
> wq_cpumask_show, etc).

Can you clarify what you mean here?  I don't see how umask_show would
get lumped together with _iommu_cpumask_show.  Not trying to be
pedantic, just trying to get a good idea of how many duplicate function
names there are.

> I believe looking at
> 
> 	cut -f3 -d' ' /proc/kallsyms | sort  | uniq -c | sort -nr -k1
> 
> gives slightly better picture.
> 
> Also keep in mind that a *lot* of the hits are not functions.

How is that giving a better picture?  I had used "grep ' t \| T ' above
to try to filter out non-function symbols.

> 
> > With kpatch, we're setting the ftrace filter by address so we don't
> > patch the wrong function.  So we already have the address.  We also have
> > the function length, which is needed for our backtrace safety checks.
> > 
> > I'm guessing kGraft doesn't have the address + length?  I think you
> > could call kallsyms_lookup() to get both values.
> > 
> > Maybe we should see what our unified live patching code ends up looking
> > like before deciding what interface(s) we need here?
> 
> Yes, that probably makes sense indeed. I am talking to David Miller wrt. 
> mailinglist creation on vger.kernel.org as we speak, hopefully it'll 
> materialize soon.

Ok, thanks!  Seth is currently slaving away on the code :-)

> 
> > > Do we need to be race-free here? If userspace is both instantiating new 
> > > krpobe and initiating live kernel patching at the "same time", I don't 
> > > think kernel should try to solve such race ... it's simply there by 
> > > definition, depending on, for example, scheduling decisions.
> > 
> > If we're not preventing it, but instead just printing a warning, then
> > yeah, that sounds fine to me.
> > 
> > I think it would also be nice to do the reverse, i.e. have kprobes emit
> > a warning if someone tries to probe a replaced function.
> 
> Indeed, good idea!
> 
> Thanks,
> 
> -- 
> Jiri Kosina
> SUSE Labs

-- 
Josh

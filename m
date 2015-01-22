Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbbAVSjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:39:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbbAVSjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:39:16 -0500
Date: Thu, 22 Jan 2015 19:39:13 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, david.vrabel@citrix.com,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Ingo Molnar <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>
Subject: Re: [Xen-devel] [RFC v3 2/2] x86/xen: allow privcmd hypercalls to
	be preempted
Message-ID: <20150122183913.GO17887@wotan.suse.de>
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com> <1421893039-426-3-git-send-email-mcgrof@do-not-panic.com> <54C0E3F2.9050201@citrix.com> <20150122085649.7dc79541@grimm.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122085649.7dc79541@grimm.local.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 08:56:49AM -0500, Steven Rostedt wrote:
> On Thu, 22 Jan 2015 11:50:10 +0000
> Andrew Cooper <andrew.cooper3@citrix.com> wrote:
> 
> > On 22/01/15 02:17, Luis R. Rodriguez wrote:
> > > --- a/drivers/xen/events/events_base.c
> > > +++ b/drivers/xen/events/events_base.c
> > > @@ -32,6 +32,8 @@
> > >  #include <linux/slab.h>
> > >  #include <linux/irqnr.h>
> > >  #include <linux/pci.h>
> > > +#include <linux/sched.h>
> > > +#include <linux/kprobes.h>
> > >  
> > >  #ifdef CONFIG_X86
> > >  #include <asm/desc.h>
> > > @@ -1243,6 +1245,17 @@ void xen_evtchn_do_upcall(struct pt_regs
> > > *regs) set_irq_regs(old_regs);
> > >  }
> > >  
> > > +notrace void xen_end_upcall(struct pt_regs *regs)
> > > +{
> > > +	if (!xen_is_preemptible_hypercall(regs) ||
> > > +	    __this_cpu_read(xed_nesting_count))
> > > +		return;
> > > +
> > > +	if (_cond_resched())
> > > +		printk(KERN_DEBUG "xen hypercall preempted\n");
> > 
> > I wouldn't even put this at debug level.  On a large server with
> > plenty of domains being created/migrated/destroyed, it is quite
> > likely that a toolstack task might get preempted in this way.
> > 
> > I don't believe the message is of any practical use.
> > 
> 
> Why not make this a tracepoint? Then you can enable it only when you
> want to. As tracepoints are also hooks, you could add you own code that
> hooks to it and does a printk as well. The advantage of doing it via a
> tracepoint is that you can turn it on and off regardless of what the
> loglevel is set at.

This uses NOKPROBE_SYMBOL and notrace since based on Andy's advice
we are not confident that tracing and kprobes are safe to use in what
might be an extended RCU quiescent state (i.e. where we're outside
irq_enter and irq_exit).

> That is, if there is any practical use for that message. Tracing just
> sched_switch will give you the same info.

IMHO it may be more useful if we knew exactly what hypercalls were
being preempted but perhaps all that can be left as a secondary
exercise and for now I'll just nuke the print.

  Luis

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbbAVN4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:56:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:57816 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751584AbbAVN4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:56:31 -0500
Date: Thu, 22 Jan 2015 08:56:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, <david.vrabel@citrix.com>,
        <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>, <kvm@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        Ingo Molnar <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>
Subject: Re: [Xen-devel] [RFC v3 2/2] x86/xen: allow privcmd hypercalls to
 be preempted
Message-ID: <20150122085649.7dc79541@grimm.local.home>
In-Reply-To: <54C0E3F2.9050201@citrix.com>
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com>
	<1421893039-426-3-git-send-email-mcgrof@do-not-panic.com>
	<54C0E3F2.9050201@citrix.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015 11:50:10 +0000
Andrew Cooper <andrew.cooper3@citrix.com> wrote:

> On 22/01/15 02:17, Luis R. Rodriguez wrote:
> > --- a/drivers/xen/events/events_base.c
> > +++ b/drivers/xen/events/events_base.c
> > @@ -32,6 +32,8 @@
> >  #include <linux/slab.h>
> >  #include <linux/irqnr.h>
> >  #include <linux/pci.h>
> > +#include <linux/sched.h>
> > +#include <linux/kprobes.h>
> >  
> >  #ifdef CONFIG_X86
> >  #include <asm/desc.h>
> > @@ -1243,6 +1245,17 @@ void xen_evtchn_do_upcall(struct pt_regs
> > *regs) set_irq_regs(old_regs);
> >  }
> >  
> > +notrace void xen_end_upcall(struct pt_regs *regs)
> > +{
> > +	if (!xen_is_preemptible_hypercall(regs) ||
> > +	    __this_cpu_read(xed_nesting_count))
> > +		return;
> > +
> > +	if (_cond_resched())
> > +		printk(KERN_DEBUG "xen hypercall preempted\n");
> 
> I wouldn't even put this at debug level.  On a large server with
> plenty of domains being created/migrated/destroyed, it is quite
> likely that a toolstack task might get preempted in this way.
> 
> I don't believe the message is of any practical use.
> 

Why not make this a tracepoint? Then you can enable it only when you
want to. As tracepoints are also hooks, you could add you own code that
hooks to it and does a printk as well. The advantage of doing it via a
tracepoint is that you can turn it on and off regardless of what the
loglevel is set at.

That is, if there is any practical use for that message. Tracing just
sched_switch will give you the same info.

-- Steve



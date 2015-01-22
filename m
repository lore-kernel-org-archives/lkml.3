Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbbAVSlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:41:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbbAVSlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:41:02 -0500
Date: Thu, 22 Jan 2015 19:41:00 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, david.vrabel@citrix.com,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>
Subject: Re: [Xen-devel] [RFC v3 2/2] x86/xen: allow privcmd hypercalls to
	be preempted
Message-ID: <20150122184100.GP17887@wotan.suse.de>
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com> <1421893039-426-3-git-send-email-mcgrof@do-not-panic.com> <54C0E3F2.9050201@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C0E3F2.9050201@citrix.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 11:50:10AM +0000, Andrew Cooper wrote:
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
> > @@ -1243,6 +1245,17 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
> >  	set_irq_regs(old_regs);
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
> I wouldn't even put this at debug level.  On a large server with plenty
> of domains being created/migrated/destroyed, it is quite likely that a
> toolstack task might get preempted in this way.
> 
> I don't believe the message is of any practical use.

I'll just nuke it then.

 Luis

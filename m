Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbbAVR4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:56:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbbAVR4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:56:41 -0500
Date: Thu, 22 Jan 2015 18:56:37 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [RFC v3 2/2] x86/xen: allow privcmd hypercalls to
	be preempted
Message-ID: <20150122175637.GN17887@wotan.suse.de>
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com> <1421893039-426-3-git-send-email-mcgrof@do-not-panic.com> <CALCETrXSQ0JCKY5k0S_xX-i4+1BBVY+_9dv2ouj23WXFi8hyfg@mail.gmail.com> <54C0F335.6030403@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C0F335.6030403@citrix.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 12:55:17PM +0000, David Vrabel wrote:
> On 22/01/15 03:18, Andy Lutomirski wrote:
> >> --- a/drivers/xen/events/events_base.c
> >> +++ b/drivers/xen/events/events_base.c
> >> @@ -32,6 +32,8 @@
> >>  #include <linux/slab.h>
> >>  #include <linux/irqnr.h>
> >>  #include <linux/pci.h>
> >> +#include <linux/sched.h>
> >> +#include <linux/kprobes.h>
> >>
> >>  #ifdef CONFIG_X86
> >>  #include <asm/desc.h>
> >> @@ -1243,6 +1245,17 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
> >>         set_irq_regs(old_regs);
> >>  }
> >>
> >> +notrace void xen_end_upcall(struct pt_regs *regs)
> >> +{
> >> +       if (!xen_is_preemptible_hypercall(regs) ||
> >> +           __this_cpu_read(xed_nesting_count))
> >> +               return;
> > 
> > What's xed_nesting_count?
> 
> It used to prevent nested upcalls when a hypercall called from an upcall
> triggers another upcall.
> 
> There's no way a such a nested hypercall can be preemptible so the check
> for xed_nesting_count an be removed from here.

Removed.

  Luis

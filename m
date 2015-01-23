Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbbAWB44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:56:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:57794 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753334AbbAWB4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:56:51 -0500
Date: Thu, 22 Jan 2015 20:57:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [RFC v4 2/2] x86/xen: allow privcmd hypercalls to be preempted
Message-ID: <20150122205717.57615751@grimm.local.home>
In-Reply-To: <CALCETrXKeoFKCDYcqeN=HV6MJt_CjwSPQmn_DbBxY6s-76W3Tw@mail.gmail.com>
References: <1421972951-3940-1-git-send-email-mcgrof@do-not-panic.com>
	<1421972951-3940-3-git-send-email-mcgrof@do-not-panic.com>
	<CALCETrXKeoFKCDYcqeN=HV6MJt_CjwSPQmn_DbBxY6s-76W3Tw@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015 17:40:27 -0800
Andy Lutomirski <luto@amacapital.net> wrote:

> >
> > +/*
> > + * CONFIG_PREEMPT=n kernels can end up triggering the softlock
> > + * TASK_UNINTERRUPTIBLE hanger check (default 120 seconds)
> > + * when certain multicalls are used [0] on large systems, in
> > + * that case we need a way to voluntarily preempt. This is
> > + * only an issue on CONFIG_PREEMPT=n kernels.
> > + *
> > + * [0] https://bugzilla.novell.com/show_bug.cgi?id=861093
> > + */
> > +void xen_end_upcall(struct pt_regs *regs)
> > +{
> > +       if (xen_is_preemptible_hypercall(regs)) {
> > +               int cpuid = smp_processor_id();
> > +               if (_cond_resched())
> > +                       trace_xen_hypercall_preemption(cpuid);
> 
> If you want to speed this up a bit, I think you could move the
> smp_processor_id() into the TP_fast_assign.  But don't tracepoints
> report the cpu number even without any action?

Yes, but if you scheduled here, the tracepoint could happen on a
different CPU. Thus, cpuid will not equal smp_processor_id().

-- Steve

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbbAVVHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:07:44 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:33214 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbbAVVHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:07:42 -0500
Date: Thu, 22 Jan 2015 13:07:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, david.vrabel@citrix.com,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Ingo Molnar <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>
Subject: Re: [Xen-devel] [RFC v3 2/2] x86/xen: allow privcmd hypercalls to be
 preempted
Message-ID: <20150122210731.GN9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com>
 <1421893039-426-3-git-send-email-mcgrof@do-not-panic.com>
 <54C0E3F2.9050201@citrix.com>
 <20150122085649.7dc79541@grimm.local.home>
 <20150122183913.GO17887@wotan.suse.de>
 <20150122151657.287fe29b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122151657.287fe29b@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012221-0033-0000-0000-0000036D47FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 03:16:57PM -0500, Steven Rostedt wrote:
> 
> [ Added Paul McKenney ]
> 
> On Thu, 22 Jan 2015 19:39:13 +0100
> "Luis R. Rodriguez" <mcgrof@suse.com> wrote:
> 
> > > Why not make this a tracepoint? Then you can enable it only when you
> > > want to. As tracepoints are also hooks, you could add you own code that
> > > hooks to it and does a printk as well. The advantage of doing it via a
> > > tracepoint is that you can turn it on and off regardless of what the
> > > loglevel is set at.
> > 
> > This uses NOKPROBE_SYMBOL and notrace since based on Andy's advice
> > we are not confident that tracing and kprobes are safe to use in what
> > might be an extended RCU quiescent state (i.e. where we're outside
> > irq_enter and irq_exit).
> 
> We have trace_*_rcuidle() for such cases.
> 
> That is, you create the tracepoint just the same, and instead of having
> trace_foo(), if you are in a known area that is outside of rcu viewing,
> you use trace_foo_rcuidle() and it will tell RCU "hey, there's something
> here that may need RCU, so look at me!"

What Steve said!

Also, there is an rcu_is_watching() API member that can tell you
whether or not RCU is paying attention at a given point.  Or test with
CONFIG_PROVE_RCU, in which case lockdep will yell at you if you should
have used the _rcuidle() form of the tracing hooks.  ;-)

							Thanx, Paul

> Also, please remove the "notrace", because function tracing goes an
> extra step to not require RCU being visible. The only thing you get
> with notrace is not being able to trace an otherwise traceable function.
> 
> -- Steve
> 
> > 
> > > That is, if there is any practical use for that message. Tracing just
> > > sched_switch will give you the same info.
> > 
> > IMHO it may be more useful if we knew exactly what hypercalls were
> > being preempted but perhaps all that can be left as a secondary
> > exercise and for now I'll just nuke the print.
> 


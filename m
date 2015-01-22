Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbbAVURE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:17:04 -0500
Received: from smtprelay0190.hostedemail.com ([216.40.44.190]:43947 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752900AbbAVURB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:17:01 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:5007:6119:6120:6261:6742:7875:8957:9040:10004:10400:10848:10967:11026:11232:11658:11914:12296:12517:12519:12740:13069:13095:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: brass68_770d33077f054
X-Filterd-Recvd-Size: 3092
Date: Thu, 22 Jan 2015 15:16:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, david.vrabel@citrix.com,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Ingo Molnar <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] [RFC v3 2/2] x86/xen: allow privcmd hypercalls to
 be preempted
Message-ID: <20150122151657.287fe29b@gandalf.local.home>
In-Reply-To: <20150122183913.GO17887@wotan.suse.de>
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com>
	<1421893039-426-3-git-send-email-mcgrof@do-not-panic.com>
	<54C0E3F2.9050201@citrix.com>
	<20150122085649.7dc79541@grimm.local.home>
	<20150122183913.GO17887@wotan.suse.de>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Added Paul McKenney ]

On Thu, 22 Jan 2015 19:39:13 +0100
"Luis R. Rodriguez" <mcgrof@suse.com> wrote:

> > Why not make this a tracepoint? Then you can enable it only when you
> > want to. As tracepoints are also hooks, you could add you own code that
> > hooks to it and does a printk as well. The advantage of doing it via a
> > tracepoint is that you can turn it on and off regardless of what the
> > loglevel is set at.
> 
> This uses NOKPROBE_SYMBOL and notrace since based on Andy's advice
> we are not confident that tracing and kprobes are safe to use in what
> might be an extended RCU quiescent state (i.e. where we're outside
> irq_enter and irq_exit).

We have trace_*_rcuidle() for such cases.

That is, you create the tracepoint just the same, and instead of having
trace_foo(), if you are in a known area that is outside of rcu viewing,
you use trace_foo_rcuidle() and it will tell RCU "hey, there's something
here that may need RCU, so look at me!"

Also, please remove the "notrace", because function tracing goes an
extra step to not require RCU being visible. The only thing you get
with notrace is not being able to trace an otherwise traceable function.

-- Steve

> 
> > That is, if there is any practical use for that message. Tracing just
> > sched_switch will give you the same info.
> 
> IMHO it may be more useful if we knew exactly what hypercalls were
> being preempted but perhaps all that can be left as a secondary
> exercise and for now I'll just nuke the print.

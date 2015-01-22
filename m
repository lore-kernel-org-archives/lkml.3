Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbbAVUhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:37:15 -0500
Received: from smtprelay0111.hostedemail.com ([216.40.44.111]:49487 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751930AbbAVUhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:37:13 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:2897:2904:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3873:3874:4250:5007:6120:6261:6742:7875:8660:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13069:13148:13161:13229:13230:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beast32_426ffecbc15c
X-Filterd-Recvd-Size: 2886
Date: Thu, 22 Jan 2015 15:37:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] [RFC v3 2/2] x86/xen: allow privcmd hypercalls to
 be preempted
Message-ID: <20150122153707.4625878b@gandalf.local.home>
In-Reply-To: <CALCETrU+B_8C2-1+gEQ20wrL+0A6G0XTQ4wAnWuewKc=Pei5Qg@mail.gmail.com>
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com>
	<1421893039-426-3-git-send-email-mcgrof@do-not-panic.com>
	<54C0E3F2.9050201@citrix.com>
	<20150122085649.7dc79541@grimm.local.home>
	<20150122183913.GO17887@wotan.suse.de>
	<20150122151657.287fe29b@gandalf.local.home>
	<CALCETrU+B_8C2-1+gEQ20wrL+0A6G0XTQ4wAnWuewKc=Pei5Qg@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015 12:24:47 -0800
Andy Lutomirski <luto@amacapital.net> wrote:

> > Also, please remove the "notrace", because function tracing goes an
> > extra step to not require RCU being visible. The only thing you get
> > with notrace is not being able to trace an otherwise traceable function.
> >
> 
> Is this also true for kprobes?  And can kprobes nest inside function
> tracing hooks?

No, kprobes are a bit more fragile than function tracing or tracepoints.

And nothing should nest inside a function hook (except for interrupts,
they are fine).

> 
> The other issue, above and beyond RCU, is that we can't let kprobes
> run on the int3 stack.  If Xen upcalls can happen when interrupts are
> off, then we may need this protection to prevent that type of
> recursion.  (This will be much less scary in 3.20, because userspace
> int3 instructions will no longer execute on the int3 stack.)

Does this execute between the start of the int3 interrupt handler and
the call of do_int3()?

-- Steve

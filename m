Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbbAVUZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:25:12 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:43838 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbbAVUZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:25:09 -0500
MIME-Version: 1.0
In-Reply-To: <20150122151657.287fe29b@gandalf.local.home>
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com>
 <1421893039-426-3-git-send-email-mcgrof@do-not-panic.com> <54C0E3F2.9050201@citrix.com>
 <20150122085649.7dc79541@grimm.local.home> <20150122183913.GO17887@wotan.suse.de>
 <20150122151657.287fe29b@gandalf.local.home>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Jan 2015 12:24:47 -0800
Message-ID: <CALCETrU+B_8C2-1+gEQ20wrL+0A6G0XTQ4wAnWuewKc=Pei5Qg@mail.gmail.com>
Subject: Re: [Xen-devel] [RFC v3 2/2] x86/xen: allow privcmd hypercalls to be preempted
To: Steven Rostedt <rostedt@goodmis.org>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 12:16 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> [ Added Paul McKenney ]
>
> On Thu, 22 Jan 2015 19:39:13 +0100
> "Luis R. Rodriguez" <mcgrof@suse.com> wrote:
>
>> > Why not make this a tracepoint? Then you can enable it only when you
>> > want to. As tracepoints are also hooks, you could add you own code that
>> > hooks to it and does a printk as well. The advantage of doing it via a
>> > tracepoint is that you can turn it on and off regardless of what the
>> > loglevel is set at.
>>
>> This uses NOKPROBE_SYMBOL and notrace since based on Andy's advice
>> we are not confident that tracing and kprobes are safe to use in what
>> might be an extended RCU quiescent state (i.e. where we're outside
>> irq_enter and irq_exit).
>
> We have trace_*_rcuidle() for such cases.
>
> That is, you create the tracepoint just the same, and instead of having
> trace_foo(), if you are in a known area that is outside of rcu viewing,
> you use trace_foo_rcuidle() and it will tell RCU "hey, there's something
> here that may need RCU, so look at me!"
>
> Also, please remove the "notrace", because function tracing goes an
> extra step to not require RCU being visible. The only thing you get
> with notrace is not being able to trace an otherwise traceable function.
>

Is this also true for kprobes?  And can kprobes nest inside function
tracing hooks?

The other issue, above and beyond RCU, is that we can't let kprobes
run on the int3 stack.  If Xen upcalls can happen when interrupts are
off, then we may need this protection to prevent that type of
recursion.  (This will be much less scary in 3.20, because userspace
int3 instructions will no longer execute on the int3 stack.)

--Andy

> -- Steve
>
>>
>> > That is, if there is any practical use for that message. Tracing just
>> > sched_switch will give you the same info.
>>
>> IMHO it may be more useful if we knew exactly what hypercalls were
>> being preempted but perhaps all that can be left as a secondary
>> exercise and for now I'll just nuke the print.



-- 
Andy Lutomirski
AMA Capital Management, LLC

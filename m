Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbbAVU6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:58:25 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:57448 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbbAVU6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:58:22 -0500
MIME-Version: 1.0
In-Reply-To: <20150122153707.4625878b@gandalf.local.home>
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com>
 <1421893039-426-3-git-send-email-mcgrof@do-not-panic.com> <54C0E3F2.9050201@citrix.com>
 <20150122085649.7dc79541@grimm.local.home> <20150122183913.GO17887@wotan.suse.de>
 <20150122151657.287fe29b@gandalf.local.home> <CALCETrU+B_8C2-1+gEQ20wrL+0A6G0XTQ4wAnWuewKc=Pei5Qg@mail.gmail.com>
 <20150122153707.4625878b@gandalf.local.home>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Jan 2015 12:58:00 -0800
Message-ID: <CALCETrUTekrhz=tXF=bAn1wuZBA+Kh+CgU+USwx--hNALvR5Mw@mail.gmail.com>
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

On Thu, Jan 22, 2015 at 12:37 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 22 Jan 2015 12:24:47 -0800
> Andy Lutomirski <luto@amacapital.net> wrote:
>
>> > Also, please remove the "notrace", because function tracing goes an
>> > extra step to not require RCU being visible. The only thing you get
>> > with notrace is not being able to trace an otherwise traceable function.
>> >
>>
>> Is this also true for kprobes?  And can kprobes nest inside function
>> tracing hooks?
>
> No, kprobes are a bit more fragile than function tracing or tracepoints.
>
> And nothing should nest inside a function hook (except for interrupts,
> they are fine).
>

But kprobes do nest inside interrupts, right?

>>
>> The other issue, above and beyond RCU, is that we can't let kprobes
>> run on the int3 stack.  If Xen upcalls can happen when interrupts are
>> off, then we may need this protection to prevent that type of
>> recursion.  (This will be much less scary in 3.20, because userspace
>> int3 instructions will no longer execute on the int3 stack.)
>
> Does this execute between the start of the int3 interrupt handler and
> the call of do_int3()?

I doubt it.

The thing I worry about is that, if do_int3 nests inside itself by any
means (e.g. int3 sends a signal, scheduling for whatever reason
(really shouldn't happen, but I haven't looked that hard)), then we're
completely hosed -- the inner int3 will overwrite the outer int3's
stack frame.  Since I have no idea what Xen upcalls do, I don't know
whether they can fire inside do_int3.

--Andy

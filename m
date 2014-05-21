Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaEUCjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:39:53 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:64232 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaEUCjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:39:51 -0400
MIME-Version: 1.0
In-Reply-To: <1400639227.9759.21.camel@pippen.local.home>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <1400639227.9759.21.camel@pippen.local.home>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 20 May 2014 19:39:31 -0700
Message-ID: <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 7:27 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2014-05-20 at 17:53 -0700, Andy Lutomirski wrote:
>>
>> If there's an NMI on the stack, we must use `RET` until we're ready
>> to re-enabled NMIs.
>
> I'm a little confused by NMI on the stack. Do you mean NMI on the target
> stack? If so, please state that.

I mean that if we're in an NMI handler or in anything nested inside it.


>>   * We can add a per-cpu variable `nmi_mce_nest_count` that is nonzero
>>     whenever an NMI or MCE is on the stack.  We'll increment it at the
>>     very beginning of the NMI handler and clear it at the very end.
>>     We will also increment it in `do_machine_check` before doing
>>     anything that can cause an interrupt.  The result is that the only
>>     interrupt that can happen with `nmi_mce_nest_count == 0` in NMI
>>     context is an MCE at the beginning or end of the NMI handler.
>
> Just note that this will probably be done in the C code, as NMI has
> issues with gs being safe.
>
> Also, should we call it "nmi" specifically. Perhaps
> "ist_stack_nest_count", stating that the stack is ist to match
> do_machine_check as well? Maybe that's not a good name either. Someone
> else can come up with something that's a little more generic than NMI?

So the issue here is that we can have an NMI followed immediately by
an MCE.  The MCE code can call force_sig, which could plausibly result
in a kprobe or something similar happening.  The return from that
needs to use IRET.

Since I don't see a clean way to reliably detect that we're inside an
NMI, I propose instead detecting when we're in *either* NMI or MCE,
hence the name.  As long as we mark do_machine_check and whatever asm
code calls it __kprobes, I think we'll be okay.

--Andy

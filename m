Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaEURwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:52:25 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:42243 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbaEURwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:52:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140521163002.GI21205@pd.tnic>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <1400639227.9759.21.camel@pippen.local.home> <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
 <20140521094626.GB21205@pd.tnic> <CALCETrWkAnSe6kzha5+MmnZn+YT+rBrmu0vz+9Pr94uUjh9dDQ@mail.gmail.com>
 <20140521163002.GI21205@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 10:52:01 -0700
Message-ID: <CALCETrXP1GSfgObP4DLbG+Reu3a4g=26aoOpe9jfUtt4_bzCfQ@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: Borislav Petkov <bp@alien8.de>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 9:30 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, May 21, 2014 at 08:21:08AM -0700, Andy Lutomirski wrote:
>> On May 21, 2014 2:46 AM, "Borislav Petkov" <bp@alien8.de> wrote:
>> >
>> > On Tue, May 20, 2014 at 07:39:31PM -0700, Andy Lutomirski wrote:
>> > > So the issue here is that we can have an NMI followed immediately by
>> > > an MCE.
>> >
>> > That part might need clarification for me: #MC is higher prio interrupt
>> > than NMI so a machine check exception can interrupt the NMI handler at
>> > any point.
>>
>> Except that NMI can interrupt #MC at any point as well, I think.
>
> No, #MC is higher prio than NMI, actually even the highest along with
> RESET#. And come to think of it, all exceptions which have a higher prio
> than NMI should touch that nmi_mce_nest_count thing.
>
> See Table 8-8 here:
>
> http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2012/10/24593_APM_v21.pdf
>
> That's the prios before 3, i.e. the NMI one.
>
> HOWEVER, this all is spoken with the assumption that higher prio
> interrupts can interrupt the NMI handler too at the first instruction
> boundary they've been recognized.
>
> The text is talking about simultaneous interrupts and not about
> interrupt handler preemption.
>
> But it must be because Steve wouldn't be dealing with exceptions in the
> NMI handler and nested NMIs otherwise...

I think that some of these exceptions are synchronous things (e.g.
int3 or page faults) that happen because the kernel caused them.

Anyway, going through the list:

Reset, INIT, and stpclk ought to be irrelevant -- we don't handle them anyway.

SMI is already supposedly correct wrt nesting inside NMI.

Debug register stuff should be handled in my outline.  Hopefully
correctly :)  We need to make sure that no breakpoints trip before the
nmi count is incremented, but that should be straightforward as long
as we don't do ridiculous things like poking at userspace addresses.
I don't know how kgdb/kdb fits in -- if someone sets a watchpoint on a
kernel address (e.g. the nesting count) or enables single-stepping,
we'll mess up.


It may pay to bump the nesting count inside the #DB and #BP handlers
and to check the RIP that we're returning to, but that starts to look
ugly, and we have to be careful about NMI, immediate breakpoint, and
them immediate MCE.  I'd rather just be able to say that there are
some very short windows in which a debug or breakpoint exception will
never happen.

--Andy

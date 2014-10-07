Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaJGSRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:17:17 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:45613 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaJGSRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:17:16 -0400
MIME-Version: 1.0
In-Reply-To: <54341013.2030509@caviumnetworks.com>
References: <5433071B.4050606@caviumnetworks.com> <20141006213101.GA23797@brightrain.aerifal.cx>
 <54330D79.80102@caviumnetworks.com> <20141006215813.GB23797@brightrain.aerifal.cx>
 <543327E7.4020608@amacapital.net> <54332A64.5020605@caviumnetworks.com>
 <20141007000514.GD23797@brightrain.aerifal.cx> <543334CE.8060305@caviumnetworks.com>
 <20141007004915.GF23797@brightrain.aerifal.cx> <54337127.40806@gmail.com>
 <20141007111102.GH23797@brightrain.aerifal.cx> <54341013.2030509@caviumnetworks.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 7 Oct 2014 11:16:54 -0700
Message-ID: <CALCETrWHE0nMZFthg_JP9dEABpvyumcKoHGn1-2q2F2nm2CvLg@mail.gmail.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
To: David Daney <ddaney@caviumnetworks.com>
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        libc-alpha <libc-alpha@sourceware.org>,
        David Daney <ddaney.cavm@gmail.com>,
        David Daney <david.daney@cavium.com>, Rich Felker <dalias@libc.org>,
        David Daney <david.s.daney@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 7, 2014 9:09 AM, "David Daney" <ddaney@caviumnetworks.com> wrote:
>
> On 10/07/2014 04:11 AM, Rich Felker wrote:
>>
>> On Mon, Oct 06, 2014 at 09:50:47PM -0700, David Daney wrote:
>>>>>
>>>>> the out-of-line execution trick, but do it somewhere other than in
>>>>> stack memory.
>>>>
>>>> How do you answer Andy Lutomirski's question about what happens when a
>>>> signal handler interrupts execution while the program counter is
>>>> pointing at this "out-of-line execution" trampoline? This seems like a
>>>> show-stopper for using anything other than the stack.
>>>
>>> It would be nice to support, but not doing so would not be a
>>> regression from current behavior.
>>
>>
>> It's not just "nice" to support, it's mandatory. Otherwise you will
>> execute essentially *random instructions* in this case, providing a
>> very nice attack vector that can almost certainly be elevated to
>> arbitrary code execution via timing of signals during floating point
>> code.
>>
>> The current behavior in regards to this is correct: because you have a
>> *stack*, each trampoline is pushed onto the stack in its own context,
>> and popped when it's no longer needed. You can have arbitrarily many
>> such trampolines up to the stack size. Note that each nested signal
>> handler already requires sizeof(ucontext_t) in stack space, so these
>> trampolines are a negligible additional cost without major effects on
>> the number of signal handlers you can nest without overflowing the
>> stack.
>
>
> Yes, the stack takes care of the allocations, but the current implementation has many problems:
>
> 1) Signals clobber the emulation area.
> 2) Signals caused by the emulation, have incorrect saved machine state.
>
> We have a low bar to pass, any new solution doesn't have to be perfect, it only has to be an improvement.
>
> Keep in mind that we are not starting from a clean slate, there are many years of legacy code that has built up here.

A lesson I learned when doing the x86 vsyscall stuff: Don't waste time
improving legacy crap without a really good reason.  Especially don't
extend the interface.  Deprecate it (without breaking working user
code) and move on.

--Andy

>
> David Daney

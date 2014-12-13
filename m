Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbaLMBp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 20:45:26 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:37319 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbaLMBpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 20:45:25 -0500
MIME-Version: 1.0
In-Reply-To: <548B8716.7000106@sr71.net>
References: <20141212191213.579887D2@viggo.jf.intel.com> <548B4E75.5010507@amacapital.net>
 <548B4FBE.5090101@sr71.net> <CALCETrW4f3EUYGG_zyzb7sZBXaoW3eHMpTn3dd3WpDgJq2HjtA@mail.gmail.com>
 <548B60F4.6020903@sr71.net> <CALCETrVZcED1x+YV4V+c9nnieaz8DMbO4D455h2QYF__jX-DKg@mail.gmail.com>
 <548B7764.2060608@sr71.net> <CALCETrVEDS9Os5P11ub+FxHsDACgDWnkC4N6yqquQSfUv-=3kw@mail.gmail.com>
 <548B8716.7000106@sr71.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 12 Dec 2014 17:45:03 -0800
Message-ID: <CALCETrXt4yi6GC1f-gRYRYHuOue0-RfCWhQqJL0XK0hdUurDxA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/8] x86, mpx: Support 32-bit binaries on 64-bit kernels
To: Dave Hansen <dave@sr71.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 4:23 PM, Dave Hansen <dave@sr71.net> wrote:
> On 12/12/2014 04:11 PM, Andy Lutomirski wrote:
>> On Fri, Dec 12, 2014 at 3:16 PM, Dave Hansen <dave@sr71.net> wrote:
>>> On 12/12/2014 03:04 PM, Andy Lutomirski wrote:
>>>> Anyway, do your patches handle the case where a 32-bit app maliciously
>>>> executes a 64-bit mpx insn with a very large address?  I think it's
>>>> okay, but I might have missed something.
>>>
>>> You mean in the instruction decoder?  I haven't tried that case
>>> explicitly, but I did do a substantial amount of testing throwing random
>>> instruction streams at the decoder to make sure it never fell over.
>>> (Well, mostly random, I made sure to throw the MPX opcodes in there a
>>> bunch so it would get much deeper in to the decoder).
>>>
>>> It's not about the instruction size, it's about the mode the CPU is in.
>>> If a 32-bit app manages to switch over to 64-bit mode and doesn't tell
>>> the kernel (TIF_IA32 remains set), then we'll treat it as a 32-bit
>>> instruction.
>>
>> The insn decoder should probably use user_64bit_mode, not TIF_IA32.
>> It's actually quite easy to far jump/call/ret or sigreturn to a
>> different bitness.
>
> There are number of examples of this in the kernel today:
>
> #ifdef CONFIG_X86_64
>                 is_64bit = kernel_ip(to) || !test_thread_flag(TIF_IA32);
> #endif
>                 insn_init(&insn, kaddr, size, is_64bit);
>
> Are you saying that those need to get fixed up?
>

Yes, although so far it looks like the only real danger with them is
that userspace could shoot itself in the foot.

>>> The kernel might end up going and looking for the bounds tables in some
>>> funky places if the kernel and the hardware disagree about 32 vs. 64-bit
>>> modes, but it's not going to do any harm since we treat all of the data
>>> we get from MPX (instruction decoding, register contents, bounds table
>>> contents, etc...) as completely untrusted.
>>>
>>> It's a nice, paranoid thing to ask and I'm glad you brought it up
>>> because I hadn't thought about it, but I don't think any harm can come
>>> of it.
>>
>> Paranoia is fun!
>>
>> The only thing I'd really be worried about is if the code that turns
>> va into bounds table offset generates some absurdly large offset as a
>> result and causes a problem.
>
> The instructions that get decoded have *NOTHING* to do with the mode
> we're running in.  By the time we take a bounds fault and copy the
> instruction in from the instruction pointer, we have absolutely no idea
> what was actually being executed, no matter what mode we are running in.
>
> I believe the instruction decoder already happily handles this.
>
> Furthermore, we don't even *USE* the result of the instruction decode in
> the kernel.  We toss it in to the siginfo and hand it out to userspace.

Hmm.  I may have confused myself.

I was thinking of this:

+ if (is_64bit_mm(mm)) {
+       vaddr_space_size = 1ULL << __VIRTUAL_MASK_SHIFT;
+ bd_entry_virt_space = vaddr_space_size / MPX_BD_NR_ENTRIES_64;
+ /*
+ * __VIRTUAL_MASK takes the 64-bit addressing hole
+ * in to accout.  This is a noop on 32-bit.
+ */
+ addr &= __VIRTUAL_MASK;
+ return addr / bd_entry_virt_space;
+ } else {
+       vaddr_space_size = (1ULL << 32);
+ bd_entry_virt_space = vaddr_space_size / MPX_BD_NR_ENTRIES_32;
+ return addr / bd_entry_virt_space;
+ }

Is there a scenario in which the return value ends up being insanely
high?  If so, does it matter?

--Andy

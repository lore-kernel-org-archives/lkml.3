Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbaIZMfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:35:43 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:38118 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbaIZMfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:35:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140926092539.GA9649@gmail.com>
References: <1411313216-2641-1-git-send-email-minipli@googlemail.com>
	<1411313216-2641-3-git-send-email-minipli@googlemail.com>
	<541F2BCD.2040007@linux.intel.com>
	<CA+rthh_UJWqeTJP9aewuC0HRo9wnucy5GScqYH0=0ob=bn4nBw@mail.gmail.com>
	<20140924074555.GA3797@gmail.com>
	<CA+rthh9HRMg0E3gE11F+KSdyMpjYC6d=gZhcu5-1TDqMfAw3Uw@mail.gmail.com>
	<20140926092539.GA9649@gmail.com>
Date: Fri, 26 Sep 2014 14:35:41 +0200
Message-ID: <CA+rthh-r60-0VDy0PpF5hw32S_ox7by3iQdM-evHSEYx0Cb08Q@mail.gmail.com>
Subject: Re: [PATCHv2 2/3] x86, ptdump: Simplify page flag evaluation code
From: Mathias Krause <minipli@googlemail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2014 11:25, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Mathias Krause <minipli@googlemail.com> wrote:
>
>> On 24 September 2014 09:45, Ingo Molnar <mingo@kernel.org> wrote:
>> > * Mathias Krause <minipli@googlemail.com> wrote:
>> >> On 21 September 2014 21:49, Arjan van de Ven <arjan@linux.intel.com> wrote:
>> >> > On 9/21/2014 8:26 AM, Mathias Krause wrote:
>> >> >>
>> >> >> -               if (pr & _PAGE_PCD)
>> >> >> -                       pt_dump_cont_printf(m, dmsg, "PCD ");
>> >> >> -               else
>> >> >> -                       pt_dump_cont_printf(m, dmsg, "    ");
>> >> >> +               pt_dump_cont(m, dmsg, "%-4s", pr & _PAGE_USER ? "USR" :
>> >> >> "");
>> >> >
>> >> >
>> >> > while you have some nice cleanups in your patch, I can't say I consider this
>> >> > an improvement.
>> >> > Yes the C standard allows ? to be used like this
>> >> > but no, I don't think it improves readability in general.
>> >>
>> >> Not in general, but in this case, it does, IMHO.
>> >>
>> >> > (I think for me the main exception is NULL pointer cases, but this is not
>> >> > one of these)
>> >>
>> >> Apparently such a pattern (using the question mark operator combined
>> >> with a bit test to choose string constants) is used quite often in the
>> >> linux kernel as a simple grep tells me (probably catches a few false
>> >> positives but still a representative number):
>> >
>> > Both can be used (although I too find the original version easier
>> > to read), and it's usually the taste/opinion of the original
>> > author whose choice we prefer.
>>
>> So I should start writing more code from the scratch than changing
>> others... ;)
>>
>> But concerning this patch, are you interested in the following other
>> pieces:
>> - changing the macros from being a compound statement expression to
>>   the common 'do .. while(0)' pattern
>> - use of pr_info()/pr_cont() instead of printk(KERN_INFO/KERN_CONT)
>> - use of format strings in pt_dump_cont_printf() calls
>> - removing the trailing blank before '\n' in the "... # entries
>>   skipped ..." message
>> ...or should I just drop patch 2 altogether?
>
> Honestly? I'm not interested at all in self-centered make-work
> cleanups that don't really improve the code materially - I'm more
> interested in cleanups that are a side effect of real work and
> real interest.

That's exactly what this patch was all about. A cleanup patch in the
middle of a series fixing one issue (patch 1) and extending the
functionality (patch 3). The latter was touching the code this patch
tries to clean-up. At least for *me* it makes the code more readable
as it's now more compact -- one print call per flag. Others may have
different opinions which is perfectly fine. But still, why do think
this is "self-centered make-work"?

To recap, patch 1 makes the EFI runtime mappings visible again, commit
3891a04aafd6 broke. I really *do* want to see, that those are RWX
mapped into the kernel address space, so this nastiness is visible --
not wiped under the carpet. It's a nice little attack surface for all
those SMEP enabled systems, attackers are probably aware of but, after
commit 3891a04aafd6, we're not so much any more. While trying to do
something about it (playing with protection flags on the PGD level) I
noticed the page table dump code did not honor those. So I fixed that
too in patch 3. An improvement to the code I immediately could make
use of.

>
> There's literally 1 million checkpatch 'failures' in the kernel
> source code, do we really want to clean them all up, waste
> reviewer and maintainer bandwidth and pretend that those 1
> million extra cleanup commits are just as valuable as the 'other'
> work that goes on in the kernel?

I don't think the time is wasted if the end result is cleaner and more
readable code. If those commits are as valuable as "real" commits? I
don't think so either. But they still have value -- making code more
readable and fixing small bugs.

>
> Why don't you do something different: for example something
> functionally useful (some real improvements to the code!), and
> make sure it's all clean while you are doing it? That gives an
> opportunity to clean up anything that your changes touch as well.

I though that's what I have done in this series, as explained above.
Why do you think it does not?

Fiddling with EFI is a PITA, I can tell you. So having tools
supporting me while debugging issues I have is valuable. I thought, it
might be valueable for others, too. Why do you think this is not the
case?

>
> We always welcome cleanups that are a side effect of feature
> work. Cleanups for code that is perfectly readable, just for
> cleanup's sake, is counterproductive ...
>
> Doing printk() formatting fixes is fine for a newbie, but as I
> told Perches a couple of times already, and as I told Bunk before
> him, most kernel developers grow beyond printk() fixes after
> their first few commits.

Thanks, I'm fine. I've contributed other, imho valuable things in the
past already. But I'm no "professional" kernel developer whatsoever.
I'm doing most of this in my spare time. It's a hobby of mine. Nothing
more.


Thanks,
Mathias

>
> Thanks,
>
>         Ingo

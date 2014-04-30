Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759759AbaD3XsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 19:48:10 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:41746 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbaD3XsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 19:48:08 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVQiZPb1M183Fq61dbFAjnJScuB2y+rdH8BQ+yp-MO+Mw@mail.gmail.com>
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
 <1398723161-21968-5-git-send-email-andi@firstfloor.org> <535FED4D.5000703@amacapital.net>
 <20140429233950.GE2382@two.firstfloor.org> <53608180.5070800@zytor.com> <CALCETrVQiZPb1M183Fq61dbFAjnJScuB2y+rdH8BQ+yp-MO+Mw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 30 Apr 2014 16:47:47 -0700
Message-ID: <CALCETrVinnPtBPXDRhb=kZFTKKWrG8G=mxfYbGfBm9zucKw1cw@mail.gmail.com>
Subject: Re: [PATCH 4/7] x86: Add support for rd/wr fs/gs base
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 4:44 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Apr 29, 2014 at 9:52 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 04/29/2014 04:39 PM, Andi Kleen wrote:
>>>> Case 3 is annoying.  If nothing tries to change the user gs base, then
>>>> everything is okay because the user gs base and the kernel gs bases are
>>>> equal.  But if something does try to change the user gs base, then it
>>>> will accidentally change the kernel gs base instead.
>>>
>>> It doesn't really matter, as they are the same.
>>> They would just switch identities.
>>>
>>> Besides I don't think anyone does that.
>>>
>>
>> It matters -- greatly -- if (and only if) we can enter the kernel with
>> usergs == kernelgs and then want to change usergs inside a paranoid
>> routine.  At that point we risk being upside down, which basically means
>> we're rooted.
>>
>> However, I believe this patchset also means only IST entries can be
>> paranoid, which in turn means we can't sleep inside them.  To the very
>> best of my knowledge the only times we change usergs is on context
>> switch or inside a system call.  We need to make sure that is actually
>> the case, though.
>>
>> I'm at ELC for a few days, so I'll have limited decent-sized-monitor
>> time, but it shouldn't be too hard to convince ourselves of... mostly a
>> matter of making sure something like ptrace can't to stupid crap.
>
> The only things that look relevant are the context switch paths and
> the kvm stuff.  I don't know what happens if an IST exception happens
> while running a guest, though.  TBH I have no idea what the VMX and
> SVM interfaces look like.
>
> paranoid_schedule looks scary.  If I'm understanding it correctly, it
> expects to be executed with gs == usergs.  I think it's okay, since it
> will only be invoked if we trapped from userspace, in which case the
> state is well-defined.  But this bit could be wrong:
>
>     testl %ebx,%ebx                /* swapgs needed? */
>     jnz paranoid_restore
>     testl $3,CS(%rsp)
>     jnz   paranoid_userspace
>
> If usergs == kernelgs, then ebx will always be 1 and we'll never end
> up in paranoid_userspace.
>
> This could be fixed in two ways.  We could just switch the order of
> the tests, since the only way to have ebx == 1 and CS with CPL == 3
> should be if we're coming from userspace with usergs==kernelgs.  Or we
> could get rid of the paranoid schedule code entirely.  It is actually
> needed for anything?  Timer and rescheduling interrupts shouldn't be
> paranoid, and if there's any paranoid code that will trigger a
> reschedule, couldn't it do it much more sanely by sending an IPI to
> self and thus deferring the reschedule until interrupts are enabled?

Having just asked this, isn't the current code already broken if
something like an NMI or MCE tried to reschedule the current cpu?  It
could hit just before running hlt in the non-polling idle loop or it
could happen during execution of a kernel thread.  In either case, I
don't see why anything is guaranteed to notice the resched flag being
set.

--Andy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbaIKP1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:27:10 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:57209 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaIKP1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:27:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140910175126.GJ1710@arm.com>
References: <1409781429-27593-1-git-send-email-keescook@chromium.org>
	<1409781429-27593-4-git-send-email-keescook@chromium.org>
	<20140904170349.GL7156@arm.com>
	<CAGXu5jKimGaupwyUwt0Zwa3OtjeoED8-uBeMX0MwXjBYP6ssAg@mail.gmail.com>
	<20140904172748.GO7156@arm.com>
	<20140908191634.GV5598@outflux.net>
	<20140908215506.GA4759@dator>
	<CAGXu5jJFB+pcDVkcMoRZ9DnJu7MQuN=kceDhpkGrO=6ZLFy6Kw@mail.gmail.com>
	<20140909123829.GK1754@arm.com>
	<CAGXu5jJoW-B7WwuFUhbN4e1aL-HVxa9x4da9hB9DcCGEXVLgzw@mail.gmail.com>
	<20140910175126.GJ1710@arm.com>
Date: Thu, 11 Sep 2014 08:27:06 -0700
X-Google-Sender-Auth: dJ794W7fduhLVzHMJ6JXLpOnjXU
Message-ID: <CAGXu5jJaML_S+6LUn1uPLrScXxUJL+1N1B+Fa08ioxKt933nCw@mail.gmail.com>
Subject: Re: [PATCH v5 3/8] arm: fixmap: implement __set_fixmap()
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Rabin Vincent <rabin@rab.in>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh@kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:51 AM, Will Deacon <will.deacon@arm.com> wrote:
> Hi Kees,
>
> On Tue, Sep 09, 2014 at 03:33:11PM +0100, Kees Cook wrote:
>> On Tue, Sep 9, 2014 at 5:38 AM, Will Deacon <will.deacon@arm.com> wrote:
>> > On Mon, Sep 08, 2014 at 11:40:43PM +0100, Kees Cook wrote:
>> >> Ah, so it was, yes! Will, which version of this logic would you prefer?
>> >
>> > I still don't think we're solving the general problem here -- we're actually
>> > just making the ftrace case work. It is perfectly possible for another CPU
>> > to undergo a TLB miss and refill whilst the page table is being modified by
>> > the CPU with preemption disabled. In this case, a local tlb flush won't
>> > invalidate that entry on the other core, and we have no way of knowing when
>> > the original permissions are actually observed across the system.
>>
>> The fixmap is used by anything doing patching _except_ ftrace,
>> actually. It's used by jump labels, kprobes, and kgdb. This code is
>> the general case. Access to set_fixmap is done via the kernel patching
>> interface: patch_text().
>>
>> Right now, the patch_text interface checks cache_ops_need_broadcast(),
>> and conditionally runs under stop_machine(). We could make this
>> unconditional, and we'll avoid any problem with TLB misses on another
>> CPU.
>
> Yes, it we always use stop_machine, that solves the TLB broadcast problem
> and we could do that if CONFIG_ARM_ERRATA_798181 is set.

Okay, sounds good.

>
>> > So I think we need to figure out a way to invalidate the TLB properly. What
>> > do architectures that use IPIs for TLB broadcasting do (x86, some powerpc,
>> > mips, ...)? They must have exactly the same problem.
>>
>> I don't think this should be done at the set_fixmap level, as it is
>> more a primitive. I think making sure patch_text() always works would
>> be best. What do you think of using an unconditional stop_machine()
>> instead?
>
> Why not move the TLB invalidation into patch_text, then we can do
> stop_machine if IS_ENABLED(CONFIG_ARM_ERRATA_798181) ||
> tlb_ops_need_broadcast()?

The (local) TLB flush needs to happen for patch_text to do its work,
so I'd rather it stay in set_fixmap, otherwise the flush calls will
have to follow each call of set_fixmap.

Is there a reason tlb_ops_need_broadcast() doesn't check
IS_ENABLED(CONFIG_ARM_ERRATA_798181) itself?

> Then that just leaves ftrace.

ftrace is already covered by stop_machine. Is there something I missing there?

-Kees

-- 
Kees Cook
Chrome OS Security

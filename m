Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaBRSKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:10:06 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:36267 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaBRSKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:10:03 -0500
MIME-Version: 1.0
In-Reply-To: <20140217123415.GA2182@e103592.cambridge.arm.com>
References: <1392339850-18686-1-git-send-email-keescook@chromium.org>
	<1392339850-18686-3-git-send-email-keescook@chromium.org>
	<20140214162257.GB2331@e103592.cambridge.arm.com>
	<CAGXu5jLmYLQpu9CDhoL-2OTdwxqrfVCFbojmpjpcpLqmA=wWYA@mail.gmail.com>
	<20140217123415.GA2182@e103592.cambridge.arm.com>
Date: Tue, 18 Feb 2014 10:10:03 -0800
X-Google-Sender-Auth: 4UXdof9_g1Gs28moDaCI7QnRPwQ
Message-ID: <CAGXu5j+s70cNVVGf_T4=MqJ0TeYOFAyfWNUozWvHJ4-BvX-yKg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: mm: keep rodata non-executable
From: Kees Cook <keescook@chromium.org>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Larry Bassel <lbassel@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Jiang Liu <liuj97@gmail.com>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Laura Abbott <lauraa@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Vitaly Andrianov <vitalya@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Simon Baatz <gmbnomis@gmail.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 4:34 AM, Dave Martin <Dave.Martin@arm.com> wrote:
> On Fri, Feb 14, 2014 at 11:11:07AM -0800, Kees Cook wrote:
>> On Fri, Feb 14, 2014 at 8:22 AM, Dave Martin <Dave.Martin@arm.com> wrote:
>> > On Thu, Feb 13, 2014 at 05:04:10PM -0800, Kees Cook wrote:
>> >> Introduce "CONFIG_DEBUG_RODATA" to mostly match the x86 config, though
>> >> the behavior is different: it depends on STRICT_KERNMEM_PERMS, which
>> >> sets rodata read-only (but executable), where as this option additionally
>> >> splits rodata from the kernel text (resulting in potentially more memory
>> >> lost to padding) and sets it non-executable as well. The end result is
>> >> that on builds with CONFIG_DEBUG_RODATA=y (like x86) the rodata with be
>> >> marked purely read-only.
>> >
>> > This triggers an Oops in kexec, because we have a block of code in .text
>> > which is a template for generating baremetal code to relocate the new
>> > kernel, and some literal words are written into it before copying.
>>
>> You're writing into the text area? I would imagine that
>> CONFIG_ARM_KERNMEM_PERMS would break that. However, that's not the
>> right place to be building code -- shouldn't the module area be used
>> for that?
>>
>> > Possibly this should be in .rodata, not .text.
>>
>> Well, rodata should be neither writable nor executable.
>
> We're not writing into code exactly.
>
> This code is never executed in-place in vmlinux.  It gets copied, and
> only copies are ever executed.
>
> Some pointers and offsets get poked into the code to configure it.
>
> I think it would be better simply to put the code in .rodata, and
> poke paramaters into the copy, not the original -- but that's a bit
> more awkward to code up, since the values can't be poked simply by
> writing global variables.

Okay, interesting. I'll be curious to see what the patch for this looks like.

>> > There may be a few other instances of this kind of thing.
>>
>> This config will certainly find them! :) But, that's why it's behind a config.
>
> I haven't tested exhaustively, but it think this is sufficient for a
> Tested-by.  The patch does seem to be doing what it is intended to
> do, and doesn't seem to be triggering false positives all over the
> place.

Great, thanks for taking the time to check on it!

Should I send this to the patch tracker, or wait for more feedback?

>> > Are you aware of similar situations on other arches?
>>
>> I think there were some problems a long time ago on x86 for rodata too.
>
> It would be good to get this kexec case fixed -- I'll try to hack up
> a separate patch.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security

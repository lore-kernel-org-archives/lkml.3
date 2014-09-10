Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaIJRRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:17:25 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:57221 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaIJRRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:17:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140908135436.GC22717@arm.com>
References: <1409173419-13076-1-git-send-email-sonnyrao@chromium.org>
	<CAOesGMjK65Rc-K0fyFUUJLw6huLT82E-nqJwZO4PqhgopF96Ow@mail.gmail.com>
	<CAPz6YkWAPtuy4sAuAK9GtpDgfGsccxeS+pqqe_t_R818Jt01qA@mail.gmail.com>
	<53FE5B09.2020403@codeaurora.org>
	<CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com>
	<53FE7E3B.1010500@codeaurora.org>
	<CAOesGMgXnsqttHwAxEW4a7-Rx-nmSwpJd_Dt1iCcFOvzDwbzdA@mail.gmail.com>
	<CAD=FV=VjN6Xam-nRRcxvOoN-gokU6DbGVjoPXN_fkTJssH1RWA@mail.gmail.com>
	<20140828093505.GC14650@leverpostej>
	<CAD=FV=UwfP0x-bswbtV_eUvpKeOSNnsVVLTE3VHguyhm_jiSug@mail.gmail.com>
	<20140908135436.GC22717@arm.com>
Date: Wed, 10 Sep 2014 10:17:23 -0700
X-Google-Sender-Auth: ynNvWpyNy8zHlhRmjsRHmApyDEQ
Message-ID: <CAD=FV=Up=+zNneY-behnkFbhupi50_f5R=ECgJQeqGV5kz5d2g@mail.gmail.com>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
From: Doug Anderson <dianders@chromium.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Sonny Rao <sonnyrao@chromium.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin,

On Mon, Sep 8, 2014 at 6:54 AM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Fri, Sep 05, 2014 at 11:11:47PM +0100, Doug Anderson wrote:
>> On Thu, Aug 28, 2014 at 2:35 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>> > Not if you boot Linux at hyp, as we've recommended for this precise
>> > reason. That doesn't fix other things like CNTFRQ if the secure
>> > initialisation doesn't poke that, however.
>>
>> I'll freely admit that I'm out of my league and out of my comfort zone
>> here, but...
>>
>> In the theory that firmware ought to be as minimal as possible
>> (because it's hard to update and hard to keep in sync with kernel
>> versions), it seems like firmware ought to start the kernel out in as
>> permissive mode as it's willing to provide, right?
>
> Not necessarily (and definitely not for arm64). And we've seen in
> practice that the actual deployed kernel may run in a different security
> mode than what's in mainline and used for initial development (you may
> just not see all the patches upstream). For development, that's indeed
> simpler, but once you go into production, a customer requesting some
> secure OS for payments etc. and Linux is moved to the non-secure side
> (and you end up putting hacks in the kernel because they were not
> spotted during initial development with Linux running in secure mode).

I guess the important part of my statement is "as it's willing to
provide".  In your case your firmware isn't willing to provide "secure
SVC".  In our case it is.

We've actually shipped products where the firmware boots the kernel in
"secure" mode.  These products have a very different security model
than you're envisioning, I guess.  In these products, less firmware is
better and adding firmware code to do the whole transition to "non
secure hyp mode" just isn't worth it.  It's not just a one-time blob
of code in the firmware before booting the kernel.  (I'm told) it
means somehow keeping firmware code around to help out with turning
processors off/on and to help with resume from S3.  That's
infrastructure that we don't want to add.

To put it another way: if you're already architecting your system to
have firmware manage the secure state then everything you have said
makes sense.  You've got to solve all the problems (processor bringup,
suspend/resume, etc) anyway, so being consistent about having the
kernel in nonsecure HYP makes sense.  ...but if you have no need to
ever limit access to "secure mode" then adding a whole lot of code to
the firmware doesn't make sense to me.


>> If the kernel is started out as permissive as possible then it can do
>> anything it needs to.  Future versions of the kernel can be
>> implemented to do any way-cool things that they want to do without an
>> update to firmware, right?  ...and current versions of the kernel can
>> just shed permissions if they don't want them.
>>
>> ...so if I understand correctly, "Secure SVC" mode is more permissive
>> than "Non Secure HYP" mode, right?  It looks to me as if we currently
>> start the kernel in "Secure SVC" mode.  What do you think about the
>> kernel detecting Secure SVC and then dropping down permission levels
>> (to Non Secure HYP).  Once it did this, it could update things like
>> the virtual offset and then transition down further into non-secure
>> SVC mode.
>
> If we talk about ARMv8/AArch64, Secure SVC (aka secure EL1) is not more
> permissive than Non-secure Hyp (aka non-secure EL2). The only way to go
> from secure EL1 to non-secure EL2 is via EL3 (and SMC call) which means
> firmware code. Certain registers like CNTFRQ are only writable in EL3,
> CNTVOFF in EL2 or EL3.

Hmmm, I guess I was under the impression that if you were in Secure
SVC mode then you are guaranteed to have enough access that you could
control where the SMC call would go.  Thus you could install your own
SMC handler and effectively transition yourself from Secure SVC to
Monitor mode, then to Hypervisor mode.

I was also under the impression that if you were in Nonsecure HYP mode
that you couldn't guarantee that you could control the transition back
to Secure SVC mode.

If the above is incorrect then I guess my statement is incorrect.  Can
you confirm?


...however, even if "Secure SVC" isn't guaranteed to be more
permissive than "Nonsecure HYP", it is often the case that you can
transition from "Secure SVC" to "Nonsecure HYP" (by setting up
handlers, etc) because the system hasn't been locked down.  Given that
if we "do nothing" in firmware we seem to boot the kernel in Secure
SVC w/ the ability to transition to Nonsecure HYP, that seems like a
good reason for the kernel to be able to handle that switching.


-Doug

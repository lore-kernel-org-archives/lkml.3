Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbaAHTnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:43:32 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:40107 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaAHTna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:43:30 -0500
MIME-Version: 1.0
In-Reply-To: <20140108192028.GM27432@n2100.arm.linux.org.uk>
References: <1389187991-26446-1-git-send-email-gautam.vivek@samsung.com>
	<20140108143529.GB14122@mudshark.cambridge.arm.com>
	<CAD=FV=WYe7Qk_XPs=FCeB7pbDz8AnG0txFcDyAQWWAU60vd-Sw@mail.gmail.com>
	<20140108192028.GM27432@n2100.arm.linux.org.uk>
Date: Wed, 8 Jan 2014 11:43:29 -0800
X-Google-Sender-Auth: LWyziB22y6kqmTGdGe4jjpXaODU
Message-ID: <CAD=FV=Ui8kec5vYA1jRT3EGNaUeWX-Ua5sUs+u3wdRz1oFnTzw@mail.gmail.com>
Subject: Re: [PATCH] arm: Add Arm Erratum 773769 for Large data RAM latency.
From: Doug Anderson <dianders@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        David Garbett <David.Garbett@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 8, 2014 at 11:20 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Jan 08, 2014 at 08:21:21AM -0800, Doug Anderson wrote:
>> WIll,
>>
>> Thanks for your comments!
>>
>> On Wed, Jan 8, 2014 at 6:35 AM, Will Deacon <will.deacon@arm.com> wrote:
>> > NAK. Whilst I appreciate that you may not be able to fix your bootloader,
>> > this isn't the right change to make in the kernel. Blindly changing memory
>> > latencies is likely to do more harm than good for a multi-platform kernel,
>> > even if it works for exynos 5250. The only alternative I can think of (if you
>> > have to make a mainline kernel change) is to restrict the clock frequencies at
>> > which the CPU is allowed to run, although that obviously requires some
>> > investigation in order to determine how viable it is for your SoC.
>
> +1
>
>> I'll start off by saying that I'm totally OK if mainline doesn't want
>> this fixed.  If mainline is not interested in running reliably on
>> exynos5250-based products then there's nothing I can do about it.  It
>> seems unfortunate, but I'm not going to get into a shouting match
>> about it.
>
> No, we're saying to put the work-around in the boot loader, not the kernel.

Unfortunately the resume path of the firmware runs from Read Only
firmware code (yes, it sucks), so it's not totally trivial to fix.  It
would be possible for someone to unscrew their write protect switch
and update their RO firmware, but that doesn't help the average user.

Olof came up with the idea that you could update the RW firmware
(affects initial boot) and then cache away the value and restore it in
the kernel after resume.  That would still require a kernel patch but
perhaps a less objectionable one.  ...of course if writing this
register is a problem in secure mode then maybe that patch would be
NAKed anyway.


>> * Is guarded by a runtime check of the revision number so that it
>> doesn't run on unaffected A15 revisions.
>
> So what if the A15 reports an affected revision, but the SoC integrator
> has fixed the problem - why should they have to put up with the work-
> around being applied on their silicon?

That's one I didn't think about, you're right.  ...but we're really
getting into hypothetical situations here.  Are there any r2p0
products that have such a fix (and thus require a latency of >= 4)?


> We've been through these arguments many times, you're not the first to
> raise it, and we've decided upon the policy.  We want as _few_ work-
> arounds in the kernel as possible, because applying the work-arounds
> is very problematical with the mixture of secure and non-secure booting.

OK, fair enough.  If we want no workaround here then we can drop this patch.


I'd guess that the way forward is:

* Land kernel workaround locally in Chromium tree

* I'll try to land FW change locally in at least one Chromium branch.
If we were to get a new RO build ever (seems unlikely at this point)
it would be fixed for upstream kernels.  If we were to get a new RW
build (seems unlikely, but at least less unlikely) it would be fixed
if someone landed a kernel patch to save/restore this register across
suspend/resume.

* If Joe Upstream wants to run an upstream kernel on some type of
exynos5250 product (Samsung ARM Chromebook, HP Chromebook 11, Nexus 10
are the ones I know of) then he will deal with the small number of
crashes or figure out a solution.


-Doug

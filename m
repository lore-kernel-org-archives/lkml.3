Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936124AbaH1Dde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 23:33:34 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:47284 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbaH1Ddc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 23:33:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMgXnsqttHwAxEW4a7-Rx-nmSwpJd_Dt1iCcFOvzDwbzdA@mail.gmail.com>
References: <1409173419-13076-1-git-send-email-sonnyrao@chromium.org>
	<CAOesGMjK65Rc-K0fyFUUJLw6huLT82E-nqJwZO4PqhgopF96Ow@mail.gmail.com>
	<CAPz6YkWAPtuy4sAuAK9GtpDgfGsccxeS+pqqe_t_R818Jt01qA@mail.gmail.com>
	<53FE5B09.2020403@codeaurora.org>
	<CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com>
	<53FE7E3B.1010500@codeaurora.org>
	<CAOesGMgXnsqttHwAxEW4a7-Rx-nmSwpJd_Dt1iCcFOvzDwbzdA@mail.gmail.com>
Date: Wed, 27 Aug 2014 20:33:31 -0700
X-Google-Sender-Auth: mfYqEjUdqxa7s7AAbt3LMgmHsZ4
Message-ID: <CAD=FV=VjN6Xam-nRRcxvOoN-gokU6DbGVjoPXN_fkTJssH1RWA@mail.gmail.com>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
From: Doug Anderson <dianders@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Sonny Rao <sonnyrao@chromium.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 27, 2014 at 7:58 PM, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Aug 27, 2014 at 5:56 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> On 08/27/14 15:33, Olof Johansson wrote:
>>> On Wed, Aug 27, 2014 at 3:26 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>>
>>>> Is there any reason why the virtual counter can't be read? Maybe we're
>>>> the hyp and we need to make sure we don't use the virtual timer so that
>>>> the guest can use it, but that doesn't have any effect on the usage of
>>>> the virtual counter for the clocksource.
>>> There are several cases where virtual is unusable -- in particular it
>>> might not have been configured properly (i.e. the phys/virt offset is
>>> at a bad value).
>>>
>>
>> Any specifics? It would be nice to say so in the commit text so that
>> others using such devices know they need this patch. I'm guessing the
>> firmware can't be fixed?

Even if we could change things to use a virtual timer in some cases,
Sonny's patch still fixes a bug.  The code as written right now makes
pretenses about supporting the physical timer, but it doesn't work.
That should be fixed.


> Yeah, there are a few. The big.LITTLE on the Chromebook 2 models have
> this issue, due to the A7 cluster having an incorrect offset
> programmed. However, arch timers aren't supported on that SoC in the
> first place, so it's not a problem in reality.
>
> The other known platform is rk3288. It has products out in the wild
> where firmware updates are unlikely.

One other reason is that (I'm told) that the virtual offset is lost in
certain power down conditions (powering down a core, going into S3,
etc).  When we power back up the offset is effectively reset to a
random value.  That means we need something to reprogram the virtual
timer offset whenever we power things back up.

If we've got a hypervisor then the hypervisor will definitely be
involved in powering things back up and it can reset the virtual
offset.  ...but forcing systems to implement a hypervisor (or somehow
adding an interface for the kernel to call back into firmware) is a
huge effort and it means more hard-to-update code sitting in firmware.

Note: having the virtual offset initted to a random value seems like
an unfortunate design choice for the virtual timer offset
(guaranteeing it was initted to 0 would have avoided the problem), but
that's what we seem to have.


-Doug

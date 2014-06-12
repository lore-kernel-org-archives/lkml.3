Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbaFLQyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:54:00 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:38949 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213AbaFLQx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:53:58 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406042004140.3319@nanos>
References: <1401903034-20074-1-git-send-email-dianders@chromium.org>
	<1401903034-20074-3-git-send-email-dianders@chromium.org>
	<alpine.DEB.2.10.1406042004140.3319@nanos>
Date: Thu, 12 Jun 2014 09:53:57 -0700
X-Google-Sender-Auth: -6RohUVonABkGIAKaJ27G7uVmRQ
Message-ID: <CAD=FV=VSPF8rD_JQivxizSkwMfjkKC6QeL_fDC_0RQvHQsYRCA@mail.gmail.com>
Subject: Re: [PATCH 3/3] clocksource: exynos_mct: Optimize register reads with ldmia
From: Doug Anderson <dianders@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Chirantan Ekbote <chirantan@chromium.org>,
        David Riley <davidriley@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Wed, Jun 4, 2014 at 11:05 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 4 Jun 2014, Doug Anderson wrote:
>
>> As we saw in (clocksource: exynos_mct: cache mct upper count), the
>> time spent reading the MCT shows up fairly high in real-world
>> profiles.  That means that it's worth some optimization.
>>
>> We get a roughly 10% speedup in userspace gettimeofday() by using an
>> ldmia to read the two halfs of the MCT.  That seems like a worthwhile
>> thing to do.
>>
>> Before: 1173084 us for 1000000 gettimeofday in userspace
>> After:  1045674 us for 1000000 gettimeofday in userspace
>>
>> NOTE: we could actually do better than this if we really wanted to.
>> Technically we could register the clocksource as a 32-bit timer and
>> only use the "lower" half.  Doing so brings us down to 1014429 us for
>> 1000000 gettimeofday in userspace (and doesn't even require assembly
>> code).  That would be an alternative to this change.
>
> I was about to ask exactly that question: What's the advantage of the
> 64 bit dance there? AFAICT nothing.

Are you explicitly naking the 64-bit version of these patches?  If so
I'll send out the 32-bit version right away.  If nothing else we
should get the ftrace fix (patch 1 in this series) landed ASAP since
that fixes a regression.  I'd like to make the 32-bit decision first
though since fixing the regression is easier in the 32-bit version.

Roughly: with the 64-bit version there's no question that we're not
regressing anyone's functionality or performance and it's nearly as
fast as the 32-bit version.  The 32-bit version is simpler / faster
but has the potential to cause (unknown) problems.

-Doug

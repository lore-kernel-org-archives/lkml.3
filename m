Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaKJOLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:11:48 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:45985 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaKJOLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:11:47 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1411070948180.1214-100000@iolanthe.rowland.org>
References: <1415347601.8532.7.camel@AMDC1943>
	<Pine.LNX.4.44L0.1411070948180.1214-100000@iolanthe.rowland.org>
Date: Mon, 10 Nov 2014 15:11:45 +0100
Message-ID: <CAPDyKFpCx9XZu7xWt+koY-iLmiX4+XPu+2hGow2hrz3AR8Cb=A@mail.gmail.com>
Subject: Re: [PATCH v10 1/5] PM / Runtime: Allow accessing irq_safe if no PM_RUNTIME
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2014 15:50, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 7 Nov 2014, Krzysztof Kozlowski wrote:
>
>> > Well, that is a good reason to introduce a wrapper around power.irq_safe in my
>> > view.
>> >
>> > And define the wrapper so that it always returns false for CONFIG_PM_RUNTIME
>> > unset.
>> >
>> > This way not only you wouldn't need to move the flag from under the #ifdef,
>> > but also you would make the compiler skip the relevant pieces of code
>> > entiretly for CONFIG_PM_RUNTIME unset.
>>
>> Few days ago I would be happy with your opinion :), but know I think
>> this is better solution than wrapper. Consider case:
>> 1. PM_RUNTIME unset.
>> 2. System suspends.
>> 3. The pl330 in its suspend callback calls force_runtime_suspend which
>> leads us to amba/bus.
>> 4. The amba/bus.c in runtime suspend checks for irq_safe (it is FALSE),
>> so it disables and unprepares the clock.
>> 5. The pl330 in probe requested irq_safe so it assumes amba/bus will
>> only disable the clock. So the pl330 unprepares the clock. Again.
>
> To me, this sounds like a good reason to avoid using
> force_runtime_suspend().  In fact, it sounds like a good reason to
> avoid relying on the runtime PM mechanism to handle non-runtime-PM
> things (like a system suspend callback).  If CONFIG_PM_RUNTIME isn't
> enabled then the runtime PM stack simply should not be used.

There are an important advantage of using the pm_runtime_force_suspend() here.

For the driver to handle clock gating at system PM suspend, it first
needs to bring the device into full power, through
pm_runtime_get_sync(). Otherwise it's not safe to gate the clock,
since it may already be gated.

Kind regards
Uffe

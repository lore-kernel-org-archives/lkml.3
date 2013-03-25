Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab3CYQtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:49:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4476 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab3CYQtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:49:19 -0400
X-IronPort-AV: E=Sophos;i="4.84,905,1355126400"; 
   d="scan'208";a="32501674"
Message-ID: <5150800E.2000905@codeaurora.org>
Date: Mon, 25 Mar 2013 09:49:18 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv3 01/10] clocksource: add generic dummy timer driver
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org> <1363198676-30417-2-git-send-email-sboyd@codeaurora.org> <20130321180922.GB10716@e106331-lin.cambridge.arm.com> <514B4DBD.4060403@codeaurora.org> <20130322180305.GB1436@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130322180305.GB1436@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/13 11:03, Mark Rutland wrote:
> On Thu, Mar 21, 2013 at 06:13:17PM +0000, Stephen Boyd wrote:
>> On 03/21/13 11:09, Mark Rutland wrote:
>>> Hi Stephen,
>>>
>>> I've just been trying to test the dummy timer, and realised it's broken, as it
>>> registers a cpu notifier from a device_initcall (after SMP's been brought up),
>>> and doesn't ensure all active CPUs have been set up. Evidently no-one else has
>>> attempted to test it thus far, and I'm not able to throughly test it at the
>>> moment.
>> Would it be sufficient to register as a pre-smp initcall?
> I've looked a bit further into the problem, and I believe using early_initcall
> will make it work as well as the current arm-specific dummy timers work with a
> rating of 100 (this means the recent patch lowering the rating broke tc2 as
> explained below).

Yes, moving to early_initcall() should make the dummy timer equivalent
to the code that is already in the arm directory. It sounds like there
is a problem with mainline though?

>
> I've spent the last few hours trying to get the dummy_timer driver working on
> tc2 with the sp804 as the broadcast source (with architected timer support
> disabled). It turns out that having dummy timer's rating so low means that it
> won't be selected as the tick device on cpu0 in preference to the sp804, and
> thus won't push the sp804 out of that spot (allowing it to become the broadcast
> source). This leads to boot stalling.

I'm not following here. Why would we want to remove sp804 from the tick
duty?

>
> Jumping the dummy_timer's rating up would fix this, but that doesn't seem
> great. Registering the dummy before all other clocks would also fix this (I
> tried calling dummy_timer_register from time_init), but I can't see a way to do
> that while keeping the driver self-contained.


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


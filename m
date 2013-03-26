Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab3CZCO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 22:14:56 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37547 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758811Ab3CZCOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 22:14:54 -0400
X-IronPort-AV: E=Sophos;i="4.84,909,1355126400"; 
   d="scan'208";a="32421165"
Message-ID: <5151049D.5040400@codeaurora.org>
Date: Mon, 25 Mar 2013 19:14:53 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCHv3 01/10] clocksource: add generic dummy timer driver
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org> <1363198676-30417-2-git-send-email-sboyd@codeaurora.org> <20130321180922.GB10716@e106331-lin.cambridge.arm.com> <514B4DBD.4060403@codeaurora.org> <20130322180305.GB1436@e106331-lin.cambridge.arm.com> <5150800E.2000905@codeaurora.org> <20130325180007.GA4065@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130325180007.GA4065@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/13 11:00, Mark Rutland wrote:
>
>>> I've spent the last few hours trying to get the dummy_timer driver working on
>>> tc2 with the sp804 as the broadcast source (with architected timer support
>>> disabled). It turns out that having dummy timer's rating so low means that it
>>> won't be selected as the tick device on cpu0 in preference to the sp804, and
>>> thus won't push the sp804 out of that spot (allowing it to become the broadcast
>>> source). This leads to boot stalling.
>> I'm not following here. Why would we want to remove sp804 from the tick
>> duty?
> To run an SMP system without local timers, we need the sp804 to be the
> broadcast timer. Unfortunately the tick device and broadcast timer are mutually
> exclusive positions, so we need to have a dummy timer knock the sp804 out of
> tick device duty to enable broadcast.
>
> When the dummy timer's rating was 400 (against the sp804's 350), this worked.
> The sp804 would be registered, and would become cpu0's tick device. Later the
> dummy would get registered, knocking the sp804 out (whereupon it would get
> cycled back through tick_check_new_device and become the broadcast timer).
>
> With the dummy timer's rating lower, the sp804 stays as cpu0's tick device, all
> other cpus get dummy timers, but there's no broadcast source, so the system
> locks up waiting for secondary cpus.

Ok. Thanks for clearing up my confusion.

Like you say, increasing the dummy timer rating seems like a hack. But
it also sounds like you want to keep the dummy timer driver fully self
contained. I'm not opposed to calling dummy_timer_register() at the
bottom of tick_init() if we have to, but it sounds like you don't like that.

An alternative would be to push the dummy timer logic into the core
clockevents layer under the ifdef for arch has broadcast. This is
probably the correct approach because most devices don't want to have a
dummy timer sitting around unused. I might be able to take a look at
this tomorrow.

One final question, if you remove all other CPUs besides the CPU that is
servicing the sp804 interrupt do we end up in a situation where the
sp804 is broadcasting to the dummy tick device? I haven't read through
all the code yet for that one. I would think tick_switch_to_oneshot()
would complain on your device?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


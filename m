Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964782Ab3DEBq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:46:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49341 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab3DEBq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:46:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,412,1363158000"; 
   d="scan'208";a="36043317"
Message-ID: <515E2CF1.6030709@codeaurora.org>
Date: Thu, 04 Apr 2013 18:46:25 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
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
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org> <1363198676-30417-2-git-send-email-sboyd@codeaurora.org> <20130321180922.GB10716@e106331-lin.cambridge.arm.com> <514B4DBD.4060403@codeaurora.org> <20130322180305.GB1436@e106331-lin.cambridge.arm.com> <5150800E.2000905@codeaurora.org> <20130325180007.GA4065@e106331-lin.cambridge.arm.com> <5151049D.5040400@codeaurora.org> <20130326112811.GD4065@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130326112811.GD4065@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/13 04:28, Mark Rutland wrote:
> On Tue, Mar 26, 2013 at 02:14:53AM +0000, Stephen Boyd wrote:
>> Ok. Thanks for clearing up my confusion.
>>
>> Like you say, increasing the dummy timer rating seems like a hack. But
>> it also sounds like you want to keep the dummy timer driver fully self
>> contained. I'm not opposed to calling dummy_timer_register() at the
>> bottom of tick_init() if we have to, but it sounds like you don't like that.
> I'd like to keep the dummy timer driver self-contained if we can, but if it
> makes it more robust and/or easier to deal with by having an external call to
> register the driver, then I'm not opposed to that.
>
>> An alternative would be to push the dummy timer logic into the core
>> clockevents layer under the ifdef for arch has broadcast. This is
>> probably the correct approach because most devices don't want to have a
>> dummy timer sitting around unused. I might be able to take a look at
>> this tomorrow.
> I'm also not opposed to this idea.

What if we only check the rating if the two devices are for the same
CPU, i.e. always prefer percpu devices over global ones? This would make
your dummy timers into tick devices.

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index b1600a6..9ea59b9 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -251,9 +251,10 @@ static int tick_check_new_device(struct clock_event_device *newdev)
                    !(newdev->features & CLOCK_EVT_FEAT_ONESHOT))
                        goto out_bc;
                /*
-                * Check the rating
+                * Check the rating, but prefer CPU local devices
                 */
-               if (curdev->rating >= newdev->rating)
+               if (curdev->rating >= newdev->rating &&
+                   cpumask_equal(curdev->cpumask, newdev->cpumask))
                        goto out_bc;
        }
 

I think it will work with smp_twd, sp804, and dummy timers registered in
any order too.

> Though "broadcasting" to the same cpu is special-cased in tick_do_broadcast,
> which will call the tick device's event_handler directly rather than having the
> cpu attempt to IPI to itself.
>
> As you suggest, tick_switch_to_oneshot does complain:
>
> Clockevents: could not switch to one-shot mode: dummy_timer is not functional.
> Could not switch to high resolution mode on CPU 0
>
> To handle this case we could check cpu_possible_mask when initialising the
> dummy and only register it if more than 1 cpu is possible. That would be
> roughly in line with how we handle this case in smp.c.

Yes, this will work well enough. Squashed it into this patch.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab3FFWaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 18:30:35 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34901 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3FFWad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 18:30:33 -0400
Message-ID: <51B10D85.1060507@linaro.org>
Date: Fri, 07 Jun 2013 00:30:29 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv7 01/11] clockevents: Prefer CPU local devices over global
 devices
References: <1370291642-13259-1-git-send-email-sboyd@codeaurora.org> <1370291642-13259-2-git-send-email-sboyd@codeaurora.org> <51B0A6E8.20909@linaro.org> <20130606180425.GQ599@codeaurora.org>
In-Reply-To: <20130606180425.GQ599@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 08:04 PM, Stephen Boyd wrote:
> On 06/06, Daniel Lezcano wrote:
>> On 06/03/2013 10:33 PM, Stephen Boyd wrote:
>>> On an SMP system with only one global clockevent and a dummy
>>> clockevent per CPU we run into problems. We want the dummy
>>> clockevents to be registered as the per CPU tick devices, but
>>> we can only achieve that if we register the dummy clockevents
>>> before the global clockevent or if we artificially inflate the
>>> rating of the dummy clockevents to be higher than the rating
>>> of the global clockevent. Failure to do so leads to boot
>>> hangs when the dummy timers are registered on all other CPUs
>>> besides the CPU that accepted the global clockevent as its tick
>>> device and there is no broadcast timer to poke the dummy
>>> devices.
>>>
>>> If we're registering multiple clockevents and one clockevent is
>>> global and the other is local to a particular CPU we should
>>> choose to use the local clockevent regardless of the rating of
>>> the device. This way, if the clockevent is a dummy it will take
>>> the tick device duty as long as there isn't a higher rated tick
>>> device and any global clockevent will be bumped out into
>>> broadcast mode, fixing the problem described above.
>>
>> It is not clear the connection between the changelog, the patch and the
>> comment. Could you clarify a bit ?
>>
> 
> There is one tick device per-cpu and one broadcast device. The
> broadcast device can only be a global clockevent, whereas the
> per-cpu tick device can be a global clockevent or a per-cpu
> clockevent. The code tries hard to keep per-cpu clockevents in
> the tick device slots but it has an ordering/rating requirement
> that doesn't work when there are only dummy per-cpu devices and
> one global device.
> 
> Perhaps an example will help. Let's say you only have one global
> clockevent such as the sp804, and you have SMP enabled. To
> support SMP we have to register dummy clockevents on each CPU so
> that the sp804 can go into broadcast mode. If we don't do this,
> only the CPU that registered the sp804 will get interrupts while
> the other CPUs will be left with no tick device and thus no
> scheduling. To fix this we register dummy clockevents on all the
> CPUs _before_ we register the sp804 to force the sp804 into the
> broadcast slot. Or we give the dummy clockevents a higher rating
> than the sp804 so that when we register them after the sp804 the
> sp804 is bumped out to broadcast duty.
> 
> If the dummy devices are registered before the sp804 we can give
> the dummies a low rating and the sp804 will still go into the
> broadcast slot due to this code:
> 
> 	/*
> 	 * If we have a cpu local device already, do not replace it
> 	 * by a non cpu local device
> 	 */
> 	if (curdev && cpumask_equal(curdev->cpumask, cpumask_of(cpu)))
> 		goto out_bc;
> 
> If we register the sp804 before the dummies we're also fine as
> long as the rating of the dummy is more than the sp804.  Playing
> games with the dummy rating is not very nice so this patch fixes
> it by allowing the per-cpu device to replace the global device no
> matter what the rating of the global device is.
> 
> This fixes the sp804 case when the dummy is rated lower than
> sp804 and it removes any ordering requirement from the
> registration of clockevents. It also completes the logic above
> where we prefer cpu local devices over non cpu local devices.

Thanks for the detailed explanation.

Did Thomas reacted to this patch ?


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


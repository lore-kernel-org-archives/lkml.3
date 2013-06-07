Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab3FGJQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:16:03 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:56302 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3FGJP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:15:58 -0400
Message-ID: <51B1A4C8.9070404@gmail.com>
Date: Fri, 07 Jun 2013 11:15:52 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        John Stultz <john.stultz@linaro.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH v3 4/6] ARM: kirkwood: move device tree nodes to DT irqchip
 and clocksource
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com> <1370536034-23956-5-git-send-email-sebastian.hesselbarth@gmail.com> <20130607103007.415575c8@skate>
In-Reply-To: <20130607103007.415575c8@skate>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/13 10:30, Thomas Petazzoni wrote:
> On Thu,  6 Jun 2013 18:27:12 +0200, Sebastian Hesselbarth wrote:
>> -		wdt@20300 {
>> +		wdt: watchdog-timer@20300 {
>>   			compatible = "marvell,orion-wdt";
>>   			reg = <0x20300 0x28>;
>> +			interrupt-parent = <&bridge_intc>;
>> +			interrupts = <3>;
>>   			clocks = <&gate_clk 7>;
>>   			status = "okay";
>>   		};
>
> The watchdog driver is mapping the same registers as the timer driver
> (0x20300) and is poking into the same TIMER_CTRL register that controls
> both the timers and the watchdog.

Thomas,

you are right. I must admit that I forgot to take care of watchdog
driver.

> In addition to this, the watchdog driver also pokes into some other
> registers, such as BRIDGE_CAUSE and RSTOUTn_MASK.

As you can see above, watchdog should depend on chained interrupts but
current implementation doesn't but clears itself in BRIDGE_CAUSE.
Current non-DT timer also does (thread unsafe).

DT timer depends on the chained irq handler introduced with this patch
set. So for the interrupt, watchdog should also depend on the chained
irq handler to clear wdt irq.

Access to TIMER_CTRL should be made thread safe. I suggest to put that
common code into orion clocksource as it will be always compiled in
while wdt is optional.

> As we want to bring watchdog support for Armada 370/XP, I'm wondering
> if we should fix those problems, and if yes, how:
>
>   (1) The timer driver is also responsible for handling the watchdog
>       (probably the easiest solution)

Well, there is drivers/watchdog where current (Orion) wdt is located.
I guess it should stay there. For Armada 370/XP I guess it will need
to clear the watchdog events in common timer registers as for the timer
events? That is why I didn't merge Orion clocksource into Armada 370/XP
clocksource because we would have to check for Orion/Armada 370/XP on
every timer event.

>   (2) Have some sort of 'common code' between the timer driver and the
>       watchdog driver to control the access to the shared TIMER_CTRL
>       register.

Yes. Both should call a common thread-safe timer_en(num) at least.

>   (3) Something else.
>
> And this still does not solve the access to BRIDGE_CAUSE and
> RSTOUTn_MASK.

BRIDGE_CAUSE is taken care of by making wdt depend on chained irq
handler.. RSTOUTn_MASK is only used by current common code on reset,
maybe there is an API for that I have missed yet. But both reset and
watchdog will ultimately cause a reset - maybe we can accept that for
now.

Sebastian

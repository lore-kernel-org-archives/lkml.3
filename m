Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab3KVRFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:05:39 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57170 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3KVRFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:05:38 -0500
Message-ID: <528F8EC4.9050506@ti.com>
Date: Fri, 22 Nov 2013 11:05:08 -0600
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <benoit.cousson@linaro.org>,
        <santosh.shilimkar@ti.com>, <jgchunter@gmail.com>, <rnayak@ti.com>,
        <balbi@ti.com>
Subject: Re: [PATCH 6/8] devicetree: doc: Document ti,timer-parent property
References: <1385085414-9034-1-git-send-email-joelf@ti.com> <1385085414-9034-7-git-send-email-joelf@ti.com> <20131122155838.GF10023@atomide.com>
In-Reply-To: <20131122155838.GF10023@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 09:58 AM, Tony Lindgren wrote:
> * Joel Fernandes <joelf@ti.com> [131121 18:00]:
>> +Required properties for system timers (clockevents/clocksource):
>> +- ti,timer-parent:	System timer's parent mux clock needs to be setup.
>> +			This is currently hardcoded in code, for DT boot we
>> +			move this to DT.
>> +
> 
> This can be replaced with just clk_set_rate, or clk_set_parent if needed.
> Or by having a clocks = <&32k_clk> property in the dmtimer node in the
> .dts file.
> 
>>  Optional properties:
>>  - ti,timer-alwon:	Indicates the timer is in an alway-on power domain.
> 
> Hmm this we may not need, this can probably be deciphered from the compatible
> flag already?

I was thinking maybe we can improve the of_clocksource_init matching
capabilities to match better, not just on compatible but other properties for
better selection?

For example, a generic clocksource DT property to say that the timer is in the
wakeup domain and so should be preferred as the clocksource? Also additional
properties to force its selection?

Then we can switch to clocksource_of_init and have it do the selection. Not sure
if there is such a need or value for other ARM platforms so we may be over
complicating the framework to handle these quirks. Comments welcomed about it.

thanks,

-Joel

> 
> Then for the users of a specific dmtimer, they can select the right one using
> the interrupt-parent property:
> 
> timer1: timer@0x4800abcd {
> 	compatible = "ti,omap5430-timer";
> 	#interrupt-cells = <1>;		/* needs irqchip implemented for dmtimer */
> 	interrupt-controller;
> 	#clock-cells = <1>;		/* needs clocksource implemented for dmtimer */
> 	clock-output-names = "32k", "sys_ck";
> 	...
> };
> 
> counter32k: counter@4ae04000 {
> 	compatible = "ti,omap-counter32k";
> 	#clock-cells = <1>;		/* needs clocksource implemented for 32k counter */
> 	clock-output-names = "32k";
> 	...
> };
> 
> timer {
> 	compatible = "ti,omap5-timer";
> 	interrupt-parent = <&timer1>;
> 	interrupts = <1>;
> 	clocks = <&timer1 0>,		/* use timer1 as clockevent, clock index 0 = 32k, 1 = sys_ck ... */
> 		 <&counter32k 0>;	/* use 32k counter as clocksource */
> };
> 
>>  - ti,timer-dsp:		Indicates the timer can interrupt the on-chip DSP in
> 
> This can be probably also be mapped based on the compatible property?
> 
> Regards,
> 
> Tony
> 


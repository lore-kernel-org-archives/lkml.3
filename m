Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaIDKl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:41:58 -0400
Received: from rhcavuit01.kulnet.kuleuven.be ([134.58.240.129]:60981 "EHLO
	cavuit01.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752373AbaIDKl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:41:56 -0400
X-KULeuven-Envelope-From: bart.tanghe@thomasmore.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: 311D3138030.A358B
X-KULeuven-Information: Katholieke Universiteit Leuven
Message-ID: <540841EC.9010906@thomasmore.be>
Date: Thu, 04 Sep 2014 12:41:48 +0200
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From: Bart Tanghe <bart.tanghe@thomasmore.be>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: monstr@monstr.eu, Arnd Bergmann <arnd@arndb.de>
CC: thierry.reding@gmail.com, michal.simek@xilinx.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        grant.likely@linaro.org, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [rfc]pwm: add xilinx pwm driver
References: <1400066773-14393-1-git-send-email-bart.tanghe@thomasmore.be> <53748D84.5040005@monstr.eu> <5049141.XmehsUeakV@wuerfel> <5374C773.6070402@monstr.eu>
In-Reply-To: <5374C773.6070402@monstr.eu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See below

On 2014-05-15 15:56, Michal Simek wrote:
> On 05/15/2014 02:20 PM, Arnd Bergmann wrote:
>> On Thursday 15 May 2014 11:48:52 Michal Simek wrote:
>>> On 05/14/2014 01:26 PM, Bart Tanghe wrote:
>>>> 	add Xilinx PWM support - axi timer hardware block 
>>>>
>>>> Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>
>>>> diff --git a/Documentation/devicetree/bindings/pwm/pwm-xlnx.txt b/Documentation/devicetree/bindings/pwm/pwm-xlnx.txt
>>>> new file mode 100644
>>>> index 0000000..cb48926
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/pwm/pwm-xlnx.txt
>>>> @@ -0,0 +1,20 @@
>>>> +Xilinx PWM controller
>>>> +
>>>> +Required properties:
>>>> +- compatible: should be "xlnx,pwm-xlnx"
>>>> +- add a clock source to the description
>>>> +
>>>> +Examples:
>>>> +
>>>> +		axi_timer_0: timer@42800000 {
>>>> +			clock-frequency = <100000000>;
>>>
>>> just remove this from example it is not needed and unused.
>>>
>>>
>>>> +			clocks = <&clkc 15>;
>>>> +			compatible = "xlnx,xlnx-pwm";
>>>> +			reg = <0x42800000 0x10000>;
>>>> +			xlnx,count-width = <0x20>;
>>>> +			xlnx,gen0-assert = <0x1>;
>>>> +			xlnx,gen1-assert = <0x1>;
>>>> +			xlnx,one-timer-only = <0x0>;
>>>> +			xlnx,trig0-assert = <0x1>;
>>>> +			xlnx,trig1-assert = <0x1>;
>>>> +		} ;
>>>
>>> ok. This has to be done completely differently.
>>> I have looked around and found one a little bit older
>>> example but it is in the Linux kernel.
>>> It is pwm-atmel-tcb.c driver and atmel_tclib.c and tcb_clksrc.c.
>>>
>>> Arnd: Isn't there any newer better example how to manage it?
>>
>> Note that we have two atmel pwm drivers: drivers/misc/atmel_pwm.c 
>> and drivers/pwm/pwm-atmel.c. If you want to take that as an example,
>> make sure you use base on the latter.
> 
> Yes, I have seen that there are two drivers. atmel_pwm is older one
> without using that tclib.
> 
>>
>>> Back to atmel example - they are maintaining
>>> internal list of timers (atmel_tclib.c)
>>> and then clocksource driver (tcb_clksrc.c) is asking with atmel_tc_alloc() for it.
>>> The same is for pwm driver (pwm-atmel-tcb.c).
>>>
>>> They probably have all timers the same which is not
>>> our case because they can be different but this can be solved
>>> with flags.
>>>
>>> From DT point of view I think this is the reasonable description
>>>
>>> axi_timer_0: timer@42800000 {
>>> 	clocks = <&clkc 15>;
>>> 	compatible = "xlnx,xps-timer-1.00.a";
>>> 	interrupt-parent = <&xps_intc_0>;
>>> 	interrupts = < 3 2 >;
>>> 	reg = <0x42800000 0x10000>;
>>> 	xlnx,count-width = <0x20>;
>>> 	xlnx,gen0-assert = <0x1>;
>>> 	xlnx,gen1-assert = <0x1>;
>>> 	xlnx,one-timer-only = <0x0>;
>>> 	xlnx,trig0-assert = <0x1>;
>>> 	xlnx,trig1-assert = <0x1>;
>>> } ;
>>>
>>>
>>> pwm {
>>>         compatible = "xlnx,timer-pwm";
>>>         #pwm-cells = <2>;
>>>         timer = <&axi_timer_0>;
>>> };
>>>
>>>
>>> Allocation function will also require to do a change
>>> in clocksource driver because currently the first
>>> timer in the DTS/system is taken for clocksource/clockevents
>>> (others are just ignored).
>>> That's why will be necessary to add clock-handle property
>>> to cpu node to exactly describe which timer is system timer.
>>> The same as is for interrupt-handle (more intc's can be in design).
>>
>> If there is just one set of registers, I wouldn't object to
>> having just a single node in DT, and just one driver that registers
>> to both the clocksource and the PWM interfaces. That might
>> simplify the code.
> 
> IP is configurable as is normal for us.
> You can select IP with just one timer.
> It means register locations for specific timer are fixed.
> http://www.xilinx.com/support/documentation/ip_documentation/xps_timer.pdf
> 
> timer0 - offset 0x0
> timer1 - offset 0x10 (doesn't need to be synthesized)
> 
> There is one interrupt for both timers.
> 
> Timers can be as timers (up/down count/ reload with or without IRQs)
> But then one options is to use both timers and generate PWM signal.
> From full ip description in DT you can see xlnx,gen0-assert = <1>;
> which can suggest that this IP can output PMW signal.
> (We can also detect if PWM0 signal is connected just to be sure
> that PWM can be enabled).
> 
> There is also capture trigger mode where external signal start/stop
> timer counting.
> 
> It means there are 3 modes - timer, capture and PWM.
> Timer (clocksource, clockevent) requires specific handling,
> PWM has own subsystem and not sure if there is any subsystem for
> capture mode. Is there any?
> 
> Not every timer configuration is suitable for all things
> but fully configured timer can be used in all 3 modes.
> 
> 
> I think that make sense to register and map all timers in the system
> and classify them with flags (like can't be used for capture or PMW
> if there are not outputs connected) and then use the best
> timer for clocksource and clockevent. The best candidate is IP
> with the lowest IRQ number in dual timer mode but in general
> whatever timer can be used that's why we can't probably avoid
> timer specification in DT.
> In spite of this smells because you are saying via DT
> to Linux which timer should be used for what purpose.
> 
Can anyone help me with a correct example devicetree description of this block?
As metioned above, this can be used as timer, pwm and capture device.
Is a description as below a good starting point?

axi_timer_0: timer@42800000 {
 	clocks = <&clkc 15>;
 	compatible = "xlnx,xps-timer-1.00.a";
 	interrupt-parent = <&xps_intc_0>;
 	interrupts = < 3 2 >;
 	reg = <0x42800000 0x10000>;
 	xlnx,count-width = <0x20>;
 	xlnx,gen0-assert = <0x1>;
 	xlnx,gen1-assert = <0x1>;
 	xlnx,one-timer-only = <0x0>;
 	xlnx,trig0-assert = <0x1>;
 	xlnx,trig1-assert = <0x1>;
 } ;

 pwm {
         compatible = "xlnx,timer-pwm";
         #pwm-cells = <2>;
         timer = <&axi_timer_0>;
 };


 clocksource {
         compatible = "xlnx,timer-clk";
         timer = <&axi_timer_0>;
 };

 IIOcapture {
         compatible = "xlnx,timer-IIO";
         timer = <&axi_timer_0>;
 };

> Thanks,
> Michal
> 

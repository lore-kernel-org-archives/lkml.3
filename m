Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbaEOMUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:20:31 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:61999 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaEOMU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:20:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Cc: Bart Tanghe <bart.tanghe@thomasmore.be>, thierry.reding@gmail.com,
        michal.simek@xilinx.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, grant.likely@linaro.org,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc]pwm: add xilinx pwm driver
Date: Thu, 15 May 2014 14:20:11 +0200
Message-ID: <5049141.XmehsUeakV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53748D84.5040005@monstr.eu>
References: <1400066773-14393-1-git-send-email-bart.tanghe@thomasmore.be> <53748D84.5040005@monstr.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:HKMIzLFIxc7GLyzQIfrJFLRx6XAWfC2JXa0tycEWTkj
 O6QzZ+q/w1qCSF+s4yJdc/nj/liYpkT7YeUpMwU3nWBY5xZahb
 nrBywSqso7A6Q6bcT4QMwpOVrvwjd3GuQVQ2GAgbLcuf4sDRhT
 j95NOz33c3wxIiRoRU/Ew3xIQ8KeQb6Rn6uIgr7BLT5p658+0X
 WY9HD3zGm64tWNwlEaR/6vqfhclb8J40VAGo/Xr4SRGXK5DlOB
 ZZ1OlVwbpVZBlt3jDS0DmMYmV5bGMUJ4AAhxkuoYiSa3Jc5t25
 lFjjxK4bIoq6WLsEaBqUunf4pm9bzQ5va+M5G+e5ydnUKuqEMx
 aHa0WmbxJYBa3iNPUKF8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2014 11:48:52 Michal Simek wrote:
> On 05/14/2014 01:26 PM, Bart Tanghe wrote:
> > 	add Xilinx PWM support - axi timer hardware block 
> > 
> > Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>
> > diff --git a/Documentation/devicetree/bindings/pwm/pwm-xlnx.txt b/Documentation/devicetree/bindings/pwm/pwm-xlnx.txt
> > new file mode 100644
> > index 0000000..cb48926
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pwm/pwm-xlnx.txt
> > @@ -0,0 +1,20 @@
> > +Xilinx PWM controller
> > +
> > +Required properties:
> > +- compatible: should be "xlnx,pwm-xlnx"
> > +- add a clock source to the description
> > +
> > +Examples:
> > +
> > +		axi_timer_0: timer@42800000 {
> > +			clock-frequency = <100000000>;
> 
> just remove this from example it is not needed and unused.
> 
> 
> > +			clocks = <&clkc 15>;
> > +			compatible = "xlnx,xlnx-pwm";
> > +			reg = <0x42800000 0x10000>;
> > +			xlnx,count-width = <0x20>;
> > +			xlnx,gen0-assert = <0x1>;
> > +			xlnx,gen1-assert = <0x1>;
> > +			xlnx,one-timer-only = <0x0>;
> > +			xlnx,trig0-assert = <0x1>;
> > +			xlnx,trig1-assert = <0x1>;
> > +		} ;
> 
> ok. This has to be done completely differently.
> I have looked around and found one a little bit older
> example but it is in the Linux kernel.
> It is pwm-atmel-tcb.c driver and atmel_tclib.c and tcb_clksrc.c.
> 
> Arnd: Isn't there any newer better example how to manage it?

Note that we have two atmel pwm drivers: drivers/misc/atmel_pwm.c 
and drivers/pwm/pwm-atmel.c. If you want to take that as an example,
make sure you use base on the latter.

> Back to atmel example - they are maintaining
> internal list of timers (atmel_tclib.c)
> and then clocksource driver (tcb_clksrc.c) is asking with atmel_tc_alloc() for it.
> The same is for pwm driver (pwm-atmel-tcb.c).
> 
> They probably have all timers the same which is not
> our case because they can be different but this can be solved
> with flags.
> 
> From DT point of view I think this is the reasonable description
> 
> axi_timer_0: timer@42800000 {
> 	clocks = <&clkc 15>;
> 	compatible = "xlnx,xps-timer-1.00.a";
> 	interrupt-parent = <&xps_intc_0>;
> 	interrupts = < 3 2 >;
> 	reg = <0x42800000 0x10000>;
> 	xlnx,count-width = <0x20>;
> 	xlnx,gen0-assert = <0x1>;
> 	xlnx,gen1-assert = <0x1>;
> 	xlnx,one-timer-only = <0x0>;
> 	xlnx,trig0-assert = <0x1>;
> 	xlnx,trig1-assert = <0x1>;
> } ;
> 
> 
> pwm {
>         compatible = "xlnx,timer-pwm";
>         #pwm-cells = <2>;
>         timer = <&axi_timer_0>;
> };
> 
> 
> Allocation function will also require to do a change
> in clocksource driver because currently the first
> timer in the DTS/system is taken for clocksource/clockevents
> (others are just ignored).
> That's why will be necessary to add clock-handle property
> to cpu node to exactly describe which timer is system timer.
> The same as is for interrupt-handle (more intc's can be in design).

If there is just one set of registers, I wouldn't object to
having just a single node in DT, and just one driver that registers
to both the clocksource and the PWM interfaces. That might
simplify the code.

> 	cpus {
> 		#address-cells = <1>;
> 		#cpus = <1>;
> 		#size-cells = <0>;
> 		microblaze_0: cpu@0 {
> 			compatible = "xlnx,microblaze-8.50.a";
> 			interrupt-handle = <&microblaze_0_intc>;
> 			...
> 			clock-handle = <&axi_timer_X>;
> 			...
> 		} ;
> 	} ;
> 
> Then clocksource driver will ask just exact timer which is suitable
> to provide clocksource/clockevent. It can be also split and
> use 2 cells format to specify which timer should be used.
> clocksource-handle = <&axi_timer_X 0>;
> clockeven-handle = <&axi_timer_X 1>;

This seems fine, too.

	Arnd

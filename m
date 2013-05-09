Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab3EIXwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:52:07 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27245 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3EIXwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 19:52:05 -0400
X-IronPort-AV: E=Sophos;i="4.87,643,1363158000"; 
   d="scan'208";a="45788541"
Message-ID: <518C369F.2070505@codeaurora.org>
Date: Thu, 09 May 2013 16:51:59 -0700
From: hanumant <hanumant@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [RFC] pinctrl: Alternative to gpio to pinctrl pin mapping via DT
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have a pincontroller with different pin types
For example pin type A & B. (There are more but 2 is sufficient to 
specify here).
Each pin type has its own register programming semantics
So each pin type is associated with its own programming vectors.

Of this lets say pin type A can support gpio funcitonality as well.

I model this as

1) total pins exported to pinctrl subsystem = num pins of type A +
						num pins of type B

2) Each pin type is a child node of the pinctrl node in device tree.

3) The starting pin number of each pin type on the pinctroller depends 
on the order in which it occurs in the device tree when the pinctrl 
driver is parsing the device tree.

4) In this case, if a pintype supports gpio functionality, I could have 
informed the pinctrl system of the pin range, based on the run time 
determined start pin of that pin type. (This would have involved the use 
of the now deprecated pinctrl_add_gpio_range())

5) The current way of notifying the pinctrl system of gpio functionality 
is by using the gpio-ranges attribute in the gpio chip device tree node. 
But in my case, this would require me to know run time what pin range is 
going to correspond to my pin type.
					

Sample DT node

&pinctrl0: pinctrl@<0xfd110000> {
....
..
	pinA: pinA {
		pintype = "A";
		num-pins = <100>;
		#pin-cells = <1>;
	};
	pinB: pinB {
		pintype = "B"
		num-pins = <20>;
		#pin-cells = <1>;
	};
	gpio_chip_A: GC_A {
		pin-type-parent = <&pinA>;
		gpio-controller
		#gpio-cells = <2>;
		interrupt-controller;
		interrupt-cells = <2>;
		gpio-ranges = <??????>;	
	};
	/* Sample pin use case */
	uart0_pins {
		pins = <&pinA 22>, <&pinA 23>;
		pins-func = <2>;

		uart0_active {
			pin-drv = <8>;
			pin-pull = <1>;
		};
		uart0_suspend {
			pin-drv = <2>;
			pin-pull = <0>;
		};
	};
		
}
/* Sample gpio use case */
lcd@0xAb000000 {
		gpios = <&gpio_chip_A 33 0>;
		....
		...
};

In the above example, i could assume since the pin type A occurs first
in order, the gpio-ranges = 0 to 99 for the corresponding. But that 
would mean ensuring that your pin type occurs at a certain order in 
Device tree.

The pinctrl_add_gpio_range() would have really helped here in specifying 
the gpio range at device tree parsing time.

Is there a more elegant option rather then hard coding the order of pin 
types.?

Thanks
Hanumant

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, hosted by The Linux Foundation
-- 

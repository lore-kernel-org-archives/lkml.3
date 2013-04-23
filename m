Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab3DWXrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 19:47:42 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50613 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab3DWXrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 19:47:40 -0400
X-IronPort-AV: E=Sophos;i="4.87,537,1363158000"; 
   d="scan'208";a="40809799"
Message-ID: <51771D78.5080101@codeaurora.org>
Date: Tue, 23 Apr 2013 16:47:04 -0700
From: hanumant <hanumant@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [RFC] pinctrl: Pin controller with different types of pins
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

  I am implementing a pinctrol driver for a pin controller with the 
following attributes, relevant to the problem.

It has 2 different types of pins.
a) Pins that can be used for multiple functions, including being used as 
a gpio to be toggled by SW.
b) Pins that have a dedicated function.

Both types support configuration of drive strength and pull up values.
The register formats for these are different.

The register address map can be descibed as

1) Config registers starting from the pinctrl base, for the general 
purpose pins, one per pin at fixed offsets.
Each config register has fields to setup drive strength, pull up and
function for the corresponding pin.

2) After the above, we have config registers for the dedicated pins.
In this case the config register are per use case. For example
if SDCC uses dedicated pins as follows 1 clock pin, 8 data pins and 2 
command pins then there will be one config register as follows
Bits 31-29 = clk pull value (1-7)
Bits 28-26 = data line pull values (1-7)
Bits 25-23 = command pull values (1-7)
Bits 8-6 = clk drive strength values (1-7)
Bits 5-3 = data drive strength values
Bits 2-0 = command drive strength values

3) After the config register for dedicated pins, we again have registers 
for pin type a) that configure its direction and value
(in case pin is being used as a gpio and toggled by SW).

Solutions:
I initially tried to model this as 2 separate pin controllers
one for the general purpose pins and the other for dedicated pins but 
this is complicated by the fact that
1) In this case the address map for the pinctroller 1 would be dis 
contiguous.
2) Also the address range for the deidcated pins does not start at a 4K
page boundary, in fact some registers from pin type 1 overflow into the 
starting page of the dedicated pin registers.

The only option I see is

1) to implement this as one pin controller, with total number of pins = 
multi function pins + dedicated pins.

2) The pin descriptor registered with the framework would be part of a 
bigger descriptor maintained by the driver that additionally defines the 
pin type and the register manipulation methods for that type.

3) The pin number would serve as an index into the driver descriptor.

4) The register manipulation methods would be part of the of_device_id
data for the pin controller

I have not been able to find any precedence for this kind of pin 
controller design. I do see some vendors with pin banks, and they too 
maintain the "descriptor" as part of the vendor driver. But not this 
kind of register address map. Would the above option be an acceptable
design or is there a better approach?

Is there any value add to having a private data field for the framework 
pin descriptor that can be overloaded for every pin to take care of 
these kinds of problems?

Thanks
Hanumant
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, hosted by The Linux Foundation
-- 

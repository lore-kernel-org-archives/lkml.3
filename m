Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965172Ab3DPUTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:19:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50371 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964969Ab3DPUTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:19:04 -0400
X-IronPort-AV: E=Sophos;i="4.87,487,1363158000"; 
   d="scan'208";a="38857532"
Message-ID: <516DB233.5070504@codeaurora.org>
Date: Tue, 16 Apr 2013 13:18:59 -0700
From: hanumant <hanumant@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linus.walleij@linaro.org, swarren@wwwdotorg.org
Subject: [RFC] Pinctrl: driver design supporting gpiolib
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am trying to implement a pinctrl driver.
I have given a brief description of the relevant pinctrl hw features as 
well as a the use cases and my proposed solution for them. Please 
advise/comment.

HW:
The pin controller has the following properties
1) Each pin has its own 32 bit register at a fixed offset from base.
2) Register supports configuration like drive strength, pull, function.
3) The function can be gpio or a number of other functionalities.
4) By default all pins are configured as GPIO.

The SOC using this pinmuxer hardware has various peripherals(clients) 
that utilize this pinmuxer for example, spi, uart etc

Usecases:
The use cases can broadly fall into 3 cattegories.

1) Client defines atleast 2 configurations (active, suspend)
for its pin groups, with different drive strength and pull up values for
each configuration and both configurations have function as being not 
gpio but the specified use case. (For eg pin 1 used for UART TX
and pin 2 used for UART RX. Both should have function = 1 => uart will 
drive them. If function = 0 they can be used as gpio.If function = 3
spi will drive them)

2) Client uses 2 configurations (active, suspend) with the function 
being gpio (function = 0). Both configurations use different pull up and 
drive strength values but in each case the pins are used in gpio mode.

3) Client uses more then 2 configurations (pull, drive strength) with a
combination of the same group of pins being configured as gpio and non 
gpio (specific function)

Solutions:
Solution For usecase 1) I believe the existing framework supports this 
by having the client define states that would correspond to the same 
function mapping to different configurations. With each map being 
identified by the state name.

Solution For usecase 2) my proposal is
a) to have the client select the state that configures the drive 
strength and the pull up values.
b) call gpio_request to own the gpio. (Add support for giolib in the
pinctrl)
c) set direction
d) set/read value

Solution For usecase 3) Have the client use the above 2 solutions
for respective situations.

Please let me know if you believe there is a better way to handle use case 2
and 3

Thanks
Hanumant
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, hosted by The Linux Foundation
-- 

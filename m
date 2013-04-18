Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967761Ab3DRROx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 13:14:53 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33288 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966669Ab3DRROw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 13:14:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,503,1363158000"; 
   d="scan'208";a="39625084"
Message-ID: <51702A0A.7030502@codeaurora.org>
Date: Thu, 18 Apr 2013 10:14:50 -0700
From: hanumant <hanumant@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC] Pinctrl: driver design supporting gpiolib
References: <516DB233.5070504@codeaurora.org> <CACRpkda_V7qKUKF9o5kNpra7VQbu+hEoAsr1z1_0upFw5s0wQA@mail.gmail.com>
In-Reply-To: <CACRpkda_V7qKUKF9o5kNpra7VQbu+hEoAsr1z1_0upFw5s0wQA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 09:05 AM, Linus Walleij wrote:
> On Tue, Apr 16, 2013 at 10:18 PM, hanumant <hanumant@codeaurora.org> wrote:
>
>> I am trying to implement a pinctrl driver.
>> I have given a brief description of the relevant pinctrl hw features as well
>> as a the use cases and my proposed solution for them. Please advise/comment.
>
> OK! Generic background material:
>
> Brief overview by LWN editor Jon Corbet:
> http://lwn.net/Articles/468759/
>
> Documentation/pinctrl.txt latest version from Torvald's HEAD:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/pinctrl.txt;hb=HEAD
>
> My slides from the Embedded Linux Conference presenting the pin
> control subsystem:
> http://www.df.lth.se/~triad/papers/pincontrol.pdf
> A video recording of my seminar from the ELC:
> http://video.linux.com/videos/pin-control-subsystem-overview
>
> Another presentation dealing with the software side of things:
> http://www.df.lth.se/~triad/papers/Linaro_pinctrl_overview.pdf
>
>> HW:
>> The pin controller has the following properties
>> 1) Each pin has its own 32 bit register at a fixed offset from base.
>> 2) Register supports configuration like drive strength, pull, function.
>
> Makes it sound like you can use the generic pinconfig in
> drivers/pinctrl/pinconf-generic.c
> include/linux/pinctrl/pinconf-generic.h
>
>> 3) The function can be gpio or a number of other functionalities.
>
> Regarding this, please read carefully the section named
> "GPIO mode pitfalls" in Documentation/pinctrl.txt from the latest
> linux-next.
>
>> 4) By default all pins are configured as GPIO.
>
> You mean they are configured like that at power-on or something?
>
>> The SOC using this pinmuxer hardware has various peripherals(clients) that
>> utilize this pinmuxer for example, spi, uart etc
>
> OK this is normal.
>
>> Usecases:
>> The use cases can broadly fall into 3 cattegories.
>>
>> 1) Client defines atleast 2 configurations (active, suspend)
>
> We call these "default" and "sleep", see:
> include/linux/pinctrl/pinctrl-state.h
>
>> for its pin groups, with different drive strength and pull up values for
>> each configuration and both configurations have function as being not gpio
>> but the specified use case. (For eg pin 1 used for UART TX
>> and pin 2 used for UART RX. Both should have function = 1 => uart will drive
>> them. If function = 0 they can be used as gpio.If function = 3
>> spi will drive them)
>
> This is supported by the pinctrl subsystem.
>
>> 2) Client uses 2 configurations (active, suspend)
>
> (So again I refer to these as default and sleep.)
>
>> with the function being
>> gpio (function = 0). Both configurations use different pull up and drive
>> strength values but in each case the pins are used in gpio mode.
>
> Refer to the document about GPIO mode pitfall.
>
> Pin mode in datasheet named "GPIO" does not mean
> Linux GPIO subsystem shall be used by necessity.
>
> The important question is if the consumer in the Linux
> kernel (such as a driver) is using gpio_request() etc to
> access these pins, or if it is an ordinary driver.
>
>> 3) Client uses more then 2 configurations (pull, drive strength) with a
>> combination of the same group of pins being configured as gpio and non gpio
>> (specific function)
>
> The pinctrl subsystem actually even allows you to use the same
> pin for a function and GPIO *at the same time*. This is because
> some systems will allow these two things to mess with each other,
> e.g. to use a GPIO pin to "spy" on a UART.
>
>> Solutions:
>> Solution For usecase 1) I believe the existing framework supports this by
>> having the client define states that would correspond to the same function
>> mapping to different configurations. With each map being identified by the
>> state name.
>
> Yes.
>
>> Solution For usecase 2) my proposal is
>> a) to have the client select the state that configures the drive strength
>> and the pull up values.
>> b) call gpio_request to own the gpio. (Add support for giolib in the
>> pinctrl)
>> c) set direction
>> d) set/read value
>
> Yes if the individual GPIO pins is what the driver needs to acces,
> like it needs to drive them high and low or read the value.
> Then this is the right way.
>
>> Solution For usecase 3) Have the client use the above 2 solutions
>> for respective situations.
>
> Yes pinctrl and GPIO can be used at the same time.
>
>> Please let me know if you believe there is a better way to handle use case 2
>> and 3
>
> No I think you've got it! :-)
>
> Yours,
> Linus Walleij
>
Thanks for all the information and your help.

Hanumant

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum, hosted by The Linux Foundation
-- 

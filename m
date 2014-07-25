Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759863AbaGYI1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:27:23 -0400
Received: from router.aksignal.cz ([188.175.113.102]:55314 "EHLO
	router.aksignal.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaGYI1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:27:20 -0400
Message-ID: <53D214E1.4050105@aksignal.cz>
Date: Fri, 25 Jul 2014 10:27:13 +0200
From: =?UTF-8?B?SmnFmcOtIFByY2hhbA==?= <jiri.prchal@aksignal.cz>
Reply-To: jiri.prchal@aksignal.cz
Organization: AK signal Brno
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Bo Shen <voice.shen@atmel.com>, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: at91sam9x5: sets NPCS0 (PA14) back to GPIO
References: <1405074175-22444-1-git-send-email-voice.shen@atmel.com>	<53D10C50.50305@aksignal.cz>	<20140724162645.4e19c26c@bbrezillon>	<53D12103.3020103@aksignal.cz>	<20140724175848.44f5da10@bbrezillon>	<53D1F5D0.1080006@aksignal.cz> <20140725095319.16a8465c@bbrezillon>
In-Reply-To: <20140725095319.16a8465c@bbrezillon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dne 25.7.2014 v 09:53 Boris BREZILLON napsal(a):
> On Fri, 25 Jul 2014 08:14:40 +0200
> Jiří Prchal <jiri.prchal@aksignal.cz> wrote:
>
>>
>>
>> Dne 24.7.2014 v 17:58 Boris BREZILLON napsal(a):
>>> On Thu, 24 Jul 2014 17:06:43 +0200
>>> Jiří Prchal <jiri.prchal@aksignal.cz> wrote:
>>>
>>>> Hi,
>>>>
>>>> Dne 24.7.2014 v 16:26 Boris BREZILLON napsal(a):
>>>>> Hello Jiří,
>>>>>
>>>>> First of all, please try to use git format-patch when submitting a
>>>>> patch to any kernel mailing list.
>>>> Sorry for that.
>>>>>
>>>>> On Thu, 24 Jul 2014 15:38:24 +0200
>>>>> Jiří Prchal <jiri.prchal@aksignal.cz> wrote:
>>>>>
>>>>>> After ROMBOOT tries boot from flash on SPI0 NPCS0, this NPCS0 (PA14) remains set to PERIPH_A.
>>>>>> Because of that, this pin is unusable to something else.
>>>>>> This patch sets it back to GPIO.
>>>>>
>>>>> The policy is to leave pins in an unknown state till some peripheral
>>>>> need them.
>>>>>
>>>>> What are you trying to use this pin for ?
>>>> For chip select, but #3. And when SPI communicate with cs0 (PA22), it goes down too (PA14), so 2 devices on bus were
>>>> selected.
>>>
>>> Are you using a 9x5ek board or a custom one, in the latter case could
>>> you paste your spi0 node definition ?
>> I'm using custom board. My spi node:
>> 			spi0: spi@f0000000 {
>> 				status = "okay";
>> 				cs-gpios = <&pioA 23 0
>> 					    &pioA 22 0
>> 					    &pioC 29 0
>> 					    &pioA 14 0>;
>>
>> 				fm25@0 {
>> 					compatible = "cypress,fm25";
>> 					spi-max-frequency = <40000000>;
>> 					reg = <0>;
>> 					pagesize = <256>;
>> 					size = <131072>;
>> 					address-width = <24>;
>> 				};
>> 				/* ADC */
>> 				spidev@1 {
>> 					compatible = "spidev";
>> 					reg = <1>;
>> 					spi-max-frequency = <1000000>;
>> 				};
>> 				/* IO expander for busaddr */
>> 				spidev@2 {
>> 					compatible = "spidev";
>> 					reg = <2>;
>> 					label = "busaddr";
>> 					spi-max-frequency = <10000000>;
>> 				};
>> 				/* audio codec */
>> 				codec: codec@3 {
>> 					compatible = "ti,tlv320aic3x";
>> 					spi-max-frequency = <1000000>;
>> 					reg = <3>;
>> 				};
>> 			};
>>
>> This does not work without patch, because of 2 chips selected at one time because of PA14 is periph_a. Probably ROMBOOT
>> changes that.
>
> Yes, boot code stored in ROM probably mux PA14 to periph A function,
> but with your definition PA 14 should be set GPIO mode when the codec
> device is created.
I tried codec defined as spidev to see if it is not in codec driver, but its the same.
				/* audio codec */
				spidev@3 {
					compatible = "spidev";
					reg = <3>;
					label = "codec";
					spi-max-frequency = <10000000>;
				};

>
> I don't see any obvious error in your definition, could you add a trace
> there [1] to see if the gpio is successfully requested ?
I add a trace:
@@ -1029,6 +1029,7 @@ static int atmel_spi_setup(struct spi_device *spi)
  		if (!asd)
  			return -ENOMEM;

+		dev_dbg(&spi->dev, "gpio_request: %u\n", npcs_pin);
  		ret = gpio_request(npcs_pin, dev_name(&spi->dev));
  		if (ret) {
  			kfree(asd);
But don't see it.
/ # dmesg | grep spi
[    1.167968] atmel_spi f0000000.spi: version: 0x212
[    1.175781] atmel_spi f0000000.spi: Using dma0chan1 (tx) and dma0chan2 (rx) for DMA transfers
[    1.183593] atmel_spi f0000000.spi: Atmel SPI Controller at 0xf0000000 (irq 34)
/ # dmesg | grep gpio_request
/ # dmesg | grep gpio
[    0.121093] gpiochip_add: registered GPIOs 0 to 31 on device: fffff400.gpio
[    0.121093] gpio-at91 fffff400.gpio: at address fefff400
[    0.125000] gpiochip_add: registered GPIOs 32 to 50 on device: fffff600.gpio
[    0.125000] gpio-at91 fffff600.gpio: at address fefff600
[    0.125000] gpiochip_add: registered GPIOs 64 to 95 on device: fffff800.gpio
[    0.125000] gpio-at91 fffff800.gpio: at address fefff800
[    0.128906] gpiochip_add: registered GPIOs 96 to 117 on device: fffffa00.gpio
[    0.128906] gpio-at91 fffffa00.gpio: at address fefffa00
[    0.304687] of_get_named_gpiod_flags exited with status 0
[    0.304687] gpio-of-helper gpio: Allocated GPIO id=-1
[    0.304687] of_get_named_gpiod_flags exited with status 0
[    0.304687] gpio-of-helper gpio: Allocated GPIO id=-1
[    0.304687] of_get_named_gpiod_flags exited with status 0
[    0.308593] gpio-of-helper gpio: Allocated GPIO id=-1
[    0.308593] of_get_named_gpiod_flags exited with status 0
[    0.308593] gpio-of-helper gpio: Allocated GPIO id=-1
[    0.308593] of_get_named_gpiod_flags exited with status 0
[    0.308593] gpio-of-helper gpio: Allocated GPIO id=-1
[    0.312500] of_get_named_gpiod_flags exited with status 0
[    0.312500] gpio-of-helper gpio: Allocated GPIO id=-1
[    0.312500] of_get_named_gpiod_flags exited with status 0
[    0.312500] gpio-of-helper gpio: Allocated GPIO id=-1
[    0.312500] of_get_named_gpiod_flags exited with status 0
[    0.312500] gpio-of-helper gpio: Allocated GPIO id=-1
[    0.312500] of_get_named_gpiod_flags exited with status 0
[    0.316406] gpio-of-helper gpio: Allocated GPIO id=-1
[    0.316406] of_get_named_gpiod_flags exited with status 0
[    0.316406] gpio-of-helper gpio: Allocated GPIO id=-1
[    0.316406] of_get_named_gpiod_flags exited with status 0
[    0.316406] gpio-of-helper gpio: Allocated GPIO id=-1
[    0.316406] of_get_named_gpiod_flags exited with status 0
[    0.320312] gpio-of-helper gpio: Allocated GPIO id=-1
[    0.320312] of_get_named_gpiod_flags exited with status 0
[    0.320312] gpio-of-helper gpio: Allocated GPIO id=-1
[    0.320312] of_get_named_gpiod_flags exited with status 0
[    0.324218] gpio-of-helper gpio: Allocated GPIO id=-1
[    0.324218] of_get_named_gpiod_flags exited with status 0
[    0.324218] gpio-of-helper gpio: Allocated GPIO id=-1
[    0.324218] gpio-of-helper gpio: ready
[    0.328125] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.328125] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.328125] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.328125] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.328125] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.328125] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.328125] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.328125] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.328125] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.328125] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.328125] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.328125] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.332031] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.332031] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.332031] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.332031] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@fffff200[0]'
[    0.847656] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.847656] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.847656] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.847656] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.847656] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.847656] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.847656] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.847656] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.851562] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.851562] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.851562] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.851562] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.851562] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.851562] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.851562] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.851562] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f801c000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.863281] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8020000[0]'
[    0.875000] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.875000] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.875000] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.875000] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.875000] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.875000] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.875000] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.878906] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.878906] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.878906] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.878906] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.878906] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.878906] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.878906] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.878906] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.878906] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8024000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.890625] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/serial@f8028000[0]'
[    0.929687] of_get_named_gpiod_flags exited with status 0
[    0.929687] of_get_named_gpiod_flags exited with status 0
[    0.929687] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/nand@40000000[2]'
[    1.191406] of_get_named_gpiod_flags exited with status 0
[    1.191406] of_get_named_gpiod_flags exited with status 0
[    1.191406] of_get_named_gpiod_flags exited with status 0
[    1.191406] of_get_named_gpiod_flags exited with status 0
[    1.437500] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/ohci@00600000[0]'
[    1.437500] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/ohci@00600000[1]'
[    1.437500] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/ohci@00600000[2]'
[    1.437500] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/ohci@00600000[0]'
[    1.437500] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/ohci@00600000[1]'
[    1.437500] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/ohci@00600000[2]'
[    1.609375] of_get_named_gpiod_flags exited with status 0
[    1.699218] of_get_named_gpiod_flags exited with status 0
[    1.699218] of_get_named_gpiod_flags exited with status 0
[    1.699218] of_get_named_gpiod_flags exited with status 0
[    1.699218] of_get_named_gpiod_flags exited with status 0
[    1.699218] of_get_named_gpiod_flags exited with status 0
[    1.699218] of_get_named_gpiod_flags exited with status 0
[    1.699218] of_get_named_gpiod_flags exited with status 0
[    1.703125] of_get_named_gpiod_flags exited with status 0
[    3.042968] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/mmc@f0008000/slot@0[0]'
[    3.042968] of_get_named_gpiod_flags: can't parse gpios property of node '/ahb/apb/mmc@f0008000/slot@0[0]'


> Could you also paste the content of /sys/kernel/debug/gpio ?
The /sys/kernel/debug/ is empty.
It's set in config:
---GPIOSupport
  │       [*]   Debug GPIO calls │
  │
But in .config not:
# CONFIG_SPI_DEBUG is not set

>
>>>
>>>>> If you just want to use it as a chip select for an spi device, take a
>>>>> look at [1].
>>>> At [1] it's OK until as cs0 is for example PA22 and cs1 is PA14.
>>>
>>> If you want PA14 to control cs1 and PA22 to control cs0 (both
>>> configured as GPIOs), you'll have the following definition:
>>>
>>> cs-gpios = <&pioA 22 0>, <&pioA 14 0>, <0>, <0>;
>> See my node.
>>>
>>>>>
>>>>> Here the gpio is requested by the spi core when defining the cs-gpios
>>>>> property. The gpio controller then request the listed pins to the pin
>>>>> controller (pinctrl driver).
>>>> GPIO is not set in driver as GPIO, at least I didn't find it.
>>>
>>> Take a look at [1], which is set as the gpio_request_enable callback,
>>> called by pinctrl core when a gpio is requested.
>> But is this called from spi driver when requesting gpios as cs?
>
> Yes, it's part of the gpio_request process:
> gpio_request calls request method on at91 gpio_chip which in turn
> calls pinctrl_request_gpio which then calls the gpio_request_enable
> method I previously mentioned.
>
>
> Best Regards,
>
> Boris
>
> [1]http://lxr.free-electrons.com/source/drivers/spi/spi-atmel.c#L1031
>

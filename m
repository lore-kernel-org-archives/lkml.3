Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab3HAKwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:52:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:41228 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3HAKwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:52:12 -0400
Message-ID: <51FA3DD9.9080207@linutronix.de>
Date: Thu, 01 Aug 2013 12:52:09 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: linux-usb@vger.kernel.org, balbi@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] usb: musb: dsps: use proper child nodes
References: <1375215401-19729-1-git-send-email-bigeasy@linutronix.de> <1375215401-19729-6-git-send-email-bigeasy@linutronix.de> <51F9F10A.4000908@ti.com>
In-Reply-To: <51F9F10A.4000908@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 07:24 AM, George Cherian wrote:
>> b/arch/arm/boot/dts/am33xx.dtsi
>> index 38b446b..0f756ca 100644
>> --- a/arch/arm/boot/dts/am33xx.dtsi
>> +++ b/arch/arm/boot/dts/am33xx.dtsi
>> @@ -333,21 +337,85 @@
>>               status = "disabled";
>>           };
>>   -        usb@47400000 {
>> -            compatible = "ti,musb-am33xx";
>> -            reg = <0x47400000 0x1000    /* usbss */
>> -                   0x47401000 0x800        /* musb instance 0 */
>> -                   0x47401800 0x800>;    /* musb instance 1 */
>> -            interrupts = <17        /* usbss */
>> -                      18        /* musb instance 0 */
>> -                      19>;        /* musb instance 1 */
>> -            multipoint = <1>;
>> -            num-eps = <16>;
>> -            ram-bits = <12>;
>> -            port0-mode = <3>;
>> -            port1-mode = <3>;
>> -            power = <250>;
>> +        usb: usb@47400000 {
>> +            compatible = "ti,am33xx-usb";
>> +            reg = <0x47400000 0x1000>;
>> +            ranges;
>> +            #address-cells = <1>;
>> +            #size-cells = <1>;
>>               ti,hwmods = "usb_otg_hs";
>> +            status = "disabled";
>> +
>> +            ctrl_mod: control@44e10000 {
>> +                compatible = "ti,am335x-ctrl-module";
>> +                reg = <0x44e10000 0x650>;
> 
> Do you really need to map Control Module base to 0x650? If some other
> driver does this mapping

This is what I cam currently not sure about. Either we minimize the
register window and introduce two (the other wakeup) or we keep using
the same reset driver for other devices.

> we will always end returning -EPROBE_DEFER.
> 
> How about this
>     reg =     <0x44e10620 0x4> ,
this has to be 16 bytes in size

>         <0x44e10648 0x1>;
this has to be 4 bytes in size.

>     reg-names = "phycontrol_dev" , "phywkup_dev";
> 
> and map for power on/off and phywkup separately in the control driver.
> 
>> +                reg-names = "control_dev";
>> +                status = "disabled";
>> +            };
>> +
> 
> <snip>
> 
>> diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
>> index 797e3fd..b7257ae 100644
>> --- a/drivers/usb/musb/Kconfig
>> +++ b/drivers/usb/musb/Kconfig
>> @@ -83,6 +83,7 @@ config USB_MUSB_AM35X
>>     config USB_MUSB_DSPS
>>       tristate "TI DSPS platforms"
>> +    select USB_MUSB_AM335X_CHILD
> 
> How about adding select AM335X_PHY_USB here?

For now maybe a good think but if we do multi platform support we
should recommend them instead of forcing users. What you think?

Sebastian

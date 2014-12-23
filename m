Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbaLWUJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 15:09:50 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:54161 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaLWUJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 15:09:49 -0500
Message-ID: <5499CC08.8000606@cogentembedded.com>
Date: Tue, 23 Dec 2014 23:09:44 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>
CC: myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        baolu.lu@linux.intel.com
Subject: Re: [RFC/PATCH] extcon: otg_gpio: add driver for USB OTG port controlled
 by GPIO(s)
References: <1419288217-19262-1-git-send-email-david.a.cohen@linux.intel.com> <549969D4.5020303@cogentembedded.com> <20141223195709.GA19996@psi-dev26.jf.intel.com>
In-Reply-To: <20141223195709.GA19996@psi-dev26.jf.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/23/2014 10:57 PM, David Cohen wrote:

>>> Some platforms have an USB OTG port fully (or partially) controlled by
>>> GPIOs:

>>> (1) USB ID is connected directly to GPIO

>>> Optionally:
>>> (2) VBUS is enabled by a GPIO (when ID is grounded)

>>     Can't the host driver still control Vbus?

> I can't a clean way for host driver to control VBUS considering it
> depends on USB ID.

    You're using the cable state notifiers, why not control Vbus from there?
You need some way of passing the GPIO to host driver though... I assume you're 
not using the device tree, and your host controllers live on PCI, so the 
platform data is out of question. You may be right then...

>>> (3) Platform has 2 USB controllers connected to same port: one for
>>>      device and one for host role. D+/- are switched between phys
>>>      by GPIO.

>>> As per initial version, this driver has the duty to control whether
>>> USB-Host cable is plugged in or not:
>>>   - If yes, OTG port is configured for host role
>>>   - If no, by standard, the OTG port is configured for device role

>>> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
>>> ---

>>> Hi,

>>> Some Intel Bay Trail boards have an unusual way to handle the USB OTG port:
>>>   - The USB ID pin is connected directly to GPIO on SoC
>>>   - When in host role, VBUS is provided by enabling a GPIO
>>>   - Device and host roles are supported by 2 independent controllers with D+/-
>>>     pins from port switched between different phys according a GPIO level.

>>> The ACPI table describes this USB port as a (virtual) device with all the
>>> necessary GPIOs. This driver implements support to this virtual device as an
>>> extcon class driver. All drivers that depend on the USB OTG port state (USB phy,
>>> PMIC, charge detection) will listen to extcon events.

>>     It's very close to my setup on R-Car R8A7791 based boards. :-)
>> I have already submitted Maxim MAX3355 OTG chip GPIO-based driver.

> Hm. I'll look for it. Thanks for pointing.

    http://marc.info/?l=linux-usb&m=141825413802370
    In my case, Vbus is not controlled via GPIO though. I would have probably 
used the generic GPIO extcon driver if I didn't have to drive MAX3355's SHDN# 
pin high...
    There were also some other patches for this issue, the one probably 
interesting to you is there:

    http://marc.info/?l=linux-usb&m=141877180912359

>>> Comments are welcome.

>>> Br, David

[...]

>>> +static int __init vuport_init(void)
>>> +{
>>> +	return platform_driver_register(&vuport_driver);
>>> +}
>>> +subsys_initcall(vuport_init);

>>     Hm, why?

> We have drivers that depend on this one during their probe.

    What about deferred probing? With EPROBE_DEFER we don't need to play the 
initcall games any more AFAIU.

> Br, David

WBR, Sergei


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab3E1IOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:14:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56713 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328Ab3E1IOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:14:51 -0400
Message-ID: <51A4676D.9010404@ti.com>
Date: Tue, 28 May 2013 11:14:37 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: =?UTF-8?B?QWRyaWVuIFZlcmfDqQ==?= <adrienverge@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Florian Fainelli <florian@openwrt.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yannick Brosseau <yannick.brosseau@gmail.com>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH] ARM: OMAP4: USB_EHCI_HCD needs USB_PHY and NOP_USB_XCEIV
References: <CANsc=4W7ZVuCoimeALsv6xEQAURYc=QYsCvXd_kZD-A52aTL5w@mail.gmail.com> <CANsc=4WDM0q=RwaN2ZrcNqgJ=fDsgGHcBDcufnDek4EVWcnGfw@mail.gmail.com> <201305272023.12281.arnd@arndb.de>
In-Reply-To: <201305272023.12281.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 09:23 PM, Arnd Bergmann wrote:
> On Saturday 25 May 2013, Adrien Vergé wrote:
>> On OMAP4 platforms, EHCI HCD needs the physical layer signalling
>> activated, along with the NOP USB Transceiver driver. Otherwise, the
>> kernel boots without registering any USB device.
> 
> This does not actually sound like a critical error: If a user forgets
> to enable a driver, that driver will not be loaded. Of course the
> kernel should not just crash when a non-essential driver is missing,
> and it should not fail to build, but your description sounds harmless.
> 
> Am I missing something?

Right, there is no crash or anything if the PHY drivers are not selected,
just that OMAP USB host will not work.

> 
>> This patch applies to Linux 3.10-rc2.
>>
>> Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
>> ---
>> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
>> index de94f26..47959d7 100644
>> --- a/drivers/usb/host/Kconfig
>> +++ b/drivers/usb/host/Kconfig
>> @@ -44,6 +44,8 @@ endif # USB_XHCI_HCD
>>  config USB_EHCI_HCD
>>         tristate "EHCI HCD (USB 2.0) support"
> 
> This is the wrong place: it should be in USB_EHCI_HCD_OMAP
> if any.

Right.
> 
>>         depends on USB_ARCH_HAS_EHCI
>> +       select USB_PHY if ARCH_OMAP4
>> +       select NOP_USB_XCEIV if ARCH_OMAP4
>>         ---help---
>>           The Enhanced Host Controller Interface (EHCI) is standard for USB 2.0
>>           "high speed" (480 Mbit/sec, 60 Mbyte/sec) host controller hardware.
> 
> 'select'ing USB_PHY sounds wrong too, I think you mean 'depends on'.
> 
> Also note that Roger Quadros has just removed the 'select NOP_USB_XCEIV'
> there, I think you should coordinate with him.

Selecting NOP_USB_XCEIV is wrong as it in turn depends on USB_PHY.

I'm not for depends as it would hide USB_EHCI_HCD_OMAP in menuconfig.
I'm for explicitly selecting both, as it makes the user's life much easier.
But I'm afraid maintainers might object to that.

The other option is to enable the required drivers in omap2plus_defconfig.
http://comments.gmane.org/gmane.linux.ports.arm.omap/97899

Maybe you could just resend that patch after addressing Kevin's comments?

cheers,
-roger

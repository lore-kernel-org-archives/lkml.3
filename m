Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaLSJ6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:58:47 -0500
Received: from senator.holtmann.net ([87.106.208.187]:36002 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaLSJ6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:58:45 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: bluetooth: Add hci_h4p driver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20141219095000.GA24703@amd>
Date: Fri, 19 Dec 2014 10:58:35 +0100
Cc: =?utf-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-bluetooth@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7DC7F8DF-CBC7-47CE-8B6F-5BA19ADBB3B6@holtmann.org>
References: <20141213223727.GA13894@amd> <97C706D6-765B-446A-8180-600F5FB6C68B@holtmann.org> <20141219095000.GA24703@amd>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

>> And you want to set the QUIRK_INVALID_BADDR. At least you want to do that in the final submission.
>> 
> 
> Ok, I found out that I can do it and result works, provided that I do
> hciconfig hci0 up/down first.

that should not be the case. Actually hciconfig uses old ioctl. A full Bluetooth system running bluetoothd (from BlueZ 5) will never use any old ioctl. Only an old system (BlueZ 4) will use ioctl.

> I have trouble understanding... h4p_hci_open() seems to be called as
> soon as I insmod the driver. Who does that? Is it some kind of udev
> magic?

As soon as you do hci_register_dev, it will bring up the device and run the basic initialization. That is needed to get the address, version information and features. Otherwise the mgmt interface can not work. We need basic information about the device.

So what the kernel will do internally when you find a device is bring it up, get the basics and then bring it back down (in case nobody uses it). See hci_power_on work.

> ...
>>> +#include "hci_h4p.h"
>>> +
>>> +#define BT_DBG(a...) do {} while(0)
>> 
>> Why is this needed? BT_DBG is hooked up with dynamic debug.
> ...
> 
> I did all the changes as requested. Thanks. I did't see harm in
> include guards, but I removed them; it is not important.

There is no harm in including the guards. We just don't do it for internal files. And thus if anyone tries to be sneaky and build circular inclusion they will fall flat on their faces. That is the only reason.

> 
>>> +	if (info->rx_count == 0) {
>>> +		/* H4+ devices should always send word aligned packets */
>>> +		if (!(info->rx_skb->len % 2))
>>> +			info->garbage_bytes++;
>>> +		h4p_recv_frame(info, info->rx_skb);
>> 
>> The h4p_recv_frame should maybe done inline here since it only handles 2 exception packets. Also to make it easy, just leave the function if (info->rx_count).
>> 
>> This packet processing feels like a bit of spaghetti code. I think that is better handled in a proper function that goes through it and not with many tiny sub functions.
>> 
> 
> Well, CodingStyle says something about functions that should be kept
> short... And when manually inlined, the inner function would have to
> be made less readable, as it uses return to shortcut processing. 

It also should not make me have to follow 3 functions to figure out what it is actually doing.

> 
> 
> To use __hci_cmd_sync()
> 
>>> +
>>> +	SET_HCIDEV_DEV(hdev, info->dev);
>>> +
>>> +	if (hci_register_dev(hdev) >= 0)
>>> +		return 0;
>>> +
>>> +	dev_err(info->dev, "hci_register failed %s.\n", hdev->name);
>>> +	hci_free_dev(info->hdev);
>>> +	return -ENODEV;
>>> +}
>> 
>> And normally this is folded into the probe handling and not in a
>> separate function.
> 
> The probe function is too long, already...

Have you compared it to other functions. Normally probe() functions in general are all pretty long since they have to do tons of stuff. Having all in one function means you can read through it at once.

> 
>>> +#include <linux/delay.h>
>>> +#include <linux/clk.h>
>>> +
>>> +#include <linux/io.h>
>>> +
>>> +#include "hci_h4p.h"
>> 
>> Why is this a separate file? And if so, why not all UART specific details are in this file. Including bunch of the defines you have in the header.
>> 
> 
> Well, you wanted less global functions, so I moved some as inlines to
> headers. I guess I can merge nokia_core and nokia_uart if really wanted.

Would this become easier when some of the OMAP specific stuff is moved out of this driver? If that is possible.

Regards

Marcel


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaFBA5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 20:57:45 -0400
Received: from donald.hachti.de ([188.40.85.216]:49510 "EHLO donald.hachti.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbaFBA5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 20:57:43 -0400
Message-ID: <538BCC03.3090606@hachti.de>
Date: Mon, 02 Jun 2014 02:57:39 +0200
From: Philipp Hachtmann <hachti@hachti.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: jhovold@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] usb/ftdi_sio: Add support for setting CBUS pins on
 FT232H
References: <1401579066-8298-1-git-send-email-hachti@hachti.de> <1401579066-8298-3-git-send-email-hachti@hachti.de> <20140601000059.27360.qmail@stuge.se> <538A7063.8010205@hachti.de> <20140601023106.GA4961@kroah.com>
In-Reply-To: <20140601023106.GA4961@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.06.2014 04:31, Greg KH wrote:
> As they are GPIO pins on this device, it should be the subsystem that
> controls it.  That way, userspace programs that are used to talk to a
> GPIO device will "just work", and not have to be customized just for
> this specific device and sysfs file.

> So please use the GPIO subsystem instead of creating your own interface.

Yes but... I should have avoided the term "GPIO".

The FT232H (and other chips of the family) are communication controller ICs that 
support several operation modes. The usb-serial driver partially supports the 
chips' functionalities by supplying a tty device to the system.
At least the FT232H has something called CBUS: Four (!) bits of GPIO that 
*might* be available depending on the device's configuration stored in an EEPROM 
attached to the chip. For example if the chip is in sync FIFO mode, only two of 
those bits reach the chip's surface.

I'll try to discuss two use cases:

1. Someone builds hardware with an FT chip and some general functionality 
attached to the four usable CBUS lines, totally unrelated to the chip's 
FIFO/UART etc. functionality.
In that case I would strongly recommend to register the CBUS stuff with the GPIO 
subsystem. The user then could - as you noted - run any program used to deal 
with official GPIO pins on top of the four lines.
But I think that this use case is one of the less likely ones.

2. Someone builds hardware which uses some CBUS pins to control external 
circuitry that also uses the UART/FIFO interface. Both with tight functional 
integration. The CBUS pins become something in the rank of modem status lines.
An application that uses the port also wants to easily access the CBUS pins. And 
it really knows what it does because it knows what it is doing. From my point of 
view this is the more common use case.

Consequently the best way to cover the CBUS pins would be via the device's 
ioctls. But as the device is driven by common tty and usb-serial code which 
handles the ioctls I currently see how to achieve that without breaking a lot.

The second best way I see is adding a property to sysfs. This would already help 
a lot. A program knowing about the hardware then *can* sanely play with the CBUS.

Adding the functionality to sysfs should not interfere with a possible provision 
of an "official" GPIO device (struct gpio_chip).

For me personally it's most important to get access to CBUS in any way where the 
relation of the tty and the CBUS is *not* lost. I see no point in exposing the 
CBUS to any userspace application that thinks it can play blinkenlights on them. 
But I also see no problem if someone wants the possibility and adds general GPIO 
support. The patch will provide a stable base to do so.

So please consider the patches as a starting point.













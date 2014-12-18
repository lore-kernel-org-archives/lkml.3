Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaLRPfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 10:35:51 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60363 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751098AbaLRPft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 10:35:49 -0500
Date: Thu, 18 Dec 2014 10:35:48 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Du, Changbin" <changbin.du@intel.com>
cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [DISCUSSION] USB device remote wakeup is not working for S3 case
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A01C428B4@SHSMSX103.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1412181028510.1745-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please tell your email client to wrap lines after 72 columns or so.

On Thu, 18 Dec 2014, Du, Changbin wrote:

> When I am checking usb remote wakeup code, I found that usb remote
> wakeup will not work after system going to S3 sate and I confirmed
> with my PC.

USB remote _does_ work.

> During enumeration, usb device will be set as wakeup capable by
> usb_set_device_state if it supports. Whether usb driver send
> SET_FEATURE(REMOTE_WAKUP) usb request when suspending on S3 depend on
> do_remote_wakeup flag which is set by choose_wakeup(). It can be
> simply presented as below.
>        do_remote_wakeup  = device_may_wakeup(&udev->dev);

That's right.

> The return value is always false since usb device is not marked as
> wakeup enabled(that is no one call device_set_wakeup_enable() for usb
> device). As a result, usb device will not signal wakeup event to
> host.

There's a simple solution: Call device_set_wakeup_enable() for the
device!  You can do this from the command line by:

	echo auto >/sys/bus/usb/devices/.../power/control

where the "..." is the pathname for your device.

> Maybe we should not allow all remote wakeup supported device can
> wakeup system by default. But for usb keyboard/mouse, I think it is
> not reasonable to disable it by default.

For USB keyboards, wakeup _is_ enabled by default.  See this section of 
code close to the end of usbhid_start():

	/* Some keyboards don't work until their LEDs have been set.
	 * Since BIOSes do set the LEDs, it must be safe for any device
	 * that supports the keyboard boot protocol.
	 * In addition, enable remote wakeup by default for all keyboard
	 * devices supporting the boot protocol.
	 */
	if (interface->desc.bInterfaceSubClass == USB_INTERFACE_SUBCLASS_BOOT &&
			interface->desc.bInterfaceProtocol ==
				USB_INTERFACE_PROTOCOL_KEYBOARD) {
		usbhid_set_leds(hid);
		device_set_wakeup_enable(&dev->dev, 1);
	}

> A simple way to fix this is that replace the device_may_wakeup by
> device_can_wakeup in choose_wakeup() function, just like on auto
> suspend case (usb remote wakeup works for rpm). Another way is to
> make usb device wakeup able by default. But both of them will make
> all usb devices can wakeup system. Have any better idea?

How about leaving everything the way it is now?  If you want to enable 
wakeup for something like a USB mouse, you can write a udev script to 
do it as shown above.

Alan Stern


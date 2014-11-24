Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaKXRrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:47:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:40378 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbaKXRrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:47:46 -0500
Message-ID: <54736F3E.5070502@linutronix.de>
Date: Mon, 24 Nov 2014 18:47:42 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: balbi@ti.com, George Cherian <george.cherian@ti.com>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: musb: core: Disable the Interrupts till BABBLE is
 fully handled
References: <1415953486-6000-1-git-send-email-george.cherian@ti.com> <20141118211734.GA19146@saruman>
In-Reply-To: <20141118211734.GA19146@saruman>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 10:17 PM, Felipe Balbi wrote:
> while this helps the situation it doesn't solve the problem I'm having
> with testusb on BBB when host port is connected to peripheral port on
> the same BBB.

Exactly. On the same device. I see the same problem if I connect host
to peripheral port on am335x-evm (as well as on BBB). I don't see this
if I connect cross-connect am335x-evm and BBB (no matter who plays
host).

> I still have:
> 
> # ./testusb -t 13 -c 10 -s 2048 -a
> unknown speed   /dev/bus/usb/002/004    0
> [  114.811407] usbtest 2-1:3.0: set altsetting to 0 failed, -71
> /dev/bus/usb/002/004 test 13 --> 71 (error 71)
> [  114.862387] CAUTION: musb: Babble Interrupt Occurred
> [  114.868132] usb 2-1: USB disconnect, device number 4
> [  114.961491] musb-hdrc musb-hdrc.1.auto: Restarting MUSB to recover from Babble
> [  115.430829] usb 2-1: new high-speed USB device number 5 using musb-hdrc
> [  115.573471] zero gadget: high-speed config #3: source/sink
> [  115.584014] usbtest 2-1:3.0: Linux gadget zero
> [  115.588682] usbtest 2-1:3.0: high-speed {control in/out bulk-in bulk-out} tests (+alt)
> 
> I think the driver is mis-detecting Babble. A babble only occurs when
> the device side tries to move data without the host asking for anything.

You receive a "set altsetting to 0 failed, -71" before you see the
babble. So either host or the device is not responding well. Too bad
both is on the same HW.

It might be, that the host is in sleep and it is not ready early enough.
I think that this somehow PM related because If I disable
CONFIG_PM_RUNTIME I don't see the problem anymore. So the babble event
looks valid even if under strange conditions.

And yes, the patch fixes the endless "Babble Interrupt" message and it
makes sense to keep the interrupts disabled until the device recovers
from the babble trouble.

Sebastian

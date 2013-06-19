Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3FSRE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:04:59 -0400
Received: from mout.gmx.net ([212.227.15.18]:63992 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032Ab3FSRE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:04:58 -0400
X-Authenticated: #25030245
X-Provags-ID: V01U2FsdGVkX19wBbJD2MdwBdm5S5eWaEXYCviyDqJMj5fGjXk4VL
	fHfLdB9AhB96Zc
Subject: Re: [PATCH] lp: implement proper detach function for parport_driver lp
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Hannes Weisbach <hannes_weisbach@gmx.net>
In-Reply-To: <20130603210816.GA22677@kroah.com>
Date: Wed, 19 Jun 2013 19:04:51 +0200
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1EA8660C-5E07-42FC-91D4-7924BE87D5D7@gmx.net>
References: <2009349A-75FD-4D5F-8F25-F8FD78F1A5D8@gmx.net> <20130603210816.GA22677@kroah.com>
To: Greg Kroah-Hartman <greg@kroah.com>
X-Mailer: Apple Mail (2.1085)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Signed-off-by: Hannes Weisbach <hannes_weisbach@gmx.net>
>> ---
>> Granted, for normal parport drivers this is usually not an issue,
>> because the device does not go away. However, I am currently writing a
>> Linux device driver for a USB to parallel port converter [0] and
>> therefore need proper detaching. Additionally, the wrong ref count
>> keeps me from simply rmmod my driver and insmod a new version while
>> developing and testing.
> 
> Really?  We already have a usb to parallel port driver in the kernel
> tree that seems to work just fine.

>  It's been there since the 2.3 kernel
> days, so either it has the same problem, or your driver is doing
> something odd.

Do you mean the USB Printer class driver for pseudo parallel port
adapters?  They don't use the char/lp.c printer driver.  (Or I didn't
see it).  I'm writing a driver for USB2LPT [0], which gives you a real
/dev/parportN-device in user space, with which you can do all the
bit-twiddling like with a real parallel port.

Or do you mean USS720 (misc/uss720.c) and MOS7715 (serial/mos7720.c)
drivers.  They are doing what I am doing: translating whatever the
user does on a /dev/parportN-node and sending device-specific commands
over USB.  When they do parport_announce_port(), lp.c should also be
initialized and they should have the same problem.

On second thought, my patch might not be optimal.  lp.c stores
instance-structs in an array of size 8.  So after 8 re-plugs, lp.c
will not instantiate any more printer devices.  I think I better go
all the way and replace that array with a list, to have a proper
solution.

[0] http://www-user.tu-chemnitz.de/~heha/bastelecke/Rund%20um%20den%20PC/USB2LPT/index.html.en
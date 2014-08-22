Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbaHVNSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:18:43 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:59817 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbaHVNSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:18:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140821164803.GB10066@atomide.com>
References: <20140821164803.GB10066@atomide.com>
Date: Fri, 22 Aug 2014 16:18:40 +0300
Message-ID: <CANOLnOM_5VXDAstbQN45wRyYq9k26PWM0z9uZ+C2VmhOqzCuEw@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: twl4030-usb: Fix lost interrupts after ID pin
 goes down
From: Grazvydas Ignotas <notasas@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 21, 2014 at 7:48 PM, Tony Lindgren <tony@atomide.com> wrote:
> Commit 249751f22380 ("usb: phy: twl4030-usb: poll for ID disconnect")
> added twl4030_id_workaround_work() to deal with lost interrupts
> after ID pin goes down. However, this currently only works for the
> insertion. The PHY interrupts are not working after disconnecting
> an USB-A device from the board, and the deeper idle states for
> omap are blocked as the USB controller stays busy.
>
> The issue can be solved by calling delayed work from twl4030_usb_irq()
> when ID pin is down and the PHY is not asleep like we already do
> in twl4030_id_workaround_work().

The way it is supposed to work is that after plugging in the cable
twl4030_phy_power_on() sees ID_GROUND and kicks off id_workaround_work
every second. When cable is unplugged, twl4030_id_workaround_work()
sees changes in STS_HW_CONDITIONS register and triggers events.
Doesn't that work for you, why do you need to trigger it from
twl4030_usb_irq() too?

> But as both twl4030_usb_irq() and twl4030_id_workaround_work()
> already do pretty much the same thing, let's call twl4030_usb_irq()
> from twl4030_id_workaround_work() instead of adding some more
> duplicate code.

The difference is the sysfs_notify() call, so now every time
id_workaround_work triggers (around once per second while the cable is
plugged) userspace will now get useless uevent. Haven't actually
checked if it really happens though, so I might be wrong.


-- 
Gražvydas

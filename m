Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaKSMvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 07:51:22 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:45116 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaKSMvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 07:51:20 -0500
Message-ID: <546C920A.7060800@free.fr>
Date: Wed, 19 Nov 2014 13:50:18 +0100
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:33.0) Gecko/20100101 Firefox/33.0 SeaMonkey/2.30
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Device Tree <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Looking for good references for ARM driver development
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I've been using several Linux distributions, and writing user-space programs, for 15 years.
I recently seized an opportunity to move into kernel development, mainly writing drivers
for an ARM SoC, and I'm finding the transition harder than I expected.

I'm having a hard time finding good reference material to bring me up to speed on the ins
and outs of driver development. Sure, I found Documentation/driver-model (eventually) but
I'm still missing the high-level overview that ties everything together, and makes my
brain click and "get it".

Many years ago, I read LDD2 and it was an eye-opener. We do have LDD3 at work, but it is
now almost 10 years old, and it doesn't document things like the platform bus, or the "new"
driver model, or hwmon, or cpufreq, or device tree, to name a few things on my plate.
(I'm writing drivers for the 3.14 kernel.)

http://www.xml.com/ldd/chapter/book/
http://www.makelinux.net/ldd3/

Are there more recent technical references, as good as LDD3, that cover "modern" aspects
of kernel development?

I've read good things about:

"Writing Linux Device Drivers: a guide with exercises"
by Jerry Cooperstein (2009)
originally written for 2.6.31, updated for 3.3
http://www.coopj.com/

What do kernel devs recommend as the worthy successor to LDD3?


To wrap up this (long) message, I'd like to post some of my questions, to highlight some
of my confusion. I'm writing a driver for a temperature sensor, which is supposed to work
within the hwmon/lm-sensors framework.

The sensor's API consists of 3 memory-mapped registers, which are accessible over the
SoC's memory bus. I first wrote a user-space proof-of-concept to interact with the
sensors, accessing them through /dev/mem O_SYNC + mmap. That works as expected, and
I now have the code to read the temperature when needed.

Next, I looked at the driver glue required to use these sensors from lm-sensors.
That's where my troubles started.

1) Which bus should I be using for this driver? Is the platform bus appropriate?

2) platform.txt states

> Some drivers are not fully converted to the driver model, because they take
> on a non-driver role:  the driver registers its platform device, rather than
> leaving that for system infrastructure.  Such drivers can't be hotplugged
> or coldplugged, since those mechanisms require device creation to be in a
> different system component than the driver.

How do I "leave device registration for the system infrastructure"?
Where should I put that code?
Is it a good idea to separate device registration and driver registration
in the case of a SoC, where the device is embedded in the SoC and is not
"hot-plugged" (or anything-plugged for that matter, it's just "there").

3) Why is the function used to "destroy a platform device" named
platform_device_put? Why put?
Put on a list of things to destroy at a later time?

4) Can I use platform_driver_probe, instead of platform_driver_register?
The comments in platform.c state:
> /**
>  * platform_driver_probe - register driver for non-hotpluggable device
>  * @drv: platform driver structure
>  * @probe: the driver probe routine, probably from an __init section
>  *
>  * Use this instead of platform_driver_register() when you know the device
>  * is not hotpluggable and has already been registered, and you want to
>  * remove its run-once probe() infrastructure from memory after the driver
>  * has bound to the device.
>  *
>  * One typical use for this would be with drivers for controllers integrated
>  * into system-on-chip processors, where the controller devices have been
>  * configured as part of board setup.
>  *
>  * Note that this is incompatible with deferred probing.
>  *
>  * Returns zero if the driver registered and bound to a device, else returns
>  * a negative error code and with the driver not registered.
>  */

AFAICT, I need to answer question 2 before I can answer this one.
How do I get "devices have been configured as part of board setup."?

5) Very hwmon-specific, how often are temperature sensors probed?
Does the frequency vary? (Through /sys knobs? Or something else?)


That's all I have on my mind at the moment (well, aside from some ARM TLB
shenanigans, but that's another story for another time).

I shall be eternally grateful to anyone who can enlighten me through advice,
pointers, references, documentation, voodoo, etc.

Regards.

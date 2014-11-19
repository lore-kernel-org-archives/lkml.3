Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaKSQ5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:57:53 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39643 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbaKSQ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:57:51 -0500
Message-ID: <546CCBF6.7070607@gmail.com>
Date: Wed, 19 Nov 2014 22:27:26 +0530
From: Victor Ascroft <victorascroft@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: mpeg.blue@free.fr
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: Looking for good references for ARM driver development
References: <546C920A.7060800@free.fr>
In-Reply-To: <546C920A.7060800@free.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 06:20 PM, Mason wrote:
> Hello everyone,
> 
> I've been using several Linux distributions, and writing user-space programs, for 15 years.
> I recently seized an opportunity to move into kernel development, mainly writing drivers
> for an ARM SoC, and I'm finding the transition harder than I expected.
> 
> I'm having a hard time finding good reference material to bring me up to speed on the ins
> and outs of driver development. Sure, I found Documentation/driver-model (eventually) but
> I'm still missing the high-level overview that ties everything together, and makes my
> brain click and "get it".
> 
> Many years ago, I read LDD2 and it was an eye-opener. We do have LDD3 at work, but it is
> now almost 10 years old, and it doesn't document things like the platform bus, or the "new"
> driver model, or hwmon, or cpufreq, or device tree, to name a few things on my plate.
> (I'm writing drivers for the 3.14 kernel.)
> 
> http://www.xml.com/ldd/chapter/book/
> http://www.makelinux.net/ldd3/
> 
> Are there more recent technical references, as good as LDD3, that cover "modern" aspects
> of kernel development?

The LDD3 is one of the best there is. A fourth edition is suppose to come out sometime
next year. 
http://www.amazon.com/Linux-Device-Drivers-Jessica-McKellar/dp/1449371612

> 
> I've read good things about:
> 
> "Writing Linux Device Drivers: a guide with exercises"
> by Jerry Cooperstein (2009)
> originally written for 2.6.31, updated for 3.3
> http://www.coopj.com/
> 
> What do kernel devs recommend as the worthy successor to LDD3?
> 
> 
> To wrap up this (long) message, I'd like to post some of my questions, to highlight some
> of my confusion. I'm writing a driver for a temperature sensor, which is supposed to work
> within the hwmon/lm-sensors framework.
> 
> The sensor's API consists of 3 memory-mapped registers, which are accessible over the
> SoC's memory bus. I first wrote a user-space proof-of-concept to interact with the
> sensors, accessing them through /dev/mem O_SYNC + mmap. That works as expected, and
> I now have the code to read the temperature when needed.
> 
> Next, I looked at the driver glue required to use these sensors from lm-sensors.
> That's where my troubles started.
> 
> 1) Which bus should I be using for this driver? Is the platform bus appropriate?
> 
> 2) platform.txt states
> 
>> Some drivers are not fully converted to the driver model, because they take
>> on a non-driver role:  the driver registers its platform device, rather than
>> leaving that for system infrastructure.  Such drivers can't be hotplugged
>> or coldplugged, since those mechanisms require device creation to be in a
>> different system component than the driver.
> 
> How do I "leave device registration for the system infrastructure"?
> Where should I put that code?
> Is it a good idea to separate device registration and driver registration
> in the case of a SoC, where the device is embedded in the SoC and is not
> "hot-plugged" (or anything-plugged for that matter, it's just "there").

For understanding this you need to understand how the platform infrastructure
works and why is it used.
http://lwn.net/Articles/448499/
http://lwn.net/Articles/448502/
and go through some of the relevant drivers. 
> 
> 3) Why is the function used to "destroy a platform device" named
> platform_device_put? Why put?
> Put on a list of things to destroy at a later time?

This should be more clear once you go through LDD3.

> 
> 4) Can I use platform_driver_probe, instead of platform_driver_register?
> The comments in platform.c state:
>> /**
>>  * platform_driver_probe - register driver for non-hotpluggable device
>>  * @drv: platform driver structure
>>  * @probe: the driver probe routine, probably from an __init section
>>  *
>>  * Use this instead of platform_driver_register() when you know the device
>>  * is not hotpluggable and has already been registered, and you want to
>>  * remove its run-once probe() infrastructure from memory after the driver
>>  * has bound to the device.
>>  *
>>  * One typical use for this would be with drivers for controllers integrated
>>  * into system-on-chip processors, where the controller devices have been
>>  * configured as part of board setup.
>>  *
>>  * Note that this is incompatible with deferred probing.
>>  *
>>  * Returns zero if the driver registered and bound to a device, else returns
>>  * a negative error code and with the driver not registered.
>>  */
> 
> AFAICT, I need to answer question 2 before I can answer this one.
> How do I get "devices have been configured as part of board setup."?

This actually depends on the kernel you are using. Do you have relatively
new kernel or an old one? Depending on that, either you will get that
information in a board file or else in the device tree in arch/arm/boot/dts.
> 
> 5) Very hwmon-specific, how often are temperature sensors probed?
> Does the frequency vary? (Through /sys knobs? Or something else?)
> 
> 
> That's all I have on my mind at the moment (well, aside from some ARM TLB
> shenanigans, but that's another story for another time).
> 
> I shall be eternally grateful to anyone who can enlighten me through advice,
> pointers, references, documentation, voodoo, etc.

This depends. If you have driver compiled in with the kernel this will happen
on kernel boot up. If you have the driver as a loadable module, the probe hook
will be called on modprobe or insmod.

My blog: http://coherentmusings.wordpress.com/

Some practical stuff on there which might be useful to you.

--Regards,
Sanchayan.

> 
> Regards.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

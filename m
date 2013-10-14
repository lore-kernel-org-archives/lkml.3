Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab3JNSoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:44:46 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54424 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188Ab3JNSon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:44:43 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v4 05/17] arch_timer: Move to generic sched_clock framework
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
	<1374189690-10810-6-git-send-email-sboyd@codeaurora.org>
Date: Mon, 14 Oct 2013 11:44:40 -0700
In-Reply-To: <1374189690-10810-6-git-send-email-sboyd@codeaurora.org> (Stephen
	Boyd's message of "Thu, 18 Jul 2013 16:21:18 -0700")
Message-ID: <87k3hf7kvb.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> writes:

> Register with the generic sched_clock framework now that it
> supports 64 bits. This fixes two problems with the current
> sched_clock support for machines using the architected timers.
> First off, we don't subtract the start value from subsequent
> sched_clock calls so we can potentially start off with
> sched_clock returning gigantic numbers. Second, there is no
> support for suspend/resume handling so problems such as discussed
> in 6a4dae5 (ARM: 7565/1: sched: stop sched_clock() during
> suspend, 2012-10-23) can happen without this patch. Finally, it
> allows us to move the sched_clock setup into drivers clocksource
> out of the arch ports.
>
> Cc: Christopher Covington <cov@codeaurora.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

A boot failure on Exynos5/Arndale showed up in next-20131014[1], and a
subsequent bisect has fingered this patch as the culprit.  

I haven't had a chance to debug this any further, but wanted to share in
case someone else can debug.  

The console log is below, but don't think there is much useful there as
it shows nothing after the 'Starting kernel ...' from u-boot.

Kevin

[1] http://lists.linaro.org/pipermail/kernel-build-reports/2013-October/000651.html

Connected to arndale console [channel connected] (~$quit to exit)
(user:khilman) is already connected

~$hardreset

Command(arndale console)> hardreset
(user:khilman) Reboot arndale
Reboot: arndale ; phidget 2 0 :  off, sleep, on


U-Boot 2013.01.-rc1-dirty (Jun 28 2013 - 07:14:48) for ARNDALE5250

CPU:	Exynos5250@1000MHz

Board:  for ARNDALE5250
I2C:   ready
DRAM:  2 GiB
WARNING: Caches not enabled

Checking Boot Mode ... SDMMC
MMC:   EXYNOS DWMMC: 0, EXYNOS DWMMC: 1, EXYNOS DWMMC: 2
In:    serial
Out:   serial
Err:   serial
Net:   No ethernet found.
(Re)start USB...
USB0:   USB EHCI 1.00
scanning bus 0 for devices... 4 USB Device(s) found
       scanning usb for storage devices... 0 Storage Device(s) found
       scanning usb for ethernet devices... 1 Ethernet Device(s) found
Hit any key to stop autoboot: 
 3  0 
ARNDALE5250 # version
version

U-Boot 2013.01.-rc1-dirty (Jun 28 2013 - 07:14:48) for ARNDALE5250
arm-linux-gnueabi-gcc (Ubuntu/Linaro 4.7.2-1ubuntu1) 4.7.2
GNU ld (GNU Binutils for Ubuntu) 2.22.90.20120919
ARNDALE5250 # setenv bootargs console=tty0 console=ttySAC2,115200n8 rw root=/dev/mmcblk1p3 rootwait rootfstype=ext4
setenv bootargs console=tty0 console=ttySAC2,115200n8 rw root=/dev/mmcblk1p3 rootwait rootfstype=ext4
ARNDALE5250 # setenv netargs 'setenv bootargs ${bootargs} ip=${ipaddr}:${serverip}:${gatewayip}:${netmask}::::192.168.1.254:none'
setenv netargs 'setenv bootargs ${bootargs} ip=${ipaddr}:${serverip}:${gatewayip}:${netmask}::::192.168.1.254:none'
ARNDALE5250 # if test -n ${initenv}; then run initenv; fi
if test -n ${initenv}; then run initenv; fi
ARNDALE5250 # if test -n ${preboot}; then run preboot; fi
if test -n ${preboot}; then run preboot; fi
(Re)start USB...
USB0:   USB EHCI 1.00
scanning bus 0 for devices... 4 USB Device(s) found
       scanning usb for storage devices... 0 Storage Device(s) found
       scanning usb for ethernet devices... 1 Ethernet Device(s) found
ARNDALE5250 #setenv autoload no; setenv autoboot no
 setenv autoload no; setenv autoboot no
ARNDALE5250 # dhcp
dhcp
Waiting for Ethernet connection... done.
BOOTP broadcast 1
DHCP client bound to address 192.168.1.171
ARNDALE5250 # setenv serverip 192.168.1.2
setenv serverip 192.168.1.2
ARNDALE5250 # if test -n ${netargs}; then run netargs; fi
if test -n ${netargs}; then run netargs; fi
ARNDALE5250 # tftp 0x40800000 tmp/arndale-lNb7OG/zImage
tftp 0x40800000 tmp/arndale-lNb7OG/zImage
Waiting for Ethernet connection... done.
Using asx0 device
TFTP from server 192.168.1.2; our IP address is 192.168.1.171
Filename 'tmp/arndale-lNb7OG/zImage'.
Load address: 0x40800000
Loading: *#################################################################
	 #################################################################
	 #######################################################
done
Bytes transferred = 2709912 (295998 hex)
ARNDALE5250 # tftp 0x407c0000 tmp/arndale-lNb7OG/exynos5250-arndale.dtb
tftp 0x407c0000 tmp/arndale-lNb7OG/exynos5250-arndale.dtb
Waiting for Ethernet connection... done.
Using asx0 device
TFTP from server 192.168.1.2; our IP address is 192.168.1.171
Filename 'tmp/arndale-lNb7OG/exynos5250-arndale.dtb'.
Load address: 0x407c0000
Loading: *###
done
Bytes transferred = 32949 (80b5 hex)
ARNDALE5250 # printenv bootargs
printenv bootargs
bootargs=console=tty0 console=ttySAC2,115200n8 rw root=/dev/mmcblk1p3 rootwait rootfstype=ext4 ip=192.168.1.171:192.168.1.2:192.168.1.254:255.255.255.0::::192.168.1.254:none
ARNDALE5250 # bootz 0x40800000 - 0x407c0000
bootz 0x40800000 - 0x407c0000
## Flattened Device Tree blob at 407c0000
   Booting using the fdt blob at 0x407c0000
   Using Device Tree in place at 407c0000, end 407cb0b4

Starting kernel ...

~$off
# PYBOOT: Exception: kernel: ERROR: did not start booting.
# PYBOOT: Time: 33.50 seconds.
# PYBOOT: Result: FAIL

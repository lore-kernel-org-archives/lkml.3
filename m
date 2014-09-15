Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaIOPub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:50:31 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:44785 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbaIOPu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:50:27 -0400
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Mon, 15 Sep 2014 17:50:04 +0200
Message-ID: <CAH9NwWd46W-ad_o0T1dCBVTuQYEB7GJCZi=zW340-b=hZNVfCA@mail.gmail.com>
Subject: requesting modules in the i2c-core in case of OF
To: linux-i2c@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

I spend some time to debug an issue that our touch driver does not get
loaded even
if defined in devicetree. I enabled core debug and added a printk to
kernel/kmod.c

[    0.223468] usbcore: registered new interface driver usbfs
[    0.223558] usbcore: registered new interface driver hub
[    0.223698] usbcore: registered new device driver usb
[    0.224557] i2c i2c-1: adapter [21a4000.i2c] registered
[    0.224583] i2c i2c-1: of_i2c: walking child nodes
[    0.224596] i2c i2c-1: of_i2c: register
/soc/aips-bus@02100000/i2c@021a4000/ar1021@4d
[    0.224628] __request_module: i2c:ar1021_i2c
[    0.225144] i2c 1-004d: uevent
[    0.225183] i2c i2c-1: client [ar1021_i2c] registered with bus id 1-004d
[    0.225198] i2c i2c-1: of_i2c: register
/soc/aips-bus@02100000/i2c@021a4000/pca9555@20
[    0.225213] __request_module: i2c:pca9555
[    0.225519] i2c 1-0010: uevent
[    0.225577] pca953x 1-0010: probe
[    0.225602] i2c i2c-1: master_xfer[0] W, addr=0x10, len=1


Now it gets interesting :)

root@OT:/# modinfo ar1021_i2c
filename:
/lib/modules/3.14.18/kernel/drivers/input/touchscreen/ar1021_i2c.ko
license:        GPL
description:    Microchip AR1021 I2C Driver
author:         Christian Gmeiner <christian.gmeiner@gmail.com>
alias:          of:N*T*Cmicrochip,ar1021_i2c*
alias:          i2c:MICROCHIP_AR1021_I2C
depends:
intree:         Y
vermagic:       3.14.18 SMP preempt mod_unload ARMv7 p2v8

So the ar1021_i2c driver is build as kernel module and at this point
it is not possible to modprobe/request that module
as the RFS is not yet mounted and the initramfs does not contain this driver.

Should the i2c-core not load the requested driver in an deferred way?
Any opinions?

By the way the ar1021_i2c driver can be found here:
https://www.mail-archive.com/linux-input@vger.kernel.org/msg08071.html

Greets
--
Christian Gmeiner, MSc

https://soundcloud.com/christian-gmeiner

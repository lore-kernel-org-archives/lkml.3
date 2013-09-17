Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3IQLVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:21:54 -0400
Received: from smtp1.uu.se ([130.238.7.54]:45400 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab3IQLVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:21:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21048.15143.580015.875306@pilspetsen.it.uu.se>
Date: Tue, 17 Sep 2013 13:21:11 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Subject: [3.12-rc1 regression] X fails to start on Latitude E6510 w/ NOUVEAU DRM driver
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dell Latitude E6510, CONFIG_DRM_NOUVEAU, 64-bit Fedora 17 user-space, Xorg drivers, and

01:00.0 VGA compatible controller: nVidia Corporation GT218 [NVS 3100M] (rev a2).

With 3.11 X starts fine, with 3.12-rc1 it fails with the following in Xorg.0.log:

...
[    56.819] (II) Loading /usr/lib64/xorg/modules/drivers/nouveau_drv.so
[    56.842] (II) Module nouveau: vendor="X.Org Foundation"
[    56.842]    compiled for 1.12.2, module version = 0.0.16
[    56.842]    Module class: X.Org Video Driver
[    56.842]    ABI class: X.Org Video Driver, version 12.0
[    56.842] (II) NOUVEAU driver 
[    56.842] (II) NOUVEAU driver for NVIDIA chipset families :
[    56.842]    RIVA TNT        (NV04)
[    56.842]    RIVA TNT2       (NV05)
[    56.842]    GeForce 256     (NV10)
[    56.842]    GeForce 2       (NV11, NV15)
[    56.842]    GeForce 4MX     (NV17, NV18)
[    56.842]    GeForce 3       (NV20)
[    56.842]    GeForce 4Ti     (NV25, NV28)
[    56.842]    GeForce FX      (NV3x)
[    56.842]    GeForce 6       (NV4x)
[    56.842]    GeForce 7       (G7x)
[    56.842]    GeForce 8       (G8x)
[    56.842]    GeForce GTX 200 (NVA0)
[    56.842]    GeForce GTX 400 (NVC0)
[    56.842] (--) using VT number 7

[    56.845] drmOpenDevice: node name is /dev/dri/card0
[    56.845] drmOpenDevice: open result is 9, (OK)
[    56.845] drmOpenByBusid: Searching for BusID pci:0000:01:00.0
[    56.845] drmOpenDevice: node name is /dev/dri/card0
[    56.845] drmOpenDevice: open result is 9, (OK)
[    56.845] drmOpenByBusid: drmOpenMinor returns 9
[    56.845] drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
[    56.845] (EE) [drm] failed to open device
[    56.845] (EE) No devices detected.

With 3.11 one instead sees:

...
[    33.879] drmOpenByBusid: drmOpenMinor returns 9
[    33.879] drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
[    33.879] (II) [drm] nouveau interface version: 1.1.1
[    33.879] (II) Loading sub module "dri"
...

There are no messages in the kernel's log that indicate any problem.

stracing xinit shows:

964   open("/dev/dri/card0", O_RDWR)    = 9
964   write(0, "[  1120.365] ", 13)     = 13
964   write(0, "drmOpenDevice: open result is 9,"..., 38) = 38
964   write(0, "[  1120.365] ", 13)     = 13
964   write(0, "drmOpenByBusid: drmOpenMinor ret"..., 39) = 39
964   ioctl(9, 0xc0106407, 0x7fffda0d4800) = 0
964   ioctl(9, 0xc0106401, 0x7fffda0d4800) = 0
964   ioctl(9, 0xc0106401, 0x7fffda0d4800) = 0
964   write(0, "[  1120.365] ", 13)     = 13
964   write(0, "drmOpenByBusid: drmGetBusid repo"..., 53) = 53
964   ioctl(9, 0xc0086420, 0x7fffda0d4870) = -1 EINVAL (Invalid argument)
964   fstat(9, {st_dev=makedev(0, 5), st_ino=2348, st_mode=S_IFCHR|0660, st_nlink=1, st_uid=0, st_gid=39, st_blksize=4096, st_blocks=0, st_rdev=makedev(226, 0), st_atime=2013/09/17-11:25:35, st_mtime=2013/09/17-11:25:35, st_ctime=2013/09/17-11:43:58}) = 0
964   fstat(9, {st_dev=makedev(0, 5), st_ino=2348, st_mode=S_IFCHR|0660, st_nlink=1, st_uid=0, st_gid=39, st_blksize=4096, st_blocks=0, st_rdev=makedev(226, 0), st_atime=2013/09/17-11:25:35, st_mtime=2013/09/17-11:25:35, st_ctime=2013/09/17-11:43:58}) = 0
964   close(9)                          = 0
964   write(0, "[  1120.366] ", 13)     = 13
964   write(0, "(EE) [drm] failed to open device"..., 33) = 33

So it looke like that ioctl 0xc0086420 is the culprit.

Any ideas?  I may have time to try a bisection tomorrow.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbaAVJuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:50:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42245 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbaAVJt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:49:58 -0500
Date: Wed, 22 Jan 2014 10:49:51 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Cc: peter.chen@freescale.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Regression on next-20140116 [Was: [PATCH 3/3 v4] usb: chipidea:
 hw_phymode_configure moved before ci_usb_phy_init]
Message-ID: <20140122094951.GO26766@pengutronix.de>
References: <1386057710-3848-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <1386057710-3848-3-git-send-email-chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386057710-3848-3-git-send-email-chris.ruehl@gtsys.com.hk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 03, 2013 at 04:01:50PM +0800, Chris Ruehl wrote:
> usb: chipidea: hw_phymode_configure moved before ci_usb_phy_init
> hw_phymode_configure configures the PORTSC registers and allow the
> following phy_inits to operate on the right parameters. This fix a problem
> where the UPLI (ISP1504) could not detected, because the Viewport was not
> available and read the viewport return 0's only.
This patch (or a later revision of it to be more exact) made it into
mainline as cd0b42c2a6d2.

On an i.MX27 based machine I'm hitting an oops (see below) on
next-20140116 + a few patches. (I didn't switch to 3.13+ yet, as I think
not everything I need has landed there.) The oops goes away (and still
better, lsusb reports my connected devices instead of "unable to
initialize libusb: -99") when I do at least one of the following:

 - set CONFIG_USB_CHIPIDEA=y instead of =m
 - revert commit
      cd0b42c2a6d2 (usb: chipidea: put hw_phymode_configure before ci_usb_phy_init)

The few patches I mentioned above are:
- device tree stuff to support my machine inclusive pinmuxing
- ulpi and cs support for drivers/usb/phy/phy-generic.c
  (I got these from Chris Ruehl by PM, don't know if they were sent
  out in public already.)

Unhandled fault: external abort on non-linefetch (0x808) at 0xf4424584
Internal error: : 808 [#1] PREEMPT ARM
Modules linked in: ci_hdrc_imx(+) ci_hdrc ehci_hcd usbcore usb_common usbmisc_imx
CPU: 0 PID: 354 Comm: systemd-udevd Not tainted 3.13.0-rc8-next-20140116-00005-gf6e6ae599f37 #45
task: c389e0e0 ti: c3ab0000 task.ti: c3ab0000
PC is at ci_hdrc_probe+0x320/0x794 [ci_hdrc]
LR is at ci_hdrc_probe+0x310/0x794 [ci_hdrc]
pc : [<bf08970c>]    lr : [<bf0896fc>]    psr: 60000013
sp : c3ab1c48  ip : c041f1fc  fp : c3ab0030
r10: c3b2b9c0  r9 : c3a97000  r8 : 40000000
r7 : 8c000400  r6 : 00000000  r5 : c3a97010  r4 : c3a14010
r3 : f4424584  r2 : 00000000  r1 : 00000004  r0 : 00000024
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005317f  Table: a3ac8000  DAC: 00000015
Process systemd-udevd (pid: 354, stack limit = 0xc3ab01c0)
Stack: (0xc3ab1c48 to 0xc3ab2000)
1c40:                   d2000000 80000000 c3a97010 bf08b734 bf08b734 c389dc10
1c60: c0876958 00000000 c388d9c0 c01777b8 c01777a0 c3a97010 00000000 c0176440
1c80: 00000000 c3a97010 c0176588 c389dc10 00000000 c0174d74 c38214d8 c39c5454
1ca0: c3a97010 c3a97044 c3a97010 c017635c c3a97010 c036c638 c3a97010 c0175a60
1cc0: c3a97010 c3a97018 00000000 c01741ac 00000000 00000002 c3ab0030 c0248f10
1ce0: c035d1fc c3a97000 00000002 0000001c c3ab1d44 00000000 00000002 c0177628
1d00: 10024400 00000000 00000000 c3a97000 c3ab1d44 bf089c84 c389dc10 c3ad19b0
1d20: c389dc00 00000000 00000000 bf099610 00000000 bf0992e0 c3ab1d68 00000000
1d40: c00e6638 bf099614 00000100 00000000 c388b990 00000003 0000000a 00000001
1d60: 00000000 00000000 c3f79604 00000001 00000002 00000004 c3ad2dc0 c02e57da
1d80: c388f948 c3ad2d10 00000001 00000001 c389dc10 bf0997b8 bf0997b8 00000000
1da0: c0876958 00000001 00000000 c01777b8 c01777a0 c389dc10 00000000 c0176440
1dc0: c389dc10 c389dc44 bf0997b8 00000000 bf09b000 c017663c 00000000 bf0997b8
1de0: c01765cc c0174cd8 c38214a8 c3894750 bf0997b8 c39c5280 c036c638 c0175ca0
1e00: bf099778 00000350 00000000 bf0997b8 00000001 bf0997fc c3a386c0 c0176a30
1e20: 00000000 c3ab1f58 00000001 c0008910 c3ab0010 00000001 c0248a68 00000001
1e40: 00000001 c3a386f0 c086ad71 c0042c8c 60000013 c0361198 ffffffff bf0997fc
1e60: c086ad71 c0248a74 c03611b8 c0361194 00000000 c0037014 00000000 00000001
1e80: c3ab1f58 c3ab1f58 00000001 bf0997fc c3a386c0 bf099844 00000001 c3a386f0
1ea0: c086ad71 c0061764 bf099808 00007fff c005f2f4 bf000000 00000000 c005f480
1ec0: 00000000 bf099808 c3ab0028 bf09993c 00000000 c49a81a8 c3ab1eec b6eb68b4
1ee0: c49a7000 00001c74 007c1889 00000000 0000000c 00000000 00000000 00000000
1f00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
1f20: 00000000 00000000 00000000 00000000 00000010 00000000 b6eb68b4 00000006
1f40: 0000017b c000dda4 c3ab0000 00000000 00587ca8 c0061e54 c49a7000 00001c74
1f60: c49a7cd0 c49a7b79 c49a8718 0000094c 00000aac 00000000 00000000 00000000
1f80: 0000001f 00000020 00000016 00000000 00000012 00000000 00020000 00000000
1fa0: 00000000 c000dbe0 00020000 00000000 00000006 b6eb68b4 00000000 00000000
1fc0: 00020000 00000000 00000000 0000017b 00000000 00000000 0002d208 00587ca8
1fe0: bebd4ad8 bebd4ac8 b6eaec0c b6e2ca40 60000010 00000006 00000a6f e5d30014
[<bf08970c>] (ci_hdrc_probe [ci_hdrc]) from [<c01777b8>] (platform_drv_probe+0x18/0x48)
[<c01777b8>] (platform_drv_probe) from [<c0176440>] (driver_probe_device+0xb0/0x1f8)
[<c0176440>] (driver_probe_device) from [<c0174d74>] (bus_for_each_drv+0x74/0x88)
[<c0174d74>] (bus_for_each_drv) from [<c017635c>] (device_attach+0x6c/0x84)
[<c017635c>] (device_attach) from [<c0175a60>] (bus_probe_device+0x28/0xa0)
[<c0175a60>] (bus_probe_device) from [<c01741ac>] (device_add+0x3f8/0x4d4)
[<c01741ac>] (device_add) from [<c0177628>] (platform_device_add+0x128/0x1bc)
[<c0177628>] (platform_device_add) from [<bf089c84>] (ci_hdrc_add_device+0x104/0x140 [ci_hdrc])
[<bf089c84>] (ci_hdrc_add_device [ci_hdrc]) from [<bf0992e0>] (ci_hdrc_imx_probe+0x2ac/0x360 [ci_hdrc_imx])
[<bf0992e0>] (ci_hdrc_imx_probe [ci_hdrc_imx]) from [<c01777b8>] (platform_drv_probe+0x18/0x48)
[<c01777b8>] (platform_drv_probe) from [<c0176440>] (driver_probe_device+0xb0/0x1f8)
[<c0176440>] (driver_probe_device) from [<c017663c>] (__driver_attach+0x70/0x94)
[<c017663c>] (__driver_attach) from [<c0174cd8>] (bus_for_each_dev+0x70/0x84)
[<c0174cd8>] (bus_for_each_dev) from [<c0175ca0>] (bus_add_driver+0xd8/0x1cc)
[<c0175ca0>] (bus_add_driver) from [<c0176a30>] (driver_register+0x9c/0xe0)
[<c0176a30>] (driver_register) from [<c0008910>] (do_one_initcall+0x94/0x140)
[<c0008910>] (do_one_initcall) from [<c0061764>] (load_module+0x13dc/0x1998)
[<c0061764>] (load_module) from [<c0061e54>] (SyS_finit_module+0x5c/0x6c)
[<c0061e54>] (SyS_finit_module) from [<c000dbe0>] (ret_fast_syscall+0x0/0x44)
Code: e5d42e52 e5943060 e3520000 1a000000 (e5837000)
---[ end trace f02dcc94b8467706 ]---

bf08970c is the str instruction of

	hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);

in hw_phymode_configure().

Any ideas to fix that apart from reverting the commit above (or changing
USB_CHIPIDEA to bool :-)?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

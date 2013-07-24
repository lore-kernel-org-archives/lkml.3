Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3GXSv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:51:28 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:58118 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3GXSv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:51:26 -0400
Date: Wed, 24 Jul 2013 21:51:19 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Daniel Mack <zonque@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: v3.11-rc1 USB regressions
Message-ID: <20130724185119.GB26943@blackmetal.musicnaut.iki.fi>
References: <20130715225647.GE3296@blackmetal.musicnaut.iki.fi>
 <51E4E922.2040707@gmail.com>
 <20130716175710.GA14385@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716175710.GA14385@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 16, 2013 at 08:57:10PM +0300, Aaro Koskinen wrote:
> On Tue, Jul 16, 2013 at 08:33:06AM +0200, Daniel Mack wrote:
> > > 	fe4cb0912f8e737f8e4b8b38b9e692f8062f5423
> > > 	usb: musb: gadget: remove hcd initialization
> > > 	(Reverting this fixes error "cdc_ether: probe of 4-1:1.0 failed
> > > 	 with error -110" seen on the host side.)
> > 
> > Which role does your musb-based hardware have in this case, and which
> > MUSB_* config symbols do you set? You should have USB_MUSB_GADGET.
> 
> Here are full details:
> 
> Kernel v3.11-rc1 and the following USB fixes:
> 	ARM: omap2: fix musb usage for n8x0
> 	musb: omap: Fix: pass all the resources to musb core

[...]

> When I revert fe4cb0912f8e737f8e4b8b38b9e692f8062f5423 and
> 8b125df5b24cfb0ec7fa1971e343cc0badc1827d, it works like before (3.10):

I'm now running -rc2 with above fixes and reverts (the only way to get
USB working). I'm seeing an additional issue, the following crash happens
always on N900 when doing "poweroff":

[   33.198699] musb-hdrc musb-hdrc.0.auto: remove, state 4
[   33.206817] usb usb1: USB disconnect, device number 1
[   33.215332] musb-hdrc musb-hdrc.0.auto: USB bus 1 deregistered
[   33.225128] Unable to handle kernel NULL pointer dereference at virtual address 00000028
[   33.236083] pgd = c0914000
[   33.241149] [00000028] *pgd=8efc8831, *pte=00000000, *ppte=00000000
[   33.250213] Internal error: Oops: 17 [#1] ARM
[   33.257141] Modules linked in: usb_f_ecm g_ether u_ether libcomposite configfs omapfb cfbcopyarea cfbimgblt cfbfillrect panel_acx565akm
[   33.275146] CPU: 0 PID: 760 Comm: poweroff Not tainted 3.11.0-rc2-n9xx #1
[   33.284881] task: cefb8680 ti: c08c6000 task.ti: c08c6000
[   33.293151] PC is at usb_remove_hcd+0x10/0x178
[   33.300384] LR is at musb_gadget_stop+0x184/0x1a8
[   33.307830] pc : [<c02499d0>]    lr : [<c0261688>]    psr: 20000013
[   33.307830] sp : c08c7da0  ip : c08c7dc0  fp : c08c7dbc
[   33.324920] r10: 00000000  r9 : c08c6000  r8 : 20000013
[   33.332916] r7 : cf814010  r6 : cf814fa0  r5 : cf814fa0  r4 : 00000000
[   33.342315] r3 : c0262b80  r2 : 00000001  r1 : c0d9edd0  r0 : 00000000
[   33.351715] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   33.361846] Control: 10c5387d  Table: 80914019  DAC: 00000015
[   33.370483] Process poweroff (pid: 760, stack limit = 0xc08c6238)
[   33.379486] Stack: (0xc08c7da0 to 0xc08c8000)
[   33.386627] 7da0: c0262b80 00000000 00000000 cf814fa0 c08c7de4 c08c7dc0 c0261688 c02499cc
[   33.397918] 7dc0: c0261504 cef2d200 cf814fa0 cf93fc44 c0d9d698 c0c8bb9c c08c7dfc c08c7de8
[   33.409149] 7de0: c0262dd8 c0261510 bf03f3a4 cef2d200 c08c7e14 c08c7e00 c0263894 c0262d60
[   33.420440] 7e00: cf814010 cf93fc10 c08c7e24 c08c7e18 c0261c80 c026380c c08c7e3c c08c7e28
[   33.431732] 7e20: c025b2a4 c0261c78 cf93fc1c cf93fc10 c08c7e4c c08c7e40 c01e88ec c025b27c
[   33.443023] 7e40: c08c7e74 c08c7e50 c01e55d0 c01e88d8 00000000 4321fedc 4321fedc 00070784
[   33.454315] 7e60: fee1dead c000e848 c08c7e84 c08c7e78 c00553c4 c01e55ac c08c7fa4 c08c7e88
[   33.465606] 7e80: c0055658 c0055394 ffffffff 00000000 00000020 cef3add0 c0c72f6c 00000000
[   33.476898] 7ea0: c08c7ecc c08c7eb0 c017a914 c01791d0 00000001 00000001 c0c74078 00000000
[   33.488159] 7ec0: c08c7efc c08c7ed0 c00524b8 c017a8e8 00000001 00000007 c0337640 c0c5d9e4
[   33.499328] 7ee0: b6e5d670 c08c7fb0 00000000 b6f28000 c08c7fac c08c7f00 c0008514 c033764c
[   33.510498] 7f00: 00000000 c08c7f04 c08c7f04 7fffffff cefc1c00 00000000 00000001 00000010
[   33.521667] 7f20: 00000002 00000000 00000000 c08c7f00 cefc1c00 cef4da00 00000000 cefc1c00
[   33.532836] 7f40: cf803858 cf8037d4 c00e0528 00000000 c08c7f84 c08c7f60 c00ea404 c00d1bb0
[   33.544067] 7f60: 00000000 00000000 00000004 00000055 00000024 c000e848 c08c7fa4 c08c7f88
[   33.555297] 7f80: c00e0698 c00ea3a4 00000001 00000004 00000055 00000058 00000000 c08c7fa8
[   33.566528] 7fa0: c000e6a0 c00554a4 00000001 00000004 fee1dead 28121969 4321fedc 00070784
[   33.577789] 7fc0: 00000001 00000004 00000055 00000058 00000000 00000000 b6f28000 00000000
[   33.589080] 7fe0: b6e5d740 be88ccc0 000605f8 b6e5d758 60000010 fee1dead 8fefe821 8fefec21
[   33.600402] Backtrace: 
[   33.605621] [<c02499c0>] (usb_remove_hcd+0x0/0x178) from [<c0261688>] (musb_gadget_stop+0x184/0x1a8)
[   33.620666]  r5:cf814fa0 r4:00000000
[   33.627166] [<c0261504>] (musb_gadget_stop+0x0/0x1a8) from [<c0262dd8>] (usb_gadget_remove_driver+0x84/0xa4)
[   33.643005]  r8:c0c8bb9c r7:c0d9d698 r6:cf93fc44 r5:cf814fa0 r4:cef2d200
r3:c0261504
[   33.656890] [<c0262d54>] (usb_gadget_remove_driver+0x0/0xa4) from [<c0263894>] (usb_del_gadget_udc+0x94/0xd4)
[   33.673065]  r4:cef2d200 r3:bf03f3a4
[   33.679718] [<c0263800>] (usb_del_gadget_udc+0x0/0xd4) from [<c0261c80>] (musb_gadget_cleanup+0x14/0x18)
[   33.695465]  r5:cf93fc10 r4:cf814010
[   33.702178] [<c0261c6c>] (musb_gadget_cleanup+0x0/0x18) from [<c025b2a4>] (musb_shutdown+0x34/0x94)
[   33.717651] [<c025b270>] (musb_shutdown+0x0/0x94) from [<c01e88ec>] (platform_drv_shutdown+0x20/0x24)
[   33.733489]  r5:cf93fc10 r4:cf93fc1c
[   33.740325] [<c01e88cc>] (platform_drv_shutdown+0x0/0x24) from [<c01e55d0>] (device_shutdown+0x30/0x164)
[   33.756652] [<c01e55a0>] (device_shutdown+0x0/0x164) from [<c00553c4>] (kernel_halt+0x3c/0x60)
[   33.769042]  r8:c000e848 r7:fee1dead r6:00070784 r5:4321fedc r4:4321fedc
r3:00000000
[   33.783905] [<c0055388>] (kernel_halt+0x0/0x60) from [<c0055658>] (SyS_reboot+0x1c0/0x1dc)
[   33.795959] [<c0055498>] (SyS_reboot+0x0/0x1dc) from [<c000e6a0>] (ret_fast_syscall+0x0/0x30)
[   33.808227]  r7:00000058 r6:00000055 r5:00000004 r4:00000001
[   33.817565] Code: e1a0c00d e92dd830 e24cb004 e24dd008 (e5903028) 
[   33.827331] ---[ end trace 2bdce85d64d6c523 ]---
[   33.835418] Kernel panic - not syncing: Fatal exception

A.

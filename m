Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab3HMSzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:55:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab3HMSzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:55:22 -0400
Date: Tue, 13 Aug 2013 11:55:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt?= Coussno <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: Platform device tester - Allow removal
Message-ID: <20130813185521.GA9483@kroah.com>
References: <1376386470-27328-1-git-send-email-panto@antoniou-consulting.com>
 <20130813182012.GE7740@kroah.com>
 <70F17005-652E-4C04-B6EC-51E16EE237C3@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70F17005-652E-4C04-B6EC-51E16EE237C3@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 09:42:27PM +0300, Pantelis Antoniou wrote:
> Hi Greg,
> 
> On Aug 13, 2013, at 9:20 PM, Greg Kroah-Hartman wrote:
> 
> > On Tue, Aug 13, 2013 at 12:34:30PM +0300, Pantelis Antoniou wrote:
> >> This is a very simple device that allows testing of the removal path
> >> for platform devices.
> >> 
> >> The only interface is a single writeable sysfs attribute (action).
> > 
> > Why not use the existing "unbind/bind" sysfs files that all busses
> > support?  That's what userspace is expecting to use for adding and
> > removing devices from drivers from userspace.
> > 
> > This is a per-driver flag that the function platform_driver_probe() sets
> > for all platform drivers in the first line of that function.  Remove
> > that line and see what happens :)
> > 
> 
> I suppose you're talking about the sysfs bind/unbind attributes.

Yes.

> Unfortunately it doesn't work for what I want to do; it doesn't use the same
> path that the of platform devices use for creating and unregistering.
> My intention is to use exactly the same path the kernel uses (and what
> the capemanager does).

It should use the same path, if not, that should be fixed, as that's
what all other busses in the kernel use.  How does this not call the
disconnect() function properly?

> To wit:
> 
> Using the bind/unbind method (removal seems to work)
> 
> > root@beaglebone:/sys/bus/platform/drivers/omap_i2c# echo 4819c000.i2c >unbind 
> > [  139.261522] omap_hwmod: i2c3: enabling
> > [  139.265514] omap_hwmod: i2c3: enabling clocks
> > [  139.270090] omap_hwmod: i2c3: clk_enable(dpll_per_m2_div4_ck)
> > [  139.276130] omap_hwmod: i2c3: _am33xx_enable_module: 2
> > [  139.286477] omap_hwmod: i2c3: idling
> > [  139.290279] omap_hwmod: i2c3: _am33xx_disable_module
> > [  139.295501] omap_hwmod: i2c3: disabling clocks
> > [  139.305721] omap_hwmod: i2c3: enabling
> > [  139.309702] omap_hwmod: i2c3: enabling clocks
> > [  139.314279] omap_hwmod: i2c3: clk_enable(dpll_per_m2_div4_ck)
> > [  139.320332] omap_hwmod: i2c3: _am33xx_enable_module: 2
> > [  139.341437] omap_hwmod: i2c3: disabling
> > [  139.345515] omap_hwmod: i2c3: _am33xx_disable_module
> > [  139.350735] omap_hwmod: i2c3: disabling clocks
> 
> But creation just crashes.

Good.

> > root@beaglebone:/sys/bus/platform/drivers/omap_i2c# echo 4819c000.i2c >bind   
> > [  145.053929] Unable to handle kernel NULL pointer dereference at virtual address 00000001
> > [  145.062651] pgd = ca8c0000
> > [  145.065507] [00000001] *pgd=8f437831, *pte=00000000, *ppte=00000000
> > [  145.072163] Internal error: Oops: 17 [#1] SMP ARM
> > [  145.077105] Modules linked in: ipv6 autofs4
> > [  145.081537] CPU: 0 PID: 301 Comm: sh Not tainted 3.11.0-rc5-00125-g3b988fb #146
> > [  145.089222] task: cf5b5580 ti: cf464000 task.ti: cf464000
> > [  145.094918] PC is at omap_i2c_runtime_suspend+0x10/0xb4
> > [  145.100408] LR is at omap_i2c_runtime_suspend+0x8/0xb4
> > [  145.105808] pc : [<c0386350>]    lr : [<c0386348>]    psr: a00f0013
> > [  145.105808] sp : cf465e20  ip : 00000000  fp : 00000000
> > [  145.117860] r10: 00000008  r9 : c00523c0  r8 : cf465e70
> > [  145.123346] r7 : 00000008  r6 : 000003e8  r5 : cf0bd210  r4 : c0027c78
> > [  145.130202] r3 : 00000000  r2 : fa19c000  r1 : cf0bd280  r0 : cf178c10
> > [  145.137059] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> > [  145.144549] Control: 10c5387d  Table: 8a8c0019  DAC: 00000015
> > [  145.150572] Process sh (pid: 301, stack limit = 0xcf464240)
> > [  145.156423] Stack: (0xcf465e20 to 0xcf466000)
> > [  145.161009] 5e20: c0386340 c02cb2fc 00000000 c0027c84 00000000 c0027c78 cf0bd210 c02cc060
> > [  145.169594] 5e40: 00000000 cf0bd210 cf0bd210 c02cc0f4 cf0bd210 00000000 000003e8 c02cc65c
> > [  145.178186] 5e60: cf465e8c c0059798 00000000 00000000 cf0bd2dc 000a0009 00000000 cf0bd280
> > [  145.186781] 5e80: cf0bd210 000003e8 0000002e cf175d00 c04c3ee4 00000000 00000000 c02cd344
> > [  145.195377] 5ea0: cf178c10 cf0bd210 cf0bd200 c03867dc 00000001 c0131124 cf0518b8 c0056890
> > [  145.203977] 5ec0: 00000000 00000003 cf102c08 000186a0 c0704d08 cf0bd210 c0704d08 00000000
> > [  145.212568] 5ee0: c0714004 cf0bd244 c04c3ee4 cf15f6c0 00000000 c02c84ec c02c84d8 c02c7628
> > [  145.221151] 5f00: cf5b5580 c0714004 c0704d08 0000000d cf0bd210 c02c6558 cf18fb48 cf465f80
> > [  145.229743] 5f20: 0000000d cf3c4ec0 cf3c4ed8 c02c5c50 0000000d c012f050 cf501980 0000000d
> > [  145.238331] 5f40: 000d6408 cf465f80 000d6408 cf464000 0000000d c00d9a5c cf501980 000d6408
> > [  145.246923] 5f60: 0000000d cf501980 00000000 00000000 00000000 000d6408 0000000d c00d9eb0
> > [  145.255510] 5f80: 00000000 00000000 0000000d 0000000d 000d6408 b6f25a80 00000004 c000dc08
> > [  145.264108] 5fa0: 00000000 c000da60 0000000d 000d6408 00000001 000d6408 0000000d 00000000
> > [  145.272703] 5fc0: 0000000d 000d6408 b6f25a80 00000004 0000000d 0000000d 000d6408 00000000
> > [  145.281293] 5fe0: 00000000 be89d984 b6e61b2c b6eb430c 600f0010 00000001 00000000 00000000
> > [  145.289926] [<c0386350>] (omap_i2c_runtime_suspend+0x10/0xb4) from [<c02cb2fc>] (pm_generic_runtime_suspend+0x2c/0x40)
> > [  145.301187] [<c02cb2fc>] (pm_generic_runtime_suspend+0x2c/0x40) from [<c0027c84>] (_od_runtime_suspend+0xc/0x24)
> > [  145.311890] [<c0027c84>] (_od_runtime_suspend+0xc/0x24) from [<c02cc060>] (__rpm_callback+0x38/0x68)
> > [  145.321488] [<c02cc060>] (__rpm_callback+0x38/0x68) from [<c02cc0f4>] (rpm_callback+0x64/0x7c)
> > [  145.330535] [<c02cc0f4>] (rpm_callback+0x64/0x7c) from [<c02cc65c>] (rpm_suspend+0x24c/0x3fc)
> > [  145.339503] [<c02cc65c>] (rpm_suspend+0x24c/0x3fc) from [<c02cd344>] (pm_runtime_set_autosuspend_delay+0x30/0x3c)
> > [  145.350299] [<c02cd344>] (pm_runtime_set_autosuspend_delay+0x30/0x3c) from [<c03867dc>] (omap_i2c_probe+0x1d4/0x6e4)
> > [  145.361367] [<c03867dc>] (omap_i2c_probe+0x1d4/0x6e4) from [<c02c84ec>] (platform_drv_probe+0x14/0x18)
> > [  145.371163] [<c02c84ec>] (platform_drv_probe+0x14/0x18) from [<c02c7628>] (driver_probe_device+0xc0/0x1f0)
> > [  145.381312] [<c02c7628>] (driver_probe_device+0xc0/0x1f0) from [<c02c6558>] (driver_bind+0x88/0xd4)
> > [  145.390825] [<c02c6558>] (driver_bind+0x88/0xd4) from [<c02c5c50>] (drv_attr_store+0x20/0x2c)
> > [  145.399790] [<c02c5c50>] (drv_attr_store+0x20/0x2c) from [<c012f050>] (sysfs_write_file+0x108/0x13c)
> > [  145.409403] [<c012f050>] (sysfs_write_file+0x108/0x13c) from [<c00d9a5c>] (vfs_write+0xd4/0x1cc)
> > [  145.418647] [<c00d9a5c>] (vfs_write+0xd4/0x1cc) from [<c00d9eb0>] (SyS_write+0x3c/0x60)
> > [  145.427074] [<c00d9eb0>] (SyS_write+0x3c/0x60) from [<c000da60>] (ret_fast_syscall+0x0/0x30)
> > [  145.435944] Code: e92d4008 ebfd031e e5903058 e5902014 (e5d31001) 
> > [  145.442461] ---[ end trace 9a13e63a6817edf4 ]---

Not good :(

> While the pdevtest method works.
> 
> > root@beaglebone:/sys/devices/ocp.2/pdevtest.5# echo 28 >action 
> > [   73.511200] pdevtest pdevtest.5: Destroying device for target node /ocp/i2c@4819c000
> > [   73.519501] omap_hwmod: i2c3: enabling
> > [   73.523459] omap_hwmod: i2c3: enabling clocks
> > [   73.528038] omap_hwmod: i2c3: clk_enable(dpll_per_m2_div4_ck)
> > [   73.534079] omap_hwmod: i2c3: _am33xx_enable_module: 2
> > [   73.557101] omap_hwmod: i2c3: idling
> > [   73.560903] omap_hwmod: i2c3: _am33xx_disable_module
> > [   73.566118] omap_hwmod: i2c3: disabling clocks
> > [   73.582479] omap_hwmod: i2c3: enabling
> > [   73.586466] omap_hwmod: i2c3: enabling clocks
> > [   73.591059] omap_hwmod: i2c3: clk_enable(dpll_per_m2_div4_ck)
> > [   73.597120] omap_hwmod: i2c3: _am33xx_enable_module: 2
> > [   73.632154] omap_hwmod: i2c3: disabling
> > [   73.636224] omap_hwmod: i2c3: _am33xx_disable_module
> > [   73.641439] omap_hwmod: i2c3: disabling clocks
> > root@beaglebone:/sys/devices/ocp.2/pdevtest.5# echo 28 >action 
> > [   75.282060] pdevtest pdevtest.5: Creating device for target node /ocp/i2c@4819c000
> > [   75.290381] omap_device: 4819c000.i2c: counted 0 total resources across 1 hwmods
> > [   75.298260] platform 4819c000.i2c: Creating fck -> dpll_per_m2_div4_ck
> > [   75.308558] platform 4819c000.i2c: alias fck already exists
> > [   75.321086] omap_hwmod: i2c3: enabling
> > [   75.325067] omap_hwmod: i2c3: enabling clocks
> > [   75.329640] omap_hwmod: i2c3: clk_enable(dpll_per_m2_div4_ck)
> > [   75.335670] omap_hwmod: i2c3: _am33xx_enable_module: 2
> > [   75.398916] omap_i2c 4819c000.i2c: bus 1 rev0.11 at 100 kHz
> > [   75.485349] at24 1-0054: 32768 byte 24c256 EEPROM, writable, 1 bytes/write
> > [   75.557691] at24 1-0055: 32768 byte 24c256 EEPROM, writable, 1 bytes/write
> > [   75.653224] at24 1-0056: 32768 byte 24c256 EEPROM, writable, 1 bytes/write
> > [   75.730734] at24 1-0057: 32768 byte 24c256 EEPROM, writable, 1 bytes/write
> > [   75.751375] omap_hwmod: i2c3: idling
> > [   75.755178] omap_hwmod: i2c3: _am33xx_disable_module
> > [   75.760391] omap_hwmod: i2c3: disabling clocks

That's troubling.  Please fix up the unbind path, that's the one that
should be used here.

> Bugs, bugs everywhere...

Totally agree...

thanks,

greg k-h

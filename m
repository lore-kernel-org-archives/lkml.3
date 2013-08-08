Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807Ab3HHJXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:23:51 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:58915 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934111Ab3HHJXs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:23:48 -0400
Subject: Re: [PATCH 3/5] omap: Properly handle resources for omap_devices
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <87a9kt2vd8.fsf@linaro.org>
Date: Thu, 8 Aug 2013 12:23:42 +0300
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt_Cousson?= <benoit.cousson@gmail.com>,
        Paul Walmsley <paul@pwsan.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sourav Poddar <sourav.poddar@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Felipe Balbi <balbi@ti.com>, Koen Kooi <koen@circuitco.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A4346403-362E-4E74-9C5E-07509CBC0BF4@antoniou-consulting.com>
References: <1375775624-12250-1-git-send-email-panto@antoniou-consulting.com> <1375775624-12250-4-git-send-email-panto@antoniou-consulting.com> <87a9kt2vd8.fsf@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Aug 7, 2013, at 9:45 PM, Kevin Hilman wrote:

> [fixing address for Benoit]
> 
> Pantelis Antoniou <panto@antoniou-consulting.com> writes:
> 
>> omap_device relies on the platform notifier callbacks managing resources
>> behind the scenes. The resources were not properly linked causing crashes
>> when removing the device.
>> 
>> Rework the resource modification code so that linking is performed properly,
>> and make sure that no resources that have no parent (which can happen for DMA
>> & IRQ resources) are ever left for cleanup by the core resource layer.
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> 
> This one failed my "took more than 15 minutes to understand" test.  The
> changelog is rather vague (especially about what "properly" means), and
> the combination of moving code and changing it makes the patch rather
> clunky to read, so I remain a bit confused about what the actual problem
> is.  Please elaborate.
> 
> Also, could you share a crash dump as well as details about how to
> reproduce this problem?
> 
> Thanks,
> 
> Kevin

It's the full patchset that fixes the problem:

Let me illustrate:

The kernel I use is located at:

git@github.com:pantoniou/linux-beagle-track-mainline.git
branch: merge-20130806 (there are topic branches for other stuff too)

The DT overlay we're loading:

> /*
>  * Copyright (C) 2013 CircuitCo
>  *
>  * Virtual cape for UART1 on connector pins P9.24 P9.26
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License version 2 as
>  * published by the Free Software Foundation.
>  */
> /dts-v1/;
> /plugin/;
> 
> / {
> 	compatible = "ti,beaglebone", "ti,beaglebone-black";
> 
> 	/* identification */
> 	part-number = "BB-UART1";
> 	version = "00A0";
> 
> 	/* state the resources this cape uses */
> 	exclusive-use =
> 		/* the pin header uses */
> 		"P9.24",	/* uart1_txd */
> 		"P9.26",	/* uart1_rxd */
> 		/* the hardware ip uses */
> 		"uart1";
> 
> 	fragment@0 {
> 		target = <&am33xx_pinmux>;
> 		__overlay__ {
> 			bb_uart1_pins: pinmux_bb_uart1_pins {
> 				pinctrl-single,pins = <
> 					0x184 0x20 /* P9.24 uart1_txd.uart1_txd  OUTPUT  */
> 					0x180 0x20 /* P9.26 uart1_rxd.uart1_rxd  INPUT  */
> 				>;
> 			};
> 		};
> 	};
> 
> 	fragment@1 {
> 		target = <&uart1>;	/* really uart1 */
> 		__overlay__ {
> 			status = "okay";
> 			pinctrl-names = "default";
> 			pinctrl-0 = <&bb_uart1_pins>;
> 		};
> 	};
> };
> 

Nothing complicated; just a serial device.

With the full patchset on a beaglebone and loading a simple case of a UART 'cape'.

> root@beaglebone:/sys/devices/bone_capemgr.4# echo BB-UART1 >slots 
> [   58.546947] bone-capemgr bone_capemgr.4: part_number 'BB-UART1', version 'N/A'
> [   58.578374] bone-capemgr bone_capemgr.4: slot #4: generic override
> [   58.584925] bone-capemgr bone_capemgr.4: bone: Using override eeprom data at slot 4
> [   58.593086] bone-capemgr bone_capemgr.4: slot #4: 'Override Board Name,00A0,Override Manuf,BB-UART1'
> [   58.618455] bone-capemgr bone_capemgr.4: slot #4: Requesting part number/version based 'BB-UART1-00A0.dtbo
> [   58.638258] bone-capemgr bone_capemgr.4: slot #4: Requesting firmware 'BB-UART1-00A0.dtbo' for board-name 'Override Board Name', version '00A0'
> [   58.681259] bone-capemgr bone_capemgr.4: slot #4: dtbo 'BB-UART1-00A0.dtbo' loaded; converting to live tree
> [   58.705075] bone-capemgr bone_capemgr.4: slot #4: #2 overlays
> [   58.735058] 48022000.serial: ttyO1 at MMIO 0x48022000 (irq = 89) is a OMAP UART1
> [   58.757834] bone-capemgr bone_capemgr.4: slot #4: Applied #2 overlays.
> root@beaglebone:/sys/devices/bone_capemgr.4# echo -4 >slots 
> [   62.362519] bone-capemgr bone_capemgr.4: Removed slot #4
> 

Revert "omap: Properly handle resources for omap_devices"
Revert "of: Link platform device resources properly."
Revert "pdev: Fix platform device resource linking"

> root@beaglebone:/sys/devices/bone_capemgr.4# echo BB-UART1 >slots 
> [   39.317978] bone-capemgr bone_capemgr.4: part_number 'BB-UART1', version 'N/A'
> [   39.325630] bone-capemgr bone_capemgr.4: slot #4: generic override
> [   39.332248] bone-capemgr bone_capemgr.4: bone: Using override eeprom data at slot 4
> [   39.340336] bone-capemgr bone_capemgr.4: slot #4: 'Override Board Name,00A0,Override Manuf,BB-UART1'
> [   39.378854] bone-capemgr bone_capemgr.4: slot #4: Requesting part number/version based 'BB-UART1-00A0.dtbo
> [   39.396013] bone-capemgr bone_capemgr.4: slot #4: Requesting firmware 'BB-UART1-00A0.dtbo' for board-name 'Override Board Name', version '00A0'
> [   39.438009] bone-capemgr bone_capemgr.4: slot #4: dtbo 'BB-UART1-00A0.dtbo' loaded; converting to live tree
> [   39.452797] bone-capemgr bone_capemgr.4: slot #4: #2 overlays
> [   39.473180] 48022000.serial: ttyO1 at MMIO 0x48022000 (irq = 89) is a OMAP UART1
> [   39.498641] bone-capemgr bone_capemgr.4: slot #4: Applied #2 overlays.
> root@beaglebone:/sys/devices/bone_capemgr.4# echo -4 >slots
> [   42.233884] Unable to handle kernel NULL pointer dereference at virtual address 00000018
> [   42.242557] pgd = ca91c000
> [   42.245402] [00000018] *pgd=8a97e831, *pte=00000000, *ppte=00000000
> [   42.252062] Internal error: Oops: 17 [#1] SMP ARM
> [   42.256996] Modules linked in: ipv6 autofs4
> [   42.261429] CPU: 0 PID: 269 Comm: sh Not tainted 3.11.0-rc4-00111-g263aa42 #120
> [   42.269098] task: ca995040 ti: ca908000 task.ti: ca908000
> [   42.274786] PC is at __release_resource+0x8/0x44
> [   42.279632] LR is at release_resource+0x1c/0x34
> [   42.284379] pc : [<c003d7a8>]    lr : [<c003dbc0>]    psr: 600f0013
> [   42.284379] sp : ca909e80  ip : cf106658  fp : cf64d000
> [   42.296407] r10: cf49e888  r9 : c04badb0  r8 : 00000001
> [   42.301888] r7 : 00000001  r6 : 00000000  r5 : ca9e2e80  r4 : c06e1000
> [   42.308736] r3 : 00000000  r2 : 00000018  r1 : cf054b88  r0 : ca9e2e80
> [   42.315577] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [   42.323065] Control: 10c5387d  Table: 8a91c019  DAC: 00000015
> [   42.329089] Process sh (pid: 269, stack limit = 0xca908240)
> [   42.334935] Stack: (0xca909e80 to 0xca90a000)
> [   42.339510] 9e80: 00000200 cf49ea00 00000000 c02c6a5c cf49ea00 cf0ad600 00000000 c02c6d28
> [   42.348093] 9ea0: ca8f3200 c03b64c8 ca8f3200 cf49e888 00200200 00100100 cf49e850 c03b6564
> [   42.356674] 9ec0: ca995040 cf49e850 00000001 cf49e858 cf28bc18 cf54c7d8 cf109818 c03b6d20
> [   42.365257] 9ee0: ca8f1810 cf109800 00000000 c02d7b6c 00000004 cf28bc20 cf109810 c02d9194
> [   42.373837] 9f00: cf109810 c06f588c cf64d000 cf28a9c8 ca909f80 00000003 cf54c7c0 cf54c7d8
> [   42.382420] 9f20: c04badb0 cf109818 00000000 c02c1c94 00000003 c012eb44 ca9b12c0 00000003
> [   42.391013] 9f40: 000d6408 ca909f80 000d6408 ca908000 00000003 c00d9538 ca9b12c0 000d6408
> [   42.399594] 9f60: 00000003 ca9b12c0 00000000 00000000 00000000 000d6408 00000003 c00d998c
> [   42.408172] 9f80: 00000000 00000000 00000003 00000003 000d6408 b6ee1a80 00000004 c000dc08
> [   42.416751] 9fa0: 00000000 c000da60 00000003 000d6408 00000001 000d6408 00000003 00000000
> [   42.425334] 9fc0: 00000003 000d6408 b6ee1a80 00000004 00000003 00000003 000d6408 00000000
> [   42.433914] 9fe0: 00000000 bed59984 b6e1db2c b6e7030c 600f0010 00000001 00000000 00000000
> [   42.442522] [<c003d7a8>] (__release_resource+0x8/0x44) from [<c003dbc0>] (release_resource+0x1c/0x34)
> [   42.452231] [<c003dbc0>] (release_resource+0x1c/0x34) from [<c02c6a5c>] (platform_device_del+0x60/0x7c)
> [   42.462104] [<c02c6a5c>] (platform_device_del+0x60/0x7c) from [<c02c6d28>] (platform_device_unregister+0xc/0x18)
> [   42.472807] [<c02c6d28>] (platform_device_unregister+0xc/0x18) from [<c03b64c8>] (of_overlay_device_entry_change.clone.2+0x108/0x15c)
> [   42.485393] [<c03b64c8>] (of_overlay_device_entry_change.clone.2+0x108/0x15c) from [<c03b6564>] (of_overlay_revert_one+0x48/0x1f0)
> [   42.497725] [<c03b6564>] (of_overlay_revert_one+0x48/0x1f0) from [<c03b6d20>] (of_overlay_revert+0x34/0x58)
> [   42.507965] [<c03b6d20>] (of_overlay_revert+0x34/0x58) from [<c02d7b6c>] (bone_capemgr_remove_slot_no_lock+0x44/0xcc)
> [   42.519111] [<c02d7b6c>] (bone_capemgr_remove_slot_no_lock+0x44/0xcc) from [<c02d9194>] (slots_store+0x78/0x394)
> [   42.529797] [<c02d9194>] (slots_store+0x78/0x394) from [<c02c1c94>] (dev_attr_store+0x18/0x24)
> [   42.538840] [<c02c1c94>] (dev_attr_store+0x18/0x24) from [<c012eb44>] (sysfs_write_file+0x108/0x13c)
> [   42.548441] [<c012eb44>] (sysfs_write_file+0x108/0x13c) from [<c00d9538>] (vfs_write+0xd4/0x1cc)
> [   42.557675] [<c00d9538>] (vfs_write+0xd4/0x1cc) from [<c00d998c>] (SyS_write+0x3c/0x60)
> [   42.566083] [<c00d998c>] (SyS_write+0x3c/0x60) from [<c000da60>] (ret_fast_syscall+0x0/0x30)
> [   42.574937] Code: e1a00003 e8bd8030 e5903010 e2832018 (e5933018) 
> [   42.581424] ---[ end trace 61c82b77609dbc03 ]---
> [   42.757607] systemd[1]: serial-getty@ttyO0.service holdoff time over, scheduling restart.
> 
> 

Regards

-- Pantelis


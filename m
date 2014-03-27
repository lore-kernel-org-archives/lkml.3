Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbaC0WwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 18:52:15 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:41218 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbaC0WwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 18:52:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140327140140.GA9083@localhost>
References: <20140327140140.GA9083@localhost>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 27 Mar 2014 16:51:53 -0600
Message-ID: <CAErSpo7b+OJUoRcMY0edZPgEKG6DbwdLcq5M0-9B6JKALpm+QQ@mail.gmail.com>
Subject: Re: [mtd/sbc_gxx] kernel BUG at include/linux/mtd/map.h:148!
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc David, Brian]

On Thu, Mar 27, 2014 at 8:01 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> FYI, here is a very old warning, too old to be bisected.
>
> [    5.282127] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [    5.286079] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
> [    5.288723] ------------[ cut here ]------------
> [    5.289649] kernel BUG at include/linux/mtd/map.h:148!

I think the problem is that your randconfig happens to have none of
CONFIG_MTD_MAP_BANK_WIDTH_* set (you should have played the lottery
today!), and the default implementation of map_bankwidth() in that
case is just "BUG()":

  $ grep MTD_MAP config-3.14.0-rc8-wl-03045-gdf16ea4
  # CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
  # CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
  # CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
  # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
  # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
  # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set

I don't know enough Kconfig or MTD to fix this.

> [    5.289649] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> [    5.289649] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc8-wl-03045-gdf16ea4 #6
> [    5.289649] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    5.289649] task: d1c48000 ti: d1c36000 task.ti: d1c36000
> [    5.289649] EIP: 0060:[<c17982d8>] EFLAGS: 00010296 CPU: 0
> [    5.289649] EIP is at mtd_do_chip_probe+0x15/0x17
> [    5.289649] EAX: 00000000 EBX: c242bf28 ECX: 00000000 EDX: d1c37e88
> [    5.289649] ESI: c2275f71 EDI: d1c37ec4 EBP: d1c37ec8 ESP: d1c37e88
> [    5.289649]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [    5.289649] CR0: 8005003b CR2: 00000000 CR3: 02556000 CR4: 000006f0
> [    5.289649] Stack:
> [    5.289649]  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [    5.289649]  00000000 00000000 00000000 00000000 00000000 00000000 00000000 c242c500
> [    5.289649]  d1c37ed0 c1794d3e d1c37ee4 c1794cf5 00000000 c24f0561 00000564 d1c37f04
> [    5.289649] Call Trace:
> [    5.289649]  [<c1794d3e>] cfi_probe+0xd/0xf
> [    5.289649]  [<c1794cf5>] do_map_probe+0x50/0x66
> [    5.289649]  [<c24f0561>] ? init_ck804xrom+0x37d/0x37d
> [    5.289649]  [<c24f0649>] init_sbc_gxx+0xe8/0x123
> [    5.289649]  [<c24b8b54>] do_one_initcall+0x80/0x107
> [    5.289649]  [<c13e5049>] ? strlen+0xf/0x19
> [    5.289649]  [<c24b8500>] ? repair_env_string+0xa/0x51
> [    5.289649]  [<c1049aef>] ? parse_args+0x1bd/0x308
> [    5.289649]  [<c1056a24>] ? __wake_up+0x3a/0x42
> [    5.289649]  [<c24b8cd0>] kernel_init_freeable+0xf5/0x18c
> [    5.289649]  [<c24b84f6>] ? do_early_param+0x78/0x78
> [    5.289649]  [<c1e80009>] kernel_init+0xb/0xc2
> [    5.289649]  [<c1051d85>] ? schedule_tail+0x12/0x3a
> [    5.289649]  [<c1e93e3b>] ret_from_kernel_thread+0x1b/0x30
> [    5.289649]  [<c1e7fffe>] ? rest_init+0x6e/0x6e
> [    5.289649] Code: e9 1e fd ff ff c7 04 24 44 8e 30 c2 e8 df df 6e 00 e9 28 fb ff ff 55 31 c0 89 e5 b9 0f 00 00 00 8d 55 c0 57 89 d7 83 ec 3c f3 ab <0f> 0b 55 ba 90 c1 42 c2 89 e5 e8 dc ff ff ff 5d c3 55 89 e5 57
> [    5.289649] EIP: [<c17982d8>] mtd_do_chip_probe+0x15/0x17 SS:ESP 0068:d1c37e88
> [    5.425765] ---[ end trace ad16f43410cd0373 ]---
> [    5.428287] swapper (1) used greatest stack depth: 5800 bytes left
>
> git bisect  bad df16ea4de143a63d0f598003bde671cc277390e0  # 16:57      0-     25  0day head guard for 'devel-hourly-2014032612'
> git bisect  bad b098d6726bbfb94c06d6e1097466187afddae61f  # 16:58      0-     20  Linux 3.14-rc8
> git bisect  bad d8ec26d7f8287f5788a494f56e8814210f0e64be  # 16:58      0-     20  Linux 3.13
> git bisect  bad 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52  # 16:58      0-     20  Linux 3.12
> git bisect  bad 6e4664525b1db28f8c4e1130957f70a94c19213e  # 16:58      0-     20  Linux 3.11
> git bisect  bad 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376  # 16:58      0-     20  Linux 3.10
> git bisect  bad c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1  # 16:58      0-     20  Linux 3.9
> git bisect  bad 19f949f52599ba7c3f67a5897ac6be14bfcb1200  # 16:58      0-     20  Linux 3.8
> git bisect  bad 29594404d7fe73cd80eaa4ee8c43dcc53970c60e  # 16:59      0-     20  Linux 3.7
> git bisect  bad a0d271cbfed1dd50278c6b06bead3d00ba0a88f9  # 16:59      0-     20  Linux 3.6
> git bisect  bad 28a33cbc24e4256c143dce96c7d93bf423229f92  # 16:59      0-     20  Linux 3.5
> git bisect  bad 76e10d158efb6d4516018846f60c2ab5501900bc  # 16:59      0-     20  Linux 3.4
> git bisect  bad c16fa4f2ad19908a47c63d8fa436a1178438c7e7  # 16:59      0-     40  Linux 3.3
> git bisect  bad 805a6af8dba5dfdd35ec35dc52ec0122400b2610  # 16:59      0-     20  Linux 3.2
> git bisect  bad c3b92c8787367a8bb53d57d9789b558f1295cc96  # 16:59      0-     20  Linux 3.1
> git bisect  bad 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe  # 16:59      0-     20  Linux 3.0
>
>
> This script may reproduce the error.
>
> -----------------------------------------------------------------------------
> #!/bin/bash
>
> kernel=$1
> initrd=quantal-core-i386.cgz
>
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd
>
> kvm=(
>         qemu-system-x86_64 -cpu kvm64 -enable-kvm
>         -kernel $kernel
>         -initrd $initrd
>         -smp 2
>         -m 256M
>         -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
>         -net user,vlan=0
>         -net nic,vlan=1,model=e1000
>         -net user,vlan=1
>         -boot order=nc
>         -no-reboot
>         -watchdog i6300esb
>         -serial stdio
>         -display none
>         -monitor null
> )
>
> append=(
>         debug
>         sched_debug
>         apic=debug
>         ignore_loglevel
>         sysrq_always_enabled
>         panic=10
>         prompt_ramdisk=0
>         earlyprintk=ttyS0,115200
>         console=ttyS0,115200
>         console=tty0
>         vga=normal
>         root=/dev/ram0
>         rw
> )
>
> "${kvm[@]}" --append "${append[*]}"
> -----------------------------------------------------------------------------
>
> Thanks,
> Fengguang
>
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab3JJUll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 16:41:41 -0400
Received: from natasha.panasas.com ([67.152.220.90]:37608 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3JJUlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 16:41:39 -0400
Message-ID: <525710F3.1000209@panasas.com>
Date: Thu, 10 Oct 2013 13:41:23 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: initcall calibrate_xor_blocks returned with preemption imbalance
References: <20131010090217.GB2541@localhost>
In-Reply-To: <20131010090217.GB2541@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.17.67.163]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 02:02 AM, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 

Dear Wu

This 20545536cd8ea949c61527b6395ec8c0d2c237b1 is from my tree at linux-open-osd.org
How did you happen to find it and run with it at all?

I have never pushed it to any mailing list or blessed it for release.
Yes it has a known problem that I never bothered to fix. I carry
it in my own development trees so I can run xor.ko on UML.

If it has leaked to any upstream trees, I'm so sorry tell me where
you found it and I'll have it removed.

I can see below:
	Merge 'open-osd/exofs_ioctl' into devel-hourly-2013101007

What is devel-hourly and what does exofs_ioctl branch useful for.
exofs_ioctl is for NFS-Ganesha pnfs support. It is not good for
any other purpose. 
If you are developing NFS-Ganesha pnfs code feel free to remove
this patch, again it is so I can run exofs on UML which uses
xor.ko. If you use VMs or HW you do not have this problem.

Thanks
Boaz

> commit 20545536cd8ea949c61527b6395ec8c0d2c237b1
> Author: Boaz Harrosh <bharrosh@panasas.com>
> Date:   Thu Jul 19 15:22:37 2012 +0300
> 
>     RFC: do_xor_speed Broken on UML do to jiffies
>     
>     Remember that hang I reported a while back on UML. Well
>     I'm at it again, and it still hangs and I found why.
>     
>     I have dprinted jiffies and it never advances during the
>     loop at do_xor_speed. There for it is stuck in an endless
>     loop. I have also dprinted current_kernel_time() and it
>     returns the same constant value as well.
>     
>     Note that it does usually work on UML, only during
>     the modprobe of xor.ko while that test is running. It looks
>     like some lucking is preventing the clock from ticking.
>     
>     However ktime_get_ts does work for me so I changed the code
>     as below, so I can work. See how I put several safety
>     guards, to never get hangs again.
>     And I think my time based approach is more accurate then
>     previous system.
>     
>     UML guys please investigate the jiffies issue? what is
>     xor.ko not doing right?
>     
>     Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> 
> [    0.232004]    generic_sse:  6816.333 MB/sec
> [    0.233534] xor: using function: prefetch64-sse (9178.666 MB/sec)
> [    0.235445] ------------[ cut here ]------------
> [    0.236010] WARNING: CPU: 0 PID: 1 at init/main.c:701 do_one_initcall+0x128/0x138()
> [    0.240041] initcall calibrate_xor_blocks+0x0/0x144 returned with preemption imbalance 
> [    0.242872] Modules linked in:
> [    0.244006] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-wl-02197-g3d5587e #119
> [    0.246837] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.248004]  0000000000000000 ffff88000e1e5e00 ffffffff81a3a6bf ffff88000e1e5e48
> [    0.252003]  ffff88000e1e5e38 ffffffff810c53d5 ffffffff81000315 ffffffff8256ff16
> [    0.255243]  0000000000000000 0000000000000000 ffff88000e1e5fd8 ffff88000e1e5e98
> [    0.258537] Call Trace:
> [    0.260010]  [<ffffffff81a3a6bf>] dump_stack+0x54/0x74
> [    0.261730]  [<ffffffff810c53d5>] warn_slowpath_common+0x7f/0x98
> [    0.263623]  [<ffffffff81000315>] ? do_one_initcall+0x128/0x138
> [    0.264006]  [<ffffffff8256ff16>] ? do_xor_speed+0xe2/0xe2
> [    0.265785]  [<ffffffff810c543a>] warn_slowpath_fmt+0x4c/0x4e
> [    0.268007]  [<ffffffff811767d9>] ? free_pages+0x45/0x47
> [    0.269751]  [<ffffffff8256ff16>] ? do_xor_speed+0xe2/0xe2
> [    0.272006]  [<ffffffff81000315>] do_one_initcall+0x128/0x138
> [    0.273843]  [<ffffffff82532ed3>] kernel_init_freeable+0x159/0x1da
> [    0.276005]  [<ffffffff8253274d>] ? do_early_param+0x88/0x88
> [    0.277835]  [<ffffffff81a2a057>] ? rest_init+0xdb/0xdb
> [    0.280006]  [<ffffffff81a2a065>] kernel_init+0xe/0xdb
> [    0.281718]  [<ffffffff81a4d97c>] ret_from_fork+0x7c/0xb0
> [    0.283485]  [<ffffffff81a2a057>] ? rest_init+0xdb/0xdb
> [    0.284021] ---[ end trace 3592511960ba24aa ]---
> [    0.285636] atomic64 test passed for x86-64 platform with CX8 and with SSE
> 
> git bisect start 3d5587ec7222eebd6d2fa2d4b245ef837a8f36fa 15c03dd4859ab16f9212238f29dd315654aa94f6 --
> git bisect good bd1bc39506ad6ce236bf932757d6e3a81b3e3d55  # 09:41     20+      0  Merge 'regmap/topic/core' into devel-hourly-2013101007
> git bisect good f0a6d5852cc8b4e9e518c0426580f0589327e438  # 10:56     20+      0  Merge 'arm-soc/next/dt' into devel-hourly-2013101007
> git bisect good 909dc6fa1f1f42dcdae62b07c4d6b894a392e0d7  # 11:36     20+      0  Merge 'ipsec-next/testing' into devel-hourly-2013101007
> git bisect good 7fb1b0615235b3975def59fbffd0f52c71736bd3  # 11:57     20+      1  Merge 'arm-soc/next/drivers' into devel-hourly-2013101007
> git bisect good ac5fb9846698e9dffc430ab38c1aaefe50a51980  # 12:22     20+      0  Merge remote-tracking branch 'regulator/topic/optional' into regulator-next
> git bisect good b9729e9f8d82724c98f13dd358c7b08a4d7de3d2  # 13:31     20+      3  mtd: nand: pxa3xx_nand: Remove redundant of_match_ptr
> git bisect  bad c420082bfcc00a908360edd4bb5826ece1c59ae4  # 14:13      0-     20  Merge 'open-osd/exofs_ioctl' into devel-hourly-2013101007
> git bisect good 3f8985b977fbab1bf7ddea03bf311949ebca4afd  # 15:03     20+      0  Merge remote-tracking branch 'regulator/topic/tps6586x' into regulator-next
> git bisect  bad 7425910fffb08f541e4d2819c4ae7900894fc504  # 15:41      0-      1  {OUT-OF-TREE-DEBUG}: Remove the cdb_offset check because of osc-osd bug
> git bisect  bad 71e6bb4b77c4782642b3cb6b4f9369191e08b934  # 15:48      0-      1  pnfs_osd_xdr_srv (private): Add pnfs-objects server side XDR encoding/decoding
> git bisect  bad 20545536cd8ea949c61527b6395ec8c0d2c237b1  # 16:03      0-     16  RFC: do_xor_speed Broken on UML do to jiffies
> git bisect good 4a9a4b3528afce48d3f4b1c07b988040e78112e2  # 16:22     20+      0  pnfs: Proper delay for NFS4ERR_RECALLCONFLICT in layout_get_done
> git bisect good 4a9a4b3528afce48d3f4b1c07b988040e78112e2  # 16:36     60+      0  pnfs: Proper delay for NFS4ERR_RECALLCONFLICT in layout_get_done
> git bisect  bad 3d5587ec7222eebd6d2fa2d4b245ef837a8f36fa  # 16:36      0-     19  Merge 'tip/x86/bsp-hotplug' into devel-hourly-2013101007
> git bisect good 0e7a3ed04f0cd4311096d691888f88569310ee6c  # 16:57     63+      0  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 16:57     63+      0  Add linux-next specific files for 20130927
> 
> Thanks,
> Fengguang
> 



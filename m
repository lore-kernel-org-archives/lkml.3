Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab3KYORx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:17:53 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:64978 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab3KYOPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:15:48 -0500
MIME-Version: 1.0
In-Reply-To: <20131122060223.GP9991@yliu-dev.sh.intel.com>
References: <20131122060223.GP9991@yliu-dev.sh.intel.com>
Date: Mon, 25 Nov 2013 15:15:47 +0100
Message-ID: <CAFLxGvynVV=aY755xTPTa7-57O25Dwzc+cbWELj+4xxFKznKMg@mail.gmail.com>
Subject: Re: WARNING: CPU: 0 PID: 1 at init/main.c:711 do_one_initcall()
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: LKP <fnstml-lkp@cn.fujitsu.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Boaz Harrosh <bharrosh@panasas.com>, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 7:02 AM, Yuanhan Liu
<yuanhan.liu@linux.intel.com> wrote:
> Greetings,
>
> I got the below dmesg and the first bad commit is
>
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

This patch never hit my mailbox...

>     Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>
> +------------------------------------------------------------------+----+
> |                                                                  |    |
> +------------------------------------------------------------------+----+
> | boot_successes                                                   | 0  |
> | boot_failures                                                    | 29 |
> | WARNING:CPU:PID:at_init/main.c:do_one_initcall()                 | 29 |
> | initcall_calibrate_xor_blocks_returned_with_preemption_imbalance | 29 |
> +------------------------------------------------------------------+----+
>
> [    0.127025]    generic_sse:   148.363 MB/sec
> [    0.127478] xor: using function: prefetch64-sse (152.727 MB/sec)
> [    0.128017] ------------[ cut here ]------------
> [    0.128531] WARNING: CPU: 0 PID: 1 at init/main.c:711 do_one_initcall+0x105/0x115()
> [    0.129018] initcall calibrate_xor_blocks+0x0/0x144 returned with preemption imbalance
> [    0.130013] Modules linked in:
> [    0.130357] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-11285-gb242bff #91
> [    0.131013]  0000000000000000 ffff88000d0dde00 ffffffff8161acc5 ffff88000d0dde48
> [    0.132554]  ffff88000d0dde38 ffffffff81052de9 ffffffff81000316 ffffffff81a77cfd
> [    0.133380]  0000000000000000 0000000000000000 0000000000000000 ffff88000d0dde98
> [    0.134213] Call Trace:
> [    0.134493]  [<ffffffff8161acc5>] dump_stack+0x4e/0x7a
> [    0.135017]  [<ffffffff81052de9>] warn_slowpath_common+0x75/0x8e
> [    0.135654]  [<ffffffff81000316>] ? do_one_initcall+0x105/0x115
> [    0.136015]  [<ffffffff81a77cfd>] ? do_xor_speed+0xdd/0xdd
> [    0.137016]  [<ffffffff81052e49>] warn_slowpath_fmt+0x47/0x49
> [    0.137628]  [<ffffffff810c8382>] ? free_pages+0x51/0x53
> [    0.138015]  [<ffffffff81a77cfd>] ? do_xor_speed+0xdd/0xdd
> [    0.138623]  [<ffffffff81000316>] do_one_initcall+0x105/0x115
> [    0.139017]  [<ffffffff81a59ed6>] kernel_init_freeable+0x115/0x19b
> [    0.140016]  [<ffffffff81a59707>] ? do_early_param+0x88/0x88
> [    0.140630]  [<ffffffff81610ff9>] ? rest_init+0xbd/0xbd
> [    0.141016]  [<ffffffff81611002>] kernel_init+0x9/0xfa
> [    0.141567]  [<ffffffff8162a98c>] ret_from_fork+0x7c/0xb0
> [    0.142016]  [<ffffffff81610ff9>] ? rest_init+0xbd/0xbd
> [    0.143028] ---[ end trace 19b4eab334350767 ]---
> [    0.143530] atomic64 test passed for x86-64 platform with CX8 and with SSE
>
> git bisect start b242bff548c34510fd9b7f0e29b885263dfb8903 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52 --
> git bisect good 5cbb3d216e2041700231bcfc383ee5f8b7fc8b74  # 09:25     20+      0  Merge branch 'akpm' (patches from Andrew Morton)
> git bisect good 7e1a1e9378018aeea2c7e8a3dd2ceb1db1523b0b  # 09:42     20+      0  Merge tag 'xfs-for-linus-v3.13-rc1' of git://oss.sgi.com/xfs/xfs
> git bisect good 4937e2a6f939a41bf811378e80d71f68aa0950c6  # 10:08     20+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
> git bisect good 210e812f036736aeda097d9a6ef84b1f2b334bae  # 10:31     20+      0  perf header: Fix bogus group name
> git bisect good d5bdaf4f68f0590fc481bca54bcaffeb27b75fca  # 10:54     20+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha
> git bisect good e630a6bcf18079b2ab6b03d55c9757e8ef6656b6  # 11:03     20+      0  staging: lustre: fix checkpatch issue regarding pointer coding style
> git bisect good 6449a5811e62ab9587b54feca45c06cfee0e37cd  # 11:10     20+      0  Merge 'btrfs/for-linus' into devel-cairo-x86_64-201311220159
> git bisect good 78103b692e7aa6a8e2ef678c9a3465d6bfe44559  # 11:14     20+      0  Merge 'staging/opw-next' into devel-cairo-x86_64-201311220159
> git bisect good 7acd71879ce408af2d2ca3cd3ec3a86d0667ceae  # 11:24     20+      0  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless into for-davem
> git bisect good 2ea4606fd707f05cddce72219a5f90ca471c09d6  # 11:32     20+      0  drm/msm: add atomic support
> git bisect  bad cd7efef070cc5420858c271a9908df3f86cef83b  # 11:40      0-      3  {SQUASHME} exofs_ioctl: Fix for deadlock when close of root node
> git bisect  bad 13cf7003526891bfb7ad12fc5cff01cf9e734dc2  # 11:43      0-     14  {SPLITME} exofs_ioctl: All the new and external files
> git bisect  bad 20545536cd8ea949c61527b6395ec8c0d2c237b1  # 11:46      0-     17  RFC: do_xor_speed Broken on UML do to jiffies
> git bisect good 4a9a4b3528afce48d3f4b1c07b988040e78112e2  # 11:50     20+      0  pnfs: Proper delay for NFS4ERR_RECALLCONFLICT in layout_get_done
> # first bad commit: [20545536cd8ea949c61527b6395ec8c0d2c237b1] RFC: do_xor_speed Broken on UML do to jiffies
> git bisect good 4a9a4b3528afce48d3f4b1c07b988040e78112e2  # 11:52     60+      0  pnfs: Proper delay for NFS4ERR_RECALLCONFLICT in layout_get_done
> git bisect  bad b242bff548c34510fd9b7f0e29b885263dfb8903  # 11:52      0-     29  Merge 'open-osd/exofs_ioctl' into devel-cairo-x86_64-201311220159
> git bisect good 727fb2e90de9b05224b1801b4c21e7fe18506b43  # 12:07     60+      0  Revert "RFC: do_xor_speed Broken on UML do to jiffies"
> git bisect good 527d1511310a89650000081869260394e20c7013  # 12:26     60+      0  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
> git bisect good f3fa585afa93230883dc4c259dc03df6234a5e5f  # 12:42     60+      0  Add linux-next specific files for 20131122
>
>
> Thanks.
>
>         --yliu



-- 
Thanks,
//richard

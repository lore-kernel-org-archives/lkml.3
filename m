Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaIYIyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:54:06 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56572 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaIYIyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:54:00 -0400
Message-ID: <5423D822.9030001@gmail.com>
Date: Thu, 25 Sep 2014 16:53:54 +0800
From: zhuyj <zyjzyj2000@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: yzhu1 <Yanjun.Zhu@windriver.com>, cjb@laptop.org,
        LKML <linux-kernel@vger.kernel.org>
CC: "Wu, Kuaikuai" <Kuaikuai.Wu@windriver.com>
Subject: Re: access nand flash and mmc card at the same time on xlp board,
 there will be many io errors and system will hung
References: <541BF219.4050307@windriver.com>
In-Reply-To: <541BF219.4050307@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The root cause is that: sometimes device can not respond quickly to the 
request, the timeout mechanism will handle
this.
Solution: enlarge the device respond timeout to avoid kernel crash.

Zhu Yanjun
On 09/19/2014 05:06 PM, yzhu1 wrote:
> Hi, Chris
>
> I run a tests on a xlp208 board. This kernel is 3.17-rc5.
> The script are as below.
> -------------Begin-------------------
> mkfs.ext3 /dev/mmcblk1p1
> mount /dev/mmcblk1p1 /mnt
> cd /mnt
> cp -Rf /root/nand_sd_test /mnt
> cd /mnt/nand_sd_test
> -------------End---------------------
>
> After several minutes, the following errors will appear.
> Would you like give me some advice about this error?
>
> Thanks a lot.
> Zhu Yanjun
>
> -----------------------------ErrorMessage------------------------------
> 16777216 bytes (17 MB) copied, 34.5951 s, 485 kB/s
> mmc1: Timeout waiting for hardware interrupt.
> mmc1: Timeout waiting for hardware interrupt.
> mmc1: Timeout waiting for hardware interrupt.
> mmcblk1: error -145 sending status command, retrying
> mmc1: Timeout waiting for hardware interrupt.
> mmcblk1: error -145 sending status command, retrying
> mmc1: Timeout waiting for hardware interrupt.
> mmcblk1: error -145 sending status command, aborting
> end_request: I/O error, dev mmcblk1, sector 3460800
> Buffer I/O error on device mmcblk1p1, logical block 432598
> lost page write due to I/O error on mmcblk1p1
> end_request: I/O error, dev mmcblk1, sector 3460808
> Buffer I/O error on device mmcblk1p1, logical block 432599
> lost page write due to I/O error on mmcblk1p1
> end_request: I/O error, dev mmcblk1, sector 3460816
> Buffer I/O error on device mmcblk1p1, logical block 432600
> lost page write due to I/O error on mmcblk1p1
> end_request: I/O error, dev mmcblk1, sector 3460824
> Buffer I/O error on device mmcblk1p1, logical block 432601
> lost page write due to I/O error on mmcblk1p1
> end_request: I/O error, dev mmcblk1, sector 3460832
> Buffer I/O error on device mmcblk1p1, logical block 432602
> lost page write due to I/O error on mmcblk1p1
> end_request: I/O error, dev mmcblk1, sector 3460840
> Buffer I/O error on device mmcblk1p1, logical block 432603
> lost page write due to I/O error on mmcblk1p1
> end_request: I/O error, dev mmcblk1, sector 3460848
> Buffer I/O error on device mmcblk1p1, logical block 432604
> lost page write due to I/O error on mmcblk1p1
> end_request: I/O error, dev mmcblk1, sector 3460856
> Buffer I/O error on device mmcblk1p1, logical block 432605
> lost page write due to I/O error on mmcblk1p1
> end_request: I/O error, dev mmcblk1, sector 3460864
> Buffer I/O error on device mmcblk1p1, logical block 432606
> lost page write due to I/O error on mmcblk1p1
>
> mmc1: Timeout waiting for hardware interrupt.
> ------------[ cut here ]------------
> WARNING: at /linux/drivers/mmc/host/sdhci.c:996 
> sdhci_send_command+0xd78/0xe68()
> Modules linked in:
> CPU: 6 PID: 0 Comm: swapper/6 Not tainted 
> 3.10.38-ltsi-WR6.0.0.11_standard #1
> Stack : c0000000f83ff820 ffffffffc02a290c 0000000000000001 
> 0000000000000e1b
>   ffffffffc0d00000 ffffffffc0e005a0 0000000000000004 0000000000000001
>   c0000000f83ff860 ffffffffc02a270c 000000000000004d ffffffffc0d00000
>   c0000000f83ff880 ffffffffc02a2d7c 0000000000000000 0000000000000000
>   0000000000000000 ffffffffc1050000 ffffffffc104d008 ffffffffc1050000
>   ffffffffc0b62fc0 ffffffffc0cfab37 ffffffffc104d008 c0000000f8217b28
>           0000000000000000 0000000000000006 c0000000f92e2508 
> c0000000f92e23c0
>   c0000000f83ff900 c0000000f83ff810 c0000000f83ff928 ffffffffc02a008c
>   c0000000f83ff960 ffffffffc02a48c8 c0000000f8217788 ffffffffc0b62fc0
>   0000000000000006 ffffffffc0274c30 0000000000000000 0000000000000000
>   ...
> Call Trace:
> [<ffffffffc0274c30>] show_stack+0xd8/0xf8
> [<ffffffffc02a008c>] warn_slowpath_common+0x8c/0xc8
> [<ffffffffc0880868>] sdhci_send_command+0xd78/0xe68
> [<ffffffffc0881380>] sdhci_finish_data+0x180/0x3d0
> [<ffffffffc08818f0>] sdhci_timeout_timer+0xb0/0x120
> [<ffffffffc02b45c8>] call_timer_fn+0x58/0x1a0
> [<ffffffffc02b4a00>] run_timer_softirq+0x1f8/0x2d0
> [<ffffffffc02aa6a0>] __do_softirq+0x150/0x340
> [<ffffffffc02aa9f0>] do_softirq+0xb8/0xc0
> [<ffffffffc02aada4>] irq_exit+0xf4/0x110
> [<ffffffffc026f160>] ret_from_irq+0x0/0x4
> [<ffffffffc026f400>] __r4k_wait+0x20/0x40
> [<ffffffffc02f85a8>] cpu_startup_entry+0x190/0x2f8
> [<ffffffffc0a33438>] nlm_boot_secondary_cpus+0x44/0x54
> ---[ end trace 7070d5fae37308f2 ]---


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbaJ1Kpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 06:45:39 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:35723 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbaJ1Kph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 06:45:37 -0400
Message-ID: <544F73CD.1010409@imgtec.com>
Date: Tue, 28 Oct 2014 10:45:33 +0000
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: <iamjoonsoo.kim@lge.com>
CC: <cl@linux.com>, <penberg@kernel.org>, <rientjes@google.com>,
        <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>
Subject: Boot problems on Malta with EVA (bisected to 12220dea07f1 "mm/slab:
 support slab merge")
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.149]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems I am unable to boot my Malta with EVA. The problem appeared in
the 3.18 merge window. I bisected the problem (between v3.17 and
v3.18-rc1) and I found the following commit responsible for the broken boot.

commit 12220dea07f1ac6ac717707104773d771c3f3077
Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date:   Thu Oct 9 15:26:24 2014 -0700

    mm/slab: support slab merge


Reverting my tree back to the parent of that commit
423c929cbbecc60e9c407f9048e58f5422f7995d ("
mm/slab_common: commonize slab merge logic")

restores the boot for me.

I don't quite understand the commit yet so let me know if you need more
information to debug this problem

Here is the kernel log of the failed boot.

Calibrating delay loop... 19.86 BogoMIPS (lpj=99328)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 4096 (order: 0, 16384 bytes)
Mountpoint-cache hash table entries: 4096 (order: 0, 16384 bytes)
Kernel bug detected[#1]:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-05639-g12220dea07f1 #1631
task: 1f04f5d8 ti: 1f050000 task.ti: 1f050000
$ 0   : 00000000 806c0000 00000080 00000000
$ 4   : 1f048080 00000001 00000001 00000000
$ 8   : 1f04f5d8 00000001 fffffffc 00000000
$12   : 00000000 ffffffff fffef7b7 00000000
$16   : 1f048080 1f00ec00 1f048180 806ba998
$20   : 1f00ec00 80660000 1f03b780 806ad380
$24   : 00000000 80154d70
$28   : 1f050000 1f053d48 806ba8ec 80141184
Hi    : 00000000
Lo    : 0b532b80
epc   : 80141190 alloc_unbound_pwq+0x234/0x304
    Not tainted
ra    : 80141184 alloc_unbound_pwq+0x228/0x304
Status: 1000dc03        KERNEL EXL IE
Cause : 00800034
PrId  : 0001a82d (MIPS P5600)
Modules linked in:
Process swapper/0 (pid: 1, threadinfo=1f050000, task=1f04f5d8, tls=00000000)
Stack : 1f03b880 00000002 1f03b800 80140d90 1f048180 1f03b880 00000002
1f03b800
          1f03bb80 801417a4 1f0481e0 0000000e 1f048180 00000200 1f048180
1f048190
          00000002 1f048188 80660000 80660000 8065af94 80141dc0 0110d710
00000100
          8065af94 806ad380 8065b200 8013ea70 1f048280 1f053e0c 8065af98
1f0481e0
          00000000 00000004 80660000 80660000 80660000 80660000 80660000
80660000
          ...
Call Trace:
[<80141190>] alloc_unbound_pwq+0x234/0x304
[<801417a4>] apply_workqueue_attrs+0x11c/0x294
[<80141dc0>] __alloc_workqueue_key+0x23c/0x470
[<80683de4>] init_workqueues+0x320/0x400
[<8010058c>] do_one_initcall+0xe8/0x23c
[<8067cbec>] kernel_init_freeable+0x9c/0x224
[<80565fd8>] kernel_init+0x10/0x100
[<80104e38>] ret_from_kernel_thread+0x14/0x1c


Code: 10400032  00408021  320200ff <00020336> 00002821  02002021
0c0defb0  24060100  26020074
---[ end trace cb88537fdc8fa200 ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

---[ end Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b

-- 
markos

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161011AbaDBWw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:52:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42565 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933358AbaDBWw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:52:28 -0400
Message-ID: <533C948E.4020505@oracle.com>
Date: Wed, 02 Apr 2014 18:51:58 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>,
        Alessandro Zummo <a.zummo@towertech.it>
CC: Tejun Heo <tj@kernel.org>, Greg KH <greg@kroah.com>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs/rtc: circular dependency between kernfs and ops_lock
References: <5308E3AE.3040405@oracle.com> <20140222205217.GC16272@mtj.dyndns.org> <20140224120427.6394d5dd@linux.lan.towertech.it> <5331FA9E.20506@oracle.com> <20140325233936.655a798e@linux.lan.towertech.it> <53321D04.2040102@oracle.com> <5337653D.6020002@oracle.com> <53384080.9020502@oracle.com> <20140331114627.5e1a4609@linux.lan.towertech.it> <53393AE4.505@metafoo.de> <20140331124351.43033c93@linux.lan.towertech.it> <53394C5E.2030207@metafoo.de> <20140331140344.6030c7da@linux.lan.towertech.it> <53395D4B.1010805@metafoo.de>
In-Reply-To: <53395D4B.1010805@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 08:19 AM, Lars-Peter Clausen wrote:
> On 03/31/2014 02:03 PM, Alessandro Zummo wrote:
>> On Mon, 31 Mar 2014 13:07:10 +0200
>> Lars-Peter Clausen <lars@metafoo.de> wrote:
>>
>>> It doesn't really matter where it is unregistered. device_unregister() will
>>> (somewhere down it's callchain) take the kernfs lock, hence it must be
>>> callled with the rtc mutex being held.
>>
>>   Maybe device_remove_attrs could be called in the rtc base class,
>>   before the device removal?
>>
> 
> Just move the device_unregister() call outside the lock. I think the only thing that needs to be protected is the ops = NULL assignment. Moving the unregister after the unlock also means that the extra get_device()/put_device() pair can be removed.

That seems to cause errors on boot:

[   23.714976] BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
[   23.716017] IP: [<ffffffffb438ee5f>] kernfs_find_ns+0x1f/0x160
[   23.716620] PGD 0
[   23.716843] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   23.717448] Dumping ftrace buffer:
[   23.717861]    (ftrace buffer empty)
[   23.718233] Modules linked in:
[   23.718561] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 3.14.0-next-20140402-sasha-00013-g0cfaf7e-dirty #364
[   23.719523] task: ffff8806ec5b0000 ti: ffff88003e284000 task.ti: ffff88003e284000
[   23.720134] RIP: 0010:[<ffffffffb438ee5f>]  [<ffffffffb438ee5f>] kernfs_find_ns+0x1f/0x160
[   23.720134] RSP: 0000:ffff88003e285af8  EFLAGS: 00010292
[   23.720134] RAX: 0000000080000000 RBX: 0000000000000000 RCX: 0000000000000006
[   23.720134] RDX: 0000000000000000 RSI: ffffffffb78bd6c0 RDI: 0000000000000000
[   23.720134] RBP: ffff88003e285b28 R08: 0000000000000000 R09: 0000000000000000
[   23.720134] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[   23.720134] R13: ffffffffb78bd6c0 R14: 0000000000000000 R15: 0000000000000008
[   23.720134] FS:  0000000000000000(0000) GS:ffff8800bec00000(0000) knlGS:0000000000000000
[   23.720134] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   23.720134] CR2: 0000000000000090 CR3: 0000000038e2c000 CR4: 00000000000006a0
[   23.720134] Stack:
[   23.720134]  ffff88003e285b28 0000000000000000 ffffffffb78bd6c0 0000000000000000
[   23.720134]  0000000000000080 0000000000000008 ffff88003e285b58 ffffffffb438f0be
[   23.720134]  ffff880000000010 ffffffffb9c0f6c0 ffff8800bdd89148 ffffffffb8e430b0
[   23.720134] Call Trace:
[   23.720134]  [<ffffffffb438f0be>] kernfs_find_and_get_ns+0x3e/0x70
[   23.730419] kobject: 'tlan' (ffff88026bf2a760): kobject_cleanup, parent ffff8803ec71efe8
[   23.730422] kobject: 'tlan' (ffff88026bf2a760): auto cleanup 'remove' event
[   23.730424] kobject: 'tlan' (ffff88026bf2a760): kobject_uevent_env
[   23.730460] kobject: 'tlan' (ffff88026bf2a760): fill_kobj_path: path = '/bus/pci/drivers/tlan'
[   23.730559] kobject: 'tlan' (ffff88026bf2a760): auto cleanup kobject_del
[   23.720134]  [<ffffffffb439392d>] sysfs_unmerge_group+0x1d/0x70
[   23.720134]  [<ffffffffb50d858b>] dpm_sysfs_remove+0x2b/0x70
[   23.720134]  [<ffffffffb50cdd97>] device_del+0x47/0x1c0
[   23.720134]  [<ffffffffb50cdf68>] device_unregister+0x58/0x70
[   23.720134]  [<ffffffffb636bb95>] rtc_device_unregister+0x65/0x80
[   23.720134]  [<ffffffffb63720a3>] cmos_do_probe+0x3b3/0x400
[   23.720134]  [<ffffffffba35ddd3>] cmos_platform_probe+0x44/0x4d
[   23.720134]  [<ffffffffb50d3862>] platform_drv_probe+0x32/0x90
[   23.720134]  [<ffffffffb50d1ba5>] driver_probe_device+0x175/0x370
[   23.720134]  [<ffffffffb50d1e24>] __driver_attach+0x84/0xc0
[   23.720134]  [<ffffffffb50d1da0>] ? driver_probe_device+0x370/0x370
[   23.720134]  [<ffffffffb50cfa39>] bus_for_each_dev+0x69/0xb0
[   23.720134]  [<ffffffffb50d13de>] driver_attach+0x1e/0x20
[   23.720134]  [<ffffffffb50d1018>] bus_add_driver+0x138/0x260
[   23.720134]  [<ffffffffba35dcf0>] ? bq4802_driver_init+0x14/0x14
[   23.720134]  [<ffffffffb50d2608>] driver_register+0x98/0xe0
[   23.720134]  [<ffffffffba35dcf0>] ? bq4802_driver_init+0x14/0x14
[   23.720134]  [<ffffffffb50d36da>] __platform_driver_register+0x4a/0x50
[   23.720134]  [<ffffffffb50d3704>] platform_driver_probe+0x24/0xc0
[   23.720134]  [<ffffffffba35dcf0>] ? bq4802_driver_init+0x14/0x14
[   23.720134]  [<ffffffffba35dd2c>] cmos_init+0x3c/0x74
[   23.720134]  [<ffffffffb400216a>] do_one_initcall+0xca/0x1d0
[   23.720134]  [<ffffffffb4185100>] ? parse_args+0x280/0x460
[   23.720134]  [<ffffffffba2b8128>] kernel_init_freeable+0x1d5/0x26c
[   23.720134]  [<ffffffffba2b7848>] ? loglevel+0x31/0x31
[   23.720134]  [<ffffffffb74a1fe0>] ? rest_init+0x140/0x140
[   23.720134]  [<ffffffffb74a1fee>] kernel_init+0xe/0x100
[   23.720134]  [<ffffffffb7514b7c>] ret_from_fork+0x7c/0xb0
[   23.720134]  [<ffffffffb74a1fe0>] ? rest_init+0x140/0x140
[   23.720134] Code: 8b 75 f8 c9 c3 0f 1f 80 00 00 00 00 66 66 66 66 90 55 48 89 e5 41 57 41 56 49 89 d6 41 55 49 89 f5 41 54 49 89 fc 53 48 83 ec 08 <0f> b7 87 90 00 00 00 8b 15 d4 00 7d 05 48 8b 5f 78 66 c1 e8 05
[   23.720134] RIP  [<ffffffffb438ee5f>] kernfs_find_ns+0x1f/0x160
[   23.720134]  RSP <ffff88003e285af8>
[   23.720134] CR2: 0000000000000090


Thanks,
Sasha

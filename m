Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965702Ab3FTXch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 19:32:37 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23431 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965307Ab3FTXcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 19:32:35 -0400
Message-ID: <51C390FA.3080302@oracle.com>
Date: Thu, 20 Jun 2013 19:32:10 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: rubini@gnudd.com
CC: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org
Subject: FMC: BUG: scheduling while atomic on boot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I compiled FMC in to test it out, but when booting with it I get:

[   22.120253] BUG: scheduling while atomic: swapper/0/1/0x00000002
[   22.120371] 4 locks held by swapper/0/1:
[   22.120762]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff81f69ee0>] __dri
ver_attach+0x40/0xa0
[   22.121835]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff81f69eee>] 
__driver_attach+0x4e/0xa0
[   22.122916]  #2:  (fc_lock){+.+.+.}, at: [<ffffffff83b1436a>] fc_probe+0x9a/0x110
[   22.123745]  #3:  (misc_mtx){+.+.+.}, at: [<ffffffff81ce52c4>] misc_register+0x24/0x130
[   22.124628] CPU: 3 PID: 1 Comm: swapper/0 Tainted: G        W 
3.10.0-rc6-next-20130620-sasha-00011-gb6e9296 #1044
[   22.125646]  0000000000000003 ffff8801285597f8 ffffffff84058925 ffff8801285597f8
[   22.126556]  ffff880128555000 ffff880128559818 ffffffff81154a51 ffff880128559a20
[   22.127367]  ffff88012add7880 ffff8801285598a8 ffffffff8405b043 0000000000019190
[   22.128161] Call Trace:
[   22.128429]  [<ffffffff84058925>] dump_stack+0x52/0x87
[   22.128991]  [<ffffffff81154a51>] __schedule_bug+0x71/0x90
[   22.130363]  [<ffffffff8405b043>] __schedule+0xa3/0x8e0
[   22.131298]  [<ffffffff8405b9e5>] schedule+0x55/0x60
[   22.131492]  [<ffffffff84058a48>] schedule_timeout+0x38/0x2c0
[   22.131492]  [<ffffffff8118fd89>] ? mark_held_locks+0x109/0x140
[   22.132033]  [<ffffffff8405dbab>] ? _raw_spin_unlock_irq+0x2b/0x80
[   22.132678]  [<ffffffff8405a8e7>] wait_for_completion+0xb7/0x110
[   22.133277]  [<ffffffff8115d3b0>] ? try_to_wake_up+0x2a0/0x2a0
[   22.133871]  [<ffffffff81f6ea58>] devtmpfs_create_node+0x128/0x170
[   22.134474]  [<ffffffff81153903>] ? complete+0x23/0x60
[   22.135003]  [<ffffffff81f673b0>] device_add+0x220/0x490
[   22.135539]  [<ffffffff81f67639>] device_register+0x19/0x20
[   22.136124]  [<ffffffff81f676f5>] device_create_vargs+0xb5/0x100
[   22.136732]  [<ffffffff81f6776c>] device_create+0x2c/0x30
[   22.137296]  [<ffffffff84059bb0>] ? mutex_lock_nested+0x40/0x50
[   22.137885]  [<ffffffff81ce536e>] misc_register+0xce/0x130
[   22.138426]  [<ffffffff83b14373>] fc_probe+0xa3/0x110
[   22.138943]  [<ffffffff83b12082>] fmc_probe+0x12/0x20
[   22.140280]  [<ffffffff81f69c2f>] really_probe+0x10f/0x2e0
[   22.140280]  [<ffffffff81f69e7b>] driver_probe_device+0x7b/0xa0
[   22.140734]  [<ffffffff81f69f03>] __driver_attach+0x63/0xa0
[   22.141302]  [<ffffffff81f69ea0>] ? driver_probe_device+0xa0/0xa0
[   22.141917]  [<ffffffff81f69ea0>] ? driver_probe_device+0xa0/0xa0
[   22.142515]  [<ffffffff81f67d06>] bus_for_each_dev+0x66/0xc0
[   22.143070]  [<ffffffff81f69869>] driver_attach+0x19/0x20
[   22.143605]  [<ffffffff81f69192>] bus_add_driver+0x102/0x270
[   22.144188]  [<ffffffff83b143e0>] ? fc_probe+0x110/0x110
[   22.144727]  [<ffffffff81f6a558>] driver_register+0xa8/0x140
[   22.145322]  [<ffffffff83b143e0>] ? fc_probe+0x110/0x110
[   22.145842]  [<ffffffff83b12684>] fmc_driver_register+0x34/0x40
[   22.146447]  [<ffffffff83b143f0>] fc_init+0x10/0x20
[   22.146961]  [<ffffffff865fe8d4>] do_one_initcall+0xae/0x175
[   22.147530]  [<ffffffff8114419b>] ? parse_args+0x1cb/0x310
[   22.148081]  [<ffffffff865fed08>] ? kernel_init_freeable+0x288/0x288
[   22.148723]  [<ffffffff865fea62>] do_basic_setup+0x9c/0xba
[   22.150280]  [<ffffffff865fed08>] ? kernel_init_freeable+0x288/0x288
[   22.150333]  [<ffffffff866296aa>] ? smp_init+0x8a/0x92
[   22.151432]  [<ffffffff865fec88>] kernel_init_freeable+0x208/0x288
[   22.151970]  [<ffffffff840411e0>] ? rest_init+0x140/0x140
[   22.152551]  [<ffffffff840411e9>] kernel_init+0x9/0xf0
[   22.153120]  [<ffffffff8405ebfc>] ret_from_fork+0x7c/0xb0
[   22.153689]  [<ffffffff840411e0>] ? rest_init+0x140/0x140
[   22.154233] BUG: scheduling while atomic: swapper/0/1/0x00000002
[   22.155496] 4 locks held by swapper/0/1:
[   22.155614]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff81f69ee0>] 
__driver_attach+0x40/0xa0
[   22.155950]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff81f69eee>] 
__driver_attach+0x4e/0xa0
[   22.156971]  #2:  (fc_lock){+.+.+.}, at: [<ffffffff83b1436a>] fc_probe+0x9a/0x110
[   22.157806]  #3:  (misc_mtx){+.+.+.}, at: [<ffffffff81ce52c4>] misc_register+0x24/0x130


Thanks,
Sasha

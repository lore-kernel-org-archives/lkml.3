Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab3JJBEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 21:04:21 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38405 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510Ab3JJBET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 21:04:19 -0400
From: Lisa Du <cldu@marvell.com>
To: Fengguang Wu <fengguang.wu@intel.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 9 Oct 2013 18:04:09 -0700
Subject: RE: 6e543d5780e fixed a boot hang
Thread-Topic: 6e543d5780e fixed a boot hang
Thread-Index: Ac7E+agjSMjtcy9hQvWPMvzrKhJ4ZgAWWgBw
Message-ID: <89813612683626448B837EE5A0B6A7CB3E57459EC9@SC-VEXCH4.marvell.com>
References: <20131009141217.GA24846@localhost>
In-Reply-To: <20131009141217.GA24846@localhost>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-09_08:2013-10-09,2013-10-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310090124
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9A14Q0j016764

>-----Original Message-----
>From: Fengguang Wu [mailto:fengguang.wu@intel.com]
>Sent: 2013Äê10ÔÂ9ÈÕ 22:12
>To: Lisa Du
>Cc: KOSAKI Motohiro; linux-mm@kvack.org; linux-kernel@vger.kernel.org
>Subject: 6e543d5780e fixed a boot hang
>
>Greetings,
>
>FYI, this commit seem to fix a boot hang problem here.
>
>commit 6e543d5780e36ff5ee56c44d7e2e30db3457a7ed
>Author: Lisa Du <cldu@marvell.com>
>Date:   Wed Sep 11 14:22:36 2013 -0700
>
>    mm: vmscan: fix do_try_to_free_pages() livelock
>
>
>        [    1.394871] pci 0000:00:02.0: Boot video device
>        [    1.395883] PCI: CLS 0 bytes, default 64
>
>In parent commit, it will hang right here.
>
>With this commit, it will continue to emit the below OOM messages (which is not a surprise to me because the boot test runs in a small
>memory KVM and the kconfig builds in lots of drivers).
I think you may meet the same issue as mine.
Direct reclaim loop forever with zone->all_unreclaimable = 0(as kswapd sleeps forever).
And at the boot stage, no one detect and terminate it, so you see the boot hang. 
After apply this patch, you see there's oom-killer invoked as direct reclaim would break when zone was unreclaimable.
>
>        [    1.631892] swapper/0 invoked oom-killer: gfp_mask=0x2000d0, order=1, oom_score_adj=0
>        [    1.633549] swapper/0 cpuset=/ mems_allowed=0
>        [    1.634443] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-00019-g8b5ede6 #126
>        [    1.635982] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>        [    1.637088]  0000000000000002 ffff88001dd41b28 ffffffff82c8d78f ffff88001ef7c040
>        [    1.638955]  ffff88001dd41ba8 ffffffff82c8395f ffffffff83c54680 ffff88001dd41b60
>        [    1.640830]  ffffffff810f3f06 0000000000001eb4 0000000000000246 ffff88001dd41b98
>        [    1.642687] Call Trace:
>        [    1.643313]  [<ffffffff82c8d78f>] dump_stack+0x54/0x74
>        [    1.644331]  [<ffffffff82c8395f>] dump_header.isra.10+0x7a/0x1ba
>        [    1.645443]  [<ffffffff810f3f06>] ? lock_release_holdtime.part.27+0x4c/0x50
>        [    1.646685]  [<ffffffff810f795a>] ? lock_release+0x189/0x1d1
>        [    1.647744]  [<ffffffff811530a8>] out_of_memory+0x39e/0x3ee
>        [    1.648882]  [<ffffffff811579f5>] __alloc_pages_nodemask+0x668/0x7de
>        [    1.650385]  [<ffffffff8118eb53>] kmem_getpages+0x75/0x16c
>        [    1.651429]  [<ffffffff81190d20>] fallback_alloc+0x12c/0x1ea
>        [    1.652528]  [<ffffffff810f38e8>] ? trace_hardirqs_off+0xd/0xf
>        [    1.653627]  [<ffffffff81190be5>] ____cache_alloc_node+0x14a/0x159
>        [    1.654783]  [<ffffffff817059fb>] ? dma_debug_init+0x1ef/0x29a
>        [    1.655928]  [<ffffffff8119162c>] kmem_cache_alloc_trace+0x83/0x11a
>        [    1.657108]  [<ffffffff817059fb>] dma_debug_init+0x1ef/0x29a
>        [    1.658182]  [<ffffffff841ac38b>] pci_iommu_init+0x16/0x52
>        [    1.659263]  [<ffffffff841ac375>] ? iommu_setup+0x27d/0x27d
>        [    1.660342]  [<ffffffff810020d2>] do_one_initcall+0x93/0x137
>        [    1.661415]  [<ffffffff810bd300>] ? param_set_charp+0x92/0xd8
>        [    1.662503]  [<ffffffff810bd52e>] ? parse_args+0x189/0x247
>        [    1.663555]  [<ffffffff8419fed1>] kernel_init_freeable+0x15e/0x1df
>        [    1.664724]  [<ffffffff8419f729>] ? do_early_param+0x88/0x88
>        [    1.665814]  [<ffffffff82c77867>] ? rest_init+0xdb/0xdb
>        [    1.666824]  [<ffffffff82c77875>] kernel_init+0xe/0xdb
>        [    1.667824]  [<ffffffff82cbc57c>] ret_from_fork+0x7c/0xb0
>        [    1.668911]  [<ffffffff82c77867>] ? rest_init+0xdb/0xdb
>        [    1.669925] Mem-Info:
>        [    1.670508] Node 0 DMA per-cpu:
>
>Thanks,
>Fengguang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaH2Mhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 08:37:42 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:60911 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaH2Mhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 08:37:34 -0400
Date: Fri, 29 Aug 2014 08:37:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390 <linux-s390@vger.kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: WARNING: at kernel/workqueue.c:845
Message-ID: <20140829123730.GA23153@mtj.dyndns.org>
References: <54005AFB.2010604@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54005AFB.2010604@de.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Lai, hi!)

There have been some changes in how workqueue handles CPU hotplug
recently.  Maybe it's related?  Lai, can you please take a look?
Christian also added that the problem can be reproduced on 3.16 w/
lower frequency.

Thanks.

On Fri, Aug 29, 2014 at 12:50:35PM +0200, Christian Borntraeger wrote:
> Tejun,
> 
> with kvm/next (pretty close to 3.17-rc1) as KVM guest I get the following warning in one of my stress tests:
> 
> [    0.296047] ------------[ cut here ]------------
> [    0.296050] WARNING: at kernel/workqueue.c:809
> [    0.296051] Modules linked in:
> [    0.296054] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.17.0-rc1+ #172
> [    0.296056] task: 0000000000934618 ti: 000000000091c000 task.ti: 000000000091c000
> [    0.296062]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 EA:3
>                Krnl GPRS: 0000000000000001 00000000063bed00 0000000000996740 0000000000000000
> [    0.296065]            000000000000000d 000000000000036a ffffffff00000000 0000000000000000
> [    0.296067]            000000000620e400 0000000000001201 0000000000001201 04000000009f6700
> [    0.296068]            000000000639b700 0000000000000000 00000000001453e8 00000000063fbc80
> [    0.296078] Krnl Code: 0000000000145416: 95002000            cli     0(%r2),0
>                           000000000014541a: a774fff4            brc     7,145402
>                          #000000000014541e: a7f40001            brc     15,145420
> [    0.296083] TCP: cubic registered
> [    0.296084] 
>                          >0000000000145422: 92012000            mvi     0(%r2),1
> [    0.296086] 
>                           0000000000145426: a7f4ffee            brc     15,145402
>                           000000000014542a: 0707                bcr     0,%r7
>                           000000000014542c: ebdff0800024        stmg    %r13,%r15,128(%r15)
> [    0.296092] Initializing XFRM netlink socket
> [    0.296094] 
>                           0000000000145432: a7f13fe0            tmll    %r15,16352
> [    0.296096] Call Trace:
> [    0.296099] ([<0000000000001201>] 0x1201)
> [    0.296102]  [<00000000001545dc>] ttwu_do_activate.constprop.97+0x64/0x7c
> [    0.296103]  [<00000000001550ce>] sched_ttwu_pending+0x7e/0xd4
> [    0.296104]  [<0000000000156bea>] scheduler_ipi+0x62/0x168
> [    0.296107]  [<0000000000113482>] smp_handle_ext_call+0xbe/0xdc
> [    0.296111]  [<000000000010b3dc>] do_ext_interrupt+0xb4/0xd4
> [    0.296113]  [<00000000001833be>] handle_irq_event_percpu+0x76/0x204
> [    0.296115]  [<00000000001870e8>] handle_percpu_irq+0x6c/0x98
> [    0.296116]  [<0000000000182a02>] generic_handle_irq+0x46/0x68
> [    0.296117]  [<000000000010b78a>] do_IRQ+0x5e/0x84
> [    0.296120]  [<0000000000634840>] ext_skip+0x42/0x46
> [    0.296121]  [<0000000000633fce>] vtime_stop_cpu+0x4a/0x9c
> [    0.296122] ([<0000000000000000>]           (null))
> [    0.296124]  [<0000000000103816>] arch_cpu_idle+0x92/0xa0
> [    0.296126]  [<000000000016bb9a>] cpu_startup_entry+0x15a/0x228
> [    0.296127]  [<00000000009a5ae4>] start_kernel+0x408/0x418
> [    0.296128]  [<0000000000100020>] _stext+0x20/0x80
> [    0.296129] Last Breaking-Event-Address:
> [    0.296130]  [<000000000014541e>] wq_worker_waking_up+0x5e/0x6c
> [    0.296133] ---[ end trace 68915e61d289d806 ]---
> [    0.296137] reboot: Restarting system
> [    0.296141] ------------[ cut here ]------------
> 
> The test is basically to start 50 KVM guests that only have a kernel + busybox ramdisk with rcS calling reboot.
> One or two guests of these 50 have thing warning pretty soon. With 3.16 as guest everything runs fine.
> 
> Do you have any idea what might be wrong or do I need to bisect?
> 
> Christian
> 

-- 
tejun

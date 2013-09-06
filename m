Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152Ab3IFKL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 06:11:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:56567 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab3IFKLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 06:11:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,853,1371106800"; 
   d="scan'208";a="291569273"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Artem Savkov <artem.savkov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20130906092408.GA27657@cpv436-motbuntu.spb.ea.mot-mobility.com>
References: <20130906092408.GA27657@cpv436-motbuntu.spb.ea.mot-mobility.com>
Subject: RE: [BUG] trying to lock tailpage in page_fault path
Content-Transfer-Encoding: 7bit
Message-Id: <20130906101152.3E505E0090@blue.fi.intel.com>
Date: Fri,  6 Sep 2013 13:11:52 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Savkov wrote:
> Hi All,
> 
> Since the "thp-mm-locking-tail-page-is-a-bug-fix" patch
> (c6d04b4502a07b040b9e8cce835f899913961248 in linux-next.git) from Andrew's tree
> I get the following trace on pulseaudio start:
> 
> [  147.191296] ------------[ cut here ]------------
> [  147.192017] kernel BUG at include/linux/pagemap.h:343!

Okay, BUG_ONs were just wrong. Andrew, could you revert them?

> [  147.192017] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  147.192017] Modules linked in: snd_intel8x0 snd_ac97_codec ac97_bus
> [  147.192017] CPU: 1 PID: 1726 Comm: alsa-sink Not tainted 3.11.0-next-20130905 #244
> [  147.192017] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [  147.192017] task: ffff8800593f3360 ti: ffff8800585f8000 task.ti: ffff8800585f8000
> [  147.192017] RIP: 0010:[<ffffffff811c3e37>]  [<ffffffff811c3e37>] lock_page+0x27/0x60
> [  147.192017] RSP: 0000:ffff8800585f9cb8  EFLAGS: 00010286
> [  147.192017] RAX: 0100000000008000 RBX: ffffea000165d440 RCX: 0000000000000000
> [  147.192017] RDX: ffff8800593f3360 RSI: ffffffff824450c0 RDI: 0000000000000282
> [  147.192017] RBP: ffff8800585f9cc8 R08: 0000000000000003 R09: 00000000000000a9
> [  147.192017] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800766e6780
> [  147.192017] R13: 0000000000000001 R14: 0000000000000001 R15: 00007fca8ed9d000
> [  147.192017] FS:  00007fca90644700(0000) GS:ffff88007f500000(0000) knlGS:0000000000000000
> [  147.192017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  147.192017] CR2: 00007fca8ed9d000 CR3: 000000005847c000 CR4: 00000000000006e0
> [  147.192017] Stack:
> [  147.192017]  ffff880058567e00 ffff880058567e00 ffff8800585f9d58 ffffffff811c8292
> [  147.192017]  0000000000000000 0000000000000001 ffff8800585f9d68 0000000081114511
> [  147.192017]  0000000000000000 ffff8800584c13b0 ffff8800000000a9 0000000000000001
> [  147.192017] Call Trace:
> [  147.192017]  [<ffffffff811c8292>] __do_fault+0xd2/0x520
> [  147.192017]  [<ffffffff811c8765>] handle_pte_fault+0x85/0x1f0
> [  147.192017]  [<ffffffff81d6fa5f>] ? __do_page_fault+0x32f/0x600
> [  147.192017]  [<ffffffff811c8a98>] __handle_mm_fault+0x1c8/0x1f0
> [  147.192017]  [<ffffffff811c8ae7>] handle_mm_fault+0x27/0x30
> [  147.192017]  [<ffffffff81d6fcf1>] __do_page_fault+0x5c1/0x600
> [  147.192017]  [<ffffffff815a0a7c>] ? T.1708+0x7c/0xa0
> [  147.192017]  [<ffffffff81d6bff6>] ? error_sti+0x5/0x6
> [  147.192017]  [<ffffffff81605c4d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [  147.192017]  [<ffffffff81d6fd3e>] do_page_fault+0xe/0x10
> [  147.192017]  [<ffffffff81d6bda8>] page_fault+0x28/0x30
> [  147.192017] Code: 41 5c c9 c3 55 31 d2 be 60 01 00 00 48 89 e5 53 48 89 fb 48 c7 c7 bb e5 20 82 48 83 ec 08 e8 e1 d9 f1 ff 48 8b 03 66 85 c0 79 11 <0f> 0b 0f 1f 80 00 00 00 00 eb fe 66 0f 1f 44 00 00 f0 0f ba 2b 
> [  147.192017] RIP  [<ffffffff811c3e37>] lock_page+0x27/0x60
> [  147.192017]  RSP <ffff8800585f9cb8>
> [  147.226506] ---[ end trace 6e5253a10dc6fa32 ]---
> 
> vm_ops->fault handler in this case is snd_pcm_mmap_data_fault().
> 
> -- 
> Regards,
>     Artem

-- 
 Kirill A. Shutemov

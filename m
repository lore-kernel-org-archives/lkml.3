Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab3HEO5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:57:43 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:47630 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3HEO5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:57:41 -0400
Date: Mon, 5 Aug 2013 10:57:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org,
        kent.overstreet@gmail.com
Subject: Re: percpu: kernel BUG at mm/percpu.c:579!
Message-ID: <20130805145736.GB19631@mtj.dyndns.org>
References: <51FFBB7D.70608@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FFBB7D.70608@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Kent, hi!)

On Mon, Aug 05, 2013 at 10:49:33AM -0400, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running latest -next kernel,
> I've stumbled on the following spew:
> 
> [  274.820724] ------------[ cut here ]------------
> [  274.821320] kernel BUG at mm/percpu.c:579!

Looks like double free.

> [  274.821848] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  274.822467] Modules linked in:
> [  274.823240] CPU: 13 PID: 58 Comm: rcuos/13 Tainted: G        W
> 3.11.0-rc4-next-20130805-sasha-00002-gf6cc217 #3975
> [  274.824464] task: ffff880220cb3000 ti: ffff880220cba000 task.ti: ffff880220cba000
> [  274.825442] RIP: 0010:[<ffffffff812417b8>]  [<ffffffff812417b8>] pcpu_free_area+0xd8/0x1e0
> [  274.826470] RSP: 0018:ffff880220cbbc58  EFLAGS: 00010002
> [  274.827316] RAX: ffff8800c9e3abd4 RBX: 00000000000002f5 RCX: 00000000000002f5
> [  274.828162] RDX: 0000000000000004 RSI: 000000000000ede0 RDI: 000000000000ede0
> [  274.829270] RBP: ffff880220cbbc78 R08: 0000000000000324 R09: ffff8800c9e3a000
> [  274.830102] R10: ffff8800c9e3a000 R11: 0000000000000000 R12: ffff88022049ff80
> [  274.830102] R13: 0000000000000bd4 R14: 0000000000000012 R15: ffffffff86612060
> [  274.831367] FS:  0000000000000000(0000) GS:ffff880226000000(0000) knlGS:0000000000000000
> [  274.831367] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  274.831367] CR2: 0000000001253028 CR3: 0000000214aff000 CR4: 00000000000006e0
> [  274.831367] Stack:
> [  274.831367]  0000000000000282 000000000000ede0 ffff88022049ff80 000060fdd980ede0
> [  274.831367]  ffff880220cbbca8 ffffffff81241c7e ffff880220cbbca8 ffff8800b80f83e0
> [  274.831367]  0000000000000000 ffff8800b80f83c0 ffff880220cbbd18 ffffffff81a14ea6
> [  274.831367] Call Trace:
> [  274.831367]  [<ffffffff81241c7e>] free_percpu+0x9e/0x160
> [  274.831367]  [<ffffffff81a14ea6>] percpu_ref_kill_rcu+0xb6/0x1b0

>From percpu_ref release path.  Kent?

> [  274.831367]  [<ffffffff8114e390>] ? wake_up_bit+0x40/0x40
> [  274.831367]  [<ffffffff81a14df0>] ? percpu_ref_init+0x50/0x50
> [  274.831367]  [<ffffffff811d4169>] rcu_nocb_kthread+0x449/0x520
> [  274.831367]  [<ffffffff8114e390>] ? wake_up_bit+0x40/0x40
> [  274.831367]  [<ffffffff811d3d20>] ? rcu_adopt_orphan_cbs+0x250/0x250
> [  274.831367]  [<ffffffff8114dac7>] kthread+0xe7/0xf0
> [  274.831367]  [<ffffffff81197a2a>] ? __lock_release+0x1da/0x1f0
> [  274.831367]  [<ffffffff8114d9e0>] ? __init_kthread_worker+0x70/0x70
> [  274.831367]  [<ffffffff840a132c>] ret_from_fork+0x7c/0xb0
> [  274.831367]  [<ffffffff8114d9e0>] ? __init_kthread_worker+0x70/0x70
> [  274.831367] Code: 39 f7 74 0f 0f 0b 0f 1f 44 00 00 eb fe 66 0f 1f
> 44 00 00 4d 89 ca 48 63 cb 4c 8d 2c 8d 00 00 00 00 4b 8d 04 2a 8b 10
> 85 d2 7e 10 <0f> 0b 66 0f 1f 44 00 00 eb fe 66 0f 1f 44 00 00 f7 da
> 89 10 49
> [  274.850289] RIP  [<ffffffff812417b8>] pcpu_free_area+0xd8/0x1e0
> [  274.850289]  RSP <ffff880220cbbc58>
> [  274.850289] ---[ end trace 47f7ab405c6aeff4 ]---
> 
> 
> Thanks,
> Sasha

-- 
tejun

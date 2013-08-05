Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3HETPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:15:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59362 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3HETPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:15:21 -0400
Date: Mon, 5 Aug 2013 12:15:17 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        trinity@vger.kernel.org
Subject: Re: percpu: kernel BUG at mm/percpu.c:579!
Message-ID: <20130805191517.GA9198@kmo-pixel>
References: <51FFBB7D.70608@oracle.com>
 <20130805145736.GB19631@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805145736.GB19631@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 10:57:36AM -0400, Tejun Heo wrote:
> (cc'ing Kent, hi!)
> 
> On Mon, Aug 05, 2013 at 10:49:33AM -0400, Sasha Levin wrote:
> > Hi all,
> > 
> > While fuzzing with trinity inside a KVM tools guest running latest -next kernel,
> > I've stumbled on the following spew:
> > 
> > [  274.820724] ------------[ cut here ]------------
> > [  274.821320] kernel BUG at mm/percpu.c:579!
> 
> Looks like double free.
> 
> > [  274.821848] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > [  274.822467] Modules linked in:
> > [  274.823240] CPU: 13 PID: 58 Comm: rcuos/13 Tainted: G        W
> > 3.11.0-rc4-next-20130805-sasha-00002-gf6cc217 #3975
> > [  274.824464] task: ffff880220cb3000 ti: ffff880220cba000 task.ti: ffff880220cba000
> > [  274.825442] RIP: 0010:[<ffffffff812417b8>]  [<ffffffff812417b8>] pcpu_free_area+0xd8/0x1e0
> > [  274.826470] RSP: 0018:ffff880220cbbc58  EFLAGS: 00010002
> > [  274.827316] RAX: ffff8800c9e3abd4 RBX: 00000000000002f5 RCX: 00000000000002f5
> > [  274.828162] RDX: 0000000000000004 RSI: 000000000000ede0 RDI: 000000000000ede0
> > [  274.829270] RBP: ffff880220cbbc78 R08: 0000000000000324 R09: ffff8800c9e3a000
> > [  274.830102] R10: ffff8800c9e3a000 R11: 0000000000000000 R12: ffff88022049ff80
> > [  274.830102] R13: 0000000000000bd4 R14: 0000000000000012 R15: ffffffff86612060
> > [  274.831367] FS:  0000000000000000(0000) GS:ffff880226000000(0000) knlGS:0000000000000000
> > [  274.831367] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [  274.831367] CR2: 0000000001253028 CR3: 0000000214aff000 CR4: 00000000000006e0
> > [  274.831367] Stack:
> > [  274.831367]  0000000000000282 000000000000ede0 ffff88022049ff80 000060fdd980ede0
> > [  274.831367]  ffff880220cbbca8 ffffffff81241c7e ffff880220cbbca8 ffff8800b80f83e0
> > [  274.831367]  0000000000000000 ffff8800b80f83c0 ffff880220cbbd18 ffffffff81a14ea6
> > [  274.831367] Call Trace:
> > [  274.831367]  [<ffffffff81241c7e>] free_percpu+0x9e/0x160
> > [  274.831367]  [<ffffffff81a14ea6>] percpu_ref_kill_rcu+0xb6/0x1b0
> 
> From percpu_ref release path.  Kent?

>From the backtrace I have no idea if this was from the aio code using it
or the cgroup code - Sasha, any idea?

AIO is probably more likely, I'm going to look to see if I can find
anything...

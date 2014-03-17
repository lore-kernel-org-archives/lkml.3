Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaCQXBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 19:01:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaCQXBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 19:01:19 -0400
Date: Mon, 17 Mar 2014 16:01:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Dietmar Hahn <dietmar.hahn@ts.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: zram: zsmalloc calls sleeping function from atomic context
Message-Id: <20140317160117.9bfbfdd5128d45a80f58070c@linux-foundation.org>
In-Reply-To: <20140317144358.GA374@swordfish.minsk.epam.com>
References: <20140317144358.GA374@swordfish.minsk.epam.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2014 17:43:58 +0300 Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> Hello gents,
> 
> I just noticed that starting from commit
> 
> commit 3d693a5127e79e79da7c34dc0c776bc620697ce5
> Author: Andrew Morton <akpm@linux-foundation.org>
> Date:   Mon Mar 17 11:23:56 2014 +1100
> 
>     mm-vmalloc-avoid-soft-lockup-warnings-when-vunmaping-large-ranges-fix
>     
>     add a might_sleep() to catch atomic callers more promptly
> 
> 
> and
> 
> 
> commit 032dda8b6c4021d4be63bcc483b47fd26c6f48a2
> Author: David Vrabel <david.vrabel@citrix.com>
> Date:   Mon Mar 17 11:23:56 2014 +1100
> 
> ...
> 
> w/ CONFIG_PGTABLE_MAPPING=y zs_unmap_object() calls unmap_kernel_range() under rwlock,
> producing the following warning (basically we perform every read()/write() under
> rwlock, so I can see lots of these warnings):
> 
> [  631.541177] BUG: sleeping function called from invalid context at mm/vmalloc.c:74
> [  631.541181] in_atomic(): 1, irqs_disabled(): 0, pid: 94, name: kworker/u8:2
> [  631.541183] Preemption disabled at:[<ffffffffa00ca0ad>] zram_bvec_rw.isra.14+0x2be/0x4fc [zram]
> 
> [  631.541193] CPU: 2 PID: 94 Comm: kworker/u8:2 Tainted: G           O  3.14.0-rc6-next-20140317-dbg-dirty #182
> [  631.541195] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
> [  631.541202] Workqueue: writeback bdi_writeback_workfn (flush-254:0)
> [  631.541205]  0000000000000000 ffff88015211b748 ffffffff813ba01d 0000000000000000
> [  631.541208]  ffff88015211b768 ffffffff81057ecb ffffc9000003e000 ffffc9000003e000
> [  631.541212]  ffff88015211b7d8 ffffffff810cc491 ffffc9000003dfff ffff88015211b800
> [  631.541216] Call Trace:
> [  631.541223]  [<ffffffff813ba01d>] dump_stack+0x4e/0x7a
> [  631.541229]  [<ffffffff81057ecb>] __might_sleep+0x14e/0x153
> [  631.541234]  [<ffffffff810cc491>] vunmap_page_range+0x133/0x25d
> [  631.541237]  [<ffffffff810cd81b>] unmap_kernel_range+0x16/0x26
> [  631.541241]  [<ffffffff810de6f6>] zs_unmap_object+0xd8/0xff
> [  631.541245]  [<ffffffffa00ca120>] zram_bvec_rw.isra.14+0x331/0x4fc [zram]
> [  631.541248]  [<ffffffffa00ca439>] zram_make_request+0x14e/0x228 [zram]
> [  631.541252]  [<ffffffff810a8088>] ? mempool_alloc+0x6d/0x130
> [  631.541257]  [<ffffffff811e9395>] generic_make_request+0x97/0xd6
> [  631.541259]  [<ffffffff811e94c6>] submit_bio+0xf2/0x131
>
> ...
>

OK, thanks.  David, there's our atomic unmap and there are probably
others.  Converting a previously-atomic utility function into one which
can sleep is going to be difficult.


One "fix" would be to make unmaps of (say) less than 16MB atomic, but
unmaps of larger regions can do cond_resched().  So vunmap_pmd_range()
will do

	if (end - addr < 16MB)
		might_sleep();

but I can't believe I even mentioned that.


So what to do?  Add a new interface, perhaps: "vunmap_large()",
perhaps.  Change that to pass a boolean "may_reschedule" down the
various levels.


Or can this code which vmaps 50GB be changed to unmap it in 16MB chunks
via unmap_kernel_range(), with a cond_resched() in the loop?


I'll drop the patches while we sort this out.



btw, I note that vunmap() itself already has a might_sleep() in it, and
I can't work out why - I don't think it _does_ sleep.  The changelog to
34754b69a6f87aa6aa is, in toto:

"x86: make vmap yell louder when it is used under irqs_disabled()"

No explanation *why*.  And why didn't it use WARN_ON(irqs_disabled())?



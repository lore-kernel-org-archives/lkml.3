Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbaCZVVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 17:21:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbaCZVVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 17:21:12 -0400
Date: Wed, 26 Mar 2014 14:21:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>, ngupta@vflare.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: zram: sleeping vunmap_pmd_range called from atomic
 zram_make_request
Message-Id: <20140326142111.fee2e7afa1d455451c8cec89@linux-foundation.org>
In-Reply-To: <53275359.7000802@oracle.com>
References: <53275359.7000802@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2014 15:56:09 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next kernel
> I've stumbled on the following spew:
> 
> [  827.272181] BUG: sleeping function called from invalid context at mm/vmalloc.c:74
> [  827.273204] in_atomic(): 1, irqs_disabled(): 0, pid: 4213, name: kswapd14
> [  827.274080] 1 lock held by kswapd14/4213:
> [  827.274587]  #0:  (&zram->init_lock){++++.-}, at: zram_make_request (drivers/block/zram/zram_drv.c:765)
> [  827.275923] Preemption disabled zram_bvec_write (drivers/block/zram/zram_drv.c:500)
> [  827.276910]
> [  827.277104] CPU: 30 PID: 4213 Comm: kswapd14 Tainted: G        W     3.14.0-rc6-next-20140317-sasha-00012-ge933921-dirty #226
> [  827.278467]  ffff880229700000 ffff8802296fd388 ffffffff8449ebb3 0000000000000001
> [  827.279610]  0000000000000000 ffff8802296fd3b8 ffffffff81176cec ffff8802296fd3c8
> [  827.281258]
> [  827.281549]  ffff88032b40a000 ffffc900077fa000 ffffc900077f8000 ffff8802296fd428
> [  827.282911] Call Trace:
> [  827.283318]  dump_stack (lib/dump_stack.c:52)
> [  827.284013]  __might_sleep (kernel/sched/core.c:7016)
> [  827.284797]  vunmap_pmd_range (mm/vmalloc.c:74)

I expect this was caused by
mm-vmalloc-avoid-soft-lockup-warnings-when-vunmaping-large-ranges.patch
and its folloup
mm-vmalloc-avoid-soft-lockup-warnings-when-vunmaping-large-ranges-fix.patch.

The second patch proved that the first patch can't add cond_resched()
in the vunmap_page_range() path.  I dropped both patches on March 18th.



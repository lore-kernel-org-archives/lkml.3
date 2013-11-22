Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3KVVMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:12:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab3KVVL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:11:59 -0500
Date: Fri, 22 Nov 2013 22:11:56 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Jones <davej@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: recursive locking (coredump/vfs_write)
Message-ID: <20131122211156.GA7520@quack.suse.cz>
References: <20131113211147.GA30263@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20131113211147.GA30263@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi,

On Wed 13-11-13 16:11:47, Dave Jones wrote:
> here's another one..
> 
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.12.0+ #2 Not tainted
> ---------------------------------------------
> trinity-child3/13302 is trying to acquire lock:
>  (sb_writers#5){.+.+.+}, at: [<ffffffff811b7013>] vfs_write+0x173/0x1f0
> 
> but task is already holding lock:
>  (sb_writers#5){.+.+.+}, at: [<ffffffff8122006d>] do_coredump+0xf1d/0x1070
  Thanks for report. Attached patch should fix this. Al, can you please
merge it?

								Honza

> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(sb_writers#5);
>   lock(sb_writers#5);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 1 lock held by trinity-child3/13302:
>  #0:  (sb_writers#5){.+.+.+}, at: [<ffffffff8122006d>] do_coredump+0xf1d/0x1070
> 
> stack backtrace:
> CPU: 3 PID: 13302 Comm: trinity-child3 Not tainted 3.12.0+ #2 
>  ffffffff82526e10 ffff8801b54af820 ffffffff8171b3dc ffffffff82526e10
>  ffff8801b54af8e0 ffffffff810d722b 00007f93d6ce5000 0000000000000000
>  ffff880154b3f200 ffff880100000000 00000000004da26d ffffffff821b3901
> Call Trace:
>  [<ffffffff8171b3dc>] dump_stack+0x4e/0x7a
>  [<ffffffff810d722b>] __lock_acquire+0x19ab/0x19f0
>  [<ffffffff81729334>] ? __do_page_fault+0x264/0x610
>  [<ffffffff8100b144>] ? native_sched_clock+0x24/0x80
>  [<ffffffff810d1d1f>] ? trace_hardirqs_off_caller+0x1f/0xc0
>  [<ffffffff810d7a23>] lock_acquire+0x93/0x1c0
>  [<ffffffff811b7013>] ? vfs_write+0x173/0x1f0
>  [<ffffffff811b97f9>] __sb_start_write+0xc9/0x1a0
>  [<ffffffff811b7013>] ? vfs_write+0x173/0x1f0
>  [<ffffffff811b7013>] ? vfs_write+0x173/0x1f0
>  [<ffffffff812cc303>] ? security_file_permission+0x23/0xa0
>  [<ffffffff811b7013>] vfs_write+0x173/0x1f0
>  [<ffffffff8121ef02>] dump_emit+0x92/0xd0
>  [<ffffffff81218d50>] elf_core_dump+0xde0/0x1740
>  [<ffffffff81218832>] ? elf_core_dump+0x8c2/0x1740
>  [<ffffffff8121fdee>] do_coredump+0xc9e/0x1070
>  [<ffffffff81719d9b>] ? __slab_free+0x191/0x35d
>  [<ffffffff8106a9b8>] get_signal_to_deliver+0x2c8/0x930
>  [<ffffffff810024b8>] do_signal+0x48/0x610
>  [<ffffffff810d1e39>] ? get_lock_stats+0x19/0x60
>  [<ffffffff810d25ae>] ? put_lock_stats.isra.28+0xe/0x30
>  [<ffffffff81715e86>] ? pagefault_enable+0xe/0x21
>  [<ffffffff8114b86e>] ? context_tracking_user_exit+0x4e/0x190
>  [<ffffffff810d54c5>] ? trace_hardirqs_on_caller+0x115/0x1e0
>  [<ffffffff81002adc>] do_notify_resume+0x5c/0xa0
>  [<ffffffff81725f86>] retint_signal+0x46/0x90
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--liOOAslEiF7prFVr
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-coredump-Avoid-fs-freezing-deadlock-when-dumping-cor.patch"

>From b7d1b0a12722eb6a5cb25cc614fae26ddf652c02 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 22 Nov 2013 21:59:24 +0100
Subject: [PATCH] coredump: Avoid fs freezing deadlock when dumping core

Commit 2507a4fbd48a96bc4236e584252635f8539079df (make dump_emit() use
vfs_write() instead of banging at ->f_op->write directly) introduced a
possible deadlock when dumping core while filesystem is being frozen. We
already acquired freeze protection in do_coredump() and after this patch
we also acquire it in vfs_write(). Fix the problem by removing now
unnecessary protection in do_coredump().

Fixes: 2507a4fbd48a96bc4236e584252635f8539079df
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/coredump.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 62406b6959b6..bdb9052744d8 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -657,11 +657,8 @@ void do_coredump(const siginfo_t *siginfo)
 		goto close_fail;
 	if (displaced)
 		put_files_struct(displaced);
-	if (!dump_interrupted()) {
-		file_start_write(cprm.file);
+	if (!dump_interrupted())
 		core_dumped = binfmt->core_dump(&cprm);
-		file_end_write(cprm.file);
-	}
 	if (ispipe && core_pipe_limit)
 		wait_for_dump_helpers(cprm.file);
 close_fail:
-- 
1.8.1.4


--liOOAslEiF7prFVr--

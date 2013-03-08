Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3CHTvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:51:01 -0500
Received: from longford.logfs.org ([213.229.74.203]:58636 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab3CHTvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:51:00 -0500
Date: Fri, 8 Mar 2013 13:26:49 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: pipe_release oops.
Message-ID: <20130308182648.GA25175@logfs.org>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
 <20130307213819.GB19543@redhat.com>
 <CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
 <20130307220333.GA31039@redhat.com>
 <20130307223610.GA2494@redhat.com>
 <CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
 <20130308145306.GA24085@redhat.com>
 <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 March 2013 10:30:01 -0800, Linus Torvalds wrote:
> 
> Hmm. So I've been trying to figure this out, and I really don't see
> it. Every single pipe open routine *should* make sure that the inode
> has an inode->i_pipe field. So if the open() has succeeded and you
> have a valid file descriptor, the inode->i_pipe thing should be there.

Ok, here is a wild idea that is very likely wrong.  But some
background first.  I've had problems with process exit times and one
of the culprits turned out to be exit_files() where one device driver
went awol for several seconds.  Fixing the device driver is hard, I
didn't see a good reason not to call exit_files() earlier and
exit_mm() was the other big offender, so the idea was to run both in
parallel and I applied the patch below.

As a result I've gotten a bunch of NULL pointer dereferences that only
happen in virtual machines, never on real hardware.  For example
  [<ffffffff81164bf8>] alloc_fd+0x38/0x130
  [<ffffffff8114857e>] do_sys_open+0xee/0x1f0
  [<ffffffff811486a1>] sys_open+0x21/0x30
  [<ffffffff815bea29>] system_call_fastpath+0x16/0x1b

Now I can easily see how current->files being NULL will result in such
backtraces.  I can also see how my patch moves the NULLing of
current->files a bit back in time.  But I could never figure out how
my patch could have introduced a race that didn't exist before.

So the wild idea is that we have always had a very unlikely race with
current->files being NULL and trinity happens to hit it somehow.

Jörn

--
One of my most productive days was throwing away 1000 lines of code.
-- Ken Thompson.


diff --git a/kernel/exit.c b/kernel/exit.c
index f65345f9..5886799 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -4,6 +4,7 @@
  *  Copyright (C) 1991, 1992  Linus Torvalds
  */
 
+#include <linux/async.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
@@ -559,6 +560,11 @@ void exit_files(struct task_struct *tsk)
 	}
 }
 
+static void exit_files_async(void *data, async_cookie_t cookie)
+{
+	exit_files(data);
+}
+
 #ifdef CONFIG_MM_OWNER
 /*
  * A task is exiting.   If it owned this mm, find a new owner for the mm.
@@ -905,6 +911,7 @@ static inline void check_stack_usage(void) {}
 void do_exit(long code)
 {
 	struct task_struct *tsk = current;
+	async_cookie_t files_cookie;
 	int group_dead;
 
 	profile_task_exit(tsk);
@@ -982,6 +989,7 @@ void do_exit(long code)
 	tsk->exit_code = code;
 	taskstats_exit(tsk, group_dead);
 
+	files_cookie = async_schedule(exit_files_async, tsk);
 	exit_mm(tsk);
 
 	if (group_dead)
@@ -990,7 +998,7 @@ void do_exit(long code)
 
 	exit_sem(tsk);
 	exit_shm(tsk);
-	exit_files(tsk);
+	async_synchronize_cookie(files_cookie);
 	exit_fs(tsk);
 	exit_task_work(tsk);
 	check_stack_usage();
-- 
1.7.10.4


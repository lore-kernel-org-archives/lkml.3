Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3CDIDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:03:32 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39750 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab3CDIDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:03:31 -0500
From: Russ Dill <russ.dill@gmail.com>
To: stable@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Kossifidis <mickflemm@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] Revert "random: Mix cputime from each thread that exits to the pool"
Date: Mon,  4 Mar 2013 00:03:28 -0800
Message-Id: <1362384208-6687-1-git-send-email-Russ.Dill@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130304073908.GA982@kroah.com>
References: <20130304073908.GA982@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 6133705494bb02953e1e2cc3018a4373981b3c97.

The above commit introduces a circular locking dependacy. Existing code
takes nonblocking_port.lock and then tasklist_lock. The code in this
commit takes nonblocking_port.lock while talklist_lock is already held
leading to a potential deadlock. For now, simply revert the commit.

Existing lock order:

send_sigio /* takes read lock on tasklist_lock */
kill_fasync_rcu
kill_fasync
account /* takes nonblocking_pool.lock */
extract_entropy
get_random_bytes
create_elf_tables
load_elf_binary
load_elf_library
search_binary_handler

New code:

mix_pool_bytes /* takes nonblocking_pool.lock */
add_device_randomness
posix_cpu_timers_exit
__exit_signal
release_task /* takes write lock on tasklist_lock */
do_exit
__module_put_and_exit
cryptomgr_test

Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
---
 kernel/posix-cpu-timers.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 942ca27..1f2ef3d 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -9,7 +9,6 @@
 #include <asm/uaccess.h>
 #include <linux/kernel_stat.h>
 #include <trace/events/timer.h>
-#include <linux/random.h>
 
 /*
  * Called after updating RLIMIT_CPU to run cpu timer and update
@@ -471,8 +470,6 @@ static void cleanup_timers(struct list_head *head,
  */
 void posix_cpu_timers_exit(struct task_struct *tsk)
 {
-	add_device_randomness((const void*) &tsk->se.sum_exec_runtime,
-						sizeof(unsigned long long));
 	cleanup_timers(tsk->cpu_timers,
 		       tsk->utime, tsk->stime, tsk->se.sum_exec_runtime);
 
-- 
1.8.1.2


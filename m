Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaB1Njh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:39:37 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:12016 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751929AbaB1Nfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:35:37 -0500
Message-Id: <20140228133536.188431841@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 28 Feb 2014 08:35:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 07/11] kernel/hrtimer: be non-freezeable in cpu_chill()
References: <20140228133454.373761937@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0007-kernel-hrtimer-be-non-freezeable-in-cpu_chill.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10.32-rt31-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Since we replaced msleep() by hrtimer I see now and then (rarely) this:

| [....] Waiting for /dev to be fully populated...
| =====================================
| [ BUG: udevd/229 still has locks held! ]
| 3.12.11-rt17 #23 Not tainted
| -------------------------------------
| 1 lock held by udevd/229:
|  #0:  (&type->i_mutex_dir_key#2){+.+.+.}, at: lookup_slow+0x28/0x98
|
| stack backtrace:
| CPU: 0 PID: 229 Comm: udevd Not tainted 3.12.11-rt17 #23
| (unwind_backtrace+0x0/0xf8) from (show_stack+0x10/0x14)
| (show_stack+0x10/0x14) from (dump_stack+0x74/0xbc)
| (dump_stack+0x74/0xbc) from (do_nanosleep+0x120/0x160)
| (do_nanosleep+0x120/0x160) from (hrtimer_nanosleep+0x90/0x110)
| (hrtimer_nanosleep+0x90/0x110) from (cpu_chill+0x30/0x38)
| (cpu_chill+0x30/0x38) from (dentry_kill+0x158/0x1ec)
| (dentry_kill+0x158/0x1ec) from (dput+0x74/0x15c)
| (dput+0x74/0x15c) from (lookup_real+0x4c/0x50)
| (lookup_real+0x4c/0x50) from (__lookup_hash+0x34/0x44)
| (__lookup_hash+0x34/0x44) from (lookup_slow+0x38/0x98)
| (lookup_slow+0x38/0x98) from (path_lookupat+0x208/0x7fc)
| (path_lookupat+0x208/0x7fc) from (filename_lookup+0x20/0x60)
| (filename_lookup+0x20/0x60) from (user_path_at_empty+0x50/0x7c)
| (user_path_at_empty+0x50/0x7c) from (user_path_at+0x14/0x1c)
| (user_path_at+0x14/0x1c) from (vfs_fstatat+0x48/0x94)
| (vfs_fstatat+0x48/0x94) from (SyS_stat64+0x14/0x30)
| (SyS_stat64+0x14/0x30) from (ret_fast_syscall+0x0/0x48)

For now I see no better way but to disable the freezer the sleep the period.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/hrtimer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b569c6d..eb4c8831c 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1896,8 +1896,12 @@ void cpu_chill(void)
 	struct timespec tu = {
 		.tv_nsec = NSEC_PER_MSEC,
 	};
+	unsigned int freeze_flag = current->flags & PF_NOFREEZE;
 
+	current->flags |= PF_NOFREEZE;
 	hrtimer_nanosleep(&tu, NULL, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+	if (!freeze_flag)
+		current->flags &= ~PF_NOFREEZE;
 }
 EXPORT_SYMBOL(cpu_chill);
 #endif
-- 
1.8.5.3



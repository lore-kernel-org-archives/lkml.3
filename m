Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbaBUUdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:33:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58569 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbaBUUdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:33:07 -0500
Date: Fri, 21 Feb 2014 12:32:26 -0800
From: tip-bot for Vegard Nossum <tipbot@zytor.com>
Message-ID: <tip-4efbc454ba68def5ef285b26ebfcfdb605b52755@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, raistlin@linux.it, vegard.nossum@oracle.com,
        tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, raistlin@linux.it, vegard.nossum@oracle.com,
        tglx@linutronix.de, juri.lelli@gmail.com
In-Reply-To: <1392585857-10725-1-git-send-email-vegard.nossum@oracle.com>
References: <1392585857-10725-1-git-send-email-vegard.nossum@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Fix information leak in sys_sched_getattr()
Git-Commit-ID: 4efbc454ba68def5ef285b26ebfcfdb605b52755
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4efbc454ba68def5ef285b26ebfcfdb605b52755
Gitweb:     http://git.kernel.org/tip/4efbc454ba68def5ef285b26ebfcfdb605b52755
Author:     Vegard Nossum <vegard.nossum@oracle.com>
AuthorDate: Sun, 16 Feb 2014 22:24:17 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:27:10 +0100

sched: Fix information leak in sys_sched_getattr()

We're copying the on-stack structure to userspace, but forgot to give
the right number of bytes to copy. This allows the calling process to
obtain up to PAGE_SIZE bytes from the stack (and possibly adjacent
kernel memory).

This fix copies only as much as we actually have on the stack
(attr->size defaults to the size of the struct) and leaves the rest of
the userspace-provided buffer untouched.

Found using kmemcheck + trinity.

Fixes: d50dde5a10f30 ("sched: Add new scheduler syscalls to support an extended scheduling parameters ABI")
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392585857-10725-1-git-send-email-vegard.nossum@oracle.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 33d030a..a6e7470 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3786,7 +3786,7 @@ static int sched_read_attr(struct sched_attr __user *uattr,
 		attr->size = usize;
 	}
 
-	ret = copy_to_user(uattr, attr, usize);
+	ret = copy_to_user(uattr, attr, attr->size);
 	if (ret)
 		return -EFAULT;
 

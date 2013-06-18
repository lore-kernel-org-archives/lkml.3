Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab3FRLrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:47:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56335 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651Ab3FRLpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:45:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 90/93] audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE
Date: Tue, 18 Jun 2013 12:43:38 +0100
Message-Id: <1371555821-12820-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit f000cfdde5de4fc15dead5ccf524359c07eadf2b upstream.

audit_log_start() does wait_for_auditd() in a loop until
audit_backlog_wait_time passes or audit_skb_queue has a room.

If signal_pending() is true this becomes a busy-wait loop, schedule() in
TASK_INTERRUPTIBLE won't block.

Thanks to Guy for fully investigating and explaining the problem.

(akpm: that'll cause the system to lock up on a non-preemptible
uniprocessor kernel)

(Guy: "Our customer was in fact running a uniprocessor machine, and they
reported a system hang.")

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Guy Streeter <streeter@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: backported to 3.5: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/audit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 1c7f2c6..5917dfe 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1167,7 +1167,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 
 			/* Wait for auditd to drain the queue a little */
 			DECLARE_WAITQUEUE(wait, current);
-			set_current_state(TASK_INTERRUPTIBLE);
+			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&audit_backlog_wait, &wait);
 
 			if (audit_backlog_limit &&
-- 
1.8.1.2


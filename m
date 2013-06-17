Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3FQRjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:39:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50740 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab3FQRgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:36:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 76/84] audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE
Date: Mon, 17 Jun 2013 10:31:20 -0700
Message-Id: <1371490288-23167-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/audit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index d596e53..8a667f10 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1107,7 +1107,7 @@ static inline void audit_get_stamp(struct audit_context *ctx,
 static void wait_for_auditd(unsigned long sleep_time)
 {
 	DECLARE_WAITQUEUE(wait, current);
-	set_current_state(TASK_INTERRUPTIBLE);
+	set_current_state(TASK_UNINTERRUPTIBLE);
 	add_wait_queue(&audit_backlog_wait, &wait);
 
 	if (audit_backlog_limit &&
-- 
1.8.1.2


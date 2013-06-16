Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab3FPWW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:22:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46380 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755726Ab3FPWI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Eric Paris" <eparis@redhat.com>, "Al Viro" <viro@zeniv.linux.org.uk>,
        "Guy Streeter" <streeter@redhat.com>,
        "Oleg Nesterov" <oleg@redhat.com>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.561131741@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [73/83] audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/audit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1167,7 +1167,7 @@ struct audit_buffer *audit_log_start(str
 
 			/* Wait for auditd to drain the queue a little */
 			DECLARE_WAITQUEUE(wait, current);
-			set_current_state(TASK_INTERRUPTIBLE);
+			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&audit_backlog_wait, &wait);
 
 			if (audit_backlog_limit &&


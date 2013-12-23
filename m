Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab3LWWbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:31:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757794Ab3LWWbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 17:31:18 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 5/5] audit: allow user processes to log from another PID namespace
Date: Mon, 23 Dec 2013 17:27:39 -0500
Message-Id: <160c1e22dfacac09555da20602f5a4ab861451d5.1387834776.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1387834776.git.rgb@redhat.com>
References: <cover.1387834776.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still only permit the audit logging daemon and control to operate from the
initial PID namespace, but allow processes to log from another PID namespace.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
(informed by ebiederman's c776b5d2)

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index e39606b..83f8068 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -606,9 +606,8 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 {
 	int err = 0;
 
-	/* Only support the initial namespaces for now. */
-	if ((current_user_ns() != &init_user_ns) ||
-	    (task_active_pid_ns(current) != &init_pid_ns))
+	/* Only support initial user namespace for now. */
+	if ((current_user_ns() != &init_user_ns))
 		return -EPERM;
 
 	switch (msg_type) {
@@ -628,6 +627,11 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	case AUDIT_TTY_SET:
 	case AUDIT_TRIM:
 	case AUDIT_MAKE_EQUIV:
+		/* Only support auditd and auditctl in initial pid namespace
+		 * for now. */
+		if ((task_active_pid_ns(current) != &init_pid_ns))
+			return -EPERM;
+
 		if (!capable(CAP_AUDIT_CONTROL))
 			err = -EPERM;
 		break;
-- 
1.7.1


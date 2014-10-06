Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaJFFLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:11:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbaJFFJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:09:23 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com, arozansk@redhat.com,
        ebiederm@xmission.com, serge@hallyn.com
Subject: [PATCH V5 07/13] audit: dump namespace IDs for pid on receipt of AUDIT_NS_INFO
Date: Mon,  6 Oct 2014 01:08:32 -0400
Message-Id: <2503a41768e92791f9901e8ee7c132634821a2db.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a task with CAP_AUDIT_CONTROL sends a NETLINK_AUDIT message of type
AUDIT_NS_INFO with a PID of interest, dump the namespace IDs of that task to
the audit log.
---
 kernel/audit.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index a17a09f..cc63445 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -671,6 +671,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	case AUDIT_TTY_SET:
 	case AUDIT_TRIM:
 	case AUDIT_MAKE_EQUIV:
+	case AUDIT_NS_INFO:
 		/* Only support auditd and auditctl in initial pid namespace
 		 * for now. */
 		if ((task_active_pid_ns(current) != &init_pid_ns))
@@ -1068,6 +1069,19 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		audit_log_end(ab);
 		break;
 	}
+	case AUDIT_NS_INFO:
+#ifdef CONFIG_NAMESPACES
+	{
+		struct task_struct *tsk;
+
+		rcu_read_lock();
+		tsk = find_task_by_vpid(*(pid_t *)data);
+		rcu_read_unlock();
+		audit_log_ns_info(tsk);
+	}
+#else /* CONFIG_NAMESPACES */
+		err = -EOPNOTSUPP;
+#endif /* CONFIG_NAMESPACES */
 	default:
 		err = -EINVAL;
 		break;
-- 
1.7.1


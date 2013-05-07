Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365Ab3EGCTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:19:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63100 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760007Ab3EGCTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201752"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 06/48] Audit: make kauditd_task per user namespace
Date: Tue, 7 May 2013 10:20:27 +0800
Message-Id: <1367893269-9308-7-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:27,
	Serialize complete at 2013/05/07 10:18:27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes kauditd_task per user namespace,
Since right now we only allow user in init user
namesapce to send audit netlink message to kernel,
so actually the kauditd_task belongs to other user
namespace will still not run.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/user_namespace.h |  1 +
 kernel/audit.c                 | 25 +++++++++++++++----------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 53420a4..24f7c2f 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -23,6 +23,7 @@ struct audit_ctrl {
 	struct sock		*sock;
 	struct sk_buff_head	queue;
 	struct sk_buff_head	hold_queue;
+	struct task_struct	*kauditd_task;
 };
 #endif
 
diff --git a/kernel/audit.c b/kernel/audit.c
index 61562c5..839c4c0 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -129,7 +129,6 @@ static DEFINE_SPINLOCK(audit_freelist_lock);
 static int	   audit_freelist_count;
 static LIST_HEAD(audit_freelist);
 
-static struct task_struct *kauditd_task;
 static DECLARE_WAIT_QUEUE_HEAD(kauditd_wait);
 static DECLARE_WAIT_QUEUE_HEAD(audit_backlog_wait);
 
@@ -418,8 +417,9 @@ static void kauditd_send_skb(struct sk_buff *skb)
 static int kauditd_thread(void *dummy)
 {
 	struct sk_buff *skb;
-	struct sk_buff_head *queue = &init_user_ns.audit.queue;
-	struct sk_buff_head *hold_queue = &init_user_ns.audit.hold_queue;
+	struct user_namespace *ns = dummy;
+	struct sk_buff_head *queue = &ns->audit.queue;
+	struct sk_buff_head *hold_queue = &ns->audit.hold_queue;
 
 	set_freezable();
 	while (!kthread_should_stop()) {
@@ -663,14 +663,16 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	ns = current_user_ns();
 	/* As soon as there's any sign of userspace auditd,
 	 * start kauditd to talk to it */
-	if (!kauditd_task) {
-		kauditd_task = kthread_run(kauditd_thread, NULL, "kauditd");
-		if (IS_ERR(kauditd_task)) {
-			err = PTR_ERR(kauditd_task);
-			kauditd_task = NULL;
-			return err;
-		}
+	if (!ns->audit.kauditd_task) {
+		struct task_struct *tsk;
+
+		tsk = kthread_run(kauditd_thread, ns, "kauditd");
+		if (IS_ERR(tsk))
+			return PTR_ERR(tsk);
+
+		ns->audit.kauditd_task = tsk;
 	}
+
 	loginuid = audit_get_loginuid(current);
 	sessionid = audit_get_sessionid(current);
 	security_task_getsecid(current, &sid);
@@ -1615,6 +1617,9 @@ void audit_free_user_ns(struct user_namespace *ns)
 
 	skb_queue_purge(&ns->audit.queue);
 	skb_queue_purge(&ns->audit.hold_queue);
+
+	if (ns->audit.kauditd_task)
+		kthread_stop(ns->audit.kauditd_task);
 }
 
 EXPORT_SYMBOL(audit_log_start);
-- 
1.8.1.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266Ab3FSByA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:54:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3343 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934097Ab3FSBxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:53:12 -0400
X-IronPort-AV: E=Sophos;i="4.87,893,1363104000"; 
   d="scan'208";a="7596301"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: eparis@redhat.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        sgrubb@redhat.com, aris@redhat.com, matthltc@linux.vnet.ibm.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 21/22] Audit: send reply message to the auditd in proper user namespace
Date: Wed, 19 Jun 2013 09:53:53 +0800
Message-Id: <1371606834-5802-22-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:51:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:52:02,
	Serialize complete at 2013/06/19 09:52:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can send the audit reply message to userspace auditd
process which running in the same user namespace with the
process which send the audit request message to kernel.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 84a882c..0b3fd8b 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -146,6 +146,7 @@ struct audit_buffer {
 struct audit_reply {
 	int pid;
 	struct sk_buff *skb;
+	struct user_namespace *ns;
 };
 
 static void audit_set_pid(struct audit_buffer *ab, pid_t pid)
@@ -532,8 +533,9 @@ static int audit_send_reply_thread(void *arg)
 
 	/* Ignore failure. It'll only happen if the sender goes away,
 	   because our timeout is set to infinite. */
-	netlink_unicast(init_user_ns.audit.sock, reply->skb,
+	netlink_unicast(reply->ns->audit.sock, reply->skb,
 			reply->pid, 0);
+	put_user_ns(reply->ns);
 	kfree(reply);
 	return 0;
 }
@@ -572,11 +574,13 @@ static int audit_send_reply(int pid, int seq, int type, int done, int multi,
 
 	reply->pid = pid;
 	reply->skb = skb;
+	reply->ns = get_user_ns(current_user_ns());
 
 	tsk = kthread_run(audit_send_reply_thread, reply, "audit_send_reply");
 	if (!IS_ERR(tsk))
 		return 0;
 	kfree_skb(skb);
+	put_user_ns(reply->ns);
 out:
 	kfree(reply);
 	return ret;
@@ -833,7 +837,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				security_release_secctx(ctx, len);
 			return -ENOMEM;
 		}
-		sig_data->uid = from_kuid(&init_user_ns, audit_sig_uid);
+		sig_data->uid = from_kuid(ns, audit_sig_uid);
 		sig_data->pid = audit_sig_pid;
 		if (audit_sig_sid) {
 			memcpy(sig_data->ctx, ctx, len);
-- 
1.8.1.4


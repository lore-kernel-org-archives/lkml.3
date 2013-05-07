Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255Ab3EGC0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:26:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2879 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933209Ab3EGCTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:31 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201775"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 25/48] Audit: send reply message to the auditd in proper user namespace
Date: Tue, 7 May 2013 10:20:46 +0800
Message-Id: <1367893269-9308-26-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:29,
	Serialize complete at 2013/05/07 10:18:29
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
index cac4b21..ca9e046 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -144,6 +144,7 @@ struct audit_buffer {
 struct audit_reply {
 	int pid;
 	struct sk_buff *skb;
+	struct user_namespace *ns;
 };
 
 static void audit_set_pid(struct audit_buffer *ab, pid_t pid)
@@ -517,8 +518,9 @@ static int audit_send_reply_thread(void *arg)
 
 	/* Ignore failure. It'll only happen if the sender goes away,
 	   because our timeout is set to infinite. */
-	netlink_unicast(init_user_ns.audit.sock, reply->skb,
+	netlink_unicast(reply->ns->audit.sock, reply->skb,
 			reply->pid, 0);
+	put_user_ns(reply->ns);
 	kfree(reply);
 	return 0;
 }
@@ -552,11 +554,13 @@ static void audit_send_reply(int pid, int seq, int type, int done, int multi,
 
 	reply->pid = pid;
 	reply->skb = skb;
+	reply->ns = get_user_ns(current_user_ns());
 
 	tsk = kthread_run(audit_send_reply_thread, reply, "audit_send_reply");
 	if (!IS_ERR(tsk))
 		return;
 	kfree_skb(skb);
+	put_user_ns(reply->ns);
 out:
 	kfree(reply);
 }
@@ -859,7 +863,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
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


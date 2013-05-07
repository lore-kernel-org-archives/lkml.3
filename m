Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417Ab3EGCau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:30:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16239 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760082Ab3EGCT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:28 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201767"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 21/48] Audit: pass proper user namespace to audit_log_common_recv_msg
Date: Tue, 7 May 2013 10:20:42 +0800
Message-Id: <1367893269-9308-22-git-send-email-gaofeng@cn.fujitsu.com>
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

The audit log that generated in user namespace should be
received by the auditd running in this user namespace.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 594e4e1..c8329ce 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -604,25 +604,26 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	return err;
 }
 
-static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type,
+static int audit_log_common_recv_msg(struct user_namespace *ns,
+				     struct audit_buffer **ab, u16 msg_type,
 				     kuid_t auid, u32 ses, u32 sid)
 {
 	int rc = 0;
 	char *ctx = NULL;
 	u32 len;
 
-	if (!init_user_ns.audit.enabled) {
+	if (!ns->audit.enabled) {
 		*ab = NULL;
 		return rc;
 	}
 
-	*ab = audit_log_start(NULL, GFP_KERNEL, msg_type);
+	*ab = audit_log_start_ns(ns, NULL, GFP_KERNEL, msg_type);
 	if (unlikely(!*ab))
 		return rc;
 	audit_log_format(*ab, "pid=%d uid=%u auid=%u ses=%u",
 			 task_tgid_vnr(current),
-			 from_kuid(&init_user_ns, current_uid()),
-			 from_kuid(&init_user_ns, auid), ses);
+			 from_kuid(ns, current_uid()),
+			 from_kuid(ns, auid), ses);
 	if (sid) {
 		rc = security_secid_to_secctx(sid, &ctx, &len);
 		if (rc)
@@ -739,7 +740,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				if (err)
 					break;
 			}
-			audit_log_common_recv_msg(&ab, msg_type,
+			audit_log_common_recv_msg(ns, &ab, msg_type,
 						  loginuid, sessionid, sid);
 
 			if (msg_type != AUDIT_USER_TTY)
@@ -756,7 +757,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				audit_log_n_untrustedstring(ab, data, size);
 			}
 			audit_set_pid(ab, NETLINK_CB(skb).portid);
-			audit_log_end(ab);
+			audit_log_end_ns(ns, ab);
 		}
 		break;
 	case AUDIT_ADD:
@@ -764,12 +765,12 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (nlmsg_len(nlh) < sizeof(struct audit_rule))
 			return -EINVAL;
 		if (ns->audit.enabled == AUDIT_LOCKED) {
-			audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE,
+			audit_log_common_recv_msg(ns, &ab, AUDIT_CONFIG_CHANGE,
 						  loginuid, sessionid, sid);
 
 			audit_log_format(ab, " audit_enabled=%d res=0",
 					 ns->audit.enabled);
-			audit_log_end(ab);
+			audit_log_end_ns(ns, ab);
 			return -EPERM;
 		}
 		/* fallthrough */
@@ -783,12 +784,12 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (nlmsg_len(nlh) < sizeof(struct audit_rule_data))
 			return -EINVAL;
 		if (ns->audit.enabled == AUDIT_LOCKED) {
-			audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE,
+			audit_log_common_recv_msg(ns, &ab, AUDIT_CONFIG_CHANGE,
 						  loginuid, sessionid, sid);
 
 			audit_log_format(ab, " audit_enabled=%d res=0",
 					 ns->audit.enabled);
-			audit_log_end(ab);
+			audit_log_end_ns(ns, ab);
 			return -EPERM;
 		}
 		/* fallthrough */
@@ -800,11 +801,11 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	case AUDIT_TRIM:
 		audit_trim_trees();
 
-		audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE,
+		audit_log_common_recv_msg(ns, &ab, AUDIT_CONFIG_CHANGE,
 					  loginuid, sessionid, sid);
 
 		audit_log_format(ab, " op=trim res=1");
-		audit_log_end(ab);
+		audit_log_end_ns(ns, ab);
 		break;
 	case AUDIT_MAKE_EQUIV: {
 		void *bufp = data;
@@ -832,7 +833,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		/* OK, here comes... */
 		err = audit_tag_tree(old, new);
 
-		audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE,
+		audit_log_common_recv_msg(ns, &ab, AUDIT_CONFIG_CHANGE,
 					  loginuid, sessionid, sid);
 
 		audit_log_format(ab, " op=make_equiv old=");
@@ -840,7 +841,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		audit_log_format(ab, " new=");
 		audit_log_untrustedstring(ab, new);
 		audit_log_format(ab, " res=%d", !err);
-		audit_log_end(ab);
+		audit_log_end_ns(ns, ab);
 		kfree(old);
 		kfree(new);
 		break;
-- 
1.8.1.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab3JXHcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:32:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab3JXHbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:31:08 -0400
X-IronPort-AV: E=Sophos;i="4.93,560,1378828800"; 
   d="scan'208";a="8847753"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        toshi.okajima@jp.fujitsu.com, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 14/20] audit: pass proper audit namespace to audit_log_common_recv_msg
Date: Thu, 24 Oct 2013 15:31:59 +0800
Message-Id: <1382599925-25143-15-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/24 15:28:30,
	Serialize complete at 2013/10/24 15:28:30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The audit log that generated in audit namespace should be
received by the auditd running in this audit namespace.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 5ac7365..92da21d 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -605,7 +605,8 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
 	return err;
 }
 
-static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type)
+static int audit_log_common_recv_msg(struct audit_namespace *ns,
+				     struct audit_buffer **ab, u16 msg_type)
 {
 	int rc = 0;
 	uid_t uid = from_kuid(&init_user_ns, current_uid());
@@ -615,7 +616,7 @@ static int audit_log_common_recv_msg(struct audit_buffer **ab, u16 msg_type)
 		return rc;
 	}
 
-	*ab = audit_log_start(NULL, GFP_KERNEL, msg_type);
+	*ab = audit_log_start_ns(ns, NULL, GFP_KERNEL, msg_type);
 	if (unlikely(!*ab))
 		return rc;
 	audit_log_format(*ab, "pid=%d uid=%u", task_tgid_vnr(current), uid);
@@ -741,7 +742,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				if (err)
 					break;
 			}
-			audit_log_common_recv_msg(&ab, msg_type);
+			audit_log_common_recv_msg(ns, &ab, msg_type);
 			if (msg_type != AUDIT_USER_TTY)
 				audit_log_format(ab, " msg='%.1024s'",
 						 (char *)data);
@@ -756,7 +757,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				audit_log_n_untrustedstring(ab, data, size);
 			}
 			audit_set_pid(ab, NETLINK_CB(skb).portid);
-			audit_log_end(ab);
+			audit_log_end_ns(ns, ab);
 		}
 		break;
 	case AUDIT_ADD_RULE:
@@ -764,9 +765,9 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (nlmsg_len(nlh) < sizeof(struct audit_rule_data))
 			return -EINVAL;
 		if (audit_enabled == AUDIT_LOCKED) {
-			audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE);
+			audit_log_common_recv_msg(ns, &ab, AUDIT_CONFIG_CHANGE);
 			audit_log_format(ab, " audit_enabled=%d res=0", audit_enabled);
-			audit_log_end(ab);
+			audit_log_end_ns(ns, ab);
 			return -EPERM;
 		}
 		/* fallthrough */
@@ -776,9 +777,9 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		break;
 	case AUDIT_TRIM:
 		audit_trim_trees();
-		audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE);
+		audit_log_common_recv_msg(ns, &ab, AUDIT_CONFIG_CHANGE);
 		audit_log_format(ab, " op=trim res=1");
-		audit_log_end(ab);
+		audit_log_end_ns(ns, ab);
 		break;
 	case AUDIT_MAKE_EQUIV: {
 		void *bufp = data;
@@ -806,14 +807,14 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		/* OK, here comes... */
 		err = audit_tag_tree(old, new);
 
-		audit_log_common_recv_msg(&ab, AUDIT_CONFIG_CHANGE);
+		audit_log_common_recv_msg(ns, &ab, AUDIT_CONFIG_CHANGE);
 
 		audit_log_format(ab, " op=make_equiv old=");
 		audit_log_untrustedstring(ab, old);
 		audit_log_format(ab, " new=");
 		audit_log_untrustedstring(ab, new);
 		audit_log_format(ab, " res=%d", !err);
-		audit_log_end(ab);
+		audit_log_end_ns(ns, ab);
 		kfree(old);
 		kfree(new);
 		break;
-- 
1.8.3.1


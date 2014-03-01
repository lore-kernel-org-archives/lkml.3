Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaCAEhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 23:37:09 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53935 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaCAEhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 23:37:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <8738j3vzry.fsf@xmission.com>
	<20140301011142.GK16640@madcap2.tricolour.ca>
	<87fvn2r0yb.fsf@xmission.com>
Date: Fri, 28 Feb 2014 20:36:55 -0800
In-Reply-To: <87fvn2r0yb.fsf@xmission.com> (Eric W. Biederman's message of
	"Fri, 28 Feb 2014 20:34:52 -0800")
Message-ID: <874n3ir0uw.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19iS2OkVHag69AI2Ik06ymrTaIDOzMD9VA=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3404]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Richard Guy Briggs <rgb@redhat.com>
X-Spam-Relay-Country: 
Subject: [PATCH] audit: Send replies in the proper network namespace.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In perverse cases of file descriptor passing the current network
namespace of a process and the network namespace of a socket used by
that socket may differ.  Therefore use the network namespace of the
appropiate socket to ensure replies always go to the appropiate
socket.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

This is an incremental change on top of my previous patch to guarantee
that replies always happen in the appropriate network namespace.

 include/linux/audit.h |    3 ++-
 kernel/audit.c        |   21 ++++++++++-----------
 kernel/auditfilter.c  |    7 +++++--
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index aa865a9a4c4f..ec1464df4c60 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -43,6 +43,7 @@ struct mq_attr;
 struct mqstat;
 struct audit_watch;
 struct audit_tree;
+struct sk_buff;
 
 struct audit_krule {
 	int			vers_ops;
@@ -463,7 +464,7 @@ extern int audit_filter_user(int type);
 extern int audit_filter_type(int type);
 extern int audit_rule_change(int type, __u32 portid, int seq,
 				void *data, size_t datasz);
-extern int audit_list_rules_send(__u32 portid, int seq);
+extern int audit_list_rules_send(struct sk_buff *request_skb, int seq);
 
 extern u32 audit_enabled;
 #else /* CONFIG_AUDIT */
diff --git a/kernel/audit.c b/kernel/audit.c
index 1e5756f16f6f..32086bff5564 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -570,9 +570,11 @@ static int audit_send_reply_thread(void *arg)
  * Allocates an skb, builds the netlink message, and sends it to the port id.
  * No failure notifications.
  */
-static void audit_send_reply(__u32 portid, int seq, int type, int done,
+static void audit_send_reply(struct sk_buff *request_skb, int seq, int type, int done,
 			     int multi, const void *payload, int size)
 {
+	u32 portid = NETLINK_CB(request_skb).portid;
+	struct net *net = sock_net(NETLINK_CB(request_skb).sk);
 	struct sk_buff *skb;
 	struct task_struct *tsk;
 	struct audit_reply *reply = kmalloc(sizeof(struct audit_reply),
@@ -585,7 +587,7 @@ static void audit_send_reply(__u32 portid, int seq, int type, int done,
 	if (!skb)
 		goto out;
 
-	reply->net = get_net(current->nsproxy->net_ns);
+	reply->net = get_net(net);
 	reply->portid = portid;
 	reply->skb = skb;
 
@@ -675,8 +677,7 @@ static int audit_get_feature(struct sk_buff *skb)
 
 	seq = nlmsg_hdr(skb)->nlmsg_seq;
 
-	audit_send_reply(NETLINK_CB(skb).portid, seq, AUDIT_GET, 0, 0,
-			 &af, sizeof(af));
+	audit_send_reply(skb, seq, AUDIT_GET, 0, 0, &af, sizeof(af));
 
 	return 0;
 }
@@ -796,8 +797,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		s.backlog		= skb_queue_len(&audit_skb_queue);
 		s.version		= AUDIT_VERSION_LATEST;
 		s.backlog_wait_time	= audit_backlog_wait_time;
-		audit_send_reply(NETLINK_CB(skb).portid, seq, AUDIT_GET, 0, 0,
-				 &s, sizeof(s));
+		audit_send_reply(skb, seq, AUDIT_GET, 0, 0, &s, sizeof(s));
 		break;
 	}
 	case AUDIT_SET: {
@@ -907,7 +907,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 					   seq, data, nlmsg_len(nlh));
 		break;
 	case AUDIT_LIST_RULES:
-		err = audit_list_rules_send(NETLINK_CB(skb).portid, seq);
+		err = audit_list_rules_send(skb, seq);
 		break;
 	case AUDIT_TRIM:
 		audit_trim_trees();
@@ -972,8 +972,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			memcpy(sig_data->ctx, ctx, len);
 			security_release_secctx(ctx, len);
 		}
-		audit_send_reply(NETLINK_CB(skb).portid, seq, AUDIT_SIGNAL_INFO,
-				0, 0, sig_data, sizeof(*sig_data) + len);
+		audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO, 0, 0,
+				 sig_data, sizeof(*sig_data) + len);
 		kfree(sig_data);
 		break;
 	case AUDIT_TTY_GET: {
@@ -985,8 +985,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		s.log_passwd = tsk->signal->audit_tty_log_passwd;
 		spin_unlock(&tsk->sighand->siglock);
 
-		audit_send_reply(NETLINK_CB(skb).portid, seq,
-				 AUDIT_TTY_GET, 0, 0, &s, sizeof(s));
+		audit_send_reply(skb, seq, AUDIT_TTY_GET, 0, 0, &s, sizeof(s));
 		break;
 	}
 	case AUDIT_TTY_SET: {
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index a5e3d73d73e4..e8d1c7c515d7 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/security.h>
 #include <net/net_namespace.h>
+#include <net/sock.h>
 #include "audit.h"
 
 /*
@@ -1069,8 +1070,10 @@ int audit_rule_change(int type, __u32 portid, int seq, void *data,
  * @portid: target portid for netlink audit messages
  * @seq: netlink audit message sequence (serial) number
  */
-int audit_list_rules_send(__u32 portid, int seq)
+int audit_list_rules_send(struct sk_buff *request_skb, int seq)
 {
+	u32 portid = NETLINK_CB(request_skb).portid;
+	struct net *net = sock_net(NETLINK_CB(request_skb).sk);
 	struct task_struct *tsk;
 	struct audit_netlink_list *dest;
 	int err = 0;
@@ -1084,7 +1087,7 @@ int audit_list_rules_send(__u32 portid, int seq)
 	dest = kmalloc(sizeof(struct audit_netlink_list), GFP_KERNEL);
 	if (!dest)
 		return -ENOMEM;
-	dest->net = get_net(current->nsproxy->net_ns);
+	dest->net = get_net(net);
 	dest->portid = portid;
 	skb_queue_head_init(&dest->q);
 
-- 
1.7.5.4


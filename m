Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3JWLYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:24:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57696 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab3JWLYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:24:18 -0400
X-IronPort-AV: E=Sophos;i="4.93,553,1378828800"; 
   d="scan'208";a="8839264"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: linux-audit@redhat.com
Cc: linux-kernel@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] audit: change pid to portid for audit_reply
Date: Wed, 23 Oct 2013 19:25:23 +0800
Message-Id: <1382527523-22505-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/23 19:21:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/23 19:21:42,
	Serialize complete at 2013/10/23 19:21:42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "pid" is not a suitable name for netlink port,
change it to "portid".

more information, please see commit
15e473046cb6e5d18a4d0057e61d76315230382b

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 7b0e23a..50fdcba 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -165,7 +165,7 @@ struct audit_buffer {
 };
 
 struct audit_reply {
-	int pid;
+	int portid;
 	struct sk_buff *skb;
 };
 
@@ -487,7 +487,7 @@ int audit_send_list(void *_dest)
 	return 0;
 }
 
-struct sk_buff *audit_make_reply(int pid, int seq, int type, int done,
+struct sk_buff *audit_make_reply(int portid, int seq, int type, int done,
 				 int multi, const void *payload, int size)
 {
 	struct sk_buff	*skb;
@@ -500,7 +500,7 @@ struct sk_buff *audit_make_reply(int pid, int seq, int type, int done,
 	if (!skb)
 		return NULL;
 
-	nlh	= nlmsg_put(skb, pid, seq, t, size, flags);
+	nlh	= nlmsg_put(skb, portid, seq, t, size, flags);
 	if (!nlh)
 		goto out_kfree_skb;
 	data = nlmsg_data(nlh);
@@ -521,13 +521,13 @@ static int audit_send_reply_thread(void *arg)
 
 	/* Ignore failure. It'll only happen if the sender goes away,
 	   because our timeout is set to infinite. */
-	netlink_unicast(audit_sock, reply->skb, reply->pid, 0);
+	netlink_unicast(audit_sock, reply->skb, reply->portid, 0);
 	kfree(reply);
 	return 0;
 }
 /**
  * audit_send_reply - send an audit reply message via netlink
- * @pid: process id to send reply to
+ * @portid: the portid of netlink socket
  * @seq: sequence number
  * @type: audit message type
  * @done: done (last) flag
@@ -538,7 +538,7 @@ static int audit_send_reply_thread(void *arg)
  * Allocates an skb, builds the netlink message, and sends it to the pid.
  * No failure notifications.
  */
-static void audit_send_reply(int pid, int seq, int type, int done, int multi,
+static void audit_send_reply(int portid, int seq, int type, int done, int multi,
 			     const void *payload, int size)
 {
 	struct sk_buff *skb;
@@ -549,11 +549,11 @@ static void audit_send_reply(int pid, int seq, int type, int done, int multi,
 	if (!reply)
 		return;
 
-	skb = audit_make_reply(pid, seq, type, done, multi, payload, size);
+	skb = audit_make_reply(portid, seq, type, done, multi, payload, size);
 	if (!skb)
 		goto out;
 
-	reply->pid = pid;
+	reply->portid = portid;
 	reply->skb = skb;
 
 	tsk = kthread_run(audit_send_reply_thread, reply, "audit_send_reply");
-- 
1.8.3.1


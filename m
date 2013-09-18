Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3IRTH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:07:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab3IRTHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:07:55 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Duval <dan.duval@oracle.com>,
        Chuck Anderson <chuck.anderson@oracle.com>,
        Guy Streeter <streeter@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 8/8] audit: add audit_backlog_wait_time configuration option
Date: Wed, 18 Sep 2013 15:06:53 -0400
Message-Id: <863f1daf3a84b52ae5054f5d232b205ae5caab83.1379530867.git.rgb@redhat.com>
In-Reply-To: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
References: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
In-Reply-To: <cover.1379530867.git.rgb@redhat.com>
References: <cover.1379530867.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reaahead-collector abuses the audit logging facility to discover which files
are accessed at boot time to make a pre-load list

Add a tuning option to audit_backlog_wait_time so that if auditd can't keep up,
or gets blocked, the callers won't be blocked.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/uapi/linux/audit.h |    2 ++
 kernel/audit.c             |   22 +++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 75cef3f..493a66e 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -316,6 +316,7 @@ enum {
 #define AUDIT_STATUS_PID		0x0004
 #define AUDIT_STATUS_RATE_LIMIT		0x0008
 #define AUDIT_STATUS_BACKLOG_LIMIT	0x0010
+#define AUDIT_STATUS_BACKLOG_WAIT_TIME	0x0020
 				/* Failure-to-log actions */
 #define AUDIT_FAIL_SILENT	0
 #define AUDIT_FAIL_PRINTK	1
@@ -367,6 +368,7 @@ struct audit_status {
 	__u32		backlog_limit;	/* waiting messages limit */
 	__u32		lost;		/* messages lost */
 	__u32		backlog;	/* messages waiting in queue */
+	__u32		backlog_wait_time;/* message queue wait timeout */
 };
 
 struct audit_tty_status {
diff --git a/kernel/audit.c b/kernel/audit.c
index 3d17670..fc535b6 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -321,6 +321,12 @@ static int audit_set_backlog_limit(int limit)
 	return audit_do_config_change("audit_backlog_limit", &audit_backlog_limit, limit);
 }
 
+static int audit_set_backlog_wait_time(int timeout)
+{
+	return audit_do_config_change("audit_backlog_wait_time",
+				      &audit_backlog_wait_time, timeout);
+}
+
 static int audit_set_enabled(int state)
 {
 	int rc;
@@ -669,6 +675,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		s.backlog_limit = audit_backlog_limit;
 		s.lost		 = atomic_read(&audit_lost);
 		s.backlog	 = skb_queue_len(&audit_skb_queue);
+		s.backlog_wait_time = audit_backlog_wait_time;
 		audit_send_reply(NETLINK_CB(skb).portid, seq, AUDIT_GET, 0, 0,
 				 &s, sizeof(s));
 		break;
@@ -701,8 +708,21 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			if (err < 0)
 				return err;
 		}
-		if (s.mask & AUDIT_STATUS_BACKLOG_LIMIT)
+		if (s.mask & AUDIT_STATUS_BACKLOG_LIMIT) {
 			err = audit_set_backlog_limit(s.backlog_limit);
+			if (err < 0)
+				return err;
+		}
+		if (s.mask & AUDIT_STATUS_BACKLOG_WAIT_TIME) {
+			if (sizeof(s) > (size_t)nlh->nlmsg_len)
+				break;
+			if (s.backlog_wait_time < 0 ||
+			    s.backlog_wait_time > 10*AUDIT_BACKLOG_WAIT_TIME)
+				return -EINVAL;
+			err = audit_set_backlog_wait_time(s.backlog_wait_time);
+			if (err < 0)
+				return err;
+		}
 		break;
 	}
 	case AUDIT_USER:
-- 
1.7.1


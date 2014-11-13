Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933979AbaKMU3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:29:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296AbaKMU3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:29:51 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, sgrubb@redhat.com,
        eparis@parisplace.org, pmoore@redhat.com
Subject: [PATCH] audit: convert status version to a feature bitmap
Date: Thu, 13 Nov 2014 15:29:10 -0500
Message-Id: <a98e3f45dbffd086c872f249b650b405f5cb8d2c.1415909269.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The version field defined in the audit status structure was found to have
limitations in terms of its expressibility of features supported.  This is
distict from the get/set features call to be able to command those features
that are present.

Converting this field from a version number to a feature bitmap will allow
distributions to selectively backport and support certain features and will
allow upstream to be able to deprecate features in the future.  It will allow
userspace clients to first query the kernel for which features are actually
present and supported.  Currently, EINVAL is returned rather than EOPNOTSUP,
which isn't helpful in determining if there was an error in the command, or if
it simply isn't supported yet.  Past features are not represented by this
bitmap, but their use may be converted to EOPNOTSUP if needed in the future.

Since "version" is too generic to convert with a #define, use a union in the
struct status, introducing the member "feature_bitmap" unionized with
"version".

Convert existing AUDIT_VERSION_* macros over to AUDIT_FEATURE_BITMAP*
counterparts, leaving the former for backwards compatibility.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/uapi/linux/audit.h |   17 +++++++++++++----
 kernel/audit.c             |    2 +-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 4d100c8..74aa584 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -322,9 +322,15 @@ enum {
 #define AUDIT_STATUS_BACKLOG_LIMIT	0x0010
 #define AUDIT_STATUS_BACKLOG_WAIT_TIME	0x0020
 
-#define AUDIT_VERSION_BACKLOG_LIMIT	1
-#define AUDIT_VERSION_BACKLOG_WAIT_TIME	2
-#define AUDIT_VERSION_LATEST AUDIT_VERSION_BACKLOG_WAIT_TIME
+#define AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT	0x00000001
+#define AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME	0x00000002
+#define AUDIT_FEATURE_BITMAP (	AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT     | \
+				AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME   )
+
+/* deprecated: AUDIT_VERSION_* */
+#define AUDIT_VERSION_LATEST 		AUDIT_FEATURE_BITMAP
+#define AUDIT_VERSION_BACKLOG_LIMIT	AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT
+#define AUDIT_VERSION_BACKLOG_WAIT_TIME	AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME
 
 				/* Failure-to-log actions */
 #define AUDIT_FAIL_SILENT	0
@@ -403,7 +409,10 @@ struct audit_status {
 	__u32		backlog_limit;	/* waiting messages limit */
 	__u32		lost;		/* messages lost */
 	__u32		backlog;	/* messages waiting in queue */
-	__u32		version;	/* audit api version number */
+	union {
+		__u32	version;	/* deprecated: audit api version num */
+		__u32	feature_bitmap;	/* bitmap of kernel audit features */
+	};
 	__u32		backlog_wait_time;/* message queue wait timeout */
 };
 
diff --git a/kernel/audit.c b/kernel/audit.c
index 8ee4508..c9d0e30 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -842,7 +842,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		s.backlog_limit		= audit_backlog_limit;
 		s.lost			= atomic_read(&audit_lost);
 		s.backlog		= skb_queue_len(&audit_skb_queue);
-		s.version		= AUDIT_VERSION_LATEST;
+		s.feature_bitmap	= AUDIT_FEATURE_BITMAP;
 		s.backlog_wait_time	= audit_backlog_wait_time;
 		audit_send_reply(skb, seq, AUDIT_GET, 0, 0, &s, sizeof(s));
 		break;
-- 
1.7.1


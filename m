Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088Ab3EGCY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:24:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:15985 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933279Ab3EGCTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:32 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201783"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 37/48] Audit: translate audit_log_start to audit_log_start_ns
Date: Tue, 7 May 2013 10:20:58 +0800
Message-Id: <1367893269-9308-38-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:31,
	Serialize complete at 2013/05/07 10:18:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch translates the call of interface audit_log_start to
the namespace aware interface audit_log_start_ns.

After we finish translation, we can rename audit_log_start_ns
to audit_log_start.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/audit.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index f723fe2..926d59b 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1489,9 +1489,10 @@ void audit_log_key(struct audit_buffer *ab, char *key)
 void audit_log_link_denied(const char *operation, struct path *link)
 {
 	struct audit_buffer *ab;
+	struct user_namespace *ns = current_user_ns();
 
-	ab = audit_log_start(current->audit_context, GFP_KERNEL,
-			     AUDIT_ANOM_LINK);
+	ab = audit_log_start_ns(ns, current->audit_context, GFP_KERNEL,
+				AUDIT_ANOM_LINK);
 	if (!ab)
 		return;
 	audit_log_format(ab, "op=%s action=denied", operation);
@@ -1501,7 +1502,7 @@ void audit_log_link_denied(const char *operation, struct path *link)
 	audit_log_format(ab, " dev=");
 	audit_log_untrustedstring(ab, link->dentry->d_inode->i_sb->s_id);
 	audit_log_format(ab, " ino=%lu", link->dentry->d_inode->i_ino);
-	audit_log_end(ab);
+	audit_log_end_ns(ns, ab);
 }
 
 void audit_log_end_ns(struct user_namespace *ns, struct audit_buffer *ab)
@@ -1558,12 +1559,12 @@ void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
 	struct audit_buffer *ab;
 	va_list args;
 
-	ab = audit_log_start(ctx, gfp_mask, type);
+	ab = audit_log_start_ns(&init_user_ns, ctx, gfp_mask, type);
 	if (ab) {
 		va_start(args, fmt);
 		audit_log_vformat(ab, fmt, args);
 		va_end(args);
-		audit_log_end(ab);
+		audit_log_end_ns(&init_user_ns, ab);
 	}
 }
 
-- 
1.8.1.4


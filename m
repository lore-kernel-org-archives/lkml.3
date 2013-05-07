Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab3EGCTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:19:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2879 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933305Ab3EGCTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:34 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201787"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 41/48] Audit: lsm: translate audit_log_start to audit_log_start_ns
Date: Tue, 7 May 2013 10:21:02 +0800
Message-Id: <1367893269-9308-42-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:31,
	Serialize complete at 2013/05/07 10:18:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we can log audit message in the user namespace which current
task belongs to.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 security/lsm_audit.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 8d8d97d..90fcd08 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -392,11 +392,15 @@ void common_lsm_audit(struct common_audit_data *a,
 	void (*post_audit)(struct audit_buffer *, void *))
 {
 	struct audit_buffer *ab;
+	struct user_namespace *ns;
 
 	if (a == NULL)
 		return;
+
+	ns = current_user_ns();
 	/* we use GFP_ATOMIC so we won't sleep */
-	ab = audit_log_start(current->audit_context, GFP_ATOMIC, AUDIT_AVC);
+	ab = audit_log_start_ns(ns, current->audit_context,
+				GFP_ATOMIC, AUDIT_AVC);
 
 	if (ab == NULL)
 		return;
@@ -409,5 +413,5 @@ void common_lsm_audit(struct common_audit_data *a,
 	if (post_audit)
 		post_audit(ab, a);
 
-	audit_log_end(ab);
+	audit_log_end_ns(ns, ab);
 }
-- 
1.8.1.4


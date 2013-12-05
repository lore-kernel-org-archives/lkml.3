Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab3LECqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:46:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451Ab3LECqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:46:46 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH 2/3] smack: call WARN_ONCE() instead of calling audit_log_start()
Date: Wed,  4 Dec 2013 21:45:55 -0500
Message-Id: <f18b900087454601b1431183f705f61acd4932c7.1386206544.git.rgb@redhat.com>
In-Reply-To: <1382713941.2954.19.camel@flatline.rdu.redhat.com>
References: <1382713941.2954.19.camel@flatline.rdu.redhat.com>
In-Reply-To: <cover.1386206544.git.rgb@redhat.com>
References: <cover.1386206544.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the call to audit_log() (which call audit_log_start()) and deal with
the errors in the caller, logging only once if the condition is met.  Calling
audit_log_start() in this location makes buffer allocation and locking more
complicated in the calling tree (audit_filter_user()).

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 security/smack/smack_lsm.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 8825375..185e2e7 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3615,9 +3615,8 @@ static int smack_audit_rule_match(u32 secid, u32 field, u32 op, void *vrule,
 	struct smack_known *skp;
 	char *rule = vrule;
 
-	if (!rule) {
-		audit_log(actx, GFP_ATOMIC, AUDIT_SELINUX_ERR,
-			  "Smack: missing rule\n");
+	if (unlikely(!rule)) {
+		WARN_ONCE(1, "Smack: missing rule\n");
 		return -ENOENT;
 	}
 
-- 
1.7.1


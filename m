Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab3LECqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:46:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756250Ab3LECqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:46:44 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH 1/3] selinux: call WARN_ONCE() instead of calling audit_log_start()
Date: Wed,  4 Dec 2013 21:45:54 -0500
Message-Id: <ef6553c5bb2a7497e43dd4d17bfd43590f0e3dc0.1386206544.git.rgb@redhat.com>
In-Reply-To: <1382713941.2954.19.camel@flatline.rdu.redhat.com>
References: <1382713941.2954.19.camel@flatline.rdu.redhat.com>
In-Reply-To: <cover.1386206544.git.rgb@redhat.com>
References: <cover.1386206544.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two of the conditions in selinux_audit_rule_match() should never happen and
the third indicates a race that should be retried.  Remove the calls to
audit_log() (which call audit_log_start()) and deal with the errors in the
caller, logging only once if the condition is met.  Calling audit_log_start()
in this location makes buffer allocation and locking more complicated in the
calling tree (audit_filter_user()).

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 security/selinux/ss/services.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index b4feecc..f4dda05 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2938,25 +2938,21 @@ int selinux_audit_rule_match(u32 sid, u32 field, u32 op, void *vrule,
 	struct selinux_audit_rule *rule = vrule;
 	int match = 0;
 
-	if (!rule) {
-		audit_log(actx, GFP_ATOMIC, AUDIT_SELINUX_ERR,
-			  "selinux_audit_rule_match: missing rule\n");
+	if (unlikely(!rule)) {
+		WARN_ONCE(1, "selinux_audit_rule_match: missing rule\n");
 		return -ENOENT;
 	}
 
 	read_lock(&policy_rwlock);
 
 	if (rule->au_seqno < latest_granting) {
-		audit_log(actx, GFP_ATOMIC, AUDIT_SELINUX_ERR,
-			  "selinux_audit_rule_match: stale rule\n");
 		match = -ESTALE;
 		goto out;
 	}
 
 	ctxt = sidtab_search(&sidtab, sid);
-	if (!ctxt) {
-		audit_log(actx, GFP_ATOMIC, AUDIT_SELINUX_ERR,
-			  "selinux_audit_rule_match: unrecognized SID %d\n",
+	if (unlikely(!ctxt)) {
+		WARN_ONCE(1, "selinux_audit_rule_match: unrecognized SID %d\n",
 			  sid);
 		match = -ENOENT;
 		goto out;
-- 
1.7.1


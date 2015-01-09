Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbbAIKdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:33:02 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44623 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757520AbbAIKca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:30 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Paris <eparis@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 48/78] audit: change decimal constant to macro for invalid uid
Date: Fri,  9 Jan 2015 11:31:57 +0100
Message-Id: <a49482467c6a9a2dbf13a3a002379bc07d983b23.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 42f74461a5b60cf6b42887e6d2ff5b7be4abf1ca upstream.

SFR reported this 2013-05-15:

> After merging the final tree, today's linux-next build (i386 defconfig)
> produced this warning:
>
> kernel/auditfilter.c: In function 'audit_data_to_entry':
> kernel/auditfilter.c:426:3: warning: this decimal constant is unsigned only
> in ISO C90 [enabled by default]
>
> Introduced by commit 780a7654cee8 ("audit: Make testing for a valid
> loginuid explicit") from Linus' tree.

Replace this decimal constant in the code with a macro to make it more readable
(add to the unsigned cast to quiet the warning).

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/uapi/linux/audit.h | 2 ++
 kernel/auditfilter.c       | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 75cef3fd97ad..b7cb978ed579 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -374,6 +374,8 @@ struct audit_tty_status {
 	__u32		log_passwd;	/* 1 = enabled, 0 = disabled */
 };
 
+#define AUDIT_UID_UNSET (unsigned int)-1
+
 /* audit_rule_data supports filter rules with both integer and string
  * fields.  It corresponds with AUDIT_ADD_RULE, AUDIT_DEL_RULE and
  * AUDIT_LIST_RULES requests.
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index f7aee8be7fb2..8a344cebd8bf 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -423,7 +423,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 		f->lsm_rule = NULL;
 
 		/* Support legacy tests for a valid loginuid */
-		if ((f->type == AUDIT_LOGINUID) && (f->val == ~0U)) {
+		if ((f->type == AUDIT_LOGINUID) && (f->val == AUDIT_UID_UNSET)) {
 			f->type = AUDIT_LOGINUID_SET;
 			f->val = 0;
 		}
-- 
2.2.1


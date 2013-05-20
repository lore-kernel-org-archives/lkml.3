Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab3ETTJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:09:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294Ab3ETTJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:09:42 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Cc: sfr@canb.auug.org.au, ebiederm@xmission.com, eparis@redhat.com,
        viresh.kumar@linaro.org, linux-audit@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>, stable@vger.kernel.org.#.v3.9
Subject: [PATCH] audit: cast decimal constant for invalid uid to unsigned
Date: Mon, 20 May 2013 15:08:18 -0400
Message-Id: <1369076898-17265-1-git-send-email-rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
and add an unsigned cast to quiet the warning.

Cc: stable@vger.kernel.org # v3.9
Cc: Eric Paris <eparis@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/uapi/linux/audit.h |    2 ++
 kernel/auditfilter.c       |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 75cef3f..b7cb978 100644
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
index bc6595f..0d40b51 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -423,7 +423,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 		f->lsm_rule = NULL;
 
 		/* Support legacy tests for a valid loginuid */
-		if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295)) {
+		if ((f->type == AUDIT_LOGINUID) && (f->val == AUDIT_UID_UNSET)) {
 			f->type = AUDIT_LOGINUID_SET;
 			f->val = 0;
 		}
-- 
1.7.1


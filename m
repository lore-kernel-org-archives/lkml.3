Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3EQViM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:38:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374Ab3EQViJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:38:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Grubb <sgrubb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>
Subject: [ 101/102] audit: Make testing for a valid loginuid explicit.
Date: Fri, 17 May 2013 14:36:56 -0700
Message-Id: <20130517213254.887451162@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 780a7654cee8d61819512385e778e4827db4bfbc upstream.

audit rule additions containing "-F auid!=4294967295" were failing
with EINVAL because of a regression caused by e1760bd.

Apparently some userland audit rule sets want to know if loginuid uid
has been set and are using a test for auid != 4294967295 to determine
that.

In practice that is a horrible way to ask if a value has been set,
because it relies on subtle implementation details and will break
every time the uid implementation in the kernel changes.

So add a clean way to test if the audit loginuid has been set, and
silently convert the old idiom to the cleaner and more comprehensible
new idiom.

RGB notes: In upstream, audit_rule_to_entry has been refactored out.
This is patch is already upstream in functionally the same form in
commit 780a7654cee8d61819512385e778e4827db4bfbc .  The decimal constant
was cast to unsigned to quiet GCC 4.6 32-bit architecture warnings.

Reported-By: Steve Grubb <sgrubb@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Tested-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Backported-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/audit.h      |    5 +++++
 include/uapi/linux/audit.h |    1 +
 kernel/auditfilter.c       |   31 ++++++++++++++++++++++++++++++-
 kernel/auditsc.c           |    5 ++++-
 4 files changed, 40 insertions(+), 2 deletions(-)

--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -390,6 +390,11 @@ static inline void audit_ptrace(struct t
 #define audit_signals 0
 #endif /* CONFIG_AUDITSYSCALL */
 
+static inline bool audit_loginuid_set(struct task_struct *tsk)
+{
+	return uid_valid(audit_get_loginuid(tsk));
+}
+
 #ifdef CONFIG_AUDIT
 /* These are defined in audit.c */
 				/* Public API */
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -246,6 +246,7 @@
 #define AUDIT_OBJ_TYPE	21
 #define AUDIT_OBJ_LEV_LOW	22
 #define AUDIT_OBJ_LEV_HIGH	23
+#define AUDIT_LOGINUID_SET	24
 
 				/* These are ONLY useful when checking
 				 * at syscall exit time (AUDIT_AT_EXIT). */
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -345,6 +345,12 @@ static struct audit_entry *audit_rule_to
 		f->uid = INVALID_UID;
 		f->gid = INVALID_GID;
 
+		/* Support legacy tests for a valid loginuid */
+		if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295U)) {
+			f->type = AUDIT_LOGINUID_SET;
+			f->val = 0;
+		}
+
 		err = -EINVAL;
 		if (f->op == Audit_bad)
 			goto exit_free;
@@ -352,6 +358,12 @@ static struct audit_entry *audit_rule_to
 		switch(f->type) {
 		default:
 			goto exit_free;
+		case AUDIT_LOGINUID_SET:
+			if ((f->val != 0) && (f->val != 1))
+				goto exit_free;
+			if (f->op != Audit_not_equal && f->op != Audit_equal)
+				goto exit_free;
+			break;
 		case AUDIT_UID:
 		case AUDIT_EUID:
 		case AUDIT_SUID:
@@ -459,7 +471,20 @@ static struct audit_entry *audit_data_to
 		f->gid = INVALID_GID;
 		f->lsm_str = NULL;
 		f->lsm_rule = NULL;
-		switch(f->type) {
+
+		/* Support legacy tests for a valid loginuid */
+		if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295U)) {
+			f->type = AUDIT_LOGINUID_SET;
+			f->val = 0;
+		}
+
+		switch (f->type) {
+		case AUDIT_LOGINUID_SET:
+			if ((f->val != 0) && (f->val != 1))
+				goto exit_free;
+			if (f->op != Audit_not_equal && f->op != Audit_equal)
+				goto exit_free;
+			break;
 		case AUDIT_UID:
 		case AUDIT_EUID:
 		case AUDIT_SUID:
@@ -1378,6 +1403,10 @@ static int audit_filter_user_rules(struc
 			result = audit_uid_comparator(audit_get_loginuid(current),
 						  f->op, f->uid);
 			break;
+		case AUDIT_LOGINUID_SET:
+			result = audit_comparator(audit_loginuid_set(current),
+						  f->op, f->val);
+			break;
 		case AUDIT_SUBJ_USER:
 		case AUDIT_SUBJ_ROLE:
 		case AUDIT_SUBJ_TYPE:
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -742,6 +742,9 @@ static int audit_filter_rules(struct tas
 			if (ctx)
 				result = audit_uid_comparator(tsk->loginuid, f->op, f->uid);
 			break;
+		case AUDIT_LOGINUID_SET:
+			result = audit_comparator(audit_loginuid_set(tsk), f->op, f->val);
+			break;
 		case AUDIT_SUBJ_USER:
 		case AUDIT_SUBJ_ROLE:
 		case AUDIT_SUBJ_TYPE:
@@ -2309,7 +2312,7 @@ int audit_set_loginuid(kuid_t loginuid)
 	unsigned int sessionid;
 
 #ifdef CONFIG_AUDIT_LOGINUID_IMMUTABLE
-	if (uid_valid(task->loginuid))
+	if (audit_loginuid_set(task))
 		return -EPERM;
 #else /* CONFIG_AUDIT_LOGINUID_IMMUTABLE */
 	if (!capable(CAP_AUDIT_CONTROL))



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937186Ab3DIJj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:39:58 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54061 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934556Ab3DIJjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:39:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Guy Briggs <rgb@redhat.com>, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <1363807097-13073-1-git-send-email-rgb@redhat.com>
	<20130408164622.284f48c65341396aa8dbd220@linux-foundation.org>
Date: Tue, 09 Apr 2013 02:39:32 -0700
In-Reply-To: <20130408164622.284f48c65341396aa8dbd220@linux-foundation.org>
	(Andrew Morton's message of "Mon, 8 Apr 2013 16:46:22 -0700")
Message-ID: <87ip3w59gr.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/ydixqQLQ1Uja+gnrt1udeDo1b1sXNGZ4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] [BZ905179] audit: omit check for uid and gid validity in audit rules and data
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 20 Mar 2013 15:18:17 -0400 Richard Guy Briggs <rgb@redhat.com> wrote:
>
>> audit rule additions containing "-F auid!=4294967295" were failing with EINVAL.
>> 
>> UID_INVALID (and GID_INVALID) is actually a valid uid (gid) for setting and
>> testing against audit rules.  Remove the check for invalid uid and gid when
>> parsing rules and data for logging.

In general testing against invalid uid appears completely bogus, and
should always return true.  As it is and essentially always has been
incorrect to explicitly set any kernel uid to that value.

The only case where this appears to make the least little bit of sense
is if the goal of the test is to test to see if an audit logloginuid
has been set at all.  In which case depending on a test against
4294967295 is bogus because you are depending on an intimate internal
kernel implementation detail.

Certainly removing the gid_valid tests is completely gratitious in this
case.

>> Revert part of ca57ec0f00c3f139c41bf6b0a5b9bcc95bbb2ad7 (2012-09-11) to fix
>> this.
>
> Eric, can you please take a look?
>
>> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
>> ---
>>  kernel/auditfilter.c |   12 ------------
>>  1 files changed, 0 insertions(+), 12 deletions(-)
>> 
>> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
>> index f9fc54b..457ee39 100644
>> --- a/kernel/auditfilter.c
>> +++ b/kernel/auditfilter.c
>> @@ -360,10 +360,7 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
>>  			/* bit ops not implemented for uid comparisons */
>>  			if (f->op == Audit_bitmask || f->op == Audit_bittest)
>>  				goto exit_free;
>> -
>>  			f->uid = make_kuid(current_user_ns(), f->val);
>> -			if (!uid_valid(f->uid))
>> -				goto exit_free;
>
> It concerns me that map_id_down() can return -1 on error and that this
> change causes the kernel to no longer notice that error?

Me too.  Where we only communicate with audit in the initial user
namespace right now it isn't absolutely broken but it certainly isn't a
habit I want to get into.

How about something like my untested patch below that add an explicit
operation to test if loginuid has been set?

Eric

From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 9 Apr 2013 02:22:10 -0700
Subject: [PATCH] audit: Make testing for a valid loginuid explicit.

audit rule additions containing "-F auid!=4294967295" were failing
with EINVAL.

Apparently some userland audit rule sets want to know if loginuid uid
has been set and are using a test for auid != 4294967295 to determine
that.

In practice that is a horrible way to ask if a value has been set,
because it relies on subtle implementation details and will break
every time the uid implementation in the kernel changes.

So add a clean way to test if the audit loginuid has been set, and
silently convert the old idiom to the cleaner and more comprehensible
new idiom.

Reported-By: Richard Guy Briggs <rgb@redhat.com> wrote:
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/audit.h      |    5 +++++
 include/uapi/linux/audit.h |    1 +
 kernel/auditfilter.c       |   29 +++++++++++++++++++++++++++++
 kernel/auditsc.c           |    5 ++++-
 4 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index a9fefe2..8a1ddde 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -390,6 +390,11 @@ static inline void audit_ptrace(struct task_struct *t)
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
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 9f096f1..9554a19 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -246,6 +246,7 @@
 #define AUDIT_OBJ_TYPE	21
 #define AUDIT_OBJ_LEV_LOW	22
 #define AUDIT_OBJ_LEV_HIGH	23
+#define AUDIT_LOGINUID_SET	24
 
 				/* These are ONLY useful when checking
 				 * at syscall exit time (AUDIT_AT_EXIT). */
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 540f986..6381d17 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -349,6 +349,12 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
 		if (f->op == Audit_bad)
 			goto exit_free;
 
+		/* Support legacy tests for a valid loginuid */
+		if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295)) {
+			f->type = AUDIT_LOGINUID_SET;
+			f->val = 0;
+		}
+
 		switch(f->type) {
 		default:
 			goto exit_free;
@@ -377,6 +383,12 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
 			if (!gid_valid(f->gid))
 				goto exit_free;
 			break;
+		case AUDIT_LOGINUID_SET:
+			if ((f->op != Audit_not_equal) && (f->op != Audit_equal))
+				goto exit_free;
+			if ((f->val != 0) && (f->val != 1))
+				goto exit_free;
+			break;
 		case AUDIT_PID:
 		case AUDIT_PERS:
 		case AUDIT_MSGTYPE:
@@ -459,6 +471,13 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 		f->gid = INVALID_GID;
 		f->lsm_str = NULL;
 		f->lsm_rule = NULL;
+
+		/* Support legacy tests for a valid loginuid */
+		if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295)) {
+			f->type = AUDIT_LOGINUID_SET;
+			f->val = 0;
+		}
+
 		switch(f->type) {
 		case AUDIT_UID:
 		case AUDIT_EUID:
@@ -487,6 +506,12 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 			if (!gid_valid(f->gid))
 				goto exit_free;
 			break;
+		case AUDIT_LOGINUID_SET:
+			if ((f->op != Audit_not_equal) && (f->op != Audit_equal))
+				goto exit_free;
+			if ((f->val != 0) && (f->val != 1))
+				goto exit_free;
+			break;
 		case AUDIT_PID:
 		case AUDIT_PERS:
 		case AUDIT_MSGTYPE:
@@ -1380,6 +1405,10 @@ static int audit_filter_user_rules(struct audit_krule *rule,
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
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 3a11d34..27d0a50 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -750,6 +750,9 @@ static int audit_filter_rules(struct task_struct *tsk,
 			if (ctx)
 				result = audit_uid_comparator(tsk->loginuid, f->op, f->uid);
 			break;
+		case AUDIT_LOGINUID_SET:
+			result = audit_comparator(audit_loginuid_set(tsk), f->op, f->val);
+			break;
 		case AUDIT_SUBJ_USER:
 		case AUDIT_SUBJ_ROLE:
 		case AUDIT_SUBJ_TYPE:
@@ -2317,7 +2320,7 @@ int audit_set_loginuid(kuid_t loginuid)
 	unsigned int sessionid;
 
 #ifdef CONFIG_AUDIT_LOGINUID_IMMUTABLE
-	if (uid_valid(task->loginuid))
+	if (audit_loginuid_set(task))
 		return -EPERM;
 #else /* CONFIG_AUDIT_LOGINUID_IMMUTABLE */
 	if (!capable(CAP_AUDIT_CONTROL))
-- 
1.7.5.4


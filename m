Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbaK1FX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 00:23:28 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54085 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaK1FXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 00:23:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Richard Weinberger <richard@nod.at>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
	<0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
	<546A3942.5040906@schaufler-ca.com>
	<CALCETrWy-3C1on3+2wE9aqcChBUCUY0i_4AL_Om8CSZ5QB18sQ@mail.gmail.com>
	<CALCETrVn4gVXp7F=5h-bkN5VWuRMG9BoxgeQfKhX4+ZXxGE=wQ@mail.gmail.com>
	<546A43CE.2030706@schaufler-ca.com>
	<87lhmwwpey.fsf_-_@x220.int.ebiederm.org>
	<CALCETrUuWDq2akKfb50AiPHeDDWzPW7ijz1QwnuNiskyZbBEfA@mail.gmail.com>
	<87wq6frjcw.fsf@x220.int.ebiederm.org>
Date: Thu, 27 Nov 2014 23:22:06 -0600
In-Reply-To: <87wq6frjcw.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 27 Nov 2014 23:21:03 -0600")
Message-ID: <87r3wnrjb5.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19XjhWyNL7GyhpQuQ+nP0vKjGliL3ozyvQ=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 573 ms - load_scoreonly_sql: 0.12 (0.0%),
	signal_user_changed: 6 (1.0%), b_tie_ro: 4.0 (0.7%), parse: 2.1 (0.4%),
	extract_message_metadata: 23 (4.0%), get_uri_detail_list: 4.1 (0.7%),
	tests_pri_-1000: 9 (1.6%), tests_pri_-950: 1.84 (0.3%), tests_pri_-900: 1.39
	(0.2%), tests_pri_-400: 35 (6.1%), check_bayes: 34 (5.9%), b_tokenize: 14
	(2.5%), b_tok_get_all: 10 (1.8%), b_comp_prob: 3.4 (0.6%), b_tok_touch_all:
	3.1 (0.5%), b_finish: 0.90 (0.2%), tests_pri_0: 480 (83.8%), tests_pri_500: 7
	(1.3%), rewrite_mail: 0.00 (0.0%)
Subject: [CFT][PATCH v2] userns: Avoid problems with negative groups
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Classic unix permission checks have an interesting feature.  The group
permissions for a file can be set to less than the other permissions
on a file.  Occassionally this is used deliberately to give a certain
group of users fewer permissions than the default.

Overlooking negative groups has resulted in the permission checks for
setting up a group mapping in a user namespace to be too lax.  Tighten
the permission checks in new_idmap_permitted to ensure that mapping
uids and gids into user namespaces without privilege will not result
in new combinations of credentials being available to the users.

When setting mappings without privilege only the creator of the user
namespace is interesting as all other users that have CAP_SETUID over
the user namespace will also have CAP_SETUID over the user namespaces
parent.  So the scope of the unprivileged check is reduced to just
the case where cred->euid is the namespace creator.

For setting a uid mapping without privilege only euid is considered as
setresuid can set uid, suid and fsuid from euid without privielege
making any combination of uids possible with user namespaces already
possible without them.

For setting a gid mapping without privilege only egid on a credential
without supplementary groups is condsidered, as setresgid can set gid,
sgid and fsgid from egid without privilege.  The requirement for no
supplementary groups is because CAP_SETUID in a user namespace allows
supplementary groups to be cleared, which unfortunately means allowing
a credential with supplementary groups would allow new combinations
of credentials to exist, and thus would allow defeating negative
groups without permission.

setgroups is modified to fail not only when the group ids do not
map but also when there are no gid mappings at all, preventing
setgroups(0, NULL) from succeeding when gid mappings have not been
established.

This change should break userspace by the minimal amount needed
to fix this issue.

This should fix CVE-2014-8989.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/user_namespace.h | 10 ++++++++++
 kernel/groups.c                |  7 ++++++-
 kernel/uid16.c                 |  5 ++++-
 kernel/user_namespace.c        | 16 ++++++++++++----
 4 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index e95372654f09..26d5e8f5db97 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -46,6 +46,11 @@ static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 	return ns;
 }
 
+static inline bool gid_mapping_possible(const struct user_namespace *ns)
+{
+	return ns->gid_map.nr_extents != 0;
+}
+
 extern int create_user_ns(struct cred *new);
 extern int unshare_userns(unsigned long unshare_flags, struct cred **new_cred);
 extern void free_user_ns(struct user_namespace *ns);
@@ -70,6 +75,11 @@ static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 	return &init_user_ns;
 }
 
+static inline bool gid_mapping_possible(const struct user_namespace *ns)
+{
+	return true;
+}
+
 static inline int create_user_ns(struct cred *new)
 {
 	return -EINVAL;
diff --git a/kernel/groups.c b/kernel/groups.c
index 451698f86cfa..302aa415158f 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -6,6 +6,7 @@
 #include <linux/slab.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/user_namespace.h>
 #include <asm/uaccess.h>
 
 /* init to 2 - one for init_task, one to ensure it is never freed */
@@ -220,14 +221,18 @@ out:
 
 SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
 {
+	struct user_namespace *user_ns = current_user_ns();
 	struct group_info *group_info;
 	int retval;
 
-	if (!ns_capable(current_user_ns(), CAP_SETGID))
+	if (!gid_mapping_possible(user_ns) ||
+	    !ns_capable(user_ns, CAP_SETGID))
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
 
+	/* How do I alloc a negative gidsetsize??? */
+
 	group_info = groups_alloc(gidsetsize);
 	if (!group_info)
 		return -ENOMEM;
diff --git a/kernel/uid16.c b/kernel/uid16.c
index 602e5bbbceff..602c7de2aa11 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -13,6 +13,7 @@
 #include <linux/highuid.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/user_namespace.h>
 
 #include <asm/uaccess.h>
 
@@ -173,10 +174,12 @@ out:
 
 SYSCALL_DEFINE2(setgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
 {
+	struct user_namespace *user_ns = current_user_ns();
 	struct group_info *group_info;
 	int retval;
 
-	if (!ns_capable(current_user_ns(), CAP_SETGID))
+	if (!gid_mapping_possible(user_ns) ||
+	    !ns_capable(user_ns, CAP_SETGID))
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index aa312b0dc3ec..b338c42d04fd 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -812,16 +812,24 @@ static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
 				struct uid_gid_map *new_map)
 {
-	/* Allow mapping to your own filesystem ids */
-	if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1)) {
+	const struct cred *cred = file->f_cred;
+
+	/* Allow mapping an id without CAP_SETUID and CAP_SETGID when
+	 * allowing the root of the user namespace CAP_SETUID or
+	 * CAP_SETGID restricted to just that id will not change the
+	 * set of credentials available that user.
+	 */
+	if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1) &&
+	    uid_eq(ns->owner, cred->euid)) {
 		u32 id = new_map->extent[0].lower_first;
 		if (cap_setid == CAP_SETUID) {
 			kuid_t uid = make_kuid(ns->parent, id);
-			if (uid_eq(uid, file->f_cred->fsuid))
+			if (uid_eq(uid, cred->euid))
 				return true;
 		} else if (cap_setid == CAP_SETGID) {
 			kgid_t gid = make_kgid(ns->parent, id);
-			if (gid_eq(gid, file->f_cred->fsgid))
+			if (gid_eq(gid, cred->egid) &&
+			    (cred->group_info->ngroups == 0))
 				return true;
 		}
 	}
-- 
1.9.1


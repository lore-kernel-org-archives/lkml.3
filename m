Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113AbaK0RAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:00:25 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:36905 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaK0RAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:00:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
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
Date: Thu, 27 Nov 2014 10:59:01 -0600
In-Reply-To: <546A43CE.2030706@schaufler-ca.com> (Casey Schaufler's message of
	"Mon, 17 Nov 2014 10:51:58 -0800")
Message-ID: <87lhmwwpey.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19wY4s8f5RtuPi32iX7fm9SVTugOqig+vw=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 410 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 2.8 (0.7%), b_tie_ro: 2.0 (0.5%), parse: 0.68 (0.2%),
	extract_message_metadata: 11 (2.7%), get_uri_detail_list: 1.98 (0.5%),
	tests_pri_-1000: 5 (1.3%), tests_pri_-950: 1.26 (0.3%), tests_pri_-900: 1.25
	(0.3%), tests_pri_-400: 22 (5.4%), check_bayes: 21 (5.1%), b_tokenize: 7
	(1.7%), b_tok_get_all: 8 (1.9%), b_comp_prob: 1.83 (0.4%), b_tok_touch_all:
	2.3 (0.6%), b_finish: 0.55 (0.1%), tests_pri_0: 360 (87.7%), tests_pri_500:
	3.7 (0.9%), rewrite_mail: 0.00 (0.0%)
Subject: [CFT][PATCH] userns: Avoid problems with negative groups
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
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
 
This change should break userspace by the minimal amount needed
to fix this issue.

This should fix CVE-2014-8989.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

If people can test and review this change and verify  this and verify it
doesn't break anything I can't help breaking I will appreciate it.

 kernel/user_namespace.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

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


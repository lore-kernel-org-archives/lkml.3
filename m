Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3H3Wmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 18:42:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52939 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab3H3Wma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 18:42:30 -0400
Message-ID: <52211FD2.6090809@canonical.com>
Date: Fri, 30 Aug 2013 15:42:26 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: John Johansen <john.johansen@canonical.com>
CC: Richard Guy Briggs <rgb@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 2/3] apparmor: remove tsk field from the apparmor_audit_struct
References: <cover.1377032086.git.rgb@redhat.com> <a411b87ba4c4af251166ee5877cb8c646cf7826c.1377032086.git.rgb@redhat.com> <20130827172155.GC29147@redhat.com> <20130830195646.GJ21110@madcap2.tricolour.ca> <52210275.8040601@canonical.com>
In-Reply-To: <52210275.8040601@canonical.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that aa_capabile no longer sets the task field it can be removed
and the lsm_audit version of the field can be used.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/audit.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/security/apparmor/audit.c b/security/apparmor/audit.c
index 031d2d9..e32c448 100644
--- a/security/apparmor/audit.c
+++ b/security/apparmor/audit.c
@@ -111,7 +111,7 @@ static const char *const aa_audit_type[] = {
 static void audit_pre(struct audit_buffer *ab, void *ca)
 {
 	struct common_audit_data *sa = ca;
-	struct task_struct *tsk = sa->aad->tsk ? sa->aad->tsk : current;
+	struct task_struct *tsk = sa->u.tsk ? sa->u.tsk : current;
 
 	if (aa_g_audit_header) {
 		audit_log_format(ab, "apparmor=");
@@ -149,12 +149,6 @@ static void audit_pre(struct audit_buffer *ab, void *ca)
 		audit_log_format(ab, " name=");
 		audit_log_untrustedstring(ab, sa->aad->name);
 	}
-
-	if (sa->aad->tsk) {
-		audit_log_format(ab, " pid=%d comm=", tsk->pid);
-		audit_log_untrustedstring(ab, tsk->comm);
-	}
-
 }
 
 /**
@@ -212,7 +206,7 @@ int aa_audit(int type, struct aa_profile *profile, gfp_t gfp,
 
 	if (sa->aad->type == AUDIT_APPARMOR_KILL)
 		(void)send_sig_info(SIGKILL, NULL,
-				    sa->aad->tsk ?  sa->aad->tsk : current);
+				    sa->u.tsk ?  sa->u.tsk : current);
 
 	if (sa->aad->type == AUDIT_APPARMOR_ALLOWED)
 		return complain_error(sa->aad->error);
-- 
1.8.3.2



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab3H3Wnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 18:43:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52949 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab3H3Wnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 18:43:46 -0400
Message-ID: <5221201D.9060109@canonical.com>
Date: Fri, 30 Aug 2013 15:43:41 -0700
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
Subject: Re: [PATCH 03/3] apparmor: remove parent task info from audit logging
References: <cover.1377032086.git.rgb@redhat.com> <a411b87ba4c4af251166ee5877cb8c646cf7826c.1377032086.git.rgb@redhat.com> <20130827172155.GC29147@redhat.com> <20130830195646.GJ21110@madcap2.tricolour.ca> <52210275.8040601@canonical.com>
In-Reply-To: <52210275.8040601@canonical.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reporting of the parent task info is a vestage from old versions of
apparmor. The need for this information was removed by unique null-
profiles before apparmor was upstreamed so remove this info from logging.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/audit.c         | 6 ------
 security/apparmor/include/audit.h | 1 -
 2 files changed, 7 deletions(-)

diff --git a/security/apparmor/audit.c b/security/apparmor/audit.c
index e32c448..89c7865 100644
--- a/security/apparmor/audit.c
+++ b/security/apparmor/audit.c
@@ -111,7 +111,6 @@ static const char *const aa_audit_type[] = {
 static void audit_pre(struct audit_buffer *ab, void *ca)
 {
 	struct common_audit_data *sa = ca;
-	struct task_struct *tsk = sa->u.tsk ? sa->u.tsk : current;
 
 	if (aa_g_audit_header) {
 		audit_log_format(ab, "apparmor=");
@@ -132,11 +131,6 @@ static void audit_pre(struct audit_buffer *ab, void *ca)
 
 	if (sa->aad->profile) {
 		struct aa_profile *profile = sa->aad->profile;
-		pid_t pid;
-		rcu_read_lock();
-		pid = rcu_dereference(tsk->real_parent)->pid;
-		rcu_read_unlock();
-		audit_log_format(ab, " parent=%d", pid);
 		if (profile->ns != root_ns) {
 			audit_log_format(ab, " namespace=");
 			audit_log_untrustedstring(ab, profile->ns->base.hname);
diff --git a/security/apparmor/include/audit.h b/security/apparmor/include/audit.h
index 69d8cae..cf65443 100644
--- a/security/apparmor/include/audit.h
+++ b/security/apparmor/include/audit.h
@@ -110,7 +110,6 @@ struct apparmor_audit_data {
 	void *profile;
 	const char *name;
 	const char *info;
-	struct task_struct *tsk;
 	union {
 		void *target;
 		struct {
-- 
1.8.3.2



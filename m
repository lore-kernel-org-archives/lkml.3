Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab3H3WlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 18:41:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52931 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab3H3WlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 18:41:12 -0400
Message-ID: <52211F7F.2060905@canonical.com>
Date: Fri, 30 Aug 2013 15:41:03 -0700
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
Subject: Re: [PATCH 1/3] apparmor: fix capability to not use the current task,
 during reporting
References: <cover.1377032086.git.rgb@redhat.com> <a411b87ba4c4af251166ee5877cb8c646cf7826c.1377032086.git.rgb@redhat.com> <20130827172155.GC29147@redhat.com> <20130830195646.GJ21110@madcap2.tricolour.ca> <52210275.8040601@canonical.com>
In-Reply-To: <52210275.8040601@canonical.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mediation is based off of the cred but auditing includes the current
task which may not be related to the actual request.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/capability.c         | 15 +++++----------
 security/apparmor/domain.c             |  2 +-
 security/apparmor/include/capability.h |  5 ++---
 security/apparmor/include/ipc.h        |  4 ++--
 security/apparmor/ipc.c                |  9 ++++-----
 security/apparmor/lsm.c                |  2 +-
 6 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/security/apparmor/capability.c b/security/apparmor/capability.c
index 887a5e9..98a73eb 100644
--- a/security/apparmor/capability.c
+++ b/security/apparmor/capability.c
@@ -48,8 +48,7 @@ static void audit_cb(struct audit_buffer *ab, void *va)
 
 /**
  * audit_caps - audit a capability
- * @profile: profile confining task (NOT NULL)
- * @task: task capability test was performed against (NOT NULL)
+ * @profile: profile being tested for confinement (NOT NULL)
  * @cap: capability tested
  * @error: error code returned by test
  *
@@ -58,8 +57,7 @@ static void audit_cb(struct audit_buffer *ab, void *va)
  *
  * Returns: 0 or sa->error on success,  error code on failure
  */
-static int audit_caps(struct aa_profile *profile, struct task_struct *task,
-		      int cap, int error)
+static int audit_caps(struct aa_profile *profile, int cap, int error)
 {
 	struct audit_cache *ent;
 	int type = AUDIT_APPARMOR_AUTO;
@@ -68,7 +66,6 @@ static int audit_caps(struct aa_profile *profile, struct task_struct *task,
 	sa.type = LSM_AUDIT_DATA_CAP;
 	sa.aad = &aad;
 	sa.u.cap = cap;
-	sa.aad->tsk = task;
 	sa.aad->op = OP_CAPABLE;
 	sa.aad->error = error;
 
@@ -119,8 +116,7 @@ static int profile_capable(struct aa_profile *profile, int cap)
 
 /**
  * aa_capable - test permission to use capability
- * @task: task doing capability test against (NOT NULL)
- * @profile: profile confining @task (NOT NULL)
+ * @profile: profile being tested against (NOT NULL)
  * @cap: capability to be tested
  * @audit: whether an audit record should be generated
  *
@@ -128,8 +124,7 @@ static int profile_capable(struct aa_profile *profile, int cap)
  *
  * Returns: 0 on success, or else an error code.
  */
-int aa_capable(struct task_struct *task, struct aa_profile *profile, int cap,
-	       int audit)
+int aa_capable(struct aa_profile *profile, int cap, int audit)
 {
 	int error = profile_capable(profile, cap);
 
@@ -139,5 +134,5 @@ int aa_capable(struct task_struct *task, struct aa_profile *profile, int cap,
 		return error;
 	}
 
-	return audit_caps(profile, task, cap, error);
+	return audit_caps(profile, cap, error);
 }
diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 01b7bd6..f037c57 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -75,7 +75,7 @@ static int may_change_ptraced_domain(struct task_struct *task,
 	if (!tracer || unconfined(tracerp))
 		goto out;
 
-	error = aa_may_ptrace(tracer, tracerp, to_profile, PTRACE_MODE_ATTACH);
+	error = aa_may_ptrace(tracerp, to_profile, PTRACE_MODE_ATTACH);
 
 out:
 	rcu_read_unlock();
diff --git a/security/apparmor/include/capability.h b/security/apparmor/include/capability.h
index c24d295..e4fea19 100644
--- a/security/apparmor/include/capability.h
+++ b/security/apparmor/include/capability.h
@@ -4,7 +4,7 @@
  * This file contains AppArmor capability mediation definitions.
  *
  * Copyright (C) 1998-2008 Novell/SUSE
- * Copyright 2009-2010 Canonical Ltd.
+ * Copyright 2009-2013 Canonical Ltd.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -34,8 +34,7 @@ struct aa_caps {
 	kernel_cap_t extended;
 };
 
-int aa_capable(struct task_struct *task, struct aa_profile *profile, int cap,
-	       int audit);
+int aa_capable(struct aa_profile *profile, int cap, int audit);
 
 static inline void aa_free_cap_rules(struct aa_caps *caps)
 {
diff --git a/security/apparmor/include/ipc.h b/security/apparmor/include/ipc.h
index aeda0fb..288ca76 100644
--- a/security/apparmor/include/ipc.h
+++ b/security/apparmor/include/ipc.h
@@ -19,8 +19,8 @@
 
 struct aa_profile;
 
-int aa_may_ptrace(struct task_struct *tracer_task, struct aa_profile *tracer,
-		  struct aa_profile *tracee, unsigned int mode);
+int aa_may_ptrace(struct aa_profile *tracer, struct aa_profile *tracee,
+		  unsigned int mode);
 
 int aa_ptrace(struct task_struct *tracer, struct task_struct *tracee,
 	      unsigned int mode);
diff --git a/security/apparmor/ipc.c b/security/apparmor/ipc.c
index c51d226..777ac1c 100644
--- a/security/apparmor/ipc.c
+++ b/security/apparmor/ipc.c
@@ -54,15 +54,14 @@ static int aa_audit_ptrace(struct aa_profile *profile,
 
 /**
  * aa_may_ptrace - test if tracer task can trace the tracee
- * @tracer_task: task who will do the tracing  (NOT NULL)
  * @tracer: profile of the task doing the tracing  (NOT NULL)
  * @tracee: task to be traced
  * @mode: whether PTRACE_MODE_READ || PTRACE_MODE_ATTACH
  *
  * Returns: %0 else error code if permission denied or error
  */
-int aa_may_ptrace(struct task_struct *tracer_task, struct aa_profile *tracer,
-		  struct aa_profile *tracee, unsigned int mode)
+int aa_may_ptrace(struct aa_profile *tracer, struct aa_profile *tracee,
+		  unsigned int mode)
 {
 	/* TODO: currently only based on capability, not extended ptrace
 	 *       rules,
@@ -72,7 +71,7 @@ int aa_may_ptrace(struct task_struct *tracer_task, struct aa_profile *tracer,
 	if (unconfined(tracer) || tracer == tracee)
 		return 0;
 	/* log this capability request */
-	return aa_capable(tracer_task, tracer, CAP_SYS_PTRACE, 1);
+	return aa_capable(tracer, CAP_SYS_PTRACE, 1);
 }
 
 /**
@@ -101,7 +100,7 @@ int aa_ptrace(struct task_struct *tracer, struct task_struct *tracee,
 	if (!unconfined(tracer_p)) {
 		struct aa_profile *tracee_p = aa_get_task_profile(tracee);
 
-		error = aa_may_ptrace(tracer, tracer_p, tracee_p, mode);
+		error = aa_may_ptrace(tracer_p, tracee_p, mode);
 		error = aa_audit_ptrace(tracer_p, tracee_p, error);
 
 		aa_put_profile(tracee_p);
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 2e2a0dd..69c54c8 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -145,7 +145,7 @@ static int apparmor_capable(const struct cred *cred, struct user_namespace *ns,
 	if (!error) {
 		profile = aa_cred_profile(cred);
 		if (!unconfined(profile))
-			error = aa_capable(current, profile, cap, audit);
+			error = aa_capable(profile, cap, audit);
 	}
 	return error;
 }
-- 
1.8.3.2



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaBLIem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:34:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50125 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbaBLIN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:56 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paul Moore" <pmoore@redhat.com>,
        "Evan McNabb" <emcnabb@redhat.com>, "Oleg Nesterov" <oleg@redhat.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.807701429@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 59/79] selinux: selinux_setprocattr()->ptrace_parent()
 needs rcu_read_lock()
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit c0c1439541f5305b57a83d599af32b74182933fe upstream.

selinux_setprocattr() does ptrace_parent(p) under task_lock(p),
but task_struct->alloc_lock doesn't pin ->parent or ->ptrace,
this looks confusing and triggers the "suspicious RCU usage"
warning because ptrace_parent() does rcu_dereference_check().

And in theory this is wrong, spin_lock()->preempt_disable()
doesn't necessarily imply rcu_read_lock() we need to access
the ->parent.

Reported-by: Evan McNabb <emcnabb@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/selinux/hooks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5374,11 +5374,11 @@ static int selinux_setprocattr(struct ta
 		/* Check for ptracing, and update the task SID if ok.
 		   Otherwise, leave SID unchanged and fail. */
 		ptsid = 0;
-		task_lock(p);
+		rcu_read_lock();
 		tracer = ptrace_parent(p);
 		if (tracer)
 			ptsid = task_sid(tracer);
-		task_unlock(p);
+		rcu_read_unlock();
 
 		if (tracer) {
 			error = avc_has_perm(ptsid, sid, SECCLASS_PROCESS,


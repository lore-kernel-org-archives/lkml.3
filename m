Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaAMQDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:03:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53224 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbaAMQC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 088/208] selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()
Date: Mon, 13 Jan 2014 15:58:49 +0000
Message-Id: <1389628849-1614-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 security/selinux/hooks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 122b956..56f7621 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5558,11 +5558,11 @@ static int selinux_setprocattr(struct task_struct *p,
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
-- 
1.8.3.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3LNQcZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 11:32:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab3LNQcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 11:32:24 -0500
Date: Sat, 14 Dec 2013 17:33:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>, Evan McNabb <emcnabb@redhat.com>,
        Jan Stancek <jstancek@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] selinux: selinux_setprocattr()->ptrace_parent() needs
	rcu_read_lock()
Message-ID: <20131214163317.GB21675@redhat.com>
References: <20131205165953.GA24844@redhat.com> <2222358.CI2sulrSvj@sifl> <20131206144735.GA2674@redhat.com> <CAHC9VhQPn-aZ79BcO=Ljvn2V2fW9QdQ964M_yppJWoaQ-9_GLg@mail.gmail.com> <20131214163256.GA21675@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131214163256.GA21675@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

selinux_setprocattr() does ptrace_parent(p) under task_lock(p),
but task_struct->alloc_lock doesn't pin ->parent or ->ptrace,
this looks confusing and triggers the "suspicious RCU usage"
warning because ptrace_parent() does rcu_dereference_check().

And in theory this is wrong, spin_lock()->preempt_disable()
doesn't necessarily imply rcu_read_lock() we need to access
the ->parent.

Reported-by: Evan McNabb <emcnabb@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 security/selinux/hooks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5503,11 +5503,11 @@ static int selinux_setprocattr(struct ta
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


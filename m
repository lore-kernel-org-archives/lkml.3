Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab3LWXyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 18:54:39 -0500
Received: from tundra.namei.org ([65.99.196.166]:57351 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234Ab3LWXyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 18:54:37 -0500
Date: Tue, 24 Dec 2013 10:55:18 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] SELinux fixes
Message-ID: <alpine.LRH.2.02.1312241054230.22564@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these SELinux fixes to your current tree.

The following changes since commit f5835372ebedf26847c2b9e193284075cc9c1f7f:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2013-12-23 11:49:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Chad Hanson (1):
      selinux: fix broken peer recv check

Oleg Nesterov (1):
      selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()

 security/selinux/hooks.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

---

commit c0c1439541f5305b57a83d599af32b74182933fe
Author: Oleg Nesterov <oleg@redhat.com>
Date:   Mon Dec 23 17:45:01 2013 -0500

    selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()
    
    selinux_setprocattr() does ptrace_parent(p) under task_lock(p),
    but task_struct->alloc_lock doesn't pin ->parent or ->ptrace,
    this looks confusing and triggers the "suspicious RCU usage"
    warning because ptrace_parent() does rcu_dereference_check().
    
    And in theory this is wrong, spin_lock()->preempt_disable()
    doesn't necessarily imply rcu_read_lock() we need to access
    the ->parent.
    
    Reported-by: Evan McNabb <emcnabb@redhat.com>
    Signed-off-by: Oleg Nesterov <oleg@redhat.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Paul Moore <pmoore@redhat.com>

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5db2646..6625699 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5588,11 +5588,11 @@ static int selinux_setprocattr(struct task_struct *p,
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

commit 46d01d63221c3508421dd72ff9c879f61053cffc
Author: Chad Hanson <chanson@trustedcs.com>
Date:   Mon Dec 23 17:45:01 2013 -0500

    selinux: fix broken peer recv check
    
    Fix a broken networking check. Return an error if peer recv fails.  If
    secmark is active and the packet recv succeeds the peer recv error is
    ignored.
    
    Signed-off-by: Chad Hanson <chanson@trustedcs.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Paul Moore <pmoore@redhat.com>

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 419491d..5db2646 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4334,8 +4334,10 @@ static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		}
 		err = avc_has_perm(sk_sid, peer_sid, SECCLASS_PEER,
 				   PEER__RECV, &ad);
-		if (err)
+		if (err) {
 			selinux_netlbl_err(skb, err, 0);
+			return err;
+		}
 	}
 
 	if (secmark_active) {

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaKMKoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:44:16 -0500
Received: from tundra.namei.org ([65.99.196.166]:51185 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932354AbaKMKoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:44:13 -0500
Date: Thu, 13 Nov 2014 21:44:08 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>
Subject: [GIT PULL] SELinux: make selinux_nlmsg_perm() less alarmist
Message-ID: <alpine.LRH.2.11.1411132135540.1060@namei.org>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARN_ONCE() here will unnecessarily terrify users.  Please pull for 
v.3.18.


The following changes since commit 04689e749b7ec156291446028a0ce2e685bf3855:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2014-11-12 15:29:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

James Morris (1):
      Merge branch 'stable-3.18' of git://git.infradead.org/users/pcmoore/selinux into for-linus

Richard Guy Briggs (1):
      selinux: convert WARN_ONCE() to printk() in selinux_nlmsg_perm()

 security/selinux/hooks.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

---

commit 09c626892772e6fe03f768b3492fbb126f465fe6
Merge: 04689e7 d950f84
Author: James Morris <james.l.morris@oracle.com>
Date:   Thu Nov 13 21:49:53 2014 +1100

    Merge branch 'stable-3.18' of git://git.infradead.org/users/pcmoore/selinux into for-linus


commit d950f84c1c6658faec2ecbf5b09f7e7191953394
Author: Richard Guy Briggs <rgb@redhat.com>
Date:   Wed Nov 12 14:01:34 2014 -0500

    selinux: convert WARN_ONCE() to printk() in selinux_nlmsg_perm()
    
    Convert WARN_ONCE() to printk() in selinux_nlmsg_perm().
    
    After conversion from audit_log() in commit e173fb26, WARN_ONCE() was
    deemed too alarmist, so switch it to printk().
    
    Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
    [PM: Changed to printk(WARNING) so we catch all of the different
     invalid netlink messages.  In Richard's defense, he brought this
     point up earlier, but I didn't understand his point at the time.]
    Signed-off-by: Paul Moore <pmoore@redhat.com>

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 2478976..654f071 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4727,9 +4727,10 @@ static int selinux_nlmsg_perm(struct sock *sk, struct sk_buff *skb)
 	err = selinux_nlmsg_lookup(sksec->sclass, nlh->nlmsg_type, &perm);
 	if (err) {
 		if (err == -EINVAL) {
-			WARN_ONCE(1, "selinux_nlmsg_perm: unrecognized netlink message:"
-				  " protocol=%hu nlmsg_type=%hu sclass=%hu\n",
-				  sk->sk_protocol, nlh->nlmsg_type, sksec->sclass);
+			printk(KERN_WARNING
+			       "SELinux: unrecognized netlink message:"
+			       " protocol=%hu nlmsg_type=%hu sclass=%hu\n",
+			       sk->sk_protocol, nlh->nlmsg_type, sksec->sclass);
 			if (!selinux_enforcing || security_get_allow_unknown())
 				err = 0;
 		}

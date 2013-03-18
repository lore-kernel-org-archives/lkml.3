Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3CROZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:25:49 -0400
Received: from tundra.namei.org ([65.99.196.166]:59936 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab3CROZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:25:47 -0400
Date: Tue, 19 Mar 2013 01:25:59 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Paris <eparis@redhat.com>
Subject: [GIT] SELinux xfrm kmalloc fix
Message-ID: <alpine.LRH.2.02.1303190124250.26319@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please apply.

The following changes since commit a937536b868b8369b98967929045f1df54234323:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Dan Carpenter (1):
      selinux: use GFP_ATOMIC under spin_lock

 security/selinux/xfrm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 4502403dcf8f5c76abd4dbab8726c8e4ecb5cd34
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Sat Mar 16 12:48:11 2013 +0300

    selinux: use GFP_ATOMIC under spin_lock
    
    The call tree here is:
    
    sk_clone_lock()              <- takes bh_lock_sock(newsk);
    xfrm_sk_clone_policy()
    __xfrm_sk_clone_policy()
    clone_policy()               <- uses GFP_ATOMIC for allocations
    security_xfrm_policy_clone()
    security_ops->xfrm_policy_clone_security()
    selinux_xfrm_policy_clone()
    
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Cc: stable@kernel.org
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 48665ec..8ab2951 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -310,7 +310,7 @@ int selinux_xfrm_policy_clone(struct xfrm_sec_ctx *old_ctx,
 
 	if (old_ctx) {
 		new_ctx = kmalloc(sizeof(*old_ctx) + old_ctx->ctx_len,
-				  GFP_KERNEL);
+				  GFP_ATOMIC);
 		if (!new_ctx)
 			return -ENOMEM;
 

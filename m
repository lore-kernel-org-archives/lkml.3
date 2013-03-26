Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964926Ab3CZQQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:16:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53618 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964888Ab3CZPWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 033/150] selinux: use GFP_ATOMIC under spin_lock
Date: Tue, 26 Mar 2013 15:18:52 +0000
Message-Id: <1364311249-14454-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4502403dcf8f5c76abd4dbab8726c8e4ecb5cd34 upstream.

The call tree here is:

sk_clone_lock()              <- takes bh_lock_sock(newsk);
xfrm_sk_clone_policy()
__xfrm_sk_clone_policy()
clone_policy()               <- uses GFP_ATOMIC for allocations
security_xfrm_policy_clone()
security_ops->xfrm_policy_clone_security()
selinux_xfrm_policy_clone()

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 security/selinux/xfrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
 
-- 
1.8.1.2


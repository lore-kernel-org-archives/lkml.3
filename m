Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab3CYBSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:18:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34169 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756425Ab3CYBQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:42 -0400
Message-Id: <20130325010526.893824091@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:50 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: [ 026/104] selinux: use GFP_ATOMIC under spin_lock
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/selinux/xfrm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -310,7 +310,7 @@ int selinux_xfrm_policy_clone(struct xfr
 
 	if (old_ctx) {
 		new_ctx = kmalloc(sizeof(*old_ctx) + old_ctx->ctx_len,
-				  GFP_KERNEL);
+				  GFP_ATOMIC);
 		if (!new_ctx)
 			return -ENOMEM;
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab3KXLmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 06:42:50 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:59955 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3KXLmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 06:42:45 -0500
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Geyslan G. Bem" <geyslan@gmail.com>, Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>, Paul Moore <paul@paul-moore.com>,
        linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
Subject: [PATCH] selinux: fix possible memory leak
Date: Sun, 24 Nov 2013 08:37:01 -0300
Message-Id: <1385293021-2767-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free 'ctx_str' when necessary.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 security/selinux/xfrm.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index a91d205..cf79a45 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -327,19 +327,22 @@ int selinux_xfrm_state_alloc_acquire(struct xfrm_state *x,
 		return rc;
 
 	ctx = kmalloc(sizeof(*ctx) + str_len, GFP_ATOMIC);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	ctx->ctx_doi = XFRM_SC_DOI_LSM;
 	ctx->ctx_alg = XFRM_SC_ALG_SELINUX;
 	ctx->ctx_sid = secid;
 	ctx->ctx_len = str_len;
 	memcpy(ctx->ctx_str, ctx_str, str_len);
-	kfree(ctx_str);
 
 	x->security = ctx;
 	atomic_inc(&selinux_xfrm_refcount);
-	return 0;
+out:
+	kfree(ctx_str);
+	return rc;
 }
 
 /*
-- 
1.8.4.2


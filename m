Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaHHVLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:11:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41185 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827AbaHHUwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:52:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Milan Broz <gmazyland@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 197/259] crypto: af_alg - properly label AF_ALG socket
Date: Fri,  8 Aug 2014 13:40:20 -0700
Message-Id: <1407530482-4483-198-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milan Broz <gmazyland@gmail.com>

commit 4c63f83c2c2e16a13ce274ee678e28246bd33645 upstream.

Th AF_ALG socket was missing a security label (e.g. SELinux)
which means that socket was in "unlabeled" state.

This was recently demonstrated in the cryptsetup package
(cryptsetup v1.6.5 and later.)
See https://bugzilla.redhat.com/show_bug.cgi?id=1115120

This patch clones the sock's label from the parent sock
and resolves the issue (similar to AF_BLUETOOTH protocol family).

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 crypto/af_alg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 966f893..6a3ad80 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/net.h>
 #include <linux/rwsem.h>
+#include <linux/security.h>
 
 struct alg_type_list {
 	const struct af_alg_type *type;
@@ -243,6 +244,7 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 
 	sock_init_data(newsock, sk2);
 	sock_graft(sk2, newsock);
+	security_sk_clone(sk, sk2);
 
 	err = type->accept(ask->private, sk2);
 	if (err) {
-- 
1.9.1


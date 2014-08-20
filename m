Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbaHTMMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:12:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58862 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 002/104] crypto: af_alg - properly label AF_ALG socket
Date: Wed, 20 Aug 2014 13:42:25 +0200
Message-Id: <06bcee7de7ca6b3bd122437d9d4181ef399e7847.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milan Broz <gmazyland@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 crypto/af_alg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index ac33d5f30778..bf948e134981 100644
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
2.0.4


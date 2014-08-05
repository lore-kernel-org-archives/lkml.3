Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbaHESQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:16:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbaHESQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:16:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Milan Broz <gmazyland@gmail.com>, Paul Moore <paul@paul-moore.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.10 01/27] crypto: af_alg - properly label AF_ALG socket
Date: Tue,  5 Aug 2014 11:13:53 -0700
Message-Id: <20140805181344.310707499@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181344.268039690@linuxfoundation.org>
References: <20140805181344.268039690@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/af_alg.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/net.h>
 #include <linux/rwsem.h>
+#include <linux/security.h>
 
 struct alg_type_list {
 	const struct af_alg_type *type;
@@ -243,6 +244,7 @@ int af_alg_accept(struct sock *sk, struc
 
 	sock_init_data(newsock, sk2);
 	sock_graft(sk2, newsock);
+	security_sk_clone(sk, sk2);
 
 	err = type->accept(ask->private, sk2);
 	if (err) {



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbaIKNMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:12:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754049AbaIKNES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:18 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paul Moore" <paul@paul-moore.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Milan Broz" <gmazyland@gmail.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.603629274@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 040/131] crypto: af_alg - properly label AF_ALG socket
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 crypto/af_alg.c | 2 ++
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


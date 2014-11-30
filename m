Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaK3RFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 12:05:38 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:6028 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbaK3RFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 12:05:31 -0500
X-IronPort-AV: E=Sophos;i="5.07,488,1413237600"; 
   d="scan'208";a="91114604"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Steve French <sfrench@samba.org>
Cc: dborkman@redhat.com, herbert@gondor.apana.org.au,
        kernel-janitors@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia@diku.dk>
Subject: [PATCH 4/8] cifs: replace memset by memzero_explicit
Date: Sun, 30 Nov 2014 17:59:30 +0100
Message-Id: <1417366774-32412-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417366774-32412-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1417366774-32412-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Memset on a local variable may be removed when it is called just before the
variable goes out of scope.  Using memzero_explicit defeats this
optimization.  A simplified version of the semantic patch that makes this
change is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
type T;
@@

{
... when any
T x[...];
... when any
    when exists
- memset
+ memzero_explicit
  (x,
-0,
  ...)
... when != x
    when strict
}
// </smpl>

This change was suggested by Daniel Borkmann <dborkman@redhat.com>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Daniel Borkmann suggested that these patches could go through Herbert Xu's
cryptodev tree.

 fs/cifs/smbencrypt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 6c15663..6512c19 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -221,7 +221,7 @@ E_md4hash(const unsigned char *passwd, unsigned char *p16,
 	}
 
 	rc = mdfour(p16, (unsigned char *) wpwd, len * sizeof(__le16));
-	memset(wpwd, 0, 129 * sizeof(__le16));
+	memzero_explicit(wpwd, 129 * sizeof(__le16));
 
 	return rc;
 }


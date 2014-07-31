Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaHAGqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 02:46:32 -0400
Received: from mail.eperm.de ([89.247.134.16]:35199 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbaHAGqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 02:46:31 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH] DRBG: fix failure of generating multiple of 2**16 bytes
Date: Thu, 31 Jul 2014 21:47:33 +0200
Message-ID: <7159935.MYAcUzQ1Ny@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.15.4-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function drbg_generate_long slices the request into 2**16 byte
or smaller chunks. However, the loop, however invokes the random number
generation function with zero bytes when the request size is a multiple
of 2**16 bytes. The fix prevents zero bytes requests.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index ff975d9..7894db9 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1500,7 +1500,7 @@ static int drbg_generate_long(struct drbg_state *drbg,
 		if (0 >= tmplen)
 			return tmplen;
 		len += tmplen;
-	} while (slice > 0);
+	} while (slice > 0 && (len < buflen));
 	return len;
 }
 
-- 
1.9.3



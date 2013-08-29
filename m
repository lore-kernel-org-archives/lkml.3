Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab3H2SLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:11:10 -0400
Received: from mout.gmx.net ([212.227.17.22]:52538 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261Ab3H2SLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:11:04 -0400
From: dl9pf@gmx.de
To: linux-kernel@vger.kernel.org
Cc: dl9pf@gmx.de, pageexec@freemail.hu, llvmlinux@lists.linuxfoundation.org,
        behanw@converseincode.com, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: [PATCH] Fix bitoperation for compilation with clang
Date: Thu, 29 Aug 2013 20:09:24 +0200
Message-Id: <1377799764-14373-1-git-send-email-dl9pf@gmx.de>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:P5lUUOMj/eUJwenz12YPad+OVV6PSn7Ci5l+hMIqTzORIKK7FUy
 qEbtNWFCoDUXgqF4euSIa/eMTR58bHLwhcA7SPvdvIETMSOqU1XEZfNgE/VFn3b+h4VsMgK
 1C2hzTry64AxSv+dku5efIOlur22MILeU7tV/LylAjhkArRopBNXRRrOh/svEy/v8qvTnOH
 ioZp4zdVwDgat+S2c7xWw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

v2: Fix bug in statement as pointed out by Herbert Xu. Kudos to pipacs.

Author:  PaX Team <pageexec at freemail.hu>
ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
URL:     http://llvm.linuxfoundation.org

Merge:   Jan-Simon Möller <dl9pf at gmx.de>

Description:

Fix for warning:
linux/crypto/fcrypt.c:143:47: warning: signed shift result (0x598000000) requires 36 bits to
      represent, but 'int' only has 32 bits [-Wshift-overflow]
        Z(0xef), Z(0x70), Z(0xcf), Z(0xc2), Z(0x2a), Z(0xb3), Z(0x61), Z(0xad),
                                                     ^~~~~~~
linux/crypto/fcrypt.c:113:29: note: expanded from macro 'Z'
                            ^  ~~
linux/include/uapi/linux/byteorder/little_endian.h:38:53: note: expanded from macro
      '__cpu_to_be32'
                                                    ^
linux/include/uapi/linux/swab.h:116:21: note: expanded from macro '__swab32'
        ___constant_swab32(x) :                 \
                           ^
linux/include/uapi/linux/swab.h:18:12: note: expanded from macro '___constant_swab32'
        (((__u32)(x) & (__u32)0x0000ff00UL) <<  8) |            \
                  ^

Solution - make sure we don't exceed the 32 bit range.
 #define Z(x) cpu_to_be32(((x & 0x1f) << 27) | (x >> 5))

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
CC: pageexec@freemail.hu
CC: llvmlinux@lists.linuxfoundation.org
CC: behanw@converseincode.com
CC: herbert@gondor.apana.org.au
CC: davem@davemloft.net
CC: linux-crypto@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 crypto/fcrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index 3b2cf56..021d7fe 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -110,7 +110,7 @@ static const __be32 sbox0[256] = {
 };
 
 #undef Z
-#define Z(x) cpu_to_be32((x << 27) | (x >> 5))
+#define Z(x) cpu_to_be32(((x & 0x1f) << 27) | (x >> 5))
 static const __be32 sbox1[256] = {
 	Z(0x77), Z(0x14), Z(0xa6), Z(0xfe), Z(0xb2), Z(0x5e), Z(0x8c), Z(0x3e),
 	Z(0x67), Z(0x6c), Z(0xa1), Z(0x0d), Z(0xc2), Z(0xa2), Z(0xc1), Z(0x85),
-- 
1.8.1.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965403AbaGOXlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:41:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933897AbaGOXOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.15 33/84] crypto: sha512_ssse3 - fix byte count to bit count conversion
Date: Tue, 15 Jul 2014 16:17:30 -0700
Message-Id: <20140715231714.194661117@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@iki.fi>

commit cfe82d4f45c7cc39332a2be7c4c1d3bf279bbd3d upstream.

Byte-to-bit-count computation is only partly converted to big-endian and is
mixing in CPU-endian values. Problem was noticed by sparce with warning:

  CHECK   arch/x86/crypto/sha512_ssse3_glue.c
arch/x86/crypto/sha512_ssse3_glue.c:144:19: warning: restricted __be64 degrades to integer
arch/x86/crypto/sha512_ssse3_glue.c:144:17: warning: incorrect type in assignment (different base types)
arch/x86/crypto/sha512_ssse3_glue.c:144:17:    expected restricted __be64 <noident>
arch/x86/crypto/sha512_ssse3_glue.c:144:17:    got unsigned long long

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/crypto/sha512_ssse3_glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -141,7 +141,7 @@ static int sha512_ssse3_final(struct sha
 
 	/* save number of bits */
 	bits[1] = cpu_to_be64(sctx->count[0] << 3);
-	bits[0] = cpu_to_be64(sctx->count[1] << 3) | sctx->count[0] >> 61;
+	bits[0] = cpu_to_be64(sctx->count[1] << 3 | sctx->count[0] >> 61);
 
 	/* Pad out to 112 mod 128 and append length */
 	index = sctx->count[0] & 0x7f;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbbANHb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:31:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbbANHbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:31:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Yonan <james@openvpn.net>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.18 134/150] crypto: aesni - fix "by8" variant for 128 bit keys
Date: Tue, 13 Jan 2015 23:23:25 -0800
Message-Id: <20150114072101.918764951@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 0b1e95b2fa0934c3a08db483979c70d3b287f50e upstream.

The "by8" counter mode optimization is broken for 128 bit keys with
input data longer than 128 bytes. It uses the wrong key material for
en- and decryption.

The key registers xkey0, xkey4, xkey8 and xkey12 need to be preserved
in case we're handling more than 128 bytes of input data -- they won't
get reloaded after the initial load. They must therefore be (a) loaded
on the first iteration and (b) be preserved for the latter ones. The
implementation for 128 bit keys does not comply with (a) nor (b).

Fix this by bringing the implementation back to its original source
and correctly load the key registers and preserve their values by
*not* re-using the registers for other purposes.

Kudos to James for reporting the issue and providing a test case
showing the discrepancies.

Reported-by: James Yonan <james@openvpn.net>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S |   46 ++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 11 deletions(-)

--- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
+++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
@@ -208,7 +208,7 @@ ddq_add_8:
 
 	.if (klen == KEY_128)
 		.if (load_keys)
-			vmovdqa	3*16(p_keys), xkeyA
+			vmovdqa	3*16(p_keys), xkey4
 		.endif
 	.else
 		vmovdqa	3*16(p_keys), xkeyA
@@ -224,7 +224,7 @@ ddq_add_8:
 	add	$(16*by), p_in
 
 	.if (klen == KEY_128)
-		vmovdqa	4*16(p_keys), xkey4
+		vmovdqa	4*16(p_keys), xkeyB
 	.else
 		.if (load_keys)
 			vmovdqa	4*16(p_keys), xkey4
@@ -234,7 +234,12 @@ ddq_add_8:
 	.set i, 0
 	.rept by
 		club XDATA, i
-		vaesenc	xkeyA, var_xdata, var_xdata		/* key 3 */
+		/* key 3 */
+		.if (klen == KEY_128)
+			vaesenc	xkey4, var_xdata, var_xdata
+		.else
+			vaesenc	xkeyA, var_xdata, var_xdata
+		.endif
 		.set i, (i +1)
 	.endr
 
@@ -243,13 +248,18 @@ ddq_add_8:
 	.set i, 0
 	.rept by
 		club XDATA, i
-		vaesenc	xkey4, var_xdata, var_xdata		/* key 4 */
+		/* key 4 */
+		.if (klen == KEY_128)
+			vaesenc	xkeyB, var_xdata, var_xdata
+		.else
+			vaesenc	xkey4, var_xdata, var_xdata
+		.endif
 		.set i, (i +1)
 	.endr
 
 	.if (klen == KEY_128)
 		.if (load_keys)
-			vmovdqa	6*16(p_keys), xkeyB
+			vmovdqa	6*16(p_keys), xkey8
 		.endif
 	.else
 		vmovdqa	6*16(p_keys), xkeyB
@@ -267,12 +277,17 @@ ddq_add_8:
 	.set i, 0
 	.rept by
 		club XDATA, i
-		vaesenc	xkeyB, var_xdata, var_xdata		/* key 6 */
+		/* key 6 */
+		.if (klen == KEY_128)
+			vaesenc	xkey8, var_xdata, var_xdata
+		.else
+			vaesenc	xkeyB, var_xdata, var_xdata
+		.endif
 		.set i, (i +1)
 	.endr
 
 	.if (klen == KEY_128)
-		vmovdqa	8*16(p_keys), xkey8
+		vmovdqa	8*16(p_keys), xkeyB
 	.else
 		.if (load_keys)
 			vmovdqa	8*16(p_keys), xkey8
@@ -288,7 +303,7 @@ ddq_add_8:
 
 	.if (klen == KEY_128)
 		.if (load_keys)
-			vmovdqa	9*16(p_keys), xkeyA
+			vmovdqa	9*16(p_keys), xkey12
 		.endif
 	.else
 		vmovdqa	9*16(p_keys), xkeyA
@@ -297,7 +312,12 @@ ddq_add_8:
 	.set i, 0
 	.rept by
 		club XDATA, i
-		vaesenc	xkey8, var_xdata, var_xdata		/* key 8 */
+		/* key 8 */
+		.if (klen == KEY_128)
+			vaesenc	xkeyB, var_xdata, var_xdata
+		.else
+			vaesenc	xkey8, var_xdata, var_xdata
+		.endif
 		.set i, (i +1)
 	.endr
 
@@ -306,7 +326,12 @@ ddq_add_8:
 	.set i, 0
 	.rept by
 		club XDATA, i
-		vaesenc	xkeyA, var_xdata, var_xdata		/* key 9 */
+		/* key 9 */
+		.if (klen == KEY_128)
+			vaesenc	xkey12, var_xdata, var_xdata
+		.else
+			vaesenc	xkeyA, var_xdata, var_xdata
+		.endif
 		.set i, (i +1)
 	.endr
 
@@ -412,7 +437,6 @@ ddq_add_8:
 /* main body of aes ctr load */
 
 .macro do_aes_ctrmain key_len
-
 	cmp	$16, num_bytes
 	jb	.Ldo_return2\key_len
 



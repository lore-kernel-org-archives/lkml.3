Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaIBMws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:52:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbaIBMwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:52:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 5/5] PEFILE: Relax the check on the length of the PKCS#7 cert
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
Cc: keyrings@linux-nfs.org, linux-kernel@vger.kernel.org, dhowells@redhat.com,
        linux-security-module@vger.kernel.org, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 02 Sep 2014 13:52:28 +0100
Message-ID: <20140902125228.9247.15437.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140902125159.9247.11970.stgit@warthog.procyon.org.uk>
References: <20140902125159.9247.11970.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relax the check on the length of the PKCS#7 cert as it appears that the PE
file wrapper size gets rounded up to the nearest 8.

The debugging output looks like this:

	PEFILE: ==> verify_pefile_signature()
	PEFILE: ==> pefile_parse_binary()
	PEFILE: checksum @ 110
	PEFILE: header size = 200
	PEFILE: cert = 968 @547be0 [68 09 00 00 00 02 02 00 30 82 09 56 ]
	PEFILE: sig wrapper = { 968, 200, 2 }
	PEFILE: Signature data not PKCS#7

The wrapper is the first 8 bytes of the hex dump inside [].  This indicates a
length of 0x968 bytes, including the wrapper header - so 0x960 bytes of
payload.

The ASN.1 wrapper begins [ ... 30 82 09 56 ].  That indicates an object of size
0x956 - a four byte discrepency, presumably just padding for alignment
purposes.

So we just check that the ASN.1 container is no bigger than the payload and
reduce the recorded size appropriately.

Whilst we're at it, allow shorter PKCS#7 objects that manage to squeeze within
127 or 255 bytes.  It's just about conceivable if no X.509 certs are included
in the PKCS#7 message.

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Peter Jones <pjones@redhat.com>
---

 crypto/asymmetric_keys/verify_pefile.c |   49 ++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 79175e6ea0b2..90122831b818 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -128,6 +128,7 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 {
 	struct win_certificate wrapper;
 	const u8 *pkcs7;
+	unsigned len;
 
 	if (ctx->sig_len < sizeof(wrapper)) {
 		pr_debug("Signature wrapper too short\n");
@@ -154,33 +155,49 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 		return -ENOTSUPP;
 	}
 
-	/* Looks like actual pkcs signature length is in wrapper->length.
-	 * size obtained from data dir entries lists the total size of
-	 * certificate table which is also aligned to octawrod boundary.
-	 *
-	 * So set signature length field appropriately.
+	/* It looks like the pkcs signature length in wrapper->length and the
+	 * size obtained from the data dir entries, which lists the total size
+	 * of certificate table, are both aligned to an octaword boundary, so
+	 * we may have to deal with some padding.
 	 */
 	ctx->sig_len = wrapper.length;
 	ctx->sig_offset += sizeof(wrapper);
 	ctx->sig_len -= sizeof(wrapper);
-	if (ctx->sig_len == 0) {
+	if (ctx->sig_len < 4) {
 		pr_debug("Signature data missing\n");
 		return -EKEYREJECTED;
 	}
 
-	/* What's left should a PKCS#7 cert */
+	/* What's left should be a PKCS#7 cert */
 	pkcs7 = pebuf + ctx->sig_offset;
-	if (pkcs7[0] == (ASN1_CONS_BIT | ASN1_SEQ)) {
-		if (pkcs7[1] == 0x82 &&
-		    pkcs7[2] == (((ctx->sig_len - 4) >> 8) & 0xff) &&
-		    pkcs7[3] ==  ((ctx->sig_len - 4)       & 0xff))
-			return 0;
-		if (pkcs7[1] == 0x80)
-			return 0;
-		if (pkcs7[1] > 0x82)
-			return -EMSGSIZE;
+	if (pkcs7[0] != (ASN1_CONS_BIT | ASN1_SEQ))
+		goto not_pkcs7;
+	
+	switch (pkcs7[1]) {
+	case 0 ... 0x7f:
+		len = pkcs7[1] + 2;
+		goto check_len;
+	case ASN1_INDEFINITE_LENGTH:
+		return 0;
+	case 0x81:
+		len = pkcs7[2] + 3;
+		goto check_len;
+	case 0x82:
+		len = ((pkcs7[2] << 8) | pkcs7[3]) + 4;
+		goto check_len;
+	case 0x83 ... 0xff:
+		return -EMSGSIZE;
+	default:
+		goto not_pkcs7;
 	}
 
+check_len:
+	if (len <= ctx->sig_len) {
+		/* There may be padding */
+		ctx->sig_len = len;
+		return 0;
+	}
+not_pkcs7:
 	pr_debug("Signature data not PKCS#7\n");
 	return -ELIBBAD;
 }


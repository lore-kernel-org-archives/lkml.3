Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbaGIPRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:17:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756834AbaGIPRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:17:05 -0400
Subject: [PATCH12/17] pefile: Strip the wrapper off of the cert data block
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: linux-security-module@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2014 16:16:43 +0100
Message-ID: <20140709151643.23074.38869.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
References: <20140709151525.23074.32315.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The certificate data block in a PE binary has a wrapper around the PKCS#7
signature we actually want to get at.  Strip this off and check that we've got
something that appears to be a PKCS#7 signature.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---

 crypto/asymmetric_keys/verify_pefile.c |   71 ++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)


diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index aec7c50..2f5268c 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/pe.h>
+#include <linux/asn1.h>
 #include <crypto/pkcs7.h>
 #include <crypto/hash.h>
 #include "verify_pefile.h"
@@ -118,6 +119,72 @@ static int pefile_parse_binary(const void *pebuf, unsigned int pelen,
 	return 0;
 }
 
+/*
+ * Check and strip the PE wrapper from around the signature and check that the
+ * remnant looks something like PKCS#7.
+ */
+static int pefile_strip_sig_wrapper(const void *pebuf,
+				    struct pefile_context *ctx)
+{
+	struct win_certificate wrapper;
+	const u8 *pkcs7;
+
+	if (ctx->sig_len < sizeof(wrapper)) {
+		pr_debug("Signature wrapper too short\n");
+		return -ELIBBAD;
+	}
+
+	memcpy(&wrapper, pebuf + ctx->sig_offset, sizeof(wrapper));
+	pr_debug("sig wrapper = { %x, %x, %x }\n",
+		 wrapper.length, wrapper.revision, wrapper.cert_type);
+
+	/* Both pesign and sbsign round up the length of certificate table
+	 * (in optional header data directories) to 8 byte alignment.
+	 */
+	if (round_up(wrapper.length, 8) != ctx->sig_len) {
+		pr_debug("Signature wrapper len wrong\n");
+		return -ELIBBAD;
+	}
+	if (wrapper.revision != WIN_CERT_REVISION_2_0) {
+		pr_debug("Signature is not revision 2.0\n");
+		return -ENOTSUPP;
+	}
+	if (wrapper.cert_type != WIN_CERT_TYPE_PKCS_SIGNED_DATA) {
+		pr_debug("Signature certificate type is not PKCS\n");
+		return -ENOTSUPP;
+	}
+
+	/* Looks like actual pkcs signature length is in wrapper->length.
+	 * size obtained from data dir entries lists the total size of
+	 * certificate table which is also aligned to octawrod boundary.
+	 *
+	 * So set signature length field appropriately.
+	 */
+	ctx->sig_len = wrapper.length;
+	ctx->sig_offset += sizeof(wrapper);
+	ctx->sig_len -= sizeof(wrapper);
+	if (ctx->sig_len == 0) {
+		pr_debug("Signature data missing\n");
+		return -EKEYREJECTED;
+	}
+
+	/* What's left should a PKCS#7 cert */
+	pkcs7 = pebuf + ctx->sig_offset;
+	if (pkcs7[0] == (ASN1_CONS_BIT | ASN1_SEQ)) {
+		if (pkcs7[1] == 0x82 &&
+		    pkcs7[2] == (((ctx->sig_len - 4) >> 8) & 0xff) &&
+		    pkcs7[3] ==  ((ctx->sig_len - 4)       & 0xff))
+			return 0;
+		if (pkcs7[1] == 0x80)
+			return 0;
+		if (pkcs7[1] > 0x82)
+			return -EMSGSIZE;
+	}
+
+	pr_debug("Signature data not PKCS#7\n");
+	return -ELIBBAD;
+}
+
 /**
  * verify_pefile_signature - Verify the signature on a PE binary image
  * @pebuf: Buffer containing the PE binary image
@@ -159,5 +226,9 @@ int verify_pefile_signature(const void *pebuf, unsigned pelen,
 	if (ret < 0)
 		return ret;
 
+	ret = pefile_strip_sig_wrapper(pebuf, &ctx);
+	if (ret < 0)
+		return ret;
+
 	return -ENOANO; // Not yet complete
 }


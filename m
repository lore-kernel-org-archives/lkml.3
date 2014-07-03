Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030221AbaGCVIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:08:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965084AbaGCVIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:08:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org, dhowells@redhat.com, pjones@redhat.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 4/9] pefile: Strip the wrapper off of the cert data block
Date: Thu,  3 Jul 2014 17:07:16 -0400
Message-Id: <1404421641-12691-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
References: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The certificate data block in a PE binary has a wrapper around the PKCS#7
signature we actually want to get at.  Strip this off and check that we've got
something that appears to be a PKCS#7 signature.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/kernel/pefile_parser.c | 73 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/arch/x86/kernel/pefile_parser.c b/arch/x86/kernel/pefile_parser.c
index 72bc2bb..088779e 100644
--- a/arch/x86/kernel/pefile_parser.c
+++ b/arch/x86/kernel/pefile_parser.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/pe.h>
+#include <linux/asn1.h>
 #include <keys/asymmetric-subtype.h>
 #include <keys/asymmetric-parser.h>
 #include <crypto/hash.h>
@@ -27,6 +28,74 @@
 	pr_devel("<== %s()"FMT"\n", __func__, ##__VA_ARGS__)
 
 /*
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
+	/*
+	 * Both pesign and sbsign round up the length of certificate table
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
+	/*
+	 * Looks like actual pkcs signature length is in wrapper->length.
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
+/*
  * Parse a PE binary.
  */
 static int pefile_parse_binary(const void *pebuf, unsigned int pelen,
@@ -140,6 +209,10 @@ int pefile_parse_verify_sig(const void *pebuf, unsigned int pelen)
 	if (ret < 0)
 		return ret;
 
+	ret = pefile_strip_sig_wrapper(pebuf, &ctx);
+	if (ret < 0)
+		return ret;
+
 	/* Not yet complete */
 	return -ENOANO;
 }
-- 
1.9.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965036AbaGCVIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:08:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964865AbaGCVI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:08:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org, dhowells@redhat.com, pjones@redhat.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 7/9] pefile: Digest the PE binary and compare to the PKCS#7 data
Date: Thu,  3 Jul 2014 17:07:19 -0400
Message-Id: <1404421641-12691-8-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
References: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Digest the signed parts of the PE binary, canonicalising the section table
before we need it, and then compare the the resulting digest to the one in the
PKCS#7 signed content.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/kernel/pefile_parser.c | 197 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 197 insertions(+)

diff --git a/arch/x86/kernel/pefile_parser.c b/arch/x86/kernel/pefile_parser.c
index 7281217..f11c254 100644
--- a/arch/x86/kernel/pefile_parser.c
+++ b/arch/x86/kernel/pefile_parser.c
@@ -96,6 +96,192 @@ static int pefile_strip_sig_wrapper(const void *pebuf,
 }
 
 /*
+ * Compare two sections for canonicalisation.
+ */
+static int pefile_compare_shdrs(const void *a, const void *b)
+{
+	const struct section_header *shdra = a;
+	const struct section_header *shdrb = b;
+	int rc;
+
+	if (shdra->data_addr > shdrb->data_addr)
+		return 1;
+	if (shdrb->data_addr > shdra->data_addr)
+		return -1;
+
+	if (shdra->virtual_address > shdrb->virtual_address)
+		return 1;
+	if (shdrb->virtual_address > shdra->virtual_address)
+		return -1;
+
+	rc = strcmp(shdra->name, shdrb->name);
+	if (rc != 0)
+		return rc;
+
+	if (shdra->virtual_size > shdrb->virtual_size)
+		return 1;
+	if (shdrb->virtual_size > shdra->virtual_size)
+		return -1;
+
+	if (shdra->raw_data_size > shdrb->raw_data_size)
+		return 1;
+	if (shdrb->raw_data_size > shdra->raw_data_size)
+		return -1;
+
+	return 0;
+}
+
+/*
+ * Load the contents of the PE binary into the digest, leaving out the image
+ * checksum and the certificate data block.
+ */
+static int pefile_digest_pe_contents(const void *pebuf, unsigned int pelen,
+				     struct pefile_context *ctx,
+				     struct shash_desc *desc)
+{
+	unsigned *canon, tmp, loop, i, hashed_bytes;
+	int ret;
+
+	/* Digest the header and data directory, but leave out the image
+	 * checksum and the data dirent for the signature.
+	 */
+	ret = crypto_shash_update(desc, pebuf, ctx->image_checksum_offset);
+	if (ret < 0)
+		return ret;
+
+	tmp = ctx->image_checksum_offset + sizeof(uint32_t);
+	ret = crypto_shash_update(desc, pebuf + tmp,
+				  ctx->cert_dirent_offset - tmp);
+	if (ret < 0)
+		return ret;
+
+	tmp = ctx->cert_dirent_offset + sizeof(struct data_dirent);
+	ret = crypto_shash_update(desc, pebuf + tmp, ctx->header_size - tmp);
+	if (ret < 0)
+		return ret;
+
+	canon = kcalloc(ctx->n_sections, sizeof(unsigned), GFP_KERNEL);
+	if (!canon)
+		return -ENOMEM;
+
+	/* We have to canonicalise the section table, so we perform an
+	 * insertion sort.
+	 */
+	canon[0] = 0;
+	for (loop = 1; loop < ctx->n_sections; loop++) {
+		for (i = 0; i < loop; i++) {
+			if (pefile_compare_shdrs(&ctx->secs[canon[i]],
+						 &ctx->secs[loop]) > 0) {
+				memmove(&canon[i + 1], &canon[i],
+					(loop - i) * sizeof(canon[0]));
+				break;
+			}
+		}
+		canon[i] = loop;
+	}
+
+	hashed_bytes = ctx->header_size;
+	for (loop = 0; loop < ctx->n_sections; loop++) {
+		i = canon[loop];
+		if (ctx->secs[i].raw_data_size == 0)
+			continue;
+		ret = crypto_shash_update(desc,
+					  pebuf + ctx->secs[i].data_addr,
+					  ctx->secs[i].raw_data_size);
+		if (ret < 0) {
+			kfree(canon);
+			return ret;
+		}
+		hashed_bytes += ctx->secs[i].raw_data_size;
+	}
+	kfree(canon);
+
+	if (pelen > hashed_bytes) {
+		tmp = hashed_bytes + ctx->certs_size;
+		ret = crypto_shash_update(desc,
+					  pebuf + hashed_bytes,
+					  pelen - tmp);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Digest the contents of the PE binary, leaving out the image checksum and the
+ * certificate data block.
+ */
+static int pefile_digest_pe(const void *pebuf, unsigned int pelen,
+			    struct pefile_context *ctx)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	size_t digest_size, desc_size;
+	void *digest;
+	int ret;
+
+	kenter(",%u", ctx->digest_algo);
+
+	/* Allocate the hashing algorithm we're going to need and find out how
+	 * big the hash operational data will be.
+	 */
+	tfm = crypto_alloc_shash(hash_algo_name[ctx->digest_algo], 0, 0);
+	if (IS_ERR(tfm))
+		return (PTR_ERR(tfm) == -ENOENT) ? -ENOPKG : PTR_ERR(tfm);
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	digest_size = crypto_shash_digestsize(tfm);
+
+	if (digest_size != ctx->digest_len) {
+		pr_debug("Digest size mismatch (%zx != %x)\n",
+			 digest_size, ctx->digest_len);
+		ret = -EBADMSG;
+		goto error_no_desc;
+	}
+	pr_debug("Digest: desc=%zu size=%zu\n", desc_size, digest_size);
+
+	ret = -ENOMEM;
+	desc = kzalloc(desc_size + digest_size, GFP_KERNEL);
+	if (!desc)
+		goto error_no_desc;
+
+	desc->tfm   = tfm;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error;
+
+	ret = pefile_digest_pe_contents(pebuf, pelen, ctx, desc);
+	if (ret < 0)
+		goto error;
+
+	digest = (void *)desc + desc_size;
+	ret = crypto_shash_final(desc, digest);
+	if (ret < 0)
+		goto error;
+
+	pr_debug("Digest calc = [%*ph]\n", ctx->digest_len, digest);
+
+	/* Check that the PE file digest matches that in the MSCODE part of the
+	 * PKCS#7 certificate.
+	 */
+	if (memcmp(digest, ctx->digest, ctx->digest_len) != 0) {
+		pr_debug("Digest mismatch\n");
+		ret = -EKEYREJECTED;
+	} else {
+		pr_debug("The digests match!\n");
+	}
+
+error:
+	kfree(desc);
+error_no_desc:
+	crypto_free_shash(tfm);
+	kleave(" = %d", ret);
+	return ret;
+}
+
+/*
  * Parse a PE binary.
  */
 static int pefile_parse_binary(const void *pebuf, unsigned int pelen,
@@ -225,6 +411,17 @@ int pefile_parse_verify_sig(const void *pebuf, unsigned int pelen)
 	pr_debug("Digest: %u [%*ph]\n", ctx.digest_len, ctx.digest_len,
 		 ctx.digest);
 
+	/* Generate the digest and check against the PKCS7 certificate
+	 * contents.
+	 */
+	ret = pefile_digest_pe(pebuf, pelen, &ctx);
+	if (ret < 0)
+		goto error;
+
+	ret = pkcs7_verify(pkcs7);
+	if (ret < 0)
+		goto error;
+
 	/* Not yet complete */
 	ret = -ENOANO;
 
-- 
1.9.0


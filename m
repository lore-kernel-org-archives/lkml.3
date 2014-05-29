Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827AbaE2FmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:42:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbaE2Eep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.14 008/140] netfilter: nf_tables: fix nft_cmp_fast failure on big endian for size < 4
Date: Wed, 28 May 2014 21:32:27 -0700
Message-Id: <20140529043050.640513956@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit b855d416dc17061ebb271ea7ef1201d100531770 upstream.

nft_cmp_fast is used for equality comparisions of size <= 4. For
comparisions of size < 4 byte a mask is calculated that is applied to
both the data from userspace (during initialization) and the register
value (during runtime). Both values are stored using (in effect) memcpy
to a memory area that is then interpreted as u32 by nft_cmp_fast.

This works fine on little endian since smaller types have the same base
address, however on big endian this is not true and the smaller types
are interpreted as a big number with trailing zero bytes.

The mask therefore must not include the lower bytes, but the higher bytes
on big endian. Add a helper function that does a cpu_to_le32 to switch
the bytes on big endian. Since we're dealing with a mask of just consequitive
bits, this works out fine.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/netfilter/nf_tables_core.h |   10 ++++++++++
 net/netfilter/nf_tables_core.c         |    3 +--
 net/netfilter/nft_cmp.c                |    2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -13,6 +13,16 @@ struct nft_cmp_fast_expr {
 	u8			len;
 };
 
+/* Calculate the mask for the nft_cmp_fast expression. On big endian the
+ * mask needs to include the *upper* bytes when interpreting that data as
+ * something smaller than the full u32, therefore a cpu_to_le32 is done.
+ */
+static inline u32 nft_cmp_fast_mask(unsigned int len)
+{
+	return cpu_to_le32(~0U >> (FIELD_SIZEOF(struct nft_cmp_fast_expr,
+						data) * BITS_PER_BYTE - len));
+}
+
 extern const struct nft_expr_ops nft_cmp_fast_ops;
 
 int nft_cmp_module_init(void);
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -25,9 +25,8 @@ static void nft_cmp_fast_eval(const stru
 			      struct nft_data data[NFT_REG_MAX + 1])
 {
 	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
-	u32 mask;
+	u32 mask = nft_cmp_fast_mask(priv->len);
 
-	mask = ~0U >> (sizeof(priv->data) * BITS_PER_BYTE - priv->len);
 	if ((data[priv->sreg].data[0] & mask) == priv->data)
 		return;
 	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -128,7 +128,7 @@ static int nft_cmp_fast_init(const struc
 	BUG_ON(err < 0);
 	desc.len *= BITS_PER_BYTE;
 
-	mask = ~0U >> (sizeof(priv->data) * BITS_PER_BYTE - desc.len);
+	mask = nft_cmp_fast_mask(desc.len);
 	priv->data = data.data[0] & mask;
 	priv->len  = desc.len;
 	return 0;



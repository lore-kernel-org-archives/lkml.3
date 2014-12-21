Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaLUUyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 15:54:31 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:59534 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbaLUUyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 15:54:24 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, linux-crypto@vger.kernel.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 3/5] MIPS: OCTEON: reintroduce crypto features check
Date: Sun, 21 Dec 2014 22:54:00 +0200
Message-Id: <1419195242-546-4-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <1419195242-546-1-git-send-email-aaro.koskinen@iki.fi>
References: <1419195242-546-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reintroduce run-time check for crypto features. The old one was deleted
because it was unreliable, now decide the crypto availability on early
boot when the model string is constructed.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/mips/cavium-octeon/executive/octeon-model.c |  6 ++++++
 arch/mips/include/asm/octeon/octeon-feature.h    | 17 +++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/mips/cavium-octeon/executive/octeon-model.c b/arch/mips/cavium-octeon/executive/octeon-model.c
index e15b049..b2104bd 100644
--- a/arch/mips/cavium-octeon/executive/octeon-model.c
+++ b/arch/mips/cavium-octeon/executive/octeon-model.c
@@ -27,6 +27,9 @@
 
 #include <asm/octeon/octeon.h>
 
+enum octeon_feature_bits __octeon_feature_bits __read_mostly;
+EXPORT_SYMBOL_GPL(__octeon_feature_bits);
+
 /**
  * Read a byte of fuse data
  * @byte_addr:	 address to read
@@ -103,6 +106,9 @@ static const char *__init octeon_model_get_string_buffer(uint32_t chip_id,
 	else
 		suffix = "NSP";
 
+	if (!fus_dat2.s.nocrypto)
+		__octeon_feature_bits |= OCTEON_HAS_CRYPTO;
+
 	/*
 	 * Assume pass number is encoded using <5:3><2:0>. Exceptions
 	 * will be fixed later.
diff --git a/arch/mips/include/asm/octeon/octeon-feature.h b/arch/mips/include/asm/octeon/octeon-feature.h
index c4fe81f..8ebd3f57 100644
--- a/arch/mips/include/asm/octeon/octeon-feature.h
+++ b/arch/mips/include/asm/octeon/octeon-feature.h
@@ -46,8 +46,6 @@ enum octeon_feature {
 	OCTEON_FEATURE_SAAD,
 	/* Does this Octeon support the ZIP offload engine? */
 	OCTEON_FEATURE_ZIP,
-	/* Does this Octeon support crypto acceleration using COP2? */
-	OCTEON_FEATURE_CRYPTO,
 	OCTEON_FEATURE_DORM_CRYPTO,
 	/* Does this Octeon support PCI express? */
 	OCTEON_FEATURE_PCIE,
@@ -86,6 +84,21 @@ enum octeon_feature {
 	OCTEON_MAX_FEATURE
 };
 
+enum octeon_feature_bits {
+	OCTEON_HAS_CRYPTO = 0x0001,	/* Crypto acceleration using COP2 */
+};
+extern enum octeon_feature_bits __octeon_feature_bits;
+
+/**
+ * octeon_has_crypto() - Check if this OCTEON has crypto acceleration support.
+ *
+ * Returns: Non-zero if the feature exists. Zero if the feature does not exist.
+ */
+static inline int octeon_has_crypto(void)
+{
+	return __octeon_feature_bits & OCTEON_HAS_CRYPTO;
+}
+
 /**
  * Determine if the current Octeon supports a specific feature. These
  * checks have been optimized to be fairly quick, but they should still
-- 
2.2.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaC0JAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 05:00:23 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:40193
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbaC0JAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 05:00:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] regmap: Add REGMAP_ENDIAN_SWAP support for values.
Date: Thu, 27 Mar 2014 16:17:39 +0800
Message-ID: <1395908259-1832-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the following cases of the SoCs using regmap-mmio:

Index   CPU mode   Device mode   Need Bytes Swap ?
--------------------------------------------------
1       LE         LE            No
2       LE         BE            Yes
3       BE         BE            No
4       BE         LE            Yes

And possiblly one Device will be used in all the endianness modes
above with the same device driver, then for the 1 and 3 cases the
REGMAP_ENDIAN_NATIVE is okey, but for the 2 and 4 cases, the
REGMAP_ENDIAN_SWAP is needed.

For the DT node, just one property like 'endian-swap' will be okey
for cases 2 and 4.

----

Certainly, for the 2 case, we can just use REGMAP_ENDIAN_BIG
instead of REGMAP_ENDIAN_SWAP, and then we should add one DT node
property like 'big-endian'.

While for the 4 case, we can just use REGMAP_ENDIAN_LITTLE instead
of REGMAP_ENDIAN_SWAP, and then we should add one DT node property
like 'little-endian'. Another question is that the
REGMAP_ENDIAN_LITTLE hasn't support by regmap core yet.

And using the REGMAP_ENDIAN_BIG and REGMAP_ENDIAN_LITTLE will make
the driver a bit more complex, and also the usage of it.

Thus using the REGMAP_ENDIAN_SWAP and one DT node property like
'endian-swap' will make the driver more easy to develop and to use
for all the above possible cases.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regmap.c | 56 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h       |  1 +
 2 files changed, 57 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 6a19515..71e0a0d 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -192,6 +192,14 @@ static void regmap_format_16_be(void *buf, unsigned int val, unsigned int shift)
 	b[0] = cpu_to_be16(val << shift);
 }
 
+static void regmap_format_16_swap(void *buf, unsigned int val,
+				  unsigned int shift)
+{
+	__u16 *b = buf;
+
+	b[0] = __swab16(val << shift);
+}
+
 static void regmap_format_16_native(void *buf, unsigned int val,
 				    unsigned int shift)
 {
@@ -216,6 +224,14 @@ static void regmap_format_32_be(void *buf, unsigned int val, unsigned int shift)
 	b[0] = cpu_to_be32(val << shift);
 }
 
+static void regmap_format_32_swap(void *buf, unsigned int val,
+				  unsigned int shift)
+{
+	__u32 *b = buf;
+
+	b[0] = __swab32(val << shift);
+}
+
 static void regmap_format_32_native(void *buf, unsigned int val,
 				    unsigned int shift)
 {
@@ -240,6 +256,13 @@ static unsigned int regmap_parse_16_be(const void *buf)
 	return be16_to_cpu(b[0]);
 }
 
+static unsigned int regmap_parse_16_swap(const void *buf)
+{
+	const __u16 *b = buf;
+
+	return __swab16(b[0]);
+}
+
 static void regmap_parse_16_be_inplace(void *buf)
 {
 	__be16 *b = buf;
@@ -247,6 +270,13 @@ static void regmap_parse_16_be_inplace(void *buf)
 	b[0] = be16_to_cpu(b[0]);
 }
 
+static void regmap_parse_16_swap_inplace(void *buf)
+{
+	__u16 *b = buf;
+
+	b[0] = __swab16(b[0]);
+}
+
 static unsigned int regmap_parse_16_native(const void *buf)
 {
 	return *(u16 *)buf;
@@ -269,6 +299,13 @@ static unsigned int regmap_parse_32_be(const void *buf)
 	return be32_to_cpu(b[0]);
 }
 
+static unsigned int regmap_parse_32_swap(const void *buf)
+{
+	const __u32 *b = buf;
+
+	return __swab32((b[0]));
+}
+
 static void regmap_parse_32_be_inplace(void *buf)
 {
 	__be32 *b = buf;
@@ -276,6 +313,13 @@ static void regmap_parse_32_be_inplace(void *buf)
 	b[0] = be32_to_cpu(b[0]);
 }
 
+static void regmap_parse_32_swap_inplace(void *buf)
+{
+	__u32 *b = buf;
+
+	b[0] = __swab32(b[0]);
+}
+
 static unsigned int regmap_parse_32_native(const void *buf)
 {
 	return *(u32 *)buf;
@@ -585,6 +629,12 @@ struct regmap *regmap_init(struct device *dev,
 			map->format.parse_val = regmap_parse_16_be;
 			map->format.parse_inplace = regmap_parse_16_be_inplace;
 			break;
+		case REGMAP_ENDIAN_SWAP:
+			map->format.format_val = regmap_format_16_swap;
+			map->format.parse_val = regmap_parse_16_swap;
+			map->format.parse_inplace =
+					regmap_parse_16_swap_inplace;
+			break;
 		case REGMAP_ENDIAN_NATIVE:
 			map->format.format_val = regmap_format_16_native;
 			map->format.parse_val = regmap_parse_16_native;
@@ -606,6 +656,12 @@ struct regmap *regmap_init(struct device *dev,
 			map->format.parse_val = regmap_parse_32_be;
 			map->format.parse_inplace = regmap_parse_32_be_inplace;
 			break;
+		case REGMAP_ENDIAN_SWAP:
+			map->format.format_val = regmap_format_32_swap;
+			map->format.parse_val = regmap_parse_32_swap;
+			map->format.parse_inplace =
+					regmap_parse_32_swap_inplace;
+			break;
 		case REGMAP_ENDIAN_NATIVE:
 			map->format.format_val = regmap_format_32_native;
 			map->format.parse_val = regmap_parse_32_native;
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 4149f1a..a2e68f3 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -56,6 +56,7 @@ enum regmap_endian {
 	REGMAP_ENDIAN_DEFAULT = 0,
 	REGMAP_ENDIAN_BIG,
 	REGMAP_ENDIAN_LITTLE,
+	REGMAP_ENDIAN_SWAP,
 	REGMAP_ENDIAN_NATIVE,
 };
 
-- 
1.8.4



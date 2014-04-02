Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbaDBKxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 06:53:33 -0400
Received: from [216.32.181.185] ([216.32.181.185]:48293 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758509AbaDBKxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 06:53:31 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 1/3] regmap: implement LE formatting/parsing for 16/32-bit values.
Date: Wed, 2 Apr 2014 18:09:07 +0800
Message-ID: <1396433349-31470-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1396433349-31470-1-git-send-email-Li.Xiubo@freescale.com>
References: <1396433349-31470-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow busses to request little endianness formatting and
parsing for 16- and 32-bit values. This will be useful to
support regmap-mmio.

For the following the scenarios using the regmap-mmio,
for example:

Index    CPU       Device     Endianess flag for values
----------------------------------------------------------
1        LE        LE         REGMAP_ENDIAN_DEFAULT/NATIVE
2        LE        BE         REGMAP_ENDIAN_BIG
3        BE        BE         REGMAP_ENDIAN_DEFAULT/NATIVE
4        BE        LE         REGMAP_ENDIAN_LITTLE

For one device driver, which will support all the cases above,
needs two boolean properties in DT node like: 'big-endian'
for case 2 and 'little-endian' for case 4, and for cases 1
and 3 they all will be absent.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regmap.c | 52 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 6a19515..8e8cea1 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -192,6 +192,13 @@ static void regmap_format_16_be(void *buf, unsigned int val, unsigned int shift)
 	b[0] = cpu_to_be16(val << shift);
 }
 
+static void regmap_format_16_le(void *buf, unsigned int val, unsigned int shift)
+{
+	__le16 *b = buf;
+
+	b[0] = cpu_to_le16(val << shift);
+}
+
 static void regmap_format_16_native(void *buf, unsigned int val,
 				    unsigned int shift)
 {
@@ -216,6 +223,13 @@ static void regmap_format_32_be(void *buf, unsigned int val, unsigned int shift)
 	b[0] = cpu_to_be32(val << shift);
 }
 
+static void regmap_format_32_le(void *buf, unsigned int val, unsigned int shift)
+{
+	__le32 *b = buf;
+
+	b[0] = cpu_to_le32(val << shift);
+}
+
 static void regmap_format_32_native(void *buf, unsigned int val,
 				    unsigned int shift)
 {
@@ -240,6 +254,13 @@ static unsigned int regmap_parse_16_be(const void *buf)
 	return be16_to_cpu(b[0]);
 }
 
+static unsigned int regmap_parse_16_le(const void *buf)
+{
+	const __le16 *b = buf;
+
+	return le16_to_cpu(b[0]);
+}
+
 static void regmap_parse_16_be_inplace(void *buf)
 {
 	__be16 *b = buf;
@@ -247,6 +268,13 @@ static void regmap_parse_16_be_inplace(void *buf)
 	b[0] = be16_to_cpu(b[0]);
 }
 
+static void regmap_parse_16_le_inplace(void *buf)
+{
+	__le16 *b = buf;
+
+	b[0] = le16_to_cpu(b[0]);
+}
+
 static unsigned int regmap_parse_16_native(const void *buf)
 {
 	return *(u16 *)buf;
@@ -269,6 +297,13 @@ static unsigned int regmap_parse_32_be(const void *buf)
 	return be32_to_cpu(b[0]);
 }
 
+static unsigned int regmap_parse_32_le(const void *buf)
+{
+	const __le32 *b = buf;
+
+	return le32_to_cpu(b[0]);
+}
+
 static void regmap_parse_32_be_inplace(void *buf)
 {
 	__be32 *b = buf;
@@ -276,6 +311,13 @@ static void regmap_parse_32_be_inplace(void *buf)
 	b[0] = be32_to_cpu(b[0]);
 }
 
+static void regmap_parse_32_le_inplace(void *buf)
+{
+	__le32 *b = buf;
+
+	b[0] = le32_to_cpu(b[0]);
+}
+
 static unsigned int regmap_parse_32_native(const void *buf)
 {
 	return *(u32 *)buf;
@@ -585,6 +627,11 @@ struct regmap *regmap_init(struct device *dev,
 			map->format.parse_val = regmap_parse_16_be;
 			map->format.parse_inplace = regmap_parse_16_be_inplace;
 			break;
+		case REGMAP_ENDIAN_LITTLE:
+			map->format.format_val = regmap_format_16_le;
+			map->format.parse_val = regmap_parse_16_le;
+			map->format.parse_inplace = regmap_parse_16_le_inplace;
+			break;
 		case REGMAP_ENDIAN_NATIVE:
 			map->format.format_val = regmap_format_16_native;
 			map->format.parse_val = regmap_parse_16_native;
@@ -606,6 +653,11 @@ struct regmap *regmap_init(struct device *dev,
 			map->format.parse_val = regmap_parse_32_be;
 			map->format.parse_inplace = regmap_parse_32_be_inplace;
 			break;
+		case REGMAP_ENDIAN_LITTLE:
+			map->format.format_val = regmap_format_32_le;
+			map->format.parse_val = regmap_parse_32_le;
+			map->format.parse_inplace = regmap_parse_32_le_inplace;
+			break;
 		case REGMAP_ENDIAN_NATIVE:
 			map->format.format_val = regmap_format_32_native;
 			map->format.parse_val = regmap_parse_32_native;
-- 
1.8.4



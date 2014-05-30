Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaE3FfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:35:08 -0400
Received: from ns.horizon.com ([71.41.210.147]:15642 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751209AbaE3FfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:35:06 -0400
Date: 30 May 2014 01:35:05 -0400
Message-ID: <20140530053505.18155.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: davem@davemloft.net, dborkman@redhat.com
Subject: [PATCH 1/3] lib: crc32: Greatly shrink CRC combining code
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need for a full 32x32 matrix, when rows before the last are
just shifted copies of the rows after them.

There's still room for improvement (especially on X86 processors with
CRC32 and PCLMUL instructions), but this is a large step in the
right direction.

The internal primitive is now called crc32_generic_shift and takes one
less argument; the XOR with crc2 is done in inline wrappers.

Signed-off-by: George Spelvin <linux@horizon.com>
---
This is the significant patch; there other two patches are minor
cleanups that I did while in the area.

Tested extensively in user-space (the "power" variable is identical
to the last row of the current even/odd matrix in the previous code)
and with CONFIG_CRC32_SELFTEST:

[    0.587152] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
[    0.587186] crc32: self tests passed, processed 225944 bytes in 115727 nsec
[    0.587341] crc32c: CRC_LE_BITS = 64
[    0.587373] crc32c: self tests passed, processed 225944 bytes in 59505 nsec
[    0.596827] crc32_combine: 8373 self tests passed
[    0.606259] crc32c_combine: 8373 self tests passed

Code shrunk; comments increased to match.
Pulling 2x32x32 bits = 256 bytes off the stack is a nice bonus.

 include/linux/crc32.h |  12 ++++-
 lib/crc32.c           | 142 +++++++++++++++++++++++---------------------------
 2 files changed, 76 insertions(+), 78 deletions(-)

diff --git a/include/linux/crc32.h b/include/linux/crc32.h
index 7d275c4f..bcb8e9d3 100644
--- a/include/linux/crc32.h
+++ b/include/linux/crc32.h
@@ -29,7 +29,11 @@ extern u32  crc32_be(u32 crc, unsigned char const *p, size_t len);
  * 	   with the same initializer as crc1, and crc2 seed was 0. See
  * 	   also crc32_combine_test().
  */
-extern u32  crc32_le_combine(u32 crc1, u32 crc2, size_t len2);
+u32  crc32_le_shift(u32 crc, size_t len) __attribute_const__;
+static inline u32  crc32_le_combine(u32 crc1, u32 crc2, size_t len2)
+{
+	return crc32_le_shift(crc1, len2) ^ crc2;
+}
 
 extern u32  __crc32c_le(u32 crc, unsigned char const *p, size_t len);
 
@@ -51,7 +55,11 @@ extern u32  __crc32c_le(u32 crc, unsigned char const *p, size_t len);
  * 	   seeded with the same initializer as crc1, and crc2 seed
  * 	   was 0. See also crc32c_combine_test().
  */
-extern u32  __crc32c_le_combine(u32 crc1, u32 crc2, size_t len2);
+u32  __crc32c_le_shift(u32 crc, size_t len) __attribute_const__;
+static inline u32  __crc32c_le_combine(u32 crc1, u32 crc2, size_t len2)
+{
+	return __crc32c_le_shift(crc1, len2) ^ crc2;
+}
 
 #define crc32(seed, data, length)  crc32_le(seed, (unsigned char const *)(data), length)
 
diff --git a/lib/crc32.c b/lib/crc32.c
index 70f00ca5..a4a576f3 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -50,29 +50,6 @@ MODULE_AUTHOR("Matt Domsch <Matt_Domsch@dell.com>");
 MODULE_DESCRIPTION("Various CRC32 calculations");
 MODULE_LICENSE("GPL");
 
-#define GF2_DIM		32
-
-static u32 gf2_matrix_times(u32 *mat, u32 vec)
-{
-	u32 sum = 0;
-
-	while (vec) {
-		if (vec & 1)
-			sum ^= *mat;
-		vec >>= 1;
-		mat++;
-	}
-
-	return sum;
-}
-
-static void gf2_matrix_square(u32 *square, u32 *mat)
-{
-	int i;
-
-	for (i = 0; i < GF2_DIM; i++)
-		square[i] = gf2_matrix_times(mat, mat[i]);
-}
 
 #if CRC_LE_BITS > 8 || CRC_BE_BITS > 8
 
@@ -155,51 +132,6 @@ crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 }
 #endif
 
-/* For conditions of distribution and use, see copyright notice in zlib.h */
-static u32 crc32_generic_combine(u32 crc1, u32 crc2, size_t len2,
-				 u32 polynomial)
-{
-	u32 even[GF2_DIM]; /* Even-power-of-two zeros operator */
-	u32 odd[GF2_DIM];  /* Odd-power-of-two zeros operator  */
-	u32 row;
-	int i;
-
-	if (len2 <= 0)
-		return crc1;
-
-	/* Put operator for one zero bit in odd */
-	odd[0] = polynomial;
-	row = 1;
-	for (i = 1; i < GF2_DIM; i++) {
-		odd[i] = row;
-		row <<= 1;
-	}
-
-	gf2_matrix_square(even, odd); /* Put operator for two zero bits in even */
-	gf2_matrix_square(odd, even); /* Put operator for four zero bits in odd */
-
-	/* Apply len2 zeros to crc1 (first square will put the operator for one
-	 * zero byte, eight zero bits, in even).
-	 */
-	do {
-		/* Apply zeros operator for this bit of len2 */
-		gf2_matrix_square(even, odd);
-		if (len2 & 1)
-			crc1 = gf2_matrix_times(even, crc1);
-		len2 >>= 1;
-		/* If no more bits set, then done */
-		if (len2 == 0)
-			break;
-		/* Another iteration of the loop with odd and even swapped */
-		gf2_matrix_square(odd, even);
-		if (len2 & 1)
-			crc1 = gf2_matrix_times(odd, crc1);
-		len2 >>= 1;
-	} while (len2 != 0);
-
-	crc1 ^= crc2;
-	return crc1;
-}
 
 /**
  * crc32_le_generic() - Calculate bitwise little-endian Ethernet AUTODIN II
@@ -271,19 +203,77 @@ u32 __pure __crc32c_le(u32 crc, unsigned char const *p, size_t len)
 			(const u32 (*)[256])crc32ctable_le, CRC32C_POLY_LE);
 }
 #endif
-u32 __pure crc32_le_combine(u32 crc1, u32 crc2, size_t len2)
+EXPORT_SYMBOL(crc32_le);
+EXPORT_SYMBOL(__crc32c_le);
+
+/*
+ * This multiplies the polynomials x and y modulo the given modulus.
+ * This follows the "little-endian" CRC convention that the lsbit
+ * represents the highest power of x, and the msbit represents x^0.
+ */
+static u32 __attribute_const__ gf2_multiply(u32 x, u32 y, u32 modulus)
 {
-	return crc32_generic_combine(crc1, crc2, len2, CRCPOLY_LE);
+	int i;
+	u32 product = x & 1 ? y : 0;
+
+	for (i = 0; i < 31; i++) {
+		product = (product >> 1) ^ (product & 1 ? modulus : 0);
+		x >>= 1;
+		product ^= x & 1 ? y : 0;
+	}
+	return product;
 }
 
-u32 __pure __crc32c_le_combine(u32 crc1, u32 crc2, size_t len2)
+/**
+ * crc32_generic_shift - Append len 0 bytes to crc, in logarithmic time
+ * @crc: The original little-endian CRC (i.e. lsbit is x^31 coefficient)
+ * @len: The number of bytes.  @crc is multiplied by x^(8*@len)
+ # @polynomial: The modulus used to reduce the result to 32 bits.
+ *
+ * It's possible to parallelize CRC computations by computing a CRC
+ * over separate ranges of a buffer, then summing them.
+ * This shifts the given CRC by 8*len bits (i.e. produces the same effect
+ * as appending len bytes of zero to the data), in time proportional
+ * to log(len).
+ */
+static u32 __attribute_const__ crc32_generic_shift(u32 crc, size_t len,
+				 u32 polynomial)
 {
-	return crc32_generic_combine(crc1, crc2, len2, CRC32C_POLY_LE);
+	u32 power = polynomial;	/* CRC of x^32 */
+	int i;
+
+	/* Shift up to 32 bits in the simple linear way */
+	for (i = 0; i < 8*(int)(len & 3); i++)
+		crc = (crc >> 1) ^ (crc & 1 ? polynomial : 0);
+	len >>= 2;
+	if (!len)
+		return crc;
+
+	for (;;) {
+		/* "power" is x^(2^i), modulo the polynomial */
+		if (len & 1)
+			crc = gf2_multiply(crc, power, polynomial);
+		len >>= 1;
+		if (!len)
+			break;
+		/* Square power, advancing to x^(2^(i+1)) */
+		power = gf2_multiply(power, power, polynomial);
+	}
+	return crc;
 }
-EXPORT_SYMBOL(crc32_le);
-EXPORT_SYMBOL(crc32_le_combine);
-EXPORT_SYMBOL(__crc32c_le);
-EXPORT_SYMBOL(__crc32c_le_combine);
+
+u32 crc32_le_shift(u32 crc, size_t len)
+{
+	return crc32_generic_shift(crc, len, CRCPOLY_LE);
+}
+
+u32 __crc32c_le_shift(u32 crc, size_t len)
+{
+	return crc32_generic_shift(crc, len, CRC32C_POLY_LE);
+}
+
+EXPORT_SYMBOL(crc32_le_shift);
+EXPORT_SYMBOL(__crc32c_le_shift);
 
 /**
  * crc32_be_generic() - Calculate bitwise big-endian Ethernet AUTODIN II CRC32
-- 
1.9.2


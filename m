Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab3LKQtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:49:42 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:36372 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3LKQtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:49:35 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [RFC 1/2] CRC32 Add GenWQE CRC to kernel CRC code
Date: Wed, 11 Dec 2013 17:49:22 +0100
Message-Id: <1386780563-1722-1-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1386592244-2521-7-git-send-email-haver@linux.vnet.ibm.com>
References: <1386592244-2521-7-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121116-5024-0000-0000-0000081D4D0F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our GenWQE driver is using a CRC32 polynom, which as far as I could
see, no one else is using in the kernel. In its original version we
implemented our own CRC32, but I think it is nicer to use the common
code as suggested by Greg.

I did not want to add yet another crc32g_table and waste (1KiB) memory
when no one else is using it. I tried to externalize the
crc32init_be_generic and crc32_be_generic functions. I failed. The
crc32init* I found is used to autogenerate code can is itself not part
of the resulting kernel.

As result I gave up on that approach and just added the GenWQE special
polynom in addition to the other 3 crc tables. I wanted to figure out
if it is possible in principle to use the generic code.

Is the consumption of 1KiB for a little table justifyable if it 
currently has just one user?

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 include/linux/crc32.h |    2 	2 +	0 -	0 !
 lib/crc32.c           |   10 	10 +	0 -	0 !
 lib/crc32defs.h       |    5 	5 +	0 -	0 !
 lib/gen_crc32table.c  |   39 	31 +	8 -	0 !
 4 files changed, 48 insertions(+), 8 deletions(-)

--- a/include/linux/crc32.h
+++ b/include/linux/crc32.h
@@ -11,6 +11,8 @@
 extern u32  crc32_le(u32 crc, unsigned char const *p, size_t len);
 extern u32  crc32_be(u32 crc, unsigned char const *p, size_t len);
 
+extern u32  __crc32g_be(u32 crc, unsigned char const *p, size_t len);
+
 /**
  * crc32_le_combine - Combine two crc32 check values into one. For two
  * 		      sequences of bytes, seq1 and seq2 with lengths len1
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -339,14 +339,24 @@ u32 __pure crc32_be(u32 crc, unsigned ch
 {
 	return crc32_be_generic(crc, p, len, NULL, CRCPOLY_BE);
 }
+u32 __pure __crc32g_be(u32 crc, unsigned char const *p, size_t len)
+{
+	return crc32_be_generic(crc, p, len, NULL, CRC32G_POLY_BE);
+}
 #else
 u32 __pure crc32_be(u32 crc, unsigned char const *p, size_t len)
 {
 	return crc32_be_generic(crc, p, len,
 			(const u32 (*)[256])crc32table_be, CRCPOLY_BE);
 }
+u32 __pure __crc32g_be(u32 crc, unsigned char const *p, size_t len)
+{
+	return crc32_be_generic(crc, p, len,
+			(const u32 (*)[256])crc32gtable_be, CRC32G_POLY_BE);
+}
 #endif
 EXPORT_SYMBOL(crc32_be);
+EXPORT_SYMBOL(__crc32g_be);
 
 #ifdef CONFIG_CRC32_SELFTEST
 
--- a/lib/crc32defs.h
+++ b/lib/crc32defs.h
@@ -13,6 +13,11 @@
  */
 #define CRC32C_POLY_LE 0x82F63B78
 
+/*
+ * This is the CRC32g polynomial, used by the GenWQE driver.
+ */
+#define CRC32G_POLY_BE 0x20044009
+
 /* Try to choose an implementation variant via Kconfig */
 #ifdef CONFIG_CRC32_SLICEBY8
 # define CRC_LE_BITS 64
--- a/lib/gen_crc32table.c
+++ b/lib/gen_crc32table.c
@@ -24,6 +24,7 @@
 static uint32_t crc32table_le[LE_TABLE_ROWS][256];
 static uint32_t crc32table_be[BE_TABLE_ROWS][256];
 static uint32_t crc32ctable_le[LE_TABLE_ROWS][256];
+static uint32_t crc32gtable_be[BE_TABLE_ROWS][256];
 
 /**
  * crc32init_le() - allocate and initialize LE table data
@@ -65,29 +66,40 @@ static void crc32cinit_le(void)
 }
 
 /**
- * crc32init_be() - allocate and initialize BE table data
+ * crc32init_be_generic() - allocate and initialize BE table data
  */
-static void crc32init_be(void)
+static void crc32init_be_generic(const uint32_t polynomial,
+				 uint32_t (*tab)[256])
 {
 	unsigned i, j;
 	uint32_t crc = 0x80000000;
 
-	crc32table_be[0][0] = 0;
+	tab[0][0] = 0;
 
 	for (i = 1; i < BE_TABLE_SIZE; i <<= 1) {
-		crc = (crc << 1) ^ ((crc & 0x80000000) ? CRCPOLY_BE : 0);
+		crc = (crc << 1) ^ ((crc & 0x80000000) ? polynomial : 0);
 		for (j = 0; j < i; j++)
-			crc32table_be[0][i + j] = crc ^ crc32table_be[0][j];
+			tab[0][i + j] = crc ^ tab[0][j];
 	}
 	for (i = 0; i < BE_TABLE_SIZE; i++) {
-		crc = crc32table_be[0][i];
+		crc = tab[0][i];
 		for (j = 1; j < BE_TABLE_ROWS; j++) {
-			crc = crc32table_be[0][(crc >> 24) & 0xff] ^ (crc << 8);
-			crc32table_be[j][i] = crc;
+			crc = tab[0][(crc >> 24) & 0xff] ^ (crc << 8);
+			tab[j][i] = crc;
 		}
 	}
 }
 
+static void crc32init_be(void)
+{
+	crc32init_be_generic(CRCPOLY_BE, crc32table_be);
+}
+
+static void crc32ginit_be(void)
+{
+	crc32init_be_generic(CRC32G_POLY_BE, crc32gtable_be);
+}
+
 static void output_table(uint32_t (*table)[256], int rows, int len, char *trans)
 {
 	int i, j;
@@ -126,6 +138,7 @@ int main(int argc, char** argv)
 			     BE_TABLE_SIZE, "tobe");
 		printf("};\n");
 	}
+
 	if (CRC_LE_BITS > 1) {
 		crc32cinit_le();
 		printf("static u32 __cacheline_aligned "
@@ -136,5 +149,15 @@ int main(int argc, char** argv)
 		printf("};\n");
 	}
 
+	if (CRC_BE_BITS > 1) {
+		crc32ginit_be();
+		printf("static u32 __cacheline_aligned "
+		       "crc32gtable_be[%d][%d] = {",
+		       BE_TABLE_ROWS, BE_TABLE_SIZE);
+		output_table(crc32gtable_be, LE_TABLE_ROWS,
+			     BE_TABLE_SIZE, "tobe");
+		printf("};\n");
+	}
+
 	return 0;
 }


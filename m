Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaEREA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 00:00:28 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:51917 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaEREAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 00:00:12 -0400
From: David Matlack <matlackdavid@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, liodot@gmail.com,
        charrer@alacritech.com, David Matlack <matlackdavid@gmail.com>
Subject: [PATCH 1/2] staging: slicoss: rewrite eeprom checksum code
Date: Sat, 17 May 2014 21:00:03 -0700
Message-Id: <1400385604-21086-2-git-send-email-matlackdavid@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400385604-21086-1-git-send-email-matlackdavid@gmail.com>
References: <1400385604-21086-1-git-send-email-matlackdavid@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite slic_eeprom_cksum() to fix bugs and make readable. The original
implementation had the following issues:

  1. 2 of the 3 unrolled loops had the following bug:

       while ((len -= 32) >= 0) {
               [...]
               sum += w[15];
               w = (u16 *)((ulong) w + 16);    /* verify */
       }

     This processes 32-bytes of data but only increments the word
     pointer by 16 bytes. Fixing both of these bugs seems to fix
     slic_eeprom_cksum().

  2. Non-descriptive variable names, use of unions, and macros that
     change local state make the code difficult to read.

  3. The checksum loop is unrolled which makes the code harder to
     reason about while providing small performance improvement:
      - max eeprom length is 0x80 bytes (MAX_EECODE_SIZE), that's
        only 0x40 iterations
      - checksum is only computed during pci probe(), so not very
        often

Tested on Mojave card. Also tested against the old implementation
(with the above bug fix applied) with test data.

Signed-off-by: David Matlack <matlackdavid@gmail.com>
---
 drivers/staging/slicoss/slicoss.c | 137 +++++++++++++-------------------------
 1 file changed, 46 insertions(+), 91 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index dba6a00..d3fe8a7 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -1137,106 +1137,61 @@ static int slic_config_get(struct adapter *adapter, u32 config, u32 config_h)
 				0, 0);
 }
 
+static inline u16 __reduce(u32 checksum)
+{
+	u16 lower_16 = checksum & 0xFFFF;
+	u16 upper_16 = (checksum >> 16) & 0xFFFF;
+
+	checksum = lower_16 + upper_16;
+
+	if (checksum > 65535)
+		checksum -= 65535;
+
+	return checksum;
+}
+
 /*
- *  this is here to checksum the eeprom, there is some ucode bug
- *  which prevens us from using the ucode result.
- *  remove this once ucode is fixed.
+ * Compute a checksum of the eeprom. There is a firmware bug that prevents
+ * us from using the firmware result. Remove this once firmware is fixed.
+ *
+ * This function does not assume the eeprom begins at a word aligned address
+ * or that the length of the eeprom is a multiple of word size. These cases
+ * are handled by treating the leading and trailing byte specially and
+ * conditionally adding them to the checksum at the end.
  */
-static ushort slic_eeprom_cksum(char *m, int len)
+static u16 slic_eeprom_cksum(void *eeprom, unsigned len)
 {
-#define ADDCARRY(x)  (x > 65535 ? x -= 65535 : x)
-#define REDUCE {l_util.l = sum; sum = l_util.s[0] + l_util.s[1]; ADDCARRY(sum);\
-		}
-
-	u16 *w;
-	u32 sum = 0;
-	u32 byte_swapped = 0;
-	u32 w_int;
-
-	union {
-		char c[2];
-		ushort s;
-	} s_util;
-
-	union {
-		ushort s[2];
-		int l;
-	} l_util;
-
-	l_util.l = 0;
-	s_util.s = 0;
-
-	w = (u16 *)m;
-#if BITS_PER_LONG == 64
-	w_int = (u32) ((ulong) w & 0x00000000FFFFFFFF);
-#else
-	w_int = (u32) (w);
-#endif
-	if ((1 & w_int) && (len > 0)) {
-		REDUCE;
-		sum <<= 8;
-		s_util.c[0] = *(unsigned char *)w;
-		w = (u16 *)((char *)w + 1);
-		len--;
-		byte_swapped = 1;
+	u8 *bp = eeprom;
+	u8 *leading_byte = NULL;
+	u8 *trailing_byte = NULL;
+	u16 final_word = 0;
+	u32 checksum = 0;
+
+	if ((unsigned long) eeprom & 1) {
+		leading_byte = bp;
+		bp++;
 	}
 
-	/* Unroll the loop to make overhead from branches &c small. */
-	while ((len -= 32) >= 0) {
-		sum += w[0];
-		sum += w[1];
-		sum += w[2];
-		sum += w[3];
-		sum += w[4];
-		sum += w[5];
-		sum += w[6];
-		sum += w[7];
-		sum += w[8];
-		sum += w[9];
-		sum += w[10];
-		sum += w[11];
-		sum += w[12];
-		sum += w[13];
-		sum += w[14];
-		sum += w[15];
-		w = (u16 *)((ulong) w + 16);	/* verify */
-	}
-	len += 32;
-	while ((len -= 8) >= 0) {
-		sum += w[0];
-		sum += w[1];
-		sum += w[2];
-		sum += w[3];
-		w = (u16 *)((ulong) w + 4);	/* verify */
+	while ((void *) (bp + 1) < eeprom + len) {
+		checksum += *((u16 *) bp);
+		bp += 2;
 	}
-	len += 8;
-	if (len != 0 || byte_swapped != 0) {
-		REDUCE;
-		while ((len -= 2) >= 0)
-			sum += *w++;	/* verify */
-		if (byte_swapped) {
-			REDUCE;
-			sum <<= 8;
-			byte_swapped = 0;
-			if (len == -1) {
-				s_util.c[1] = *(char *) w;
-				sum += s_util.s;
-				len = 0;
-			} else {
-				len = -1;
-			}
 
-		} else if (len == -1) {
-			s_util.c[0] = *(char *) w;
-		}
+	if ((void *) bp < eeprom + len)
+		trailing_byte = bp;
 
-		if (len == -1) {
-			s_util.c[1] = 0;
-			sum += s_util.s;
-		}
+	if (leading_byte) {
+		checksum = __reduce(checksum);
+		checksum <<= 8;
+
+		final_word = *leading_byte;
+		if (trailing_byte)
+			final_word |= *trailing_byte << 8;
+	} else if (trailing_byte) {
+		final_word = *trailing_byte;
 	}
-	REDUCE;
-	return (ushort) sum;
+
+	return __reduce(checksum + final_word);
 }
 
 static void slic_rspqueue_free(struct adapter *adapter)
-- 
1.9.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaETFEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 01:04:36 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:51830 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaETFEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 01:04:34 -0400
From: David Matlack <matlackdavid@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, liodot@gmail.com,
        charrer@alacritech.com, dan.carpenter@oracle.com,
        David Matlack <matlackdavid@gmail.com>
Subject: [PATCH V2 1/2] staging: slicoss: fix eeprom checksum code
Date: Mon, 19 May 2014 22:03:59 -0700
Message-Id: <1400562240-15159-2-git-send-email-matlackdavid@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400562240-15159-1-git-send-email-matlackdavid@gmail.com>
References: <1400562240-15159-1-git-send-email-matlackdavid@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite slic_eeprom_cksum() to fix bugs and make readable. This patch
technically has no effect on the user as failed eeprom checksums are
ignored anyway.

The original implementation had the following issues:

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

Tested on Mojave card

Signed-off-by: David Matlack <matlackdavid@gmail.com>
---
 drivers/staging/slicoss/slicoss.c | 110 ++++++--------------------------------
 1 file changed, 15 insertions(+), 95 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index dba6a00..9eb2434 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -1138,105 +1138,26 @@ static int slic_config_get(struct adapter *adapter, u32 config, u32 config_h)
 }
 
 /*
- *  this is here to checksum the eeprom, there is some ucode bug
- *  which prevens us from using the ucode result.
- *  remove this once ucode is fixed.
+ * Compute a checksum of the EEPROM according to RFC 1071.
  */
-static ushort slic_eeprom_cksum(char *m, int len)
+static u16 slic_eeprom_cksum(void *eeprom, unsigned len)
 {
-#define ADDCARRY(x)  (x > 65535 ? x -= 65535 : x)
-#define REDUCE {l_util.l = sum; sum = l_util.s[0] + l_util.s[1]; ADDCARRY(sum);\
-		}
+	u16 *wp = eeprom;
+	u32 checksum = 0;
 
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
+	while (len > 1) {
+		checksum += *(wp++);
+		len -= 2;
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
-	}
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
+	if (len > 0)
+		checksum += *(u8 *) wp;
 
-		} else if (len == -1) {
-			s_util.c[0] = *(char *) w;
-		}
 
-		if (len == -1) {
-			s_util.c[1] = 0;
-			sum += s_util.s;
-		}
-	}
-	REDUCE;
-	return (ushort) sum;
+	while (checksum >> 16)
+		checksum = (checksum & 0xFFFF) + ((checksum >> 16) & 0xFFFF);
+
+	return ~checksum;
 }
 
 static void slic_rspqueue_free(struct adapter *adapter)
@@ -2893,9 +2814,8 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
 			/*
 			    calculate the EEPROM checksum
 			*/
-			calc_chksum =
-			    ~slic_eeprom_cksum((char *) peeprom,
-					       (eecodesize - 2));
+			calc_chksum = slic_eeprom_cksum(peeprom,
+							eecodesize - 2);
 			/*
 			    if the ucdoe chksum flag bit worked,
 			    we wouldn't need this
-- 
1.9.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab3JSQ0B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 12:26:01 -0400
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:34012 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab3JSQ0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 12:26:00 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] vsprintf: add Bluetooth UUID %pU[rR] format specifier
Date: Sat, 19 Oct 2013 09:25:49 -0700
Message-Id: <1382199949-26779-1-git-send-email-marcel@holtmann.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Bluetooth UUID is used in big endian reversed order. Add new
modifier to print a UUID in big endian, but where the input byte
stream is actually in reversed order.

This is similar to %pMR that allows to print a MAC address in
reversed order since that is how the Bluetooth BD_ADDR is
actually represented in a byte stream.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 Documentation/printk-formats.txt |  6 ++++++
 lib/vsprintf.c                   | 20 +++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 445ad74..1fd0e43 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -159,12 +159,18 @@ UUID/GUID addresses:
 	%pUB	00010203-0405-0607-0809-0A0B0C0D0E0F
 	%pUl	03020100-0504-0706-0809-0a0b0c0e0e0f
 	%pUL	03020100-0504-0706-0809-0A0B0C0E0E0F
+	%pUr	0f0e0d0c-0b0a-0908-0706-050403020100
+	%pUR	0F0E0D0C-0B0A-0908-0706-050403020100
 
 	For printing 16-byte UUID/GUIDs addresses. The additional 'l', 'L',
 	'b' and 'B' specifiers are used to specify a little endian order in
 	lower ('l') or upper case ('L') hex characters - and big endian order
 	in lower ('b') or upper case ('B') hex characters.
 
+	The additional 'r' and 'R' specifiers are used to specify reversed
+	big endian order in either lower ('r') or upper case ('R') hex
+	characters. This is useful for Bluetooth UUID addresses.
+
 	Where no additional specifiers are used the default little endian
 	order with lower case hex characters will be printed.
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 26559bd..ea9b76c 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1106,6 +1106,7 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 	static const u8 le[16] = {3,2,1,0,5,4,7,6,8,9,10,11,12,13,14,15};
 	const u8 *index = be;
 	bool uc = false;
+	bool reversed = false;
 
 	switch (*(++fmt)) {
 	case 'L':
@@ -1116,10 +1117,19 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 	case 'B':
 		uc = true;
 		break;
+	case 'R':
+		uc = true;		/* fall-through */
+	case 'r':
+		reversed = true;
+		break;
 	}
 
 	for (i = 0; i < 16; i++) {
-		p = hex_byte_pack(p, addr[index[i]]);
+		if (reversed)
+			p = hex_byte_pack(p, addr[index[15 - i]]);
+		else
+			p = hex_byte_pack(p, addr[index[i]]);
+
 		switch (i) {
 		case 3:
 		case 5:
@@ -1199,10 +1209,14 @@ int kptr_restrict __read_mostly;
  *         B big endian UPPER case hex
  *         l little endian lower case hex
  *         L little endian UPPER case hex
+ *         r big endian lower case hex, reverse order (Bluetooth)
+ *         R big endian UPPER case hex, reverse order (Bluetooth)
  *           big endian output byte order is:
  *             [0][1][2][3]-[4][5]-[6][7]-[8][9]-[10][11][12][13][14][15]
  *           little endian output byte order is:
  *             [3][2][1][0]-[5][4]-[7][6]-[8][9]-[10][11][12][13][14][15]
+ *           big endian, reverse order output byte order is:
+ *             [15][14][13][12]-[11][10]-[9][8]-[7][6]-[5][4][3][2][1][0]
  * - 'V' For a struct va_format which contains a format string * and va_list *,
  *       call vsnprintf(->format, *->va_list).
  *       Implements a "recursive vsnprintf".
@@ -1572,8 +1586,8 @@ qualifier:
  * %pI6c print an IPv6 address as specified by RFC 5952
  * %pIS depending on sa_family of 'struct sockaddr *' print IPv4/IPv6 address
  * %piS depending on sa_family of 'struct sockaddr *' print IPv4/IPv6 address
- * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
- *   case.
+ * %pU[bBlLrR] print a UUID/GUID in big or little endian or reversed order
+ *   big endian using lower or upper case.
  * %*ph[CDN] a variable-length hex string with a separator (supports up to 64
  *           bytes of the input)
  * %n is ignored
-- 
1.8.3.1


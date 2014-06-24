Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaFXLOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:14:37 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50813 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaFXLOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:14:36 -0400
Date: Tue, 24 Jun 2014 12:14:26 +0100
From: Daniel Walter <dwalter@google.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: james.hogan@imgtec.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] arch/mips/rb532: replace mac_addr parsing
Message-ID: <20140624111426.GA15160@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace parse_mac_addr with mac_pton().


Signed-off-by: Daniel Walter <dwalter@google.com>
---
Changes since v2
  Use mac_pton() instead of sscanf()
  added error handling in case could not be parsed
---
Patch applies against current linux-git
---
 arch/mips/rb532/devices.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)
---
diff --git a/arch/mips/rb532/devices.c b/arch/mips/rb532/devices.c
index 3af00b2..03a4cdc 100644
--- a/arch/mips/rb532/devices.c
+++ b/arch/mips/rb532/devices.c
@@ -250,28 +250,6 @@ static struct platform_device *rb532_devs[] = {
 	&rb532_wdt
 };
 
-static void __init parse_mac_addr(char *macstr)
-{
-	int i, h, l;
-
-	for (i = 0; i < 6; i++) {
-		if (i != 5 && *(macstr + 2) != ':')
-			return;
-
-		h = hex_to_bin(*macstr++);
-		if (h == -1)
-			return;
-
-		l = hex_to_bin(*macstr++);
-		if (l == -1)
-			return;
-
-		macstr++;
-		korina_dev0_data.mac[i] = (h << 4) + l;
-	}
-}
-
-
 /* NAND definitions */
 #define NAND_CHIP_DELAY 25
 
@@ -333,7 +311,10 @@ static int __init plat_setup_devices(void)
 static int __init setup_kmac(char *s)
 {
 	printk(KERN_INFO "korina mac = %s\n", s);
-	parse_mac_addr(s);
+	if (!mac_pton(s, korina_dev0_data.mac)) {
+		printk(KERN_ERR "Invalid mac\n");
+		return -EINVAL;
+	}
 	return 0;
 }
 

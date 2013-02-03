Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab3BCPBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:01:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34618 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755058Ab3BCO6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:25 -0500
Message-Id: <20130203144654.098873721@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Feng Jin <joe.jin@oracle.com>, Jean Delvare <khali@linux-fr.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 114/128] drivers/firmware/dmi_scan.c: check dmi version when get system uuid
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenzhong Duan <zhenzhong.duan@oracle.com>

commit f1d8e614d74b09531b9a85e812485340f3df7b1c upstream.

As of version 2.6 of the SMBIOS specification, the first 3 fields of the
UUID are supposed to be little-endian encoded.

Also a minor fix to match variable meaning and mute checkpatch.pl

[akpm@linux-foundation.org: tweak code comment]
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Feng Jin <joe.jin@oracle.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/firmware/dmi_scan.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index b298158..3714e3c 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -16,6 +16,7 @@
  */
 static char dmi_empty_string[] = "        ";
 
+static u16 __initdata dmi_ver;
 /*
  * Catch too early calls to dmi_check_system():
  */
@@ -161,8 +162,10 @@ static void __init dmi_save_uuid(const struct dmi_header *dm, int slot, int inde
 		return;
 
 	for (i = 0; i < 16 && (is_ff || is_00); i++) {
-		if(d[i] != 0x00) is_ff = 0;
-		if(d[i] != 0xFF) is_00 = 0;
+		if (d[i] != 0x00)
+			is_00 = 0;
+		if (d[i] != 0xFF)
+			is_ff = 0;
 	}
 
 	if (is_ff || is_00)
@@ -172,7 +175,15 @@ static void __init dmi_save_uuid(const struct dmi_header *dm, int slot, int inde
 	if (!s)
 		return;
 
-	sprintf(s, "%pUB", d);
+	/*
+	 * As of version 2.6 of the SMBIOS specification, the first 3 fields of
+	 * the UUID are supposed to be little-endian encoded.  The specification
+	 * says that this is the defacto standard.
+	 */
+	if (dmi_ver >= 0x0206)
+		sprintf(s, "%pUL", d);
+	else
+		sprintf(s, "%pUB", d);
 
         dmi_ident[slot] = s;
 }
@@ -414,6 +425,7 @@ static int __init dmi_present(const char __iomem *p)
 		 * DMI version 0.0 means that the real version is taken from
 		 * the SMBIOS version, which we don't know at this point.
 		 */
+		dmi_ver = (buf[14] & 0xf0) << 4 | (buf[14] & 0x0f);
 		if (buf[14] != 0)
 			printk(KERN_INFO "DMI %d.%d present.\n",
 			       buf[14] >> 4, buf[14] & 0xF);



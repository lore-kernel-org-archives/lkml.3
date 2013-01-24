Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422700Ab3AXVZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:25:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:40809 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757021Ab3AXVQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:16:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Feng Jin <joe.jin@oracle.com>, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Abdallah Chatila <abdallah.chatila@ericsson.com>
Subject: [ 15/22] drivers/firmware/dmi_scan.c: check dmi version when get system uuid
Date: Thu, 24 Jan 2013 13:15:36 -0800
Message-Id: <20130124211509.742785283@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211504.701368763@linuxfoundation.org>
References: <20130124211504.701368763@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Abdallah Chatila <abdallah.chatila@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/dmi_scan.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -16,6 +16,7 @@
  */
 static char dmi_empty_string[] = "        ";
 
+static u16 __initdata dmi_ver;
 /*
  * Catch too early calls to dmi_check_system():
  */
@@ -161,8 +162,10 @@ static void __init dmi_save_uuid(const s
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
@@ -172,7 +175,15 @@ static void __init dmi_save_uuid(const s
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
@@ -414,6 +425,7 @@ static int __init dmi_present(const char
 		 * DMI version 0.0 means that the real version is taken from
 		 * the SMBIOS version, which we don't know at this point.
 		 */
+		dmi_ver = (buf[14] & 0xf0) << 4 | (buf[14] & 0x0f);
 		if (buf[14] != 0)
 			printk(KERN_INFO "DMI %d.%d present.\n",
 			       buf[14] >> 4, buf[14] & 0xF);



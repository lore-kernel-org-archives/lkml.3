Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945989Ab3AXVbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:31:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:40316 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756964Ab3AXVOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Feng Jin <joe.jin@oracle.com>, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Abdallah Chatila <abdallah.chatila@ericsson.com>
Subject: [ 33/46] drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exists
Date: Thu, 24 Jan 2013 13:13:11 -0800
Message-Id: <20130124211148.271382224@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenzhong Duan <zhenzhong.duan@oracle.com>

commit 9f9c9cbb60576a1518d0bf93fb8e499cffccf377 upstream.

The right dmi version is in SMBIOS if it's zero in DMI region

This issue was originally found from an oracle bug.
One customer noticed system UUID doesn't match between dmidecode & uek2.

 - HP ProLiant BL460c G6 :
   # cat /sys/devices/virtual/dmi/id/product_uuid
   00000000-0000-4C48-3031-4D5030333531
   # dmidecode | grep -i uuid
   UUID: 00000000-0000-484C-3031-4D5030333531

>From SMBIOS 2.6 on, spec use little-endian encoding for UUID other than
network byte order.

So we need to get dmi version to distinguish.  If version is 0.0, the
real version is taken from the SMBIOS version.  This is part of original
kernel comment in code.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: Feng Jin <joe.jin@oracle.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Abdallah Chatila <abdallah.chatila@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/dmi_scan.c |   62 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 15 deletions(-)

--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -119,12 +119,12 @@ static int __init dmi_walk_early(void (*
 	return 0;
 }
 
-static int __init dmi_checksum(const u8 *buf)
+static int __init dmi_checksum(const u8 *buf, u8 len)
 {
 	u8 sum = 0;
 	int a;
 
-	for (a = 0; a < 15; a++)
+	for (a = 0; a < len; a++)
 		sum += buf[a];
 
 	return sum == 0;
@@ -415,30 +415,57 @@ static int __init dmi_present(const char
 	u8 buf[15];
 
 	memcpy_fromio(buf, p, 15);
-	if ((memcmp(buf, "_DMI_", 5) == 0) && dmi_checksum(buf)) {
+	if (dmi_checksum(buf, 15)) {
 		dmi_num = (buf[13] << 8) | buf[12];
 		dmi_len = (buf[7] << 8) | buf[6];
 		dmi_base = (buf[11] << 24) | (buf[10] << 16) |
 			(buf[9] << 8) | buf[8];
 
-		/*
-		 * DMI version 0.0 means that the real version is taken from
-		 * the SMBIOS version, which we don't know at this point.
-		 */
-		dmi_ver = (buf[14] & 0xf0) << 4 | (buf[14] & 0x0f);
-		if (buf[14] != 0)
-			printk(KERN_INFO "DMI %d.%d present.\n",
-			       buf[14] >> 4, buf[14] & 0xF);
-		else
-			printk(KERN_INFO "DMI present.\n");
 		if (dmi_walk_early(dmi_decode) == 0) {
+			if (dmi_ver)
+				pr_info("SMBIOS %d.%d present.\n",
+				       dmi_ver >> 8, dmi_ver & 0xFF);
+			else {
+				dmi_ver = (buf[14] & 0xF0) << 4 |
+					   (buf[14] & 0x0F);
+				pr_info("Legacy DMI %d.%d present.\n",
+				       dmi_ver >> 8, dmi_ver & 0xFF);
+			}
 			dmi_dump_ids();
 			return 0;
 		}
 	}
+	dmi_ver = 0;
 	return 1;
 }
 
+static int __init smbios_present(const char __iomem *p)
+{
+	u8 buf[32];
+	int offset = 0;
+
+	memcpy_fromio(buf, p, 32);
+	if ((buf[5] < 32) && dmi_checksum(buf, buf[5])) {
+		dmi_ver = (buf[6] << 8) + buf[7];
+
+		/* Some BIOS report weird SMBIOS version, fix that up */
+		switch (dmi_ver) {
+		case 0x021F:
+		case 0x0221:
+			pr_debug("SMBIOS version fixup(2.%d->2.%d)\n",
+			       dmi_ver & 0xFF, 3);
+			dmi_ver = 0x0203;
+			break;
+		case 0x0233:
+			pr_debug("SMBIOS version fixup(2.%d->2.%d)\n", 51, 6);
+			dmi_ver = 0x0206;
+			break;
+		}
+		offset = 16;
+	}
+	return dmi_present(buf + offset);
+}
+
 void __init dmi_scan_machine(void)
 {
 	char __iomem *p, *q;
@@ -456,7 +483,7 @@ void __init dmi_scan_machine(void)
 		if (p == NULL)
 			goto error;
 
-		rc = dmi_present(p + 0x10); /* offset of _DMI_ string */
+		rc = smbios_present(p);
 		dmi_iounmap(p, 32);
 		if (!rc) {
 			dmi_available = 1;
@@ -474,7 +501,12 @@ void __init dmi_scan_machine(void)
 			goto error;
 
 		for (q = p; q < p + 0x10000; q += 16) {
-			rc = dmi_present(q);
+			if (memcmp(q, "_SM_", 4) == 0 && q - p <= 0xFFE0)
+				rc = smbios_present(q);
+			else if (memcmp(q, "_DMI_", 5) == 0)
+				rc = dmi_present(q);
+			else
+				continue;
 			if (!rc) {
 				dmi_available = 1;
 				dmi_iounmap(p, 0x10000);



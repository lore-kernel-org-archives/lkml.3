Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbaA1NGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 08:06:45 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:54412 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaA1NG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 08:06:28 -0500
From: Michel Lespinasse <walken@google.com>
To: Mike Waychison <mikew@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Tom Gundersen <teg@jklm.no>
Subject: [PATCH 2/2] drivers-firmware: google memconsole driver fixes
Date: Tue, 28 Jan 2014 05:06:22 -0800
Message-Id: <1390914382-3285-3-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390914382-3285-1-git-send-email-walken@google.com>
References: <1390914382-3285-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The google memconsole driver is currently broken upstream, as it tries
to read memory that is described as reserved in /proc/iomem, by
dereferencing a pointer obtained through phys_to_virt(). This triggers
a kernel fault as such regions are unmapped after early boot.

The proper workaround is to use ioremap_cache() / iounmap() around such
accesses.

As some unrelated changes, I also converted some printks to use pr_info()
and added some missing __init annotations.

Tested: booted dbg build, verified I could read /sys/firmware/log

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 drivers/firmware/google/memconsole.c | 47 ++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/firmware/google/memconsole.c b/drivers/firmware/google/memconsole.c
index 2a90ba613613..2f569aaed4c7 100644
--- a/drivers/firmware/google/memconsole.c
+++ b/drivers/firmware/google/memconsole.c
@@ -15,6 +15,7 @@
 #include <linux/kobject.h>
 #include <linux/module.h>
 #include <linux/dmi.h>
+#include <linux/io.h>
 #include <asm/bios_ebda.h>
 
 #define BIOS_MEMCONSOLE_V1_MAGIC	0xDEADBABE
@@ -41,15 +42,25 @@ struct biosmemcon_ebda {
 	};
 } __packed;
 
-static char *memconsole_baseaddr;
+static u32 memconsole_baseaddr;
 static size_t memconsole_length;
 
 static ssize_t memconsole_read(struct file *filp, struct kobject *kobp,
 			       struct bin_attribute *bin_attr, char *buf,
 			       loff_t pos, size_t count)
 {
-	return memory_read_from_buffer(buf, count, &pos, memconsole_baseaddr,
-				       memconsole_length);
+	char *memconsole;
+	ssize_t ret;
+
+	memconsole = ioremap_cache(memconsole_baseaddr, memconsole_length);
+	if (!memconsole) {
+		pr_err("memconsole: ioremap_cache failed\n");
+		return -ENOMEM;
+	}
+	ret = memory_read_from_buffer(buf, count, &pos, memconsole,
+				      memconsole_length);
+	iounmap(memconsole);
+	return ret;
 }
 
 static struct bin_attribute memconsole_bin_attr = {
@@ -58,43 +69,42 @@ static struct bin_attribute memconsole_bin_attr = {
 };
 
 
-static void found_v1_header(struct biosmemcon_ebda *hdr)
+static void __init found_v1_header(struct biosmemcon_ebda *hdr)
 {
-	printk(KERN_INFO "BIOS console v1 EBDA structure found at %p\n", hdr);
-	printk(KERN_INFO "BIOS console buffer at 0x%.8x, "
+	pr_info("BIOS console v1 EBDA structure found at %p\n", hdr);
+	pr_info("BIOS console buffer at 0x%.8x, "
 	       "start = %d, end = %d, num = %d\n",
 	       hdr->v1.buffer_addr, hdr->v1.start,
 	       hdr->v1.end, hdr->v1.num_chars);
 
 	memconsole_length = hdr->v1.num_chars;
-	memconsole_baseaddr = phys_to_virt(hdr->v1.buffer_addr);
+	memconsole_baseaddr = hdr->v1.buffer_addr;
 }
 
-static void found_v2_header(struct biosmemcon_ebda *hdr)
+static void __init found_v2_header(struct biosmemcon_ebda *hdr)
 {
-	printk(KERN_INFO "BIOS console v2 EBDA structure found at %p\n", hdr);
-	printk(KERN_INFO "BIOS console buffer at 0x%.8x, "
+	pr_info("BIOS console v2 EBDA structure found at %p\n", hdr);
+	pr_info("BIOS console buffer at 0x%.8x, "
 	       "start = %d, end = %d, num_bytes = %d\n",
 	       hdr->v2.buffer_addr, hdr->v2.start,
 	       hdr->v2.end, hdr->v2.num_bytes);
 
 	memconsole_length = hdr->v2.end - hdr->v2.start;
-	memconsole_baseaddr = phys_to_virt(hdr->v2.buffer_addr
-					   + hdr->v2.start);
+	memconsole_baseaddr = hdr->v2.buffer_addr + hdr->v2.start;
 }
 
 /*
  * Search through the EBDA for the BIOS Memory Console, and
  * set the global variables to point to it.  Return true if found.
  */
-static bool found_memconsole(void)
+static bool __init found_memconsole(void)
 {
 	unsigned int address;
 	size_t length, cur;
 
 	address = get_bios_ebda();
 	if (!address) {
-		printk(KERN_INFO "BIOS EBDA non-existent.\n");
+		pr_info("BIOS EBDA non-existent.\n");
 		return false;
 	}
 
@@ -122,7 +132,7 @@ static bool found_memconsole(void)
 		}
 	}
 
-	printk(KERN_INFO "BIOS console EBDA structure not found!\n");
+	pr_info("BIOS console EBDA structure not found!\n");
 	return false;
 }
 
@@ -139,8 +149,6 @@ MODULE_DEVICE_TABLE(dmi, memconsole_dmi_table);
 
 static int __init memconsole_init(void)
 {
-	int ret;
-
 	if (!dmi_check_system(memconsole_dmi_table))
 		return -ENODEV;
 
@@ -148,10 +156,7 @@ static int __init memconsole_init(void)
 		return -ENODEV;
 
 	memconsole_bin_attr.size = memconsole_length;
-
-	ret = sysfs_create_bin_file(firmware_kobj, &memconsole_bin_attr);
-
-	return ret;
+	return sysfs_create_bin_file(firmware_kobj, &memconsole_bin_attr);
 }
 
 static void __exit memconsole_exit(void)
-- 
1.8.5.3

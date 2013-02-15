Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab3BOUft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:35:49 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:47498 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3BOUfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:35:47 -0500
MIME-Version: 1.0
Date: Fri, 15 Feb 2013 12:35:46 -0800
Message-ID: <CAJ7m5OqYv_=JB9NhHsqBsa8YU0DFRoP7C+W10PY22wonAGJK=A@mail.gmail.com>
Subject: [PATCH] phram: Allow the user to set the erase page size.
From: "Patrick O'Grady" <patrick@baymotion.com>
To: Joern Engel <joern@lazybastard.org>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick O'Grady <patrick@baymotion.com>

Permit the user to specify the erase page size as a parameter.
This solves two problems:

- phram can access images made by mkfs.jffs2.  mkfs.jffs2 won't
create images with erase sizes less than 8KiB; many architectures
define PAGE_SIZE as 4KiB.

- Allows more effective use of small capacity devices.  JFFS2
needs somewhere between 2 and 5 empty pages for garbage collection;
and for an NVRAM part with only 32KiB of space, a smaller erase page
allows much better utilization in applications where garbage collection
is important.

Signed-off-by: Patrick O'Grady <patrick@baymotion.com>
---
diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
index 67823de..5eee2a6 100644
--- a/drivers/mtd/devices/phram.c
+++ b/drivers/mtd/devices/phram.c
@@ -5,14 +5,15 @@
  * Usage:
  *
  * one commend line parameter per device, each in the form:
- *   phram=<name>,<start>,<len>
+ *   phram=<name>,<start>,<len>[,<erasesize>]
  * <name> may be up to 63 characters.
- * <start> and <len> can be octal, decimal or hexadecimal.  If followed
- * by "ki", "Mi" or "Gi", the numbers will be interpreted as kilo, mega or
- * gigabytes.
+ * <start>, <len>, and <erasesize> can be octal, decimal or
+ * hexadecimal.  If followed by "ki", "Mi" or "Gi", the numbers
+ * will be interpreted as kilo, mega or gigabytes.  <erasesize>
+ * is optional and defaults to PAGE_SIZE.
  *
  * Example:
- * phram=swap,64Mi,128Mi phram=test,900Mi,1Mi
+ * phram=swap,64Mi,128Mi phram=test,900Mi,1Mi,64Ki
  */

 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -94,7 +95,8 @@ static void unregister_devices(void)
    }
 }

-static int register_device(char *name, unsigned long start, unsigned long len)
+static int register_device(char *name, unsigned long start,
+       unsigned long len, unsigned long erasesize)
 {
    struct phram_mtd_list *new;
    int ret = -ENOMEM;
@@ -121,7 +123,7 @@ static int register_device(char *name, unsigned
long start, unsigned long len)
    new->mtd._write = phram_write;
    new->mtd.owner = THIS_MODULE;
    new->mtd.type = MTD_RAM;
-   new->mtd.erasesize = PAGE_SIZE;
+   new->mtd.erasesize = erasesize;
    new->mtd.writesize = 1;

    ret = -EAGAIN;
@@ -207,21 +209,22 @@ static inline void kill_final_newline(char *str)

 /*
  * This shall contain the module parameter if any. It is of the form:
- * - phram=<device>,<address>,<size> for module case
- * - phram.phram=<device>,<address>,<size> for built-in case
- * We leave 64 bytes for the device name, 12 for the address and 12 for the
- * size.
- * Example: phram.phram=rootfs,0xa0000000,512Mi
+ * - phram=<device>,<address>,<size>[,<erasesize>] for module case
+ * - phram.phram=<device>,<address>,<size>[,<erasesize>] for built-in case
+ * We leave 64 bytes for the device name, 12 for the address, 12 for the
+ * size, and 12 for the erasesize.
+ * Example: phram.phram=rootfs,0xa0000000,512Mi,65536
  */
 static __initdata char phram_paramline[64+12+12];

 static int __init phram_setup(const char *val)
 {
-   char buf[64+12+12], *str = buf;
+   char buf[64+12+12+12], *str = buf;
    char *token[3];
    char *name;
    uint32_t start;
    uint32_t len;
+   uint32_t erasesize = PAGE_SIZE ;
    int i, ret;

    if (strnlen(val, sizeof(buf)) >= sizeof(buf))
@@ -230,7 +233,7 @@ static int __init phram_setup(const char *val)
    strcpy(str, val);
    kill_final_newline(str);

-   for (i=0; i<3; i++)
+   for (i = 0; i < 4; i++)
        token[i] = strsep(&str, ",");

    if (str)
@@ -255,7 +258,15 @@ static int __init phram_setup(const char *val)
        parse_err("illegal device length\n");
    }

-   ret = register_device(name, start, len);
+   if (token[3]) {
+       ret = parse_num32(&erasesize, token[3]);
+       if (ret) {
+           kfree(name);
+           parse_err("illegal erase size\n");
+       }
+   }
+
+   ret = register_device(name, start, len, erasesize);
    if (!ret)
        pr_info("%s device: %#x at %#x\n", name, len, start);
    else
@@ -278,7 +289,7 @@ static int __init phram_param_call(const char
*val, struct kernel_param *kp)
 }

 module_param_call(phram, phram_param_call, NULL, NULL, 000);
-MODULE_PARM_DESC(phram, "Memory region to map.
\"phram=<name>,<start>,<length>\"");
+MODULE_PARM_DESC(phram, "Memory region to map.
\"phram=<name>,<start>,<length>[,<erasesize>]\"");


 static int __init init_phram(void)

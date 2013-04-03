Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763272Ab3DCTQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:16:24 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:41674 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763214Ab3DCTQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:16:20 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org
Cc: rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, davem@davemloft.net, lethal@linux-sh.org,
        vgupta@synopsys.com, chris@zankel.net, cmetcalf@tilera.com,
        ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn, jdike@addtoit.com,
        Tejun Heo <tj@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 4/7] dmi: morph dmi_dump_ids() into dmi_format_ids() which formats into a buffer
Date: Wed,  3 Apr 2013 12:14:54 -0700
Message-Id: <1365016497-32033-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365016497-32033-1-git-send-email-tj@kernel.org>
References: <1365016497-32033-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're gonna use DMI identification for other purposes too.  Morph
dmi_dump_ids() which is used to print DMI identification as a debug
message during boot into dmi_format_ids() which formats the same
information sans the leading "DMI:" tag into a string buffer.

dmi_present() is updated to format the information into
dmi_ids_string[] using the new function and print it with "DMI:"
prefix.  dmi_ids_string[] will be used for another purpose by a future
patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/firmware/dmi_scan.c | 44 +++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 40e940d..5022307 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -22,6 +22,9 @@ static u16 __initdata dmi_ver;
  */
 static int dmi_initialized;
 
+/* DMI system identification string used during boot */
+static char dmi_ids_string[128] __initdata;
+
 static const char * __init dmi_string_nosave(const struct dmi_header *dm, u8 s)
 {
 	const u8 *bp = ((u8 *) dm) + dm->length;
@@ -376,38 +379,44 @@ static void __init dmi_decode(const struct dmi_header *dm, void *dummy)
 	}
 }
 
-static void __init print_filtered(const char *info)
+static int __init print_filtered(char *buf, size_t len, const char *info)
 {
+	int c = 0;
 	const char *p;
 
 	if (!info)
-		return;
+		return c;
 
 	for (p = info; *p; p++)
 		if (isprint(*p))
-			printk(KERN_CONT "%c", *p);
+			c += scnprintf(buf + c, len - c, "%c", *p);
 		else
-			printk(KERN_CONT "\\x%02x", *p & 0xff);
+			c += scnprintf(buf + c, len - c, "\\x%02x", *p & 0xff);
+	return c;
 }
 
-static void __init dmi_dump_ids(void)
+static void __init dmi_format_ids(char *buf, size_t len)
 {
+	int c = 0;
 	const char *board;	/* Board Name is optional */
 
-	printk(KERN_DEBUG "DMI: ");
-	print_filtered(dmi_get_system_info(DMI_SYS_VENDOR));
-	printk(KERN_CONT " ");
-	print_filtered(dmi_get_system_info(DMI_PRODUCT_NAME));
+	c += print_filtered(buf + c, len - c,
+			    dmi_get_system_info(DMI_SYS_VENDOR));
+	c += scnprintf(buf + c, len - c, " ");
+	c += print_filtered(buf + c, len - c,
+			    dmi_get_system_info(DMI_PRODUCT_NAME));
+
 	board = dmi_get_system_info(DMI_BOARD_NAME);
 	if (board) {
-		printk(KERN_CONT "/");
-		print_filtered(board);
+		c += scnprintf(buf + c, len - c, "/");
+		c += print_filtered(buf + c, len - c, board);
 	}
-	printk(KERN_CONT ", BIOS ");
-	print_filtered(dmi_get_system_info(DMI_BIOS_VERSION));
-	printk(KERN_CONT " ");
-	print_filtered(dmi_get_system_info(DMI_BIOS_DATE));
-	printk(KERN_CONT "\n");
+	c += scnprintf(buf + c, len - c, ", BIOS ");
+	c += print_filtered(buf + c, len - c,
+			    dmi_get_system_info(DMI_BIOS_VERSION));
+	c += scnprintf(buf + c, len - c, " ");
+	c += print_filtered(buf + c, len - c,
+			    dmi_get_system_info(DMI_BIOS_DATE));
 }
 
 static int __init dmi_present(const u8 *buf)
@@ -454,7 +463,8 @@ static int __init dmi_present(const u8 *buf)
 				pr_info("Legacy DMI %d.%d present.\n",
 				       dmi_ver >> 8, dmi_ver & 0xFF);
 			}
-			dmi_dump_ids();
+			dmi_format_ids(dmi_ids_string, sizeof(dmi_ids_string));
+			printk(KERN_DEBUG "DMI: %s\n", dmi_ids_string);
 			return 0;
 		}
 	}
-- 
1.8.1.4


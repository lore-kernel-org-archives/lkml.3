Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3AWS7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 13:59:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:64910 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab3AWS7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 13:59:33 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] mtd: fix random pointer dereference in OF device name handling
Date: Wed, 23 Jan 2013 13:59:08 -0500
Message-Id: <1358967548-25491-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the output from an mpc8548 based board.  There are
three instances of missing device name here:

1 |: Found 4 x16 devices at 0x0 in 32-bit bank. Manufacturer ID 0x008989 Chip ID 0x001818
2 |Intel/Sharp Extended Query Table at 0x0031
3 |Intel/Sharp Extended Query Table at 0x0031
4 |Using buffer write method
5 |cfi_cmdset_0001: Erase suspend on write enabled
6 |2 ofpart partitions found on MTD device
7 |Creating 2 MTD partitions on "":
8 |0x000000000000-0x000003f00000 : "space"
9 |0x000003f00000-0x000004000000 : "bootloader"

Lines 1 (BOL), 6 (EOL) and 7 (inside quotes) have the missing
device name issue.

Problem introduced with commit d68cbdd4fb04d2b756ad53c22f36943167b16340
"mtd: physmap_of: allow to specify the mtd name for retro compatiblity"

There are actually two bugs here.  The 1st is that mtd_name
is on the stack and never initialized.  It uses a call to
of_property_read_string() to get the pointer.  However this
function is explicitly documented as saying that the char
"...pointer is modified only if a valid string can be decoded."

Hence it isn't NULL, and we use a pointer off in the weeds as
the device name, leading to undefined behaviour.

The second issue is in the NULL check itself.  It uses a "?"
operator to choose between mtd_name and the devicetree based
name.  But the operator isn't given two choices.  One choice
(mtd_name) is missing from the RHS of the "?".

With these fixed, the output appears as follows:

1 |fc000000.flash: Found 4 x16 devices at 0x0 in 32-bit bank. Manufacturer ID 0x008989 Chip ID 0x001818
2 |Intel/Sharp Extended Query Table at 0x0031
3 |Intel/Sharp Extended Query Table at 0x0031
4 |Using buffer write method
5 |cfi_cmdset_0001: Erase suspend on write enabled
6 |2 ofpart partitions found on MTD device fc000000.flash
7 |Creating 2 MTD partitions on "fc000000.flash":
8 |0x000000000000-0x000003f00000 : "space"
9 |0x000003f00000-0x000004000000 : "bootloader"

All the names are now appearing where they should be.

Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[Introduced into mainline at v3.8-rc1~47 ; hence no need for stable Cc]

 drivers/mtd/maps/physmap_of.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
index 67cc73c..a70c1c4 100644
--- a/drivers/mtd/maps/physmap_of.c
+++ b/drivers/mtd/maps/physmap_of.c
@@ -170,7 +170,7 @@ static int of_flash_probe(struct platform_device *dev)
 	resource_size_t res_size;
 	struct mtd_part_parser_data ppdata;
 	bool map_indirect;
-	const char *mtd_name;
+	const char *mtd_name = NULL;
 
 	match = of_match_device(of_flash_match, &dev->dev);
 	if (!match)
@@ -237,7 +237,8 @@ static int of_flash_probe(struct platform_device *dev)
 			goto err_out;
 		}
 
-		info->list[i].map.name = mtd_name ?: dev_name(&dev->dev);
+		info->list[i].map.name = mtd_name ?
+					 mtd_name : dev_name(&dev->dev);
 		info->list[i].map.phys = res.start;
 		info->list[i].map.size = res_size;
 		info->list[i].map.bankwidth = be32_to_cpup(width);
-- 
1.8.1


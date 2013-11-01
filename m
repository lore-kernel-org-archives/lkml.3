Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3KAU7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 16:59:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:8997 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab3KAU7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 16:59:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="383505613"
Message-Id: <27d82dbff5be1025bf18ab88498632d36c2fcf3c.1383331440.git.tony.luck@intel.com>
From: "Luck, Tony" <tony.luck@intel.com>
Subject: [PATCH] dmi: Avoid unaligned memory access in save_mem_devices()
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Chen Gong <gong.chen@linux.intel.com>
Date: Fri, 01 Nov 2013 13:59:52 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firmware is not required to maintain alignment of SMBIOS entries,
so we should take care accessing fields within these structures.
Use "get_unaligned()" to avoid problems.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Ingo: belongs on top of the patches already in x86/mce branch
Found on ia64 (which grumbles about unaligned access)

 drivers/firmware/dmi_scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 59579a744d58..c7e81ff8f3ef 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -8,6 +8,7 @@
 #include <linux/bootmem.h>
 #include <linux/random.h>
 #include <asm/dmi.h>
+#include <asm/unaligned.h>
 
 /*
  * DMI stands for "Desktop Management Interface".  It is part
@@ -347,7 +348,7 @@ static void __init save_mem_devices(const struct dmi_header *dm, void *v)
 		pr_warn(FW_BUG "Too many DIMM entries in SMBIOS table\n");
 		return;
 	}
-	dmi_memdev[nr].handle = dm->handle;
+	dmi_memdev[nr].handle = get_unaligned(&dm->handle);
 	dmi_memdev[nr].device = dmi_string(dm, d[0x10]);
 	dmi_memdev[nr].bank = dmi_string(dm, d[0x11]);
 	nr++;
-- 
1.8.4.1


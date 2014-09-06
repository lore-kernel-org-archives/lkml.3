Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbaIFNDB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 09:03:01 -0400
Received: from mga14.intel.com ([192.55.52.115]:9177 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbaIFNC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 09:02:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="382326269"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: matt.fleming@intel.com
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH v2] efi: Resolve some shadow warnings
Date: Sat,  6 Sep 2014 06:02:53 -0700
Message-Id: <1410008573-444-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

It is a really bad idea to declare variables or parameters that
have the same name as common types. It is valid C, but it gets
surprising if a macro expansion attempts to declare an inner
local with that type. Change the local names to eliminate the
hazard.

Change s16 => str16, s8 => str8.

This resolves warnings seen when using W=2 during make, for instance:

drivers/firmware/efi/vars.c: In function ‘dup_variable_bug’:
drivers/firmware/efi/vars.c:324:44: warning: declaration of ‘s16’ shadows a global declaration [-Wshadow]
 static void dup_variable_bug(efi_char16_t *s16, efi_guid_t *vendor_guid,

drivers/firmware/efi/vars.c:328:8: warning: declaration of ‘s8’ shadows a global declaration [-Wshadow]
  char *s8;

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

v2: Updated patch description to add warning information and modified the
    variable names to str* instead of ps*, based on feed back from Matt
    Fleming

 drivers/firmware/efi/vars.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 5abe943..afa3596 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -321,11 +321,11 @@ static unsigned long var_name_strnsize(efi_char16_t *variable_name,
  * Print a warning when duplicate EFI variables are encountered and
  * disable the sysfs workqueue since the firmware is buggy.
  */
-static void dup_variable_bug(efi_char16_t *s16, efi_guid_t *vendor_guid,
+static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
 			     unsigned long len16)
 {
 	size_t i, len8 = len16 / sizeof(efi_char16_t);
-	char *s8;
+	char *str8;
 
 	/*
 	 * Disable the workqueue since the algorithm it uses for
@@ -334,16 +334,16 @@ static void dup_variable_bug(efi_char16_t *s16, efi_guid_t *vendor_guid,
 	 */
 	efivar_wq_enabled = false;
 
-	s8 = kzalloc(len8, GFP_KERNEL);
-	if (!s8)
+	str8 = kzalloc(len8, GFP_KERNEL);
+	if (!str8)
 		return;
 
 	for (i = 0; i < len8; i++)
-		s8[i] = s16[i];
+		str8[i] = str16[i];
 
 	printk(KERN_WARNING "efivars: duplicate variable: %s-%pUl\n",
-	       s8, vendor_guid);
-	kfree(s8);
+	       str8, vendor_guid);
+	kfree(str8);
 }
 
 /**
-- 
1.9.3


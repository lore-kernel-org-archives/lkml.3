Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab3GQWvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:51:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56341 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933862Ab3GQWv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:51:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>, Matt Fleming <matt.fleming@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 141/145] x86/efi: Fix dummy variable buffer allocation
Date: Wed, 17 Jul 2013 15:47:53 -0700
Message-Id: <1374101277-7915-142-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit b8cb62f82103083a6e8fa5470bfe634a2c06514d upstream.

1. Check for allocation failure
2. Clear the buffer contents, as they may actually be written to flash
3. Don't leak the buffer

Compile-tested only.

[ Tested successfully on my buggy ASUS machine - Matt ]

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/platform/efi/efi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 87e91ba..fe2ac4f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1060,7 +1060,10 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 		 * that by attempting to use more space than is available.
 		 */
 		unsigned long dummy_size = remaining_size + 1024;
-		void *dummy = kmalloc(dummy_size, GFP_ATOMIC);
+		void *dummy = kzalloc(dummy_size, GFP_ATOMIC);
+
+		if (!dummy)
+			return EFI_OUT_OF_RESOURCES;
 
 		status = efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
 					  EFI_VARIABLE_NON_VOLATILE |
@@ -1080,6 +1083,8 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 					 0, dummy);
 		}
 
+		kfree(dummy);
+
 		/*
 		 * The runtime code may now have triggered a garbage collection
 		 * run, so check the variable info again
-- 
1.8.1.2


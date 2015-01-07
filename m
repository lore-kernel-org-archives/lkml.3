Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbbAGK4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:56:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbbAGK4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:56:41 -0500
From: WANG Chao <chaowang@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Borislav Petkov <bp@suse.de>, Daniel Kiper <daniel.kiper@oracle.com>,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE...)
Subject: [PATCH 2/2] x86: add macro for_each_setup_data()
Date: Wed,  7 Jan 2015 18:55:49 +0800
Message-Id: <1420628150-16872-2-git-send-email-chaowang@redhat.com>
In-Reply-To: <1420628150-16872-1-git-send-email-chaowang@redhat.com>
References: <1420628150-16872-1-git-send-email-chaowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A common task for parsing setup_data is to iterate over setup_data's
linked list, remap and do something and unmap. Now add macro
for_each_setup_data() to do that.

Signed-off-by: WANG Chao <chaowang@redhat.com>
---
 arch/x86/kernel/setup.c | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c4648ada..1e24c37 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -424,35 +424,30 @@ static void __init reserve_initrd(void)
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
 
+#define for_each_setup_data(pa_data, data) \
+	for (pa_data = boot_params.hdr.setup_data; \
+		pa_data && (data = early_memremap(pa_data, sizeof(*data))); \
+		pa_data = data->next, early_iounmap(data, sizeof(*data)))
+
 static void __init parse_setup_data(void)
 {
 	struct setup_data *data;
-	u64 pa_data, pa_next;
-
-	pa_data = boot_params.hdr.setup_data;
-	while (pa_data) {
-		u32 data_len, data_type;
-
-		data = early_memremap(pa_data, sizeof(*data));
-		data_len = data->len + sizeof(struct setup_data);
-		data_type = data->type;
-		pa_next = data->next;
-		early_iounmap(data, sizeof(*data));
+	u64 pa_data;
 
-		switch (data_type) {
+	for_each_setup_data(pa_data, data) {
+		switch (data->type) {
 		case SETUP_E820_EXT:
-			parse_e820_ext(pa_data, data_len);
+			parse_e820_ext(pa_data, data->len + sizeof(*data));
 			break;
 		case SETUP_DTB:
 			add_dtb(pa_data);
 			break;
 		case SETUP_EFI:
-			parse_efi_setup(pa_data, data_len);
+			parse_efi_setup(pa_data, data->len + sizeof(*data));
 			break;
 		default:
 			break;
 		}
-		pa_data = pa_next;
 	}
 }
 
@@ -462,14 +457,10 @@ static void __init e820_reserve_setup_data(void)
 	u64 pa_data;
 	int found = 0;
 
-	pa_data = boot_params.hdr.setup_data;
-	while (pa_data) {
-		data = early_memremap(pa_data, sizeof(*data));
+	for_each_setup_data(pa_data, data) {
 		e820_update_range(pa_data, sizeof(*data)+data->len,
 			 E820_RAM, E820_RESERVED_KERN);
 		found = 1;
-		pa_data = data->next;
-		early_iounmap(data, sizeof(*data));
 	}
 	if (!found)
 		return;
@@ -485,12 +476,8 @@ static void __init memblock_x86_reserve_range_setup_data(void)
 	struct setup_data *data;
 	u64 pa_data;
 
-	pa_data = boot_params.hdr.setup_data;
-	while (pa_data) {
-		data = early_memremap(pa_data, sizeof(*data));
+	for_each_setup_data(pa_data, data) {
 		memblock_reserve(pa_data, sizeof(*data) + data->len);
-		pa_data = data->next;
-		early_iounmap(data, sizeof(*data));
 	}
 }
 
-- 
2.1.0


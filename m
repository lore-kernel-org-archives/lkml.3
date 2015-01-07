Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbbAGK4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:56:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbbAGK43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:56:29 -0500
From: WANG Chao <chaowang@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE...)
Subject: [PATCH 1/2] x86: early_memremap exact size of struct setup_data
Date: Wed,  7 Jan 2015 18:55:48 +0800
Message-Id: <1420628150-16872-1-git-send-email-chaowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When early remapping setup_data, we can remap the structure alone, use
sizeof(struct setup_data). No need to remap a larger area, we never
access setup_data->data at that point.

Signed-off-by: WANG Chao <chaowang@redhat.com>
---
 arch/x86/kernel/setup.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ab4734e..c4648ada 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -431,15 +431,13 @@ static void __init parse_setup_data(void)
 
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		u32 data_len, map_len, data_type;
+		u32 data_len, data_type;
 
-		map_len = max(PAGE_SIZE - (pa_data & ~PAGE_MASK),
-			      (u64)sizeof(struct setup_data));
-		data = early_memremap(pa_data, map_len);
+		data = early_memremap(pa_data, sizeof(*data));
 		data_len = data->len + sizeof(struct setup_data);
 		data_type = data->type;
 		pa_next = data->next;
-		early_iounmap(data, map_len);
+		early_iounmap(data, sizeof(*data));
 
 		switch (data_type) {
 		case SETUP_E820_EXT:
-- 
2.1.0


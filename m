Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaDCWVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:21:37 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:52342 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbaDCWRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:50 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 18/20] x86: use libfdt accessors for header data
Date: Thu,  3 Apr 2014 17:17:01 -0500
Message-Id: <1396563423-30893-19-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

With libfdt support, we can take advantage of helper accessors in libfdt
for accessing the FDT header data. This makes the code more readable and
makes the FDT blob structure more opaque to the kernel. This also
prepares for removing struct boot_param_header completely.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/devicetree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index d35078e..f49f57f 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -206,16 +206,15 @@ static void __init dtb_apic_setup(void)
 static void __init x86_flattree_get_config(void)
 {
 	u32 size, map_len;
-	struct boot_param_header *dt;
+	const void *dt;
 
 	if (!initial_dtb)
 		return;
 
-	map_len = max(PAGE_SIZE - (initial_dtb & ~PAGE_MASK),
-			(u64)sizeof(struct boot_param_header));
+	map_len = max(PAGE_SIZE - (initial_dtb & ~PAGE_MASK), FDT_V17_SIZE);
 
 	dt = early_memremap(initial_dtb, map_len);
-	size = be32_to_cpu(dt->totalsize);
+	size = fdt_totalsize(dt);
 	if (map_len < size) {
 		early_iounmap(dt, map_len);
 		dt = early_memremap(initial_dtb, size);
-- 
1.8.3.2


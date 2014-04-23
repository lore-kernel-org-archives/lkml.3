Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbaDWBUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:20:37 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:41307 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbaDWBTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:19:12 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH v2 19/21] x86: use FDT accessors for FDT blob header data
Date: Tue, 22 Apr 2014 20:18:19 -0500
Message-Id: <1398215901-25609-20-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Remove the direct accesses to FDT header data using accessor
function instead. This makes the code more readable and makes the FDT
blob structure more opaque to the arch code. This also prepares for
removing struct boot_param_header completely.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
v2: reworked to use of_get_flat_dt_size helper function

 arch/x86/kernel/devicetree.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index d35078e..7db54b5 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -206,23 +206,21 @@ static void __init dtb_apic_setup(void)
 static void __init x86_flattree_get_config(void)
 {
 	u32 size, map_len;
-	struct boot_param_header *dt;
+	void *dt;
 
 	if (!initial_dtb)
 		return;
 
-	map_len = max(PAGE_SIZE - (initial_dtb & ~PAGE_MASK),
-			(u64)sizeof(struct boot_param_header));
+	map_len = max(PAGE_SIZE - (initial_dtb & ~PAGE_MASK), (u64)128);
 
-	dt = early_memremap(initial_dtb, map_len);
-	size = be32_to_cpu(dt->totalsize);
+	initial_boot_params = dt = early_memremap(initial_dtb, map_len);
+	size = of_get_flat_dt_size();
 	if (map_len < size) {
 		early_iounmap(dt, map_len);
-		dt = early_memremap(initial_dtb, size);
+		initial_boot_params = dt = early_memremap(initial_dtb, size);
 		map_len = size;
 	}
 
-	initial_boot_params = dt;
 	unflatten_and_copy_device_tree();
 	early_iounmap(dt, map_len);
 }
-- 
1.9.1


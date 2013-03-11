Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab3CKE50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 00:57:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49757 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3CKE5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 00:57:25 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86, kdump: Set crashkernel_low automatically
Date: Sun, 10 Mar 2013 21:56:57 -0700
Message-Id: <1362977817-23297-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <513D52BA.3070206@redhat.com>
References: <513D52BA.3070206@redhat.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code does not set low range for crashkernel if the user
does not specify that.

That cause regressions on system that does not support intel_iommu
properly.

Chao said that his system does work well on 3.8 without extra parameter.
even iommu does not work with kdump.

Set crashkernel_low automatically if the user does not specify that.

For system that does support IOMMU with kdump properly, user could
specify crashkernel_low=0 to save that 72M low ram.

Reported-by: WANG Chao <chaowang@redhat.com>
Tested-by: WANG Chao <chaowang@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -547,19 +547,28 @@ static void __init reserve_crashkernel_l
 	unsigned long long low_base = 0, low_size = 0;
 	unsigned long total_low_mem;
 	unsigned long long base;
+	bool auto_set = false;
 	int ret;
 
 	total_low_mem = memblock_mem_size(1UL<<(32-PAGE_SHIFT));
 	ret = parse_crashkernel_low(boot_command_line, total_low_mem,
 						&low_size, &base);
-	if (ret != 0 || low_size <= 0)
-		return;
+	if (ret != 0) {
+		/* default swiotlb size and overflow: 64M + 8M */
+		low_size = 72UL<<20;
+		auto_set = true;
+	} else {
+		/* passed with crashkernel_low=0 ? */
+		if (!low_size)
+			return;
+	}
 
 	low_base = memblock_find_in_range(low_size, (1ULL<<32),
 					low_size, alignment);
 
 	if (!low_base) {
-		pr_info("crashkernel low reservation failed - No suitable area found.\n");
+		if (!auto_set)
+			pr_info("crashkernel low reservation failed - No suitable area found.\n");
 
 		return;
 	}

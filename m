Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab3FEU5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:57:06 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:41045 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab3FEU5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:57:00 -0400
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, Simon Glass <sjg@chromium.org>,
        linux-samsung-soc@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Doug Anderson <dianders@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ARM: exynos: add debug_ll_io_init() call in exynos_init_io()
Date: Wed,  5 Jun 2013 13:56:33 -0700
Message-Id: <1370465793-7997-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1370397539-21653-1-git-send-email-dianders@chromium.org>
References: <1370397539-21653-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the early MMU mapping of the UART happens to get booted out of the
TLB between the start of paging_init() and when we finally re-add the
UART at the very end of s3c_init_cpu(), we'll get a hang at bootup if
we've got early_printk enabled.  Avoid this hang by calling
debug_ll_io_init() early.

Without this patch, you can reliably reproduce a hang when early
printk is enabled by adding flush_tlb_all() at the start of
exynos_init_io().  After this patch the hang goes away.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Use debug_ll_io_init() instead of reordering printks and adding
  warnings.  Thanks Olof!

 arch/arm/mach-exynos/common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 027c9e7..f7e504b 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -386,6 +386,8 @@ int __init exynos_fdt_map_chipid(unsigned long node, const char *uname,
 
 void __init exynos_init_io(struct map_desc *mach_desc, int size)
 {
+	debug_ll_io_init();
+
 #ifdef CONFIG_OF
 	if (initial_boot_params)
 		of_scan_flat_dt(exynos_fdt_map_chipid, NULL);
-- 
1.8.3


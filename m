Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaHBCWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 22:22:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:22444 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbaHBCWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 22:22:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,784,1400050800"; 
   d="scan'208";a="582427286"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, iommu@lists.linux-foundation.org
Subject: [PATCH] iommu/amd: Implement syscore_ops.shutdown()
Date: Sat,  2 Aug 2014 10:25:39 +0800
Message-Id: <1406946339-4297-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140801225049.GC4553@pd.tnic>
References: <20140801225049.GC4553@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During hibernation or shutdown, AMD iommu generates warnings on some
platforms as below:
[   89.089832] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x0000000000000080 flags=0x0020]
[   89.102239] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x0000000000000000 flags=0x0000]
[   89.114684] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[   89.127162] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[   89.139576] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[   89.152017] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[   89.164481] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]

It may be caused by that the firmware takes back the device after the OS
released it and now the legacy emulation tries to do DMA with it. But
since there is an IOMMU the physical addresses it tries to DMA to is
not mapped and it generated IO page faults. So explicitly shutdown
IOMMU units during hibernation or poweroff.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
Hi Borislav,
	Could you please help to verify whether this patch help to minimize
the race window and reduce IOMMU warning messages?
Regards!
Gerry
---
 drivers/iommu/amd_iommu_init.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 0e08545d7298..4d1752fe12e1 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1687,9 +1687,16 @@ static int amd_iommu_suspend(void)
 	return 0;
 }
 
+static void amd_iommu_shutdown(void)
+{
+	/* disable IOMMUs to go out of the way for BIOS */
+	disable_iommus();
+}
+
 static struct syscore_ops amd_iommu_syscore_ops = {
 	.suspend = amd_iommu_suspend,
 	.resume = amd_iommu_resume,
+	.shutdown = amd_iommu_shutdown,
 };
 
 static void __init free_on_init_error(void)
-- 
1.7.10.4


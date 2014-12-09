Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbaLILss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:48:48 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56174 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbaLILsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 06:48:46 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-cb-5486e19cbaa9
Content-transfer-encoding: 8BIT
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] arm64: psci: Fix build breakage without PM_SLEEP
Date: Tue, 09 Dec 2014 12:48:36 +0100
Message-id: <1418125716-18528-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t/xa7pzHraFGGzazmXxflkPo8XrF4YW
	mx5fY7W4vGsOm8Wb3y/YLV5+PMHiwOaxZt4aRo/NS+o9+rasYvT4vEkugCWKyyYlNSezLLVI
	3y6BK2PXghbWgmOcFXd3H2BrYJzJ0cXIySEhYCLx/dYxVghbTOLCvfVsXYxcHEICSxklml8/
	ZQdJ8AoISvyYfI+li5GDg1lAXuLIpWyQMLOAusSkeYuYIer7mCQm9+1mAkmwCRhLbF6+BGyQ
	iMBJRol9q66yQXQYSvx89wdsqLCAo0Tv0g5mEJtFQFVi45WzrBDL3CX+T5rJBnGRnMTJY5NZ
	JzDyzUJyxyyEO2YhuWMBI/MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJDg/LqDcekxq0OM
	AhyMSjy8OxTbQoRYE8uKK3MPMUpwMCuJ8E45ChTiTUmsrEotyo8vKs1JLT7EyMTBKdXAqN48
	6VGsz7vXsmXu/z99tgzZLv13q83m0rvd074flX/39VKnr9Oh5gWP9l7mYUxt/J1tlZDx3uHi
	XP6m+P0/7nf3ZVWrSwjHnVmk8LxEkGnvgcqyWT+vVs6+vOfV0jfatt+rbZr5HnNMc6/u4XPV
	cu5nfZh7VLVVK/O01Gzph0GGAatjLoj0KrEUZyQaajEXFScCAN0zQyUsAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build failure of defconfig when PM_SLEEP is disabled (e.g. by
disabling SUSPEND) and CPU_IDLE enabled:

arch/arm64/kernel/psci.c:543:2: error: unknown field ‘cpu_suspend’ specified in initializer
  .cpu_suspend = cpu_psci_cpu_suspend,
  ^
arch/arm64/kernel/psci.c:543:2: warning: initialization from incompatible pointer type [enabled by default]
arch/arm64/kernel/psci.c:543:2: warning: (near initialization for ‘cpu_psci_ops.cpu_prepare’) [enabled by default]
make[1]: *** [arch/arm64/kernel/psci.o] Error 1

The cpu_operations.cpu_suspend field exists only if ARM64_CPU_SUSPEND is
defined, not CPU_IDLE.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm64/kernel/psci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/psci.c b/arch/arm64/kernel/psci.c
index 3425f311c49e..f1dbca7d5c96 100644
--- a/arch/arm64/kernel/psci.c
+++ b/arch/arm64/kernel/psci.c
@@ -540,6 +540,8 @@ const struct cpu_operations cpu_psci_ops = {
 	.name		= "psci",
 #ifdef CONFIG_CPU_IDLE
 	.cpu_init_idle	= cpu_psci_cpu_init_idle,
+#endif
+#ifdef CONFIG_ARM64_CPU_SUSPEND
 	.cpu_suspend	= cpu_psci_cpu_suspend,
 #endif
 #ifdef CONFIG_SMP
-- 
1.9.1


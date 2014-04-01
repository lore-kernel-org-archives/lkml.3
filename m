Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaDALjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:39:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42613 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaDALSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, Wang Nan <wangnan0@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 106/144] ARM: ignore memory below PHYS_OFFSET
Date: Tue,  1 Apr 2014 12:15:10 +0100
Message-Id: <1396350948-29910-107-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 571b14375019c3a66ef70d4d4a7083f4238aca30 upstream.

If the kernel is loaded higher in physical memory than normal, and we
calculate PHYS_OFFSET higher than the start of RAM, this leads to
boot problems as we attempt to map part of this RAM into userspace.
Rather than struggle with this, just truncate the mapping.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Wang Nan <wangnan0@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/setup.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index f58f646..37ea994 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -656,6 +656,20 @@ int __init arm_add_memory(phys_addr_t start, phys_addr_t size)
 	}
 #endif
 
+	if (aligned_start < PHYS_OFFSET) {
+		if (aligned_start + size <= PHYS_OFFSET) {
+			pr_info("Ignoring memory below PHYS_OFFSET: 0x%08llx-0x%08llx\n",
+				aligned_start, aligned_start + size);
+			return -EINVAL;
+		}
+
+		pr_info("Ignoring memory below PHYS_OFFSET: 0x%08llx-0x%08llx\n",
+			aligned_start, (u64)PHYS_OFFSET);
+
+		size -= PHYS_OFFSET - aligned_start;
+		aligned_start = PHYS_OFFSET;
+	}
+
 	bank->start = aligned_start;
 	bank->size = size & ~(phys_addr_t)(PAGE_SIZE - 1);
 
-- 
1.9.1


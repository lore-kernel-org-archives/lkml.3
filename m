Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbaJ1Lak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:30:40 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:30771 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbaJ1Lah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:30:37 -0400
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <ralf@linux-mips.org>, <Zubair.Kakakhel@imgtec.com>
CC: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] mips: cma: Do not reserve memory if not required
Date: Tue, 28 Oct 2014 11:28:34 +0000
Message-ID: <1414495714-40815-1-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if CMA is disabled, the for_each_memblock macro expands
to run reserve_bootmem once. Hence, reserve_bootmem attempts to
reserve location 0 of size 0.

Add a check to avoid that.

Issue was highlighted during testing with EVA enabled.
resrve_bootmem used to exit gracefully when passed arguments to
reserve 0 size location at 0 without EVA.

But with EVA enabled, macros would point to different addresses
and the code would trigger a BUG.

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
Tested-by: Markos Chandras <markos.chandras@imgtec.com>
---
 arch/mips/kernel/setup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 938f157..eacfd7d 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -683,7 +683,8 @@ static void __init arch_mem_init(char **cmdline_p)
 	dma_contiguous_reserve(PFN_PHYS(max_low_pfn));
 	/* Tell bootmem about cma reserved memblock section */
 	for_each_memblock(reserved, reg)
-		reserve_bootmem(reg->base, reg->size, BOOTMEM_DEFAULT);
+		if (reg->size != 0)
+			reserve_bootmem(reg->base, reg->size, BOOTMEM_DEFAULT);
 }
 
 static void __init resource_init(void)
-- 
1.9.1


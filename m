Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaAOP2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:28:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaAOP2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:28:35 -0500
From: Jerome Marchand <jmarchan@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH] powerpc: mm: fix mmap errno when MAP_FIXED is set and mapping exceeds the allowed address space
Date: Wed, 15 Jan 2014 16:27:11 +0100
Message-Id: <1389799631-3418-1-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Posix, if MAP_FIXED is specified mmap shall set ENOMEM if
the requested mapping exceeds the allowed range for address space of
the process. The generic code set it right, but the specific powerpc
slice_get_unmapped_area() function currently returns -EINVAL in that
case.
This patch corrects it.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 arch/powerpc/mm/slice.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/mm/slice.c b/arch/powerpc/mm/slice.c
index 7ce9cf3..b0c75cc 100644
--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -408,7 +408,7 @@ unsigned long slice_get_unmapped_area(unsigned long addr, unsigned long len,
 	if (fixed && (addr & ((1ul << pshift) - 1)))
 		return -EINVAL;
 	if (fixed && addr > (mm->task_size - len))
-		return -EINVAL;
+		return -ENOMEM;
 
 	/* If hint, make sure it matches our alignment restrictions */
 	if (!fixed && addr) {
-- 
1.7.7.6


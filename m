Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaGHH0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:26:18 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:43116 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaGHH0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:26:07 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Andreas Schwab <schwab@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: Fix boot regression on machines with RAM at non-zero
Date: Tue,  8 Jul 2014 09:25:58 +0200
Message-Id: <1404804358-30299-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My enhancement to store the initial mapping size for later reuse in commit
486df8bc4627bdfc032d11bedcd056cc5343ee62 ("m68k: Increase initial mapping
to 8 or 16 MiB if possible") broke booting on machines where RAM doesn't
start at address zero.

Use pc-relative addressing to fix this.

Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Andreas Schwab <schwab@linux-m68k.org>
---
 arch/m68k/kernel/head.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/kernel/head.S b/arch/m68k/kernel/head.S
index dbb118e1a4e0..a54788458ca3 100644
--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -921,7 +921,8 @@ L(nocon):
 	jls	1f
 	lsrl	#1,%d1
 1:
-	movel	%d1,m68k_init_mapped_size
+	lea	%pc@(m68k_init_mapped_size),%a0
+	movel	%d1,%a0@
 	mmu_map	#PAGE_OFFSET,%pc@(L(phys_kernel_start)),%d1,\
 		%pc@(m68k_supervisor_cachemode)
 
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3IISp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:45:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57046 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3IISpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:45:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 02/24] ARM: Fix FIQ code on VIVT CPUs
Date: Mon,  9 Sep 2013 11:44:52 -0700
Message-Id: <1378752314-2416-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378752314-2416-1-git-send-email-kamal@canonical.com>
References: <1378752314-2416-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 2ba85e7af4c639d933c9a87a6d7363f2983d5ada upstream.

Aaro Koskinen reports the following oops:
Installing fiq handler from c001b110, length 0x164
Unable to handle kernel paging request at virtual address ffff1224
pgd = c0004000
[ffff1224] *pgd=00000000, *pte=11fff0cb, *ppte=11fff00a
...
[<c0013154>] (set_fiq_handler+0x0/0x6c) from [<c0365d38>] (ams_delta_init_fiq+0xa8/0x160)
 r6:00000164 r5:c001b110 r4:00000000 r3:fefecb4c
[<c0365c90>] (ams_delta_init_fiq+0x0/0x160) from [<c0365b14>] (ams_delta_init+0xd4/0x114)
 r6:00000000 r5:fffece10 r4:c037a9e0
[<c0365a40>] (ams_delta_init+0x0/0x114) from [<c03613b4>] (customize_machine+0x24/0x30)

This is because the vectors page is now write-protected, and to change
code in there we must write to its original alias.  Make that change,
and adjust the cache flushing such that the code will become visible
to the instruction stream on VIVT CPUs.

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/kernel/fiq.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 25442f4..fc79202 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -84,17 +84,13 @@ int show_fiq_list(struct seq_file *p, int prec)
 
 void set_fiq_handler(void *start, unsigned int length)
 {
-#if defined(CONFIG_CPU_USE_DOMAINS)
-	void *base = (void *)0xffff0000;
-#else
 	void *base = vectors_page;
-#endif
 	unsigned offset = FIQ_OFFSET;
 
 	memcpy(base + offset, start, length);
+	if (!cache_is_vipt_nonaliasing())
+		flush_icache_range(base + offset, offset + length);
 	flush_icache_range(0xffff0000 + offset, 0xffff0000 + offset + length);
-	if (!vectors_high())
-		flush_icache_range(offset, offset + length);
 }
 
 int claim_fiq(struct fiq_handler *f)
-- 
1.8.1.2


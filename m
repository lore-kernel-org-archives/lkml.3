Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3KKSbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:31:20 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:65276 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab3KKSbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:31:13 -0500
Date: Mon, 11 Nov 2013 19:31:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm changes for v3.13
Message-ID: <20131111183110.GA15907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mm-for-linus

   # HEAD: 6979287a7df66a92d6f308338e972a406f9ef842 x86/mm: Add 'step_size' comments to init_mem_mapping()

One cleanup that documents a particular detail in init_mem_mapping().

 Thanks,

	Ingo

------------------>
Yinghai Lu (1):
      x86/mm: Add 'step_size' comments to init_mem_mapping()


 arch/x86/mm/init.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 04664cd..ce32017 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -399,8 +399,25 @@ static unsigned long __init init_range_memory_mapping(
 	return mapped_ram_size;
 }
 
-/* (PUD_SHIFT-PMD_SHIFT)/2 */
-#define STEP_SIZE_SHIFT 5
+static unsigned long __init get_new_step_size(unsigned long step_size)
+{
+	/*
+	 * Explain why we shift by 5 and why we don't have to worry about
+	 * 'step_size << 5' overflowing:
+	 *
+	 * initial mapped size is PMD_SIZE (2M).
+	 * We can not set step_size to be PUD_SIZE (1G) yet.
+	 * In worse case, when we cross the 1G boundary, and
+	 * PG_LEVEL_2M is not set, we will need 1+1+512 pages (2M + 8k)
+	 * to map 1G range with PTE. Use 5 as shift for now.
+	 *
+	 * Don't need to worry about overflow, on 32bit, when step_size
+	 * is 0, round_down() returns 0 for start, and that turns it
+	 * into 0x100000000ULL.
+	 */
+	return step_size << 5;
+}
+
 void __init init_mem_mapping(void)
 {
 	unsigned long end, real_end, start, last_start;
@@ -449,7 +466,7 @@ void __init init_mem_mapping(void)
 		min_pfn_mapped = last_start >> PAGE_SHIFT;
 		/* only increase step_size after big range get mapped */
 		if (new_mapped_ram_size > mapped_ram_size)
-			step_size <<= STEP_SIZE_SHIFT;
+			step_size = get_new_step_size(step_size);
 		mapped_ram_size += new_mapped_ram_size;
 	}
 

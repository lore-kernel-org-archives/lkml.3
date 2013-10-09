Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab3JIJHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:07:13 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:48611 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab3JIJGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:06:55 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Radu Caragea <sinaelgl@gmail.com>, Michel Lespinasse <walken@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 2/2] s390/mmap: randomize mmap base for bottom up direction
Date: Wed,  9 Oct 2013 11:06:43 +0200
Message-Id: <1381309603-19570-2-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1381309603-19570-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1381309603-19570-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100909-5024-0000-0000-00000774F5D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement mmap base randomization for the bottom up direction, so ASLR works
for both mmap layouts on s390.
See also df54d6fa54 "x86 get_unmapped_area(): use proper mmap base for
bottom-up direction".

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/mm/mmap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index 4002329..7110c0f 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -64,6 +64,11 @@ static unsigned long mmap_rnd(void)
 	return (get_random_int() & 0x7ffUL) << PAGE_SHIFT;
 }
 
+static unsigned long mmap_base_legacy(void)
+{
+	return TASK_UNMAPPED_BASE + mmap_rnd();
+}
+
 static inline unsigned long mmap_base(void)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
@@ -89,7 +94,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 	 * bit is set, or if the expected stack growth is unlimited:
 	 */
 	if (mmap_is_legacy()) {
-		mm->mmap_base = TASK_UNMAPPED_BASE;
+		mm->mmap_base = mmap_base_legacy();
 		mm->get_unmapped_area = arch_get_unmapped_area;
 	} else {
 		mm->mmap_base = mmap_base();
@@ -172,7 +177,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 	 * bit is set, or if the expected stack growth is unlimited:
 	 */
 	if (mmap_is_legacy()) {
-		mm->mmap_base = TASK_UNMAPPED_BASE;
+		mm->mmap_base = mmap_base_legacy();
 		mm->get_unmapped_area = s390_get_unmapped_area;
 	} else {
 		mm->mmap_base = mmap_base();
-- 
1.8.3.4


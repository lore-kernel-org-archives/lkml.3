Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161094AbaDTC2e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 22:28:34 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:57927 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaDTC0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 22:26:52 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org
Cc: zeus@gnu.org, aswin@hp.com, davidlohr@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Dimitri@domain.invalid,
        "Sivanich <sivanich"@sgi.com
Subject: [PATCH 5/6] drivers,sgi-gru/grufault.c: call find_vma with the mmap_sem held
Date: Sat, 19 Apr 2014 19:26:30 -0700
Message-Id: <1397960791-16320-6-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397960791-16320-1-git-send-email-davidlohr@hp.com>
References: <1397960791-16320-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Gonzalez V <zeus@gnu.org>

Performing vma lookups without taking the mm->mmap_sem is asking
for trouble. While doing the search, the vma in question can
be modified or even removed before returning to the caller.
Take the lock in order to avoid races while iterating through
the vmacache and/or rbtree.

This patch is completely *untested*.

Signed-off-by: Jonathan Gonzalez V <zeus@gnu.org>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Dimitri Sivanich <sivanich@sgi.com
---
 drivers/misc/sgi-gru/grufault.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
index f74fc0c..15adc84 100644
--- a/drivers/misc/sgi-gru/grufault.c
+++ b/drivers/misc/sgi-gru/grufault.c
@@ -266,6 +266,7 @@ static int gru_vtop(struct gru_thread_state *gts, unsigned long vaddr,
 	unsigned long paddr;
 	int ret, ps;
 
+	down_write(&mm->mmap_sem);
 	vma = find_vma(mm, vaddr);
 	if (!vma)
 		goto inval;
@@ -277,22 +278,26 @@ static int gru_vtop(struct gru_thread_state *gts, unsigned long vaddr,
 	rmb();	/* Must/check ms_range_active before loading PTEs */
 	ret = atomic_pte_lookup(vma, vaddr, write, &paddr, &ps);
 	if (ret) {
-		if (atomic)
-			goto upm;
+		if (atomic) {
+			up_write(&mm->mmap_sem);
+			return VTOP_RETRY;
+		}
 		if (non_atomic_pte_lookup(vma, vaddr, write, &paddr, &ps))
 			goto inval;
 	}
 	if (is_gru_paddr(paddr))
 		goto inval;
+
+	up_write(&mm->mmap_sem);
+
 	paddr = paddr & ~((1UL << ps) - 1);
 	*gpa = uv_soc_phys_ram_to_gpa(paddr);
 	*pageshift = ps;
 	return VTOP_SUCCESS;
 
 inval:
+	up_write(&mm->mmap_sem);
 	return VTOP_INVALID;
-upm:
-	return VTOP_RETRY;
 }
 
 
-- 
1.8.1.4


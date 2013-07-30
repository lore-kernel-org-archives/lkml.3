Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab3G3Syz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:54:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56549 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab3G3Spe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:45:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 45/75] sparc: tsb must be flushed before tlb
Date: Tue, 30 Jul 2013 11:44:49 -0700
Message-Id: <1375209919-1768-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

commit 23a01138efe216f8084cfaa74b0b90dd4b097441 upstream.

This fixes a race where a cpu may re-load a tlb from a stale tsb right
after it has been flushed by a remote function call.

I still see some instability when stressing the system with parallel
kernel builds while creating memory pressure by writing to
/proc/sys/vm/nr_hugepages, but this patch improves the stability
significantly.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Acked-by: Bob Picco <bob.picco@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/mm/tlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index 83d89bc..37e7bc4 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -85,8 +85,8 @@ static void tlb_batch_add_one(struct mm_struct *mm, unsigned long vaddr,
 	}
 
 	if (!tb->active) {
-		global_flush_tlb_page(mm, vaddr);
 		flush_tsb_user_page(mm, vaddr);
+		global_flush_tlb_page(mm, vaddr);
 		goto out;
 	}
 
-- 
1.8.1.2


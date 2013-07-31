Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab3GaNhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:37:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47066 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759825Ab3GaNZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dave Kleikamp" <dave.kleikamp@oracle.com>,
        "Bob Picco" <bob.picco@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.84316608@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [25/84] sparc: tsb must be flushed before tlb
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/mm/tlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index afd021e..072f553 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -115,8 +115,8 @@ no_cache_flush:
 	}
 
 	if (!tb->active) {
-		global_flush_tlb_page(mm, vaddr);
 		flush_tsb_user_page(mm, vaddr);
+		global_flush_tlb_page(mm, vaddr);
 		goto out;
 	}
 


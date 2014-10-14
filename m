Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbaJNJAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 05:00:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbaJNJAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 05:00:22 -0400
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH] xen: avoid writing to freed memory after race in p2m handling
Date: Tue, 14 Oct 2014 11:00:18 +0200
Message-Id: <1413277218-11437-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case a race was detected during allocation of a new p2m tree
element in alloc_p2m() the new allocated mid_mfn page is freed without
updating the pointer to the found value in the tree. This will result
in overwriting the just freed page with the mfn of the p2m leaf.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/p2m.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 9f5983b..4534320 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -566,6 +566,7 @@ static bool alloc_p2m(unsigned long pfn)
 		/* Separately check the mid mfn level */
 		unsigned long missing_mfn;
 		unsigned long mid_mfn_mfn;
+		unsigned long old_mfn;
 
 		mid_mfn = alloc_p2m_page();
 		if (!mid_mfn)
@@ -575,10 +576,13 @@ static bool alloc_p2m(unsigned long pfn)
 
 		missing_mfn = virt_to_mfn(p2m_mid_missing_mfn);
 		mid_mfn_mfn = virt_to_mfn(mid_mfn);
-		if (cmpxchg(top_mfn_p, missing_mfn, mid_mfn_mfn) != missing_mfn)
+		old_mfn = cmpxchg(top_mfn_p, missing_mfn, mid_mfn_mfn);
+		if (old_mfn != missing_mfn) {
 			free_p2m_page(mid_mfn);
-		else
+			mid_mfn = mfn_to_virt(old_mfn);
+		} else {
 			p2m_top_mfn_p[topidx] = mid_mfn;
+		}
 	}
 
 	if (p2m_top[topidx][mididx] == p2m_identity ||
-- 
1.8.4.5


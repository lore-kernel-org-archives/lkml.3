Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaJQLQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 07:16:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbaJQLQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 07:16:10 -0400
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V2] xen: avoid race in p2m handling
Date: Fri, 17 Oct 2014 13:16:06 +0200
Message-Id: <1413544566-12250-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a new p2m leaf is allocated this leaf is linked into the p2m tree
via cmpxchg. Unfortunately the compare value for checking the success
of the update is read after checking for the need of a new leaf. It is
possible that a new leaf has been linked into the tree concurrently
in between. This could lead to a leaked memory page and to the loss of
some p2m entries.

Avoid the race by using the read compare value for checking the need
of a new p2m leaf and use ACCESS_ONCE() to get it.

There are other places which seem to need ACCESS_ONCE() to ensure
proper operation. Change them accordingly.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/p2m.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index d1b3da2..b456b04 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -532,12 +532,13 @@ static bool alloc_p2m(unsigned long pfn)
 	unsigned topidx, mididx;
 	unsigned long ***top_p, **mid;
 	unsigned long *top_mfn_p, *mid_mfn;
+	unsigned long *p2m_orig;
 
 	topidx = p2m_top_index(pfn);
 	mididx = p2m_mid_index(pfn);
 
 	top_p = &p2m_top[topidx];
-	mid = *top_p;
+	mid = ACCESS_ONCE(*top_p);
 
 	if (mid == p2m_mid_missing) {
 		/* Mid level is missing, allocate a new one */
@@ -552,7 +553,7 @@ static bool alloc_p2m(unsigned long pfn)
 	}
 
 	top_mfn_p = &p2m_top_mfn[topidx];
-	mid_mfn = p2m_top_mfn_p[topidx];
+	mid_mfn = ACCESS_ONCE(p2m_top_mfn_p[topidx]);
 
 	BUG_ON(virt_to_mfn(mid_mfn) != *top_mfn_p);
 
@@ -579,11 +580,10 @@ static bool alloc_p2m(unsigned long pfn)
 		}
 	}
 
-	if (p2m_top[topidx][mididx] == p2m_identity ||
-	    p2m_top[topidx][mididx] == p2m_missing) {
+	p2m_orig = ACCESS_ONCE(p2m_top[topidx][mididx]);
+	if (p2m_orig == p2m_identity || p2m_orig == p2m_missing) {
 		/* p2m leaf page is missing */
 		unsigned long *p2m;
-		unsigned long *p2m_orig = p2m_top[topidx][mididx];
 
 		p2m = alloc_p2m_page();
 		if (!p2m)
-- 
1.8.4.5


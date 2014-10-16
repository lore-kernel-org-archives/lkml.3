Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaJPGN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 02:13:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaJPGNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 02:13:22 -0400
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH] xen: avoid race in p2m handling
Date: Thu, 16 Oct 2014 08:13:17 +0200
Message-Id: <1413439997-32344-1-git-send-email-jgross@suse.com>
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
of a new p2m leaf.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/p2m.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index d1b3da2..8c1a278 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -532,6 +532,7 @@ static bool alloc_p2m(unsigned long pfn)
 	unsigned topidx, mididx;
 	unsigned long ***top_p, **mid;
 	unsigned long *top_mfn_p, *mid_mfn;
+	unsigned long *p2m_orig;
 
 	topidx = p2m_top_index(pfn);
 	mididx = p2m_mid_index(pfn);
@@ -579,11 +580,10 @@ static bool alloc_p2m(unsigned long pfn)
 		}
 	}
 
-	if (p2m_top[topidx][mididx] == p2m_identity ||
-	    p2m_top[topidx][mididx] == p2m_missing) {
+	p2m_orig = p2m_top[topidx][mididx];
+	if (p2m_orig == p2m_identity || p2m_orig == p2m_missing) {
 		/* p2m leaf page is missing */
 		unsigned long *p2m;
-		unsigned long *p2m_orig = p2m_top[topidx][mididx];
 
 		p2m = alloc_p2m_page();
 		if (!p2m)
-- 
1.8.4.5


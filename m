Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3FKT6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 15:58:50 -0400
Received: from longford.logfs.org ([213.229.74.203]:59535 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab3FKT6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 15:58:49 -0400
Date: Tue, 11 Jun 2013 14:29:21 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH, RFC] mm: Implement RLIMIT_RSS
Message-ID: <20130611182921.GB25941@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've seen a couple of instances where people try to impose a vsize
limit simply because there is no rss limit in Linux.  The vsize limit
is a horrible approximation and even this patch seems to be an
improvement.

Would there be strong opposition to actually supporting RLIMIT_RSS?

Jörn

--
It's not whether you win or lose, it's how you place the blame.
-- unknown


Not quite perfect, but close enough for many purposes.  This checks rss
limit inside may_expand_vm() and will fail if we are already over the
limit.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 mm/mmap.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index ab652fa..ea90c73 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2446,12 +2446,19 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 int may_expand_vm(struct mm_struct *mm, unsigned long npages)
 {
 	unsigned long cur = mm->total_vm;	/* pages */
-	unsigned long lim;
+	unsigned long lim, rlim;
 
 	lim = rlimit(RLIMIT_AS) >> PAGE_SHIFT;
+	rlim = rlimit(RLIMIT_RSS) >> PAGE_SHIFT;
 
 	if (cur + npages > lim)
 		return 0;
+	if (cur + npages > rlim) {
+		/* Yes, the rss limit is somewhat imprecise. */
+		if (get_mm_rss(mm) > rlim) {
+			return 0;
+		}
+	}
 	return 1;
 }
 
-- 
1.7.10.4


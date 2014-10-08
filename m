Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbaJHQI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:08:28 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:57951 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbaJHQI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:08:26 -0400
Date: Wed, 8 Oct 2014 12:08:23 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH percpu/for-3.18] percpu: fix how @gfp is interpreted by the
 percpu allocator
Message-ID: <20141008160823.GD8184@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6ae833c7fe0c6ef1f0ab13cc775da230d6f4c256 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 8 Oct 2014 12:01:52 -0400

When @gfp is specified, the percpu allocator is interested in whether
it contains all of GFP_KERNEL or not.  If it does, the normal
allocation path is taken; otherwise, the atomic allocation path.
Unfortunately, pcpu_alloc() was incorrectly testing for whether @gfp
contains any part of GFP_KERNEL.

Fix it by testing "(gfp & GFP_KERNEL) != GFP_KERNEL" instead of
"!(gfp & GFP_KERNEL)" to decide whether the allocation should be
atomic or not.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Oops, noticed this while preparing the pull request for v3.18-rc1.
Applied to percpu/for-3.18.

Thanks.

 mm/percpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index e10f9f7..014bab6 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -876,7 +876,7 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved,
 	static int warn_limit = 10;
 	struct pcpu_chunk *chunk;
 	const char *err;
-	bool is_atomic = !(gfp & GFP_KERNEL);
+	bool is_atomic = (gfp & GFP_KERNEL) != GFP_KERNEL;
 	int occ_pages = 0;
 	int slot, off, new_alloc, cpu, ret;
 	unsigned long flags;
-- 
1.9.3


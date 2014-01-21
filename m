Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaAUJsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:48:23 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:48546 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaAUJsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:48:19 -0500
Date: Tue, 21 Jan 2014 04:48:14 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: [GIT PULL] percpu changes for v3.14-rc1
Message-ID: <20140121094814.GB6928@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Two trivial changes - addition of WARN_ONCE() in lib/percpu-refcount.c
and use of VMALLOC_TOTAL instead of END - START in percpu.c.

I messed up the for-3.14 branch (committed stuff to for-next) and had
to rebuild for-3.14 by cherry-picking; however, the result is the same
as published to the next tree through for-next.

The changes are available in the following git branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git 

for you to fetch changes up to 8a0921712ec6d00754b5d7afea78137772efee0a:

  percpu: use VMALLOC_TOTAL instead of VMALLOC_END - VMALLOC_START (2014-01-21 04:41:26 -0500)

Thanks.
----------------------------------------------------------------
Kent Overstreet (1):
      percpu-refcount: Add a WARN() for ref going negative

Laura Abbott (1):
      percpu: use VMALLOC_TOTAL instead of VMALLOC_END - VMALLOC_START

 lib/percpu-refcount.c | 3 +++
 mm/percpu.c           | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 1a53d49..963b703 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -120,6 +120,9 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 
 	atomic_add((int) count - PCPU_COUNT_BIAS, &ref->count);
 
+	WARN_ONCE(atomic_read(&ref->count) <= 0, "percpu ref <= 0 (%i)",
+		  atomic_read(&ref->count));
+
 	/* @ref is viewed as dead on all CPUs, send out kill confirmation */
 	if (ref->confirm_kill)
 		ref->confirm_kill(ref);
diff --git a/mm/percpu.c b/mm/percpu.c
index 0d10def..afbf352 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1686,10 +1686,10 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 	max_distance += ai->unit_size;
 
 	/* warn if maximum distance is further than 75% of vmalloc space */
-	if (max_distance > (VMALLOC_END - VMALLOC_START) * 3 / 4) {
+	if (max_distance > VMALLOC_TOTAL * 3 / 4) {
 		pr_warning("PERCPU: max_distance=0x%zx too large for vmalloc "
 			   "space 0x%lx\n", max_distance,
-			   (unsigned long)(VMALLOC_END - VMALLOC_START));
+			   VMALLOC_TOTAL);
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 		/* and fail if we have fallback */
 		rc = -EINVAL;

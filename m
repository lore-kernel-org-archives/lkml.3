Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbaFDQhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:37:14 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:44884 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaFDQhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:37:13 -0400
Date: Wed, 4 Jun 2014 12:37:00 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [GIT PULL] last minute percpu fix for v3.15-rc8
Message-ID: <20140604163700.GH5004@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

It is very late but this is an important percpu-refcount fix from
Sebastian Ott.  The problem is that percpu_ref_*() used __this_cpu_*()
instead of this_cpu_*().  The difference between the two is that the
latter is atomic on the local cpu while the former is not.
this_cpu_inc() is guaranteed to increment the percpu counter on the
cpu that the operation is executed on without any synchronization;
however, __this_cpu_inc() doesn't and if the local cpu invokes the
function from different contexts (e.g. process and irq) of the same
CPU, it's not guaranteed to actually increment as it may be
implemented as rmw.

This bug existed from the get-go but it hasn't been noticed earlier
probably because on x86 __this_cpu_inc() is equivalent to
this_cpu_inc() as both get translated into single instruction;
however, s390 uses the generic rmw implementation and gets affected by
the bug.  Kudos to Sebastian and Heiko for diagnosing it.

The change is very low risk and fixes a critical issue on the affected
architectures, so I think it's a good candidate for inclusion although
it's very late in the devel cycle.  On the other hand, this has been
broken since v3.11, so backporting it through -stable post -rc1 won't
be the end of the world.

I'll ping Christoph whether __this_cpu_*() ops can be better annotated
so that it can trigger lockdep warning when used from multiple
contexts.

Thanks.

The following changes since commit 5a838c3b60e3a36ade764cf7751b8f17d7c9c2da:

  percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree() (2014-04-14 16:18:06 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.15-fixes

for you to fetch changes up to 0c36b390a546055b6815d4b93a2c9fed4d980ffb:

  percpu-refcount: fix usage of this_cpu_ops (2014-06-04 12:12:29 -0400)

----------------------------------------------------------------
Sebastian Ott (1):
      percpu-refcount: fix usage of this_cpu_ops

 include/linux/percpu-refcount.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 95961f0..0afb48f 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -110,7 +110,7 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
-		__this_cpu_inc(*pcpu_count);
+		this_cpu_inc(*pcpu_count);
 	else
 		atomic_inc(&ref->count);
 
@@ -139,7 +139,7 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR)) {
-		__this_cpu_inc(*pcpu_count);
+		this_cpu_inc(*pcpu_count);
 		ret = true;
 	}
 
@@ -164,7 +164,7 @@ static inline void percpu_ref_put(struct percpu_ref *ref)
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
-		__this_cpu_dec(*pcpu_count);
+		this_cpu_dec(*pcpu_count);
 	else if (unlikely(atomic_dec_and_test(&ref->count)))
 		ref->release(ref);
 

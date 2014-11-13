Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170AbaKMT2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:28:03 -0500
Received: from mail-yk0-f172.google.com ([209.85.160.172]:58937 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933962AbaKMTZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:25:23 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH 09/16] percpu: Replace smp_read_barrier_depends() with lockless_dereference()
Date: Thu, 13 Nov 2014 14:24:15 -0500
Message-Id: <1415906662-4576-10-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/percpu-refcount.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 494ab05..3cf6759 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -128,10 +128,8 @@ static inline void percpu_ref_kill(struct percpu_ref *ref)
 static inline bool __ref_is_percpu(struct percpu_ref *ref,
 					  unsigned long __percpu **percpu_countp)
 {
-	unsigned long percpu_ptr = ACCESS_ONCE(ref->percpu_count_ptr);
-
 	/* paired with smp_store_release() in percpu_ref_reinit() */
-	smp_read_barrier_depends();
+	unsigned long percpu_ptr = lockless_dereference(ref->percpu_count_ptr);
 
 	if (unlikely(percpu_ptr & __PERCPU_REF_ATOMIC))
 		return false;
-- 
1.9.1


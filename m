Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750870AbaKVGtC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 01:49:02 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:62115 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaKVGtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 01:49:00 -0500
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@fb.com>, Tejun Heo <tj@kernel.org>,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH] percpu-ref: correctly get percpu pointer
Date: Fri, 21 Nov 2014 22:48:57 -0800
Message-Id: <995deb699f5b873c45d667df4add3b06f73c2c25.1416638887.git.shli@kernel.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I saw randam system hang testing virtio with blk-mq enabled and cpu hotplug
runing in the background. It turns out __ref_is_percpu() doesn't always return
correct percpu pointer. percpu_ref_put() calls __ref_is_percpu(), which checks
__PERCPU_REF_ATOMIC. After this check, the __PERCPU_REF_ATOMIC or
__PERCPU_REF_DEAD might be set, so we must exclude the two bits from the percpu
pointer. Fortunately we can still use percpu data for percpu_ref_put() even
this happens, because the final transistion from percpu to atomic occurs at rcu
context while __ref_is_percpu() is always called with rcu read lock protected.

CC: Jens Axboe <axboe@fb.com>
CC: Tejun Heo <tj@kernel.org>
CC: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 include/linux/percpu-refcount.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index d5c89e0..6beee08 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -136,7 +136,14 @@ static inline bool __ref_is_percpu(struct percpu_ref *ref,
 	if (unlikely(percpu_ptr & __PERCPU_REF_ATOMIC))
 		return false;
 
-	*percpu_countp = (unsigned long __percpu *)percpu_ptr;
+	/*
+	 * At this point ATOMIC or DEAD might be set when percpu_ref_kill() is
+	 * running. It's still safe to use percpu here, because the final
+	 * transition from percpu to atomic occurs at rcu context while this
+	 * routine is protected with rcu read lock.
+	 */
+	*percpu_countp = (unsigned long __percpu *)(percpu_ptr &
+		~__PERCPU_REF_ATOMIC_DEAD);
 	return true;
 }
 
-- 
1.8.3.2


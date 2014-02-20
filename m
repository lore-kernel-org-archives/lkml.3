Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaBTRpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:45:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbaBTRpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:45:02 -0500
From: Mateusz Guzik <mguzik@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@redhat.com>
Subject: [PATCH] kref: oops on zero or negative refcount
Date: Thu, 20 Feb 2014 18:44:59 +0100
Message-Id: <1392918299-673-1-git-send-email-mguzik@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In use after free situations, it is possible for one thread to write to
memory that has just been reallocated to a new user. This could open up
potential security issues.

Close off those potential security holes by terminating the current
thread when kref encounters such a race condition or underflow.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
---
 include/linux/kref.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 484604d..c3f8a0a 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -43,8 +43,10 @@ static inline void kref_get(struct kref *kref)
 	/* If refcount was 0 before incrementing then we have a race
 	 * condition when this kref is freeing by some other thread right now.
 	 * In this case one should use kref_get_unless_zero()
+	 *
+	 * Terminate the current thread to stop potential security exploits.
 	 */
-	WARN_ON_ONCE(atomic_inc_return(&kref->refcount) < 2);
+	BUG_ON(atomic_inc_return(&kref->refcount) < 2);
 }
 
 /**
-- 
1.8.3.1


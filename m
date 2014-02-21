Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340AbaBURWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:22:43 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44303 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933033AbaBURWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:22:41 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: rkuo@codeaurora.org, arnd@arndb.de, paulus@samba.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 1/2] asm-generic: rwsem: ensure sem->cnt is only accessed via atomic_long_*
Date: Fri, 21 Feb 2014 17:22:26 +0000
Message-Id: <1393003347-24958-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asm-generic rwsem implementation directly acceses sem->cnt when
performing a __down_read_trylock operation. Whilst this is probably safe
on all architectures, we should stick to the atomic_long_* API and use
atomic_long_read instead.

Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 include/asm-generic/rwsem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/rwsem.h b/include/asm-generic/rwsem.h
index bb1e2cdeb9bf..75af612f54f8 100644
--- a/include/asm-generic/rwsem.h
+++ b/include/asm-generic/rwsem.h
@@ -41,7 +41,7 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
 	long tmp;
 
-	while ((tmp = sem->count) >= 0) {
+	while ((tmp = atomic_long_read((atomic_long_t *)&sem->count)) >= 0) {
 		if (tmp == cmpxchg(&sem->count, tmp,
 				   tmp + RWSEM_ACTIVE_READ_BIAS)) {
 			return 1;
-- 
1.8.2.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab3CIPiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 10:38:46 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42862 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758668Ab3CIPip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 10:38:45 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Shaohua Li <shli@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] atomic: improve atomic_inc_unless_negative/atomic_dec_unless_positive
Date: Sat,  9 Mar 2013 23:38:21 +0800
Message-Id: <1362843501-31159-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generally, both atomic_inc_unless_negative() and
atomic_dec_unless_positive() need at least two atomic_cmpxchg()
to complete the atomic operation. In fact, the 1st atomic_cmpxchg()
is just used to read current value of the atomic variable at most times.

Considered memory barrier, bus lock, cache walking, etc. things may be
involved in atomic_cmpxchg(), it is much expensive than atomic_read(),
which is just the simple below:

	(*(volatile int *)&(v)->counter)

so this patch can save one extra atomic_cmpxchg() for the two
helpers under general situation, and should improve them a bit.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 include/linux/atomic.h |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index 5b08a85..aa951d8 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -63,26 +63,34 @@ static inline int atomic_inc_not_zero_hint(atomic_t *v, int hint)
 #ifndef atomic_inc_unless_negative
 static inline int atomic_inc_unless_negative(atomic_t *p)
 {
-	int v, v1;
-	for (v = 0; v >= 0; v = v1) {
-		v1 = atomic_cmpxchg(p, v, v + 1);
-		if (likely(v1 == v))
+	int v, t;
+
+	v = atomic_read(p);
+	while (1) {
+		if (unlikely(v < 0))
+			return 0;
+		t = atomic_cmpxchg(p, v, v + 1);
+		if (likely(t == v))
 			return 1;
+		v = t;
 	}
-	return 0;
 }
 #endif
 
 #ifndef atomic_dec_unless_positive
 static inline int atomic_dec_unless_positive(atomic_t *p)
 {
-	int v, v1;
-	for (v = 0; v <= 0; v = v1) {
-		v1 = atomic_cmpxchg(p, v, v - 1);
-		if (likely(v1 == v))
+	int v, t;
+
+	v = atomic_read(p);
+	while (1) {
+		if (unlikely(v > 0))
+			return 0;
+		t = atomic_cmpxchg(p, v, v - 1);
+		if (likely(t == v))
 			return 1;
+		v = t;
 	}
-	return 0;
 }
 #endif
 
-- 
1.7.9.5


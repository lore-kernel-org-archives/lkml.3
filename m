Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966804Ab3DRJVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:21:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40332 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759400Ab3DRJSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:18:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 65/72] kref: Implement kref_get_unless_zero v3
Date: Thu, 18 Apr 2013 10:16:50 +0100
Message-Id: <1366276617-3553-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit 4b20db3de8dab005b07c74161cb041db8c5ff3a7 upstream.

This function is intended to simplify locking around refcounting for
objects that can be looked up from a lookup structure, and which are
removed from that lookup structure in the object destructor.
Operations on such objects require at least a read lock around
lookup + kref_get, and a write lock around kref_put + remove from lookup
structure. Furthermore, RCU implementations become extremely tricky.
With a lookup followed by a kref_get_unless_zero *with return value check*
locking in the kref_put path can be deferred to the actual removal from
the lookup structure and RCU lookups become trivial.

v2: Formatting fixes.
v3: Invert the return value.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/kref.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 9c07dce..fd2a616 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -93,4 +93,25 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
 {
 	return kref_sub(kref, 1, release);
 }
+
+/**
+ * kref_get_unless_zero - Increment refcount for object unless it is zero.
+ * @kref: object.
+ *
+ * Return non-zero if the increment succeeded. Otherwise return 0.
+ *
+ * This function is intended to simplify locking around refcounting for
+ * objects that can be looked up from a lookup structure, and which are
+ * removed from that lookup structure in the object destructor.
+ * Operations on such objects require at least a read lock around
+ * lookup + kref_get, and a write lock around kref_put + remove from lookup
+ * structure. Furthermore, RCU implementations become extremely tricky.
+ * With a lookup followed by a kref_get_unless_zero *with return value check*
+ * locking in the kref_put path can be deferred to the actual removal from
+ * the lookup structure and RCU lookups become trivial.
+ */
+static inline int __must_check kref_get_unless_zero(struct kref *kref)
+{
+	return atomic_add_unless(&kref->refcount, 1, 0);
+}
 #endif /* _KREF_H_ */
-- 
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab3DVOjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:39:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51597 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754862Ab3DVOaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Thomas Hellstrom" <thellstrom@vmware.com>,
        "Dave Airlie" <airlied@redhat.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.537909420@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [40/75] kref: Implement kref_get_unless_zero v3
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - Add #include <linux/atomic.h>]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -16,6 +16,7 @@
 #define _KREF_H_
 
 #include <linux/types.h>
+#include <linux/atomic.h>
 
 struct kref {
 	atomic_t refcount;
@@ -27,4 +28,24 @@ int kref_put(struct kref *kref, void (*r
 int kref_sub(struct kref *kref, unsigned int count,
 	     void (*release) (struct kref *kref));
 
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


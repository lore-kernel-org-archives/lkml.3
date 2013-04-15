Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3DOCZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:25:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3DOCZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:25:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 10/17] kref: Implement kref_get_unless_zero v3
Date: Sun, 14 Apr 2013 19:25:20 -0700
Message-Id: <20130415022353.392438843@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415022352.616689034@linuxfoundation.org>
References: <20130415022352.616689034@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/kref.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -93,4 +93,25 @@ static inline int kref_put(struct kref *
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



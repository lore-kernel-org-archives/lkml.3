Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373Ab3EGD7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:59:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23893 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932970Ab3EGD7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:59:01 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=mbmLQ2SiDuYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Iz3IxIhng2EA:10 a=eh1Yez-EAAAA:8 a=20KFwNOVAAAA:8 a=yRT1tXsR65cmlkA8zI8A:9 a=W6U7dDoXpqQA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035849.452548910@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Dave Airlie <airlied@redhat.com>
Subject: [051/126] kref: Implement kref_get_unless_zero v3
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0051-kref-Implement-kref_get_unless_zero-v3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

[ Upstream commit 4b20db3de8dab005b07c74161cb041db8c5ff3a7 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kref.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 65af688..4972e6e 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -111,4 +111,25 @@ static inline int kref_put_mutex(struct kref *kref,
 	}
 	return 0;
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
1.7.10.4



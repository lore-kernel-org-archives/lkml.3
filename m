Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbaGAVyC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:54:02 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:43119 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885AbaGAVxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:53:49 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 11/50] mars: add new file include/linux/brick/lib_pairing_heap.h
Date: Tue,  1 Jul 2014 23:46:51 +0200
Message-Id: <1404251250-22992-12-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/brick/lib_pairing_heap.h | 94 ++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)
 create mode 100644 include/linux/brick/lib_pairing_heap.h

diff --git a/include/linux/brick/lib_pairing_heap.h b/include/linux/brick/lib_pairing_heap.h
new file mode 100644
index 0000000..f60d4e7
--- /dev/null
+++ b/include/linux/brick/lib_pairing_heap.h
@@ -0,0 +1,94 @@
+/*  (c) 2010 Thomas Schoebel-Theuer / 1&1 Internet AG */
+#ifndef PAIRING_HEAP_H
+#define PAIRING_HEAP_H
+
+/* Algorithm: see http://en.wikipedia.org/wiki/Pairing_heap
+ * This is just an efficient translation from recursive to iterative form.
+ *
+ * Note: find_min() is so trivial that we don't implement it.
+ */
+
+/* generic version: KEYDEF is kept separate, allowing you to
+ * embed this structure into other container structures already
+ * possessing some key (just provide an empty KEYDEF in this case).
+ */
+#define _PAIRING_HEAP_TYPEDEF(KEYTYPE, KEYDEF)				\
+									\
+struct pairing_heap_##KEYTYPE {						\
+	KEYDEF								\
+	struct pairing_heap_##KEYTYPE *next;				\
+	struct pairing_heap_##KEYTYPE *subheaps;			\
+};									\
+/* this comment is for keeping TRAILING_SEMICOLON happy */
+
+/* less generic version: define the key inside.
+ */
+#define PAIRING_HEAP_TYPEDEF(KEYTYPE)					\
+	_PAIRING_HEAP_TYPEDEF(KEYTYPE, KEYTYPE key;)
+
+/* generic methods: allow arbitrary CMP() functions.
+ */
+#define _PAIRING_HEAP_FUNCTIONS(_STATIC, KEYTYPE, CMP)			\
+									\
+_STATIC									\
+struct pairing_heap_##KEYTYPE *_ph_merge_##KEYTYPE(struct pairing_heap_##KEYTYPE *heap1,\
+	struct pairing_heap_##KEYTYPE *heap2)				\
+{									\
+	if (!heap1)							\
+		return heap2;						\
+	if (!heap2)							\
+		return heap1;						\
+	if (CMP(heap1, heap2) < 0) {					\
+		heap2->next = heap1->subheaps;				\
+		heap1->subheaps = heap2;				\
+		return heap1;						\
+	}								\
+	heap1->next = heap2->subheaps;					\
+	heap2->subheaps = heap1;					\
+	return heap2;							\
+}									\
+									\
+_STATIC									\
+void ph_insert_##KEYTYPE(struct pairing_heap_##KEYTYPE **heap, struct pairing_heap_##KEYTYPE *new)\
+{									\
+	new->next = NULL;						\
+	new->subheaps = NULL;						\
+	*heap = _ph_merge_##KEYTYPE(*heap, new);			\
+}									\
+									\
+_STATIC									\
+void ph_delete_min_##KEYTYPE(struct pairing_heap_##KEYTYPE **heap)	\
+{									\
+	struct pairing_heap_##KEYTYPE *tmplist = NULL;			\
+	struct pairing_heap_##KEYTYPE *ptr;				\
+	struct pairing_heap_##KEYTYPE *next;				\
+	struct pairing_heap_##KEYTYPE *res;				\
+	if (!*heap) {							\
+		return;							\
+	}								\
+	for (ptr = (*heap)->subheaps; ptr; ptr = next) {		\
+		struct pairing_heap_##KEYTYPE *p2 = ptr->next;		\
+		next = p2;						\
+		if (p2) {						\
+			next = p2->next;				\
+			ptr = _ph_merge_##KEYTYPE(ptr, p2);		\
+		}							\
+		ptr->next = tmplist;					\
+		tmplist = ptr;						\
+	}								\
+	res = NULL;							\
+	for (ptr = tmplist; ptr; ptr = next) {				\
+		next = ptr->next;					\
+		res = _ph_merge_##KEYTYPE(res, ptr);			\
+	}								\
+	*heap = res;							\
+}
+
+/* some default CMP() function */
+#define PAIRING_HEAP_COMPARE(a, b) ((a)->key < (b)->key ? -1 : ((a)->key > (b)->key ? 1 : 0))
+
+/* less generic version: use the default CMP() function */
+#define PAIRING_HEAP_FUNCTIONS(_STATIC, KEYTYPE)			\
+	_PAIRING_HEAP_FUNCTIONS(_STATIC, KEYTYPE, PAIRING_HEAP_COMPARE)
+
+#endif
-- 
2.0.0


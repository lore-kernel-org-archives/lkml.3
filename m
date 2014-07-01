Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbaGAVrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:47:47 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:58341 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbaGAVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:47:37 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 07/50] mars: add new file include/linux/brick/brick_checking.h
Date: Tue,  1 Jul 2014 23:46:47 +0200
Message-Id: <1404251250-22992-8-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/brick/brick_checking.h | 88 ++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)
 create mode 100644 include/linux/brick/brick_checking.h

diff --git a/include/linux/brick/brick_checking.h b/include/linux/brick/brick_checking.h
new file mode 100644
index 0000000..e5d107d
--- /dev/null
+++ b/include/linux/brick/brick_checking.h
@@ -0,0 +1,88 @@
+/*  (c) 2010 Thomas Schoebel-Theuer / 1&1 Internet AG */
+#ifndef BRICK_CHECKING_H
+#define BRICK_CHECKING_H
+
+/***********************************************************************/
+
+/*  checking */
+
+#if defined(CONFIG_MARS_DEBUG) || defined(CONFIG_MARS_CHECKS)
+#define BRICK_CHECKING			true
+#else
+#define BRICK_CHECKING			false
+#endif
+
+#define _CHECK_ATOMIC(atom, OP, minval)					\
+do {									\
+	if (BRICK_CHECKING) {						\
+		int __test = atomic_read(atom);				\
+		if (unlikely(__test OP(minval))) {			\
+			atomic_set(atom, minval);			\
+			BRICK_ERR("%d: atomic " #atom " " #OP " " #minval " (%d)\n", __LINE__, __test);\
+		}							\
+	}								\
+} while (0)
+
+#define CHECK_ATOMIC(atom, minval)					\
+	_CHECK_ATOMIC(atom, <, minval)
+
+#define CHECK_HEAD_EMPTY(head)						\
+do {									\
+	if (BRICK_CHECKING && unlikely(!list_empty(head) && (head)->next)) {\
+		list_del_init(head);					\
+		BRICK_ERR("%d: list_head " #head " (%p) not empty\n", __LINE__, head);\
+	}								\
+} while (0)
+
+#ifdef CONFIG_MARS_DEBUG_MEM
+#define CHECK_PTR_DEAD(ptr, label)					\
+do {									\
+	if (BRICK_CHECKING && unlikely((ptr) == (void *)0x5a5a5a5a5a5a5a5a)) {\
+		BRICK_FAT("%d: pointer '" #ptr "' is DEAD\n", __LINE__);\
+		goto label;						\
+	}								\
+} while (0)
+#else
+#define CHECK_PTR_DEAD(ptr, label) /*empty*/
+#endif
+
+#define CHECK_PTR_NULL(ptr, label)					\
+do {									\
+	CHECK_PTR_DEAD(ptr, label);					\
+	if (BRICK_CHECKING && unlikely(!(ptr))) {			\
+		BRICK_FAT("%d: pointer '" #ptr "' is NULL\n", __LINE__);\
+		goto label;						\
+	}								\
+} while (0)
+
+#ifdef CONFIG_MARS_DEBUG
+#define CHECK_PTR(ptr, label)						\
+do {									\
+	CHECK_PTR_NULL(ptr, label);					\
+	if (BRICK_CHECKING && unlikely(!virt_addr_valid(ptr))) {	\
+		BRICK_FAT("%d: pointer '" #ptr "' (%p) is no valid virtual KERNEL address\n", __LINE__, ptr);\
+		goto label;						\
+	}								\
+} while (0)
+#else
+#define CHECK_PTR(ptr, label) CHECK_PTR_NULL(ptr, label)
+#endif
+
+#define CHECK_ASPECT(a_ptr, o_ptr, label)				\
+do {									\
+	if (BRICK_CHECKING && unlikely((a_ptr)->object != o_ptr)) {	\
+		BRICK_FAT("%d: aspect pointer '" #a_ptr "' (%p) belongs to object %p, not to " #o_ptr " (%p)\n",\
+			__LINE__, a_ptr, (a_ptr)->object, o_ptr);	\
+		goto label;						\
+	}								\
+} while (0)
+
+#define _CHECK(ptr, label)						\
+do {									\
+	if (BRICK_CHECKING && unlikely(!(ptr))) {			\
+		BRICK_FAT("%d: condition '" #ptr "' is VIOLATED\n", __LINE__);\
+		goto label;						\
+	}								\
+} while (0)
+
+#endif
-- 
2.0.0


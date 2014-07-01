Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477AbaGAV5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:57:37 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:19511 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877AbaGAVxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:53:52 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 08/50] mars: add new file include/linux/brick/meta.h
Date: Tue,  1 Jul 2014 23:46:48 +0200
Message-Id: <1404251250-22992-9-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/brick/meta.h | 90 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)
 create mode 100644 include/linux/brick/meta.h

diff --git a/include/linux/brick/meta.h b/include/linux/brick/meta.h
new file mode 100644
index 0000000..44104fd
--- /dev/null
+++ b/include/linux/brick/meta.h
@@ -0,0 +1,90 @@
+/*  (c) 2010 Thomas Schoebel-Theuer / 1&1 Internet AG */
+#ifndef META_H
+#define META_H
+
+/***********************************************************************/
+
+/*  metadata descriptions */
+
+/* The idea is to describe your C structures in such a way that
+ * transfers to disk or over a network become self-describing.
+ *
+ * In essence, this is a kind of version-independent marshalling.
+ *
+ * Advantage:
+ * When you extend your original C struct (and of course update the
+ * corresponding meta structure), old data on disk (or network peers
+ * running an old version of your program) will remain valid.
+ * Upon read, newly added fields missing in the old version will be simply
+ * not filled in and therefore remain zeroed (if you don't forget to
+ * initially clear your structures via memset() / initializers / etc).
+ * Note that this works only if you never rename or remove existing
+ * fields; you should only add new ones.
+ * [TODO: add macros for description of ignored / renamed fields to
+ *  overcome this limitation]
+ * You may increase the size of integers, for example from 32bit to 64bit
+ * or even higher; sign extension will be automatically carried out
+ * when necessary.
+ * Also, you may change the order of fields, because the metadata interpreter
+ * will check each field individually; field offsets are automatically
+ * maintained.
+ *
+ * Disadvantage: this adds some (small) overhead.
+ */
+
+enum field_type {
+	FIELD_DONE,
+	FIELD_REF,
+	FIELD_SUB,
+	FIELD_STRING,
+	FIELD_RAW,
+	FIELD_INT,
+	FIELD_UINT,
+};
+
+struct meta {
+	/* char field_name[MAX_FIELD_LEN]; */
+	char *field_name;
+
+	short field_type;
+	short field_data_size;
+	short field_transfer_size;
+	int   field_offset;
+	const struct meta *field_ref;
+};
+
+#define _META_INI(NAME, STRUCT, TYPE, TSIZE)				\
+	.field_name = #NAME,						\
+	.field_type = TYPE,						\
+	.field_data_size = sizeof(((STRUCT *)NULL)->NAME),		\
+	.field_transfer_size = (TSIZE),					\
+	.field_offset = offsetof(STRUCT, NAME)				\
+
+#define META_INI_TRANSFER(NAME, STRUCT, TYPE, TSIZE)			\
+	{ _META_INI(NAME, STRUCT, TYPE, TSIZE) }
+
+#define META_INI(NAME, STRUCT, TYPE)					\
+	{ _META_INI(NAME, STRUCT, TYPE, 0) }
+
+#define _META_INI_AIO(NAME, STRUCT, AIO)				\
+	.field_name = #NAME,						\
+	.field_type = FIELD_REF,					\
+	.field_data_size = sizeof(*(((STRUCT *)NULL)->NAME)),		\
+	.field_offset = offsetof(STRUCT, NAME),				\
+	.field_ref = AIO
+
+#define META_INI_AIO(NAME, STRUCT, AIO) { _META_INI_AIO(NAME, STRUCT, AIO) }
+
+#define _META_INI_SUB(NAME, STRUCT, SUB)				\
+	.field_name = #NAME,						\
+	.field_type = FIELD_SUB,					\
+	.field_data_size = sizeof(((STRUCT *)NULL)->NAME),		\
+	.field_offset = offsetof(STRUCT, NAME),				\
+	.field_ref = SUB
+
+#define META_INI_SUB(NAME, STRUCT, SUB) { _META_INI_SUB(NAME, STRUCT, SUB) }
+
+extern const struct meta *find_meta(const struct meta *meta, const char *field_name);
+/* extern void free_meta(void *data, const struct meta *meta); */
+
+#endif
-- 
2.0.0


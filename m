Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbaGAVsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:48:06 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:32536 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbaGAVrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:47:40 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 23/50] mars: add new file include/linux/lib_mapfree.h
Date: Tue,  1 Jul 2014 23:47:03 +0200
Message-Id: <1404251250-22992-24-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
---
 include/linux/lib_mapfree.h | 65 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100644 include/linux/lib_mapfree.h

diff --git a/include/linux/lib_mapfree.h b/include/linux/lib_mapfree.h
new file mode 100644
index 0000000..416a901
--- /dev/null
+++ b/include/linux/lib_mapfree.h
@@ -0,0 +1,65 @@
+/*  (c) 2012 Thomas Schoebel-Theuer / 1&1 Internet AG */
+#ifndef XIO_LIB_MAPFREE_H
+#define XIO_LIB_MAPFREE_H
+
+/* Mapfree infrastructure.
+ *
+ * Purposes:
+ *
+ * 1) Open files only once when possible, do ref-counting on struct mapfree_info
+ *
+ * 2) Automatically call invalidate_mapping_pages() in the background on
+ *    "unused" areas to free resources.
+ *    Used areas can be indicated by calling mapfree_set() frequently.
+ *    Usage model: tailored to sequential logfiles.
+ *
+ * 3) Do it all in a completely decoupled manner, in order to prevent resource deadlocks.
+ *
+ * 4) Also to prevent deadlocks: always set mapping_set_gfp_mask() accordingly.
+ */
+
+#include <linux/xio.h>
+
+extern int mapfree_period_sec;
+extern int mapfree_grace_keep_mb;
+
+struct mapfree_info {
+	struct list_head mf_head;
+	struct list_head mf_dirty_anchor;
+	char		*mf_name;
+	struct file	*mf_filp;
+	int		 mf_flags;
+	atomic_t	 mf_count;
+	spinlock_t	 mf_lock;
+	loff_t		 mf_min[2];
+	loff_t		 mf_last;
+	loff_t		 mf_max;
+	long long	 mf_jiffies;
+};
+
+struct dirty_info {
+	struct list_head dirty_head;
+	struct aio_object *dirty_aio;
+	int dirty_stage;
+};
+
+struct mapfree_info *mapfree_get(const char *filename, int flags);
+
+void mapfree_put(struct mapfree_info *mf);
+
+void mapfree_set(struct mapfree_info *mf, loff_t min, loff_t max);
+
+/***************** dirty IOs on the fly  *****************/
+
+void mf_insert_dirty(struct mapfree_info *mf, struct dirty_info *di);
+void mf_remove_dirty(struct mapfree_info *mf, struct dirty_info *di);
+void mf_get_dirty(struct mapfree_info *mf, loff_t *min, loff_t *max, int min_stage, int max_stage);
+void mf_get_any_dirty(const char *filename, loff_t *min, loff_t *max, int min_stage, int max_stage);
+
+/***************** module init stuff ************************/
+
+int __init init_xio_mapfree(void);
+
+void exit_xio_mapfree(void);
+
+#endif
-- 
2.0.0


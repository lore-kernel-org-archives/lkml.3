Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaBCQzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:55:19 -0500
Received: from sh.osrg.net ([192.16.179.4]:59553 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaBCQzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:55:13 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-nilfs <linux-nilfs@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Andreas Rohner <andreas.rohner@gmx.net>
Subject: [PATCH 2/4] nilfs2: add struct nilfs_suinfo_update and flags
Date: Tue,  4 Feb 2014 01:50:42 +0900
Message-Id: <1391446244-1435-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1391446244-1435-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1391446244-1435-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20100215(IM150)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (sh.osrg.net [192.16.179.4]); Tue, 04 Feb 2014 01:55:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Rohner <andreas.rohner@gmx.net>

This patch adds the nilfs_suinfo_update structure, which contains the
information needed to update one segment usage entry. The flags
specify, which fields need to be updated.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 include/linux/nilfs2_fs.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 9875576..2526578 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -710,6 +710,48 @@ static inline int nilfs_suinfo_clean(const struct nilfs_suinfo *si)
 }
 
 /* ioctl */
+/**
+ * nilfs_suinfo_update - segment usage information update
+ * @sup_segnum: segment number
+ * @sup_flags: flags for which fields are active in sup_sui
+ * @sup_reserved: reserved necessary for alignment
+ * @sup_sui: segment usage information
+ */
+struct nilfs_suinfo_update {
+	__u64 sup_segnum;
+	__u32 sup_flags;
+	__u32 sup_reserved;
+	struct nilfs_suinfo sup_sui;
+};
+
+enum {
+	NILFS_SUINFO_UPDATE_LASTMOD,
+	NILFS_SUINFO_UPDATE_NBLOCKS,
+	NILFS_SUINFO_UPDATE_FLAGS,
+	__NR_NILFS_SUINFO_UPDATE_FIELDS,
+};
+
+#define NILFS_SUINFO_UPDATE_FNS(flag, name)				\
+static inline void							\
+nilfs_suinfo_update_set_##name(struct nilfs_suinfo_update *sup)		\
+{									\
+	sup->sup_flags |= 1UL << NILFS_SUINFO_UPDATE_##flag;		\
+}									\
+static inline void							\
+nilfs_suinfo_update_clear_##name(struct nilfs_suinfo_update *sup)	\
+{									\
+	sup->sup_flags &= ~(1UL << NILFS_SUINFO_UPDATE_##flag);		\
+}									\
+static inline int							\
+nilfs_suinfo_update_##name(const struct nilfs_suinfo_update *sup)	\
+{									\
+	return !!(sup->sup_flags & (1UL << NILFS_SUINFO_UPDATE_##flag));\
+}
+
+NILFS_SUINFO_UPDATE_FNS(LASTMOD, lastmod)
+NILFS_SUINFO_UPDATE_FNS(NBLOCKS, nblocks)
+NILFS_SUINFO_UPDATE_FNS(FLAGS, flags)
+
 enum {
 	NILFS_CHECKPOINT,
 	NILFS_SNAPSHOT,
-- 
1.7.9.3


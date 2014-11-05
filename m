Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaKEUFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:05:47 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:39850 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751081AbaKEUFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:05:46 -0500
Message-Id: <20141105192545.005203298@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 05 Nov 2014 14:24:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 8/8] debugfs: Have debugfs_print_regs32() return void
References: <20141105192426.348510548@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0008-debugfs-Have-debugfs_print_regs32-return-void.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

The seq_printf() will soon just return void, and seq_has_overflowed()
should be used instead to see if the seq can no longer accept input.

As the return value of debugfs_print_regs32() has no users and
the seq_file descriptor should be checked with seq_has_overflowed()
instead of return values of functions, it is better to just have
debugfs_print_regs32() also return void.

Link: http://lkml.kernel.org/p/2634b19eb1c04a9d31148c1fe6f1f3819be95349.1412031505.git.joe@perches.com

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Joe Perches <joe@perches.com>
[ original change only updated seq_printf() return, added return of
  void to debugfs_print_regs32() as well ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/filesystems/debugfs.txt |  2 +-
 fs/debugfs/file.c                     | 15 ++++++++-------
 include/linux/debugfs.h               |  7 +++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/debugfs.txt b/Documentation/filesystems/debugfs.txt
index 3a863f692728..88ab81c79109 100644
--- a/Documentation/filesystems/debugfs.txt
+++ b/Documentation/filesystems/debugfs.txt
@@ -140,7 +140,7 @@ file.
 				     struct dentry *parent,
 				     struct debugfs_regset32 *regset);
 
-    int debugfs_print_regs32(struct seq_file *s, struct debugfs_reg32 *regs,
+    void debugfs_print_regs32(struct seq_file *s, struct debugfs_reg32 *regs,
 			 int nregs, void __iomem *base, char *prefix);
 
 The "base" argument may be 0, but you may want to build the reg32 array
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 76c08c2beb2f..8e0f2f410189 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -692,18 +692,19 @@ EXPORT_SYMBOL_GPL(debugfs_create_u32_array);
  * because some peripherals have several blocks of identical registers,
  * for example configuration of dma channels
  */
-int debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
-			   int nregs, void __iomem *base, char *prefix)
+void debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
+			  int nregs, void __iomem *base, char *prefix)
 {
-	int i, ret = 0;
+	int i;
 
 	for (i = 0; i < nregs; i++, regs++) {
 		if (prefix)
-			ret += seq_printf(s, "%s", prefix);
-		ret += seq_printf(s, "%s = 0x%08x\n", regs->name,
-				  readl(base + regs->offset));
+			seq_printf(s, "%s", prefix);
+		seq_printf(s, "%s = 0x%08x\n", regs->name,
+			   readl(base + regs->offset));
+		if (seq_has_overflowed(s))
+			break;
 	}
-	return ret;
 }
 EXPORT_SYMBOL_GPL(debugfs_print_regs32);
 
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 4d0b4d1aa132..d84f8c254a87 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -92,8 +92,8 @@ struct dentry *debugfs_create_regset32(const char *name, umode_t mode,
 				     struct dentry *parent,
 				     struct debugfs_regset32 *regset);
 
-int debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
-			 int nregs, void __iomem *base, char *prefix);
+void debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
+			  int nregs, void __iomem *base, char *prefix);
 
 struct dentry *debugfs_create_u32_array(const char *name, umode_t mode,
 					struct dentry *parent,
@@ -233,10 +233,9 @@ static inline struct dentry *debugfs_create_regset32(const char *name,
 	return ERR_PTR(-ENODEV);
 }
 
-static inline int debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
+static inline void debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
 			 int nregs, void __iomem *base, char *prefix)
 {
-	return 0;
 }
 
 static inline bool debugfs_initialized(void)
-- 
2.1.1



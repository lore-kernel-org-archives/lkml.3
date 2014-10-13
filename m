Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaJMUjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:39:43 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:20331 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbaJMUjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:39:42 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As8NAEI3PFRbtA5F/2dsb2JhbABbgw5TWLd1BQFzkkGHVYEgFwF9hDAvI4EaN4hCAbYsjmEshiCJOWwdhDUFhi2LJIRqhxCBLoZzhDuJNYFHbYFFOy+BD4E7AQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1 linux-next] fs/affs/amigaffs.c: use va_format instead of buffer/vnsprintf
Date: Mon, 13 Oct 2014 22:39:37 +0200
Message-Id: <1413232777-11062-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove ErrorBuffer and use %pV

Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/amigaffs.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index abc8539..9643bdd 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -10,8 +10,6 @@
 
 #include "affs.h"
 
-static char ErrorBuffer[256];
-
 /*
  * Functions for accessing Amiga-FFS structures.
  */
@@ -444,30 +442,30 @@ mode_to_prot(struct inode *inode)
 void
 affs_error(struct super_block *sb, const char *function, const char *fmt, ...)
 {
-	va_list	 args;
-
-	va_start(args,fmt);
-	vsnprintf(ErrorBuffer,sizeof(ErrorBuffer),fmt,args);
-	va_end(args);
+	struct va_format vaf;
+	va_list args;
 
-	pr_crit("error (device %s): %s(): %s\n", sb->s_id,
-		function,ErrorBuffer);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_crit("error (device %s): %s(): %pV\n", sb->s_id, function, &vaf);
 	if (!(sb->s_flags & MS_RDONLY))
 		pr_warn("Remounting filesystem read-only\n");
 	sb->s_flags |= MS_RDONLY;
+	va_end(args);
 }
 
 void
 affs_warning(struct super_block *sb, const char *function, const char *fmt, ...)
 {
-	va_list	 args;
+	struct va_format vaf;
+	va_list args;
 
-	va_start(args,fmt);
-	vsnprintf(ErrorBuffer,sizeof(ErrorBuffer),fmt,args);
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_warn("(device %s): %s(): %pV\n", sb->s_id, function, &vaf);
 	va_end(args);
-
-	pr_warn("(device %s): %s(): %s\n", sb->s_id,
-		function,ErrorBuffer);
 }
 
 bool
-- 
1.9.3


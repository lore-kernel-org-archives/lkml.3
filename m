Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163236Ab3DFKKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 06:10:36 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:51923 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab3DFKKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 06:10:32 -0400
Message-ID: <515FF2EC.3000405@gmail.com>
Date: Sat, 06 Apr 2013 12:03:24 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] fsfreeze: add new internal __sb_start_write_wait
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a new internal function __sb_start_write_wait. It must be called
when we want wait for freeze events. We can wait in killable or
uninterruptible state. The old __sb_start_write now it's used only
when we don't want to wait.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/super.c         |   47 ++++++++++++++++++++++++++++++++++++++++-------
 include/linux/fs.h |   11 ++++++-----
 2 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 7465d43..cb0149b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1190,15 +1190,11 @@ static void acquire_freeze_lock(struct super_block *sb, int level, bool trylock,
  * This is an internal function, please use sb_start_{write,pagefault,intwrite}
  * instead.
  */
-int __sb_start_write(struct super_block *sb, int level, bool wait)
+int __sb_start_write(struct super_block *sb, int level)
 {
 retry:
-	if (unlikely(sb->s_writers.frozen >= level)) {
-		if (!wait)
-			return 0;
-		wait_event(sb->s_writers.wait_unfrozen,
-			   sb->s_writers.frozen < level);
-	}
+	if (unlikely(sb->s_writers.frozen >= level))
+		return 0;
 
 #ifdef CONFIG_LOCKDEP
 	acquire_freeze_lock(sb, level, !wait, _RET_IP_);
@@ -1217,6 +1213,43 @@ retry:
 }
 EXPORT_SYMBOL(__sb_start_write);
 
+/*
+ * This is an internal function, please use sb_start_{write,pagefault,intwrite}
+ * instead. It returns zero if no error occured, the error code otherwise.
+ */
+int __sb_start_write_wait(struct super_block *sb, int level, bool wait_killable)
+{
+	int ret = 0;
+
+retry:
+	if (unlikely(sb->s_writers.frozen >= level)) {
+		if (wait_killable)
+			ret = wait_event_killable(sb->s_writers.wait_unfrozen,
+						sb->s_writers.frozen < level);
+			if (ret)
+				return -EINTR;
+		else
+			wait_event(sb->s_writers.wait_unfrozen,
+						sb->s_writers.frozen < level);
+	}
+
+#ifdef CONFIG_LOCKDEP
+	acquire_freeze_lock(sb, level, !wait, _RET_IP_);
+#endif
+	percpu_counter_inc(&sb->s_writers.counter[level-1]);
+	/*
+	 * Make sure counter is updated before we check for frozen.
+	 * freeze_super() first sets frozen and then checks the counter.
+	 */
+	smp_mb();
+	if (unlikely(sb->s_writers.frozen >= level)) {
+		__sb_end_write(sb, level);
+		goto retry;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(__sb_start_write_wait);
+
 /**
  * sb_wait_write - wait until all writers to given file system finish
  * @sb: the super for which we wait
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2c28271..2bfb88d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1333,7 +1333,8 @@ extern struct timespec current_fs_time(struct super_block *sb);
  */
 
 void __sb_end_write(struct super_block *sb, int level);
-int __sb_start_write(struct super_block *sb, int level, bool wait);
+int __sb_start_write(struct super_block *sb, int level);
+int __sb_start_write_wait(struct super_block *sb, int level, bool wait_killable);
 
 /**
  * sb_end_write - drop write access to a superblock
@@ -1392,12 +1393,12 @@ static inline void sb_end_intwrite(struct super_block *sb)
  */
 static inline void sb_start_write(struct super_block *sb)
 {
-	__sb_start_write(sb, SB_FREEZE_WRITE, true);
+	__sb_start_write_wait(sb, SB_FREEZE_WRITE, false);
 }
 
 static inline int sb_start_write_trylock(struct super_block *sb)
 {
-	return __sb_start_write(sb, SB_FREEZE_WRITE, false);
+	return __sb_start_write(sb, SB_FREEZE_WRITE);
 }
 
 /**
@@ -1421,7 +1422,7 @@ static inline int sb_start_write_trylock(struct super_block *sb)
  */
 static inline void sb_start_pagefault(struct super_block *sb)
 {
-	__sb_start_write(sb, SB_FREEZE_PAGEFAULT, true);
+	__sb_start_write_wait(sb, SB_FREEZE_PAGEFAULT, false);
 }
 
 /*
@@ -1439,7 +1440,7 @@ static inline void sb_start_pagefault(struct super_block *sb)
  */
 static inline void sb_start_intwrite(struct super_block *sb)
 {
-	__sb_start_write(sb, SB_FREEZE_FS, true);
+	__sb_start_write_wait(sb, SB_FREEZE_FS, false);
 }
 
 
-- 
1.7.3.4

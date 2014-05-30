Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030309AbaE3UFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:05:48 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:62422 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271AbaE3UFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:05:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net
Subject: [RFC 16/32] ntfs: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:40 +0200
Message-Id: <1401480116-1973111-17-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:f0+IwKlKV5bLcsamvc3FEvZaMNqcQCIvHODZEZD1qDe
 QpafCP18dR4knkJFUylZoMg433XOl12xThB9l5IMONY3C08zrA
 perQ3XncM/aIN85RRtyqKWS1ljNHagd+sqDev6yTBxPBe9UKvr
 vXo+wdup+WDvlp99B8RWGc1sFBMM3KKADhocLIxfEXgQTxtny0
 48BHOlv1AgG93qwdGvcA+70IAjm/imvxNfDhMBK0mlGNrUxlQa
 +hAKnjTDQ6POgL4qyjfUSfEdnWTamoBndmrFlKL+/cxSDnfJul
 ZCNybKYOcmlC1m1hXP8N5jR14kWTBkc2rT8NWoMRQLrBgdRfjW
 XI+49nmkdA/InIZ9Dj3KjDfWfozfglyt2W07EzAp7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ntfs uses 64-bit integers for inode timestamps, which will work
thousands of years, but the VFS uses struct timespec for timestamps,
which is only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in ntfs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: linux-ntfs-dev@lists.sourceforge.net
---
 fs/ntfs/inode.c | 12 ++++++------
 fs/ntfs/time.h  |  8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index f47af5e..8f7cba5 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2811,11 +2811,11 @@ done:
 	 * for real.
 	 */
 	if (!IS_NOCMTIME(VFS_I(base_ni)) && !IS_RDONLY(VFS_I(base_ni))) {
-		struct timespec now = current_fs_time(VFS_I(base_ni)->i_sb);
+		struct inode_time now = current_fs_time(VFS_I(base_ni)->i_sb);
 		int sync_it = 0;
 
-		if (!timespec_equal(&VFS_I(base_ni)->i_mtime, &now) ||
-		    !timespec_equal(&VFS_I(base_ni)->i_ctime, &now))
+		if (!inode_time_equal(&VFS_I(base_ni)->i_mtime, &now) ||
+		    !inode_time_equal(&VFS_I(base_ni)->i_ctime, &now))
 			sync_it = 1;
 		VFS_I(base_ni)->i_mtime = now;
 		VFS_I(base_ni)->i_ctime = now;
@@ -2930,13 +2930,13 @@ int ntfs_setattr(struct dentry *dentry, struct iattr *attr)
 		}
 	}
 	if (ia_valid & ATTR_ATIME)
-		vi->i_atime = timespec_trunc(attr->ia_atime,
+		vi->i_atime = inode_time_trunc(attr->ia_atime,
 				vi->i_sb->s_time_gran);
 	if (ia_valid & ATTR_MTIME)
-		vi->i_mtime = timespec_trunc(attr->ia_mtime,
+		vi->i_mtime = inode_time_trunc(attr->ia_mtime,
 				vi->i_sb->s_time_gran);
 	if (ia_valid & ATTR_CTIME)
-		vi->i_ctime = timespec_trunc(attr->ia_ctime,
+		vi->i_ctime = inode_time_trunc(attr->ia_ctime,
 				vi->i_sb->s_time_gran);
 	mark_inode_dirty(vi);
 out:
diff --git a/fs/ntfs/time.h b/fs/ntfs/time.h
index 0123398..2c8d325 100644
--- a/fs/ntfs/time.h
+++ b/fs/ntfs/time.h
@@ -45,7 +45,7 @@
  * measured as the number of 100-nano-second intervals since 1st January 1601,
  * 00:00:00 UTC.
  */
-static inline sle64 utc2ntfs(const struct timespec ts)
+static inline sle64 utc2ntfs(const struct inode_time ts)
 {
 	/*
 	 * Convert the seconds to 100ns intervals, add the nano-seconds
@@ -63,7 +63,7 @@ static inline sle64 utc2ntfs(const struct timespec ts)
  */
 static inline sle64 get_current_ntfs_time(void)
 {
-	return utc2ntfs(current_kernel_time());
+	return utc2ntfs(CURRENT_TIME);
 }
 
 /**
@@ -82,9 +82,9 @@ static inline sle64 get_current_ntfs_time(void)
  * measured as the number of 100 nano-second intervals since 1st January 1601,
  * 00:00:00 UTC.
  */
-static inline struct timespec ntfs2utc(const sle64 time)
+static inline struct inode_time ntfs2utc(const sle64 time)
 {
-	struct timespec ts;
+	struct inode_time ts;
 
 	/* Subtract the NTFS time offset. */
 	u64 t = (u64)(sle64_to_cpu(time) - NTFS_TIME_OFFSET);
-- 
1.8.3.2


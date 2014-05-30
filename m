Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934272AbaE3UkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:40:12 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:61283 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaE3UkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:40:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>
Subject: [RFC 22/32] fs: convert simple fs to inode_time
Date: Fri, 30 May 2014 22:01:46 +0200
Message-Id: <1401480116-1973111-23-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:7/7ESxnrftKiOaNnAVrMEuttADdWPhTNYAPXKJaXPOE
 EDuw6AGdimWbH4H2xER+SwxxDXwiEn2xzPCUirALuHsjEfQMhZ
 sHzMEE7oeh1kOGsMw34s/bpAxPagrGGUSloAzzWltr6sXHAbEe
 skZddDTjRxv93eijbes4Eyhp2wr6lUvY1Y04tBuin6tL9qZVKX
 93bpA5WRozsUSmN6FV+o6WPWJuhcSvcgXdrQVWclLi3LZNvYoQ
 bWkhRGqxWBem1H3KfkLTRS3cPoFbYqlkT24Qg08gC5XxuXmQwV
 MZGvsCQdcoIIndSuTu086WGt7gKnifB5cKaFcNx79dWuPjDz2d
 um3NxTSjc/FCTxV69P49ulgHIenxL+i9BUOMvWDCW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty, usbgadgetfs, configfs and cramfs do not store inode timestamps
permanently, but they use code that interacts with the VFS inode
times. In order to change over VFS to a struct inode_time, we
have to make trivial changes to these file systems as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joel Becker <jlbec@evilplan.org>
---
 drivers/tty/tty_io.c      | 2 +-
 drivers/usb/gadget/f_fs.c | 2 +-
 fs/configfs/inode.c       | 6 +++---
 fs/cramfs/inode.c         | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 3411071..c2c63e5 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -994,7 +994,7 @@ void start_tty(struct tty_struct *tty)
 EXPORT_SYMBOL(start_tty);
 
 /* We limit tty time update visibility to every 8 seconds or so. */
-static void tty_update_time(struct timespec *time)
+static void tty_update_time(struct inode_time *time)
 {
 	unsigned long sec = get_seconds() & ~7;
 	if ((long)(sec - time->tv_sec) > 0)
diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 74202d6..3947655 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1069,7 +1069,7 @@ ffs_sb_make_inode(struct super_block *sb, void *data,
 	inode = new_inode(sb);
 
 	if (likely(inode)) {
-		struct timespec current_time = CURRENT_TIME;
+		struct inode_time current_time = CURRENT_TIME;
 
 		inode->i_ino	 = get_next_ino();
 		inode->i_mode    = perms->mode;
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index 5946ad9..62f10c0 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -95,13 +95,13 @@ int configfs_setattr(struct dentry * dentry, struct iattr * iattr)
 	if (ia_valid & ATTR_GID)
 		sd_iattr->ia_gid = iattr->ia_gid;
 	if (ia_valid & ATTR_ATIME)
-		sd_iattr->ia_atime = timespec_trunc(iattr->ia_atime,
+		sd_iattr->ia_atime = inode_time_trunc(iattr->ia_atime,
 						inode->i_sb->s_time_gran);
 	if (ia_valid & ATTR_MTIME)
-		sd_iattr->ia_mtime = timespec_trunc(iattr->ia_mtime,
+		sd_iattr->ia_mtime = inode_time_trunc(iattr->ia_mtime,
 						inode->i_sb->s_time_gran);
 	if (ia_valid & ATTR_CTIME)
-		sd_iattr->ia_ctime = timespec_trunc(iattr->ia_ctime,
+		sd_iattr->ia_ctime = inode_time_trunc(iattr->ia_ctime,
 						inode->i_sb->s_time_gran);
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = iattr->ia_mode;
diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index ddcfe59..1b9ed3b 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -79,7 +79,7 @@ static struct inode *get_cramfs_inode(struct super_block *sb,
 	const struct cramfs_inode *cramfs_inode, unsigned int offset)
 {
 	struct inode *inode;
-	static struct timespec zerotime;
+	static struct inode_time zerotime;
 
 	inode = iget_locked(sb, cramino(cramfs_inode, offset));
 	if (!inode)
-- 
1.8.3.2


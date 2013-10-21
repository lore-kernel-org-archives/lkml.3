Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3JUIx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:53:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39891 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754595Ab3JUIxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Hui Wang" <hui.wang@canonical.com>,
        "Jan Kara" <jack@suse.cz>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.125140457@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 138/149] isofs: Refuse RW mount of the filesystem
 instead of making it RO
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 17b7f7cf58926844e1dd40f5eb5348d481deca6a upstream.

Refuse RW mount of isofs filesystem. So far we just silently changed it
to RO mount but when the media is writeable, block layer won't notice
this change and thus will think device is used RW and will block eject
button of the drive. That is unexpected by users because for
non-writeable media eject button works just fine.

Userspace mount(8) command handles this just fine and retries mounting
with MS_RDONLY set so userspace shouldn't see any regression.  Plus any
tool mounting isofs is likely confronted with the case of read-only
media where block layer already refuses to mount the filesystem without
MS_RDONLY set so our behavior shouldn't be anything new for it.

Reported-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/isofs/inode.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -120,8 +120,8 @@ static void destroy_inodecache(void)
 
 static int isofs_remount(struct super_block *sb, int *flags, char *data)
 {
-	/* we probably want a lot more here */
-	*flags |= MS_RDONLY;
+	if (!(*flags & MS_RDONLY))
+		return -EROFS;
 	return 0;
 }
 
@@ -770,15 +770,6 @@ root_found:
 	 */
 	s->s_maxbytes = 0x80000000000LL;
 
-	/*
-	 * The CDROM is read-only, has no nodes (devices) on it, and since
-	 * all of the files appear to be owned by root, we really do not want
-	 * to allow suid.  (suid or devices will not show up unless we have
-	 * Rock Ridge extensions)
-	 */
-
-	s->s_flags |= MS_RDONLY /* | MS_NODEV | MS_NOSUID */;
-
 	/* Set this for reference. Its not currently used except on write
 	   which we don't have .. */
 
@@ -1535,6 +1526,9 @@ struct inode *isofs_iget(struct super_bl
 static struct dentry *isofs_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
+	/* We don't support read-write mounts */
+	if (!(flags & MS_RDONLY))
+		return ERR_PTR(-EACCES);
 	return mount_bdev(fs_type, flags, dev_name, data, isofs_fill_super);
 }
 


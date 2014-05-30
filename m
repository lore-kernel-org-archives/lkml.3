Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934688AbaE3UK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:10:57 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:54640 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934650AbaE3UKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:10:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: [RFC 25/32] gfs2: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:49 +0200
Message-Id: <1401480116-1973111-26-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:sIUT4tCoxx2vbX9UHqhzrW4jzrSKa5igYAFPOlrIC93
 GdXpIvHV5jRJDKysLoR4CtN3e1gMVpxAezygK+DU+46hXU1n48
 GlNzV/xMhBRIvj398uEL++XQC5vFyNdV+QFnnR3CTdo8KoDs+V
 uZ7n2YmA34/RgICMtSyFbeSsXv28GYg6eP5svpjG746mk52bsM
 I2ZTPiw+uEvRIxjlNyWJK+Mq9CL2wWcMu7acpROtED9su9DaCF
 SGhNmO+lPzRFNT3D8tyB6Rf7SdSoXLaher449g+LaM97INaLol
 wdhB1kYHTgvj5ASOTjy0Z6dxhOYTdEiw+Ht5t4v1c4o8cKovC7
 gBcAtqRYk1OdM3uD6Df6UZTIck+trWR92N3vRUCaq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gfs2 uses 64-bit integers for inode timestamps, which will work
basically forever, but the VFS uses struct timespec for timestamps,
which is only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in gfs2.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com
---
 fs/gfs2/dir.c   | 6 +++---
 fs/gfs2/glops.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 1a349f9..ec57538 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -835,7 +835,7 @@ static struct gfs2_leaf *new_leaf(struct inode *inode, struct buffer_head **pbh,
 	struct gfs2_leaf *leaf;
 	struct gfs2_dirent *dent;
 	struct qstr name = { .name = "" };
-	struct timespec tv = CURRENT_TIME;
+	struct inode_time tv = CURRENT_TIME;
 
 	error = gfs2_alloc_blocks(ip, &bn, &n, 0, NULL);
 	if (error)
@@ -1716,7 +1716,7 @@ int gfs2_dir_add(struct inode *inode, const struct qstr *name,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct buffer_head *bh = da->bh;
 	struct gfs2_dirent *dent = da->dent;
-	struct timespec tv;
+	struct inode_time tv;
 	struct gfs2_leaf *leaf;
 	int error;
 
@@ -1794,7 +1794,7 @@ int gfs2_dir_del(struct gfs2_inode *dip, const struct dentry *dentry)
 	const struct qstr *name = &dentry->d_name;
 	struct gfs2_dirent *dent, *prev = NULL;
 	struct buffer_head *bh;
-	struct timespec tv = CURRENT_TIME;
+	struct inode_time tv = CURRENT_TIME;
 
 	/* Returns _either_ the entry (if its first in block) or the
 	   previous entry otherwise */
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index fc11007..b55308f 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -318,7 +318,7 @@ static void gfs2_set_nlink(struct inode *inode, u32 nlink)
 static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 {
 	const struct gfs2_dinode *str = buf;
-	struct timespec atime;
+	struct inode_time atime;
 	u16 height, depth;
 
 	if (unlikely(ip->i_no_addr != be64_to_cpu(str->di_num.no_addr)))
@@ -341,7 +341,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	gfs2_set_inode_blocks(&ip->i_inode, be64_to_cpu(str->di_blocks));
 	atime.tv_sec = be64_to_cpu(str->di_atime);
 	atime.tv_nsec = be32_to_cpu(str->di_atime_nsec);
-	if (timespec_compare(&ip->i_inode.i_atime, &atime) < 0)
+	if (inode_time_compare(&ip->i_inode.i_atime, &atime) < 0)
 		ip->i_inode.i_atime = atime;
 	ip->i_inode.i_mtime.tv_sec = be64_to_cpu(str->di_mtime);
 	ip->i_inode.i_mtime.tv_nsec = be32_to_cpu(str->di_mtime_nsec);
-- 
1.8.3.2


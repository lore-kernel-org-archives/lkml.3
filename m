Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab3EVC4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 22:56:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab3EVC4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 22:56:14 -0400
Date: Tue, 21 May 2013 22:56:05 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130522025605.GA29767@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
References: <20130521225257.GA12713@redhat.com>
 <20130521233429.GW29466@dastard>
 <20130521234016.GB14347@redhat.com>
 <20130521235410.GY29466@dastard>
 <20130522000803.GA19891@redhat.com>
 <20130522001603.GZ29466@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20130522001603.GZ29466@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 10:16:03AM +1000, Dave Chinner wrote:

Seems like I can trigger this from paths other than truncate too.. (eg, sys_open)

Here's what I ended up with for debug

diff --git a/fs/dcache.c b/fs/dcache.c
index 2b39d16..b579dfe 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2792,6 +2792,7 @@ char *dentry_path(struct dentry *dentry, char *buf, int buflen)
 Elong:
        return ERR_PTR(-ENAMETOOLONG);
 }
+EXPORT_SYMBOL(dentry_path);
 
 /*
  * NOTE! The user-level library version returns a
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d82efaa..8419e63 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -47,6 +47,7 @@
 #include <linux/security.h>
 #include <linux/fiemap.h>
 #include <linux/slab.h>
+#include <linux/dcache.h>
 
 static int
 xfs_initxattrs(
@@ -714,9 +715,20 @@ xfs_setattr_size(
                return XFS_ERROR(error);
 
        ASSERT(S_ISREG(ip->i_d.di_mode));
-       ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
+       if ((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
                        ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
-                       ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+                       ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0) {
+
+               struct dentry *dentry = d_find_any_alias(VFS_I(ip));
+               char buf[MAXPATHLEN];
+
+               dentry_path(dentry, buf, MAXPATHLEN);
+               dput(dentry);
+               xfs_warn(mp, "%s: mask 0x%x mismatch on file %s\n",
+                        __func__, mask, buf);
+
+                ASSERT(0);
+       }
 
        if (!(flags & XFS_ATTR_NOLOCK)) {
                lock_flags |= XFS_IOLOCK_EXCL;


Something isn't right though I think.. Because the filenames it outputs
look like crap.

[   71.406552] XFS (sda2): xfs_setattr_size: mask 0xa068 mismatch on file 0\xffffffee<\xffffff88\xffffffff\xffffffff\xffffff80O\xffffff82\xffffffff\xffffffff\xffffffff\xffffffff

The mask is always 0xa068 though if that helps.

	Dave


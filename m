Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943Ab3JOUTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:19:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47398 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439Ab3JOUTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:19:07 -0400
Date: Tue, 15 Oct 2013 13:19:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com
Subject: Re: fs/attr.c:notify_change locking warning.
Message-ID: <20131015201905.GA7509@infradead.org>
References: <20131005005210.GA25773@redhat.com>
 <20131005031918.GL4446@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131005031918.GL4446@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 01:19:18PM +1000, Dave Chinner wrote:
> Yup, we don't hold the i_mutex *at all* through the fast path for
> direct IO writes. Having to grab the i_mutex on every IO just for
> the extremely unlikely case we need to remove a suid bit on the file
> would add a significant serialisation point into the direct Io model
> that XFS uses, and is the difference between 50,000 and 2+ million
> direct IO IOPS to a single file.
> 
> I'm unwilling to sacrifice the concurrency of direct IO writes just
> to shut up ths warning, especially as the actual modifications that
> are made to remove SUID bits are correctly serialised within XFS
> once notify_change() calls ->setattr(). If it really matters, I'll
> just open code file_remove_suid() into XFS like ocfs2 does just so
> we don't get that warning being emitted by trinity.

But the i_lock doesn't synchronize against the VFS modifying various
struct inode fields.  The right fix is to take i_mutex just in case
we actually need to remove the suid bit.  The patch below should fix it,
although I need to write a testcase that actually exercises it first.

Dave (J.): if you have time to try the patch below please go ahead,
if not I'll make sure to write an isolated test ASAP to verify it and
will then submit the change.

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4c749ab..e879f96 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -590,8 +590,22 @@ restart:
 	 * If we're writing the file then make sure to clear the setuid and
 	 * setgid bits if the process is not being run by root.  This keeps
 	 * people from modifying setuid and setgid binaries.
+	 *
+	 * Note that file_remove_suid must be called with the i_mutex held,
+	 * so we have to go through some hoops here to make sure we hold it.
 	 */
-	return file_remove_suid(file);
+	if (!IS_NOSEC(inode) && should_remove_suid(file->f_path.dentry)) {
+		if (*iolock == XFS_IOLOCK_SHARED) {
+			mutex_lock(&inode->i_mutex);
+			error = file_remove_suid(file);
+			mutex_unlock(&inode->i_mutex);
+		} else {
+			error = file_remove_suid(file);
+		}
+
+	}
+
+	return error;
 }
 
 /*

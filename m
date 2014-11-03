Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaKCQlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:41:19 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:32857 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaKCQlS convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 3 Nov 2014 11:41:18 -0500
Message-Id: <5457BE390200007800044838@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Mon, 03 Nov 2014 16:41:13 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jan Kara" <jack@suse.cz>
Cc: <david@fromorbit.com>, <xfs@oss.sgi.com>, <linux-kernel@vger.kernel.org>
Subject: your patch "mm: Remove false WARN_ON from
 pagecache_isize_extended()"
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan,

having run into that warning too, I looked into it a little, and now
having found that patch am pretty uncertain: Both truncate_setsize()
and pagecache_isize_extended() document that they want to be
called with i_mutex held, so removing the WARN_ON() alone seems
either incomplete or wrong. What I found to work without violating
this documented requirement is the patch below.

Jan

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -797,7 +797,7 @@ xfs_file_fallocate(
 		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
 		return -EOPNOTSUPP;
 
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
@@ -877,7 +877,7 @@ xfs_file_fallocate(
 	}
 
 out_unlock:
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
 	return error;
 }
 



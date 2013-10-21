Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3JUJQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:16:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39568 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076Ab3JUIvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Weber" <wb@munzinger.de>,
        "Mark Fashen" <mfasheh@suse.de>,
        "Sunil Mushran" <sunil.mushran@gmail.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Joel Becker" <jlbec@evilplan.org>, "Jie Liu" <jeff.liu@oracle.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.104982532@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 064/149] ocfs2: fix the end cluster offset of FIEMAP
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Liu <jeff.liu@oracle.com>

commit 28e8be31803b19d0d8f76216cb11b480b8a98bec upstream.

Call fiemap ioctl(2) with given start offset as well as an desired mapping
range should show extents if possible.  However, we somehow figure out the
end offset of mapping via 'mapping_end -= cpos' before iterating the
extent records which would cause problems if the given fiemap length is
too small to a cluster size, e.g,

Cluster size 4096:
debugfs.ocfs2 1.6.3
        Block Size Bits: 12   Cluster Size Bits: 12

The extended fiemap test utility From David:
https://gist.github.com/anonymous/6172331

# dd if=/dev/urandom of=/ocfs2/test_file bs=1M count=1000
# ./fiemap /ocfs2/test_file 4096 10
start: 4096, length: 10
File /ocfs2/test_file has 0 extents:
#	Logical          Physical         Length           Flags
	^^^^^ <-- No extent is shown

In this case, at ocfs2_fiemap(): cpos == mapping_end == 1. Hence the
loop of searching extent records was not executed at all.

This patch remove the in question 'mapping_end -= cpos', and loops
until the cpos is larger than the mapping_end as usual.

# ./fiemap /ocfs2/test_file 4096 10
start: 4096, length: 10
File /ocfs2/test_file has 1 extents:
#	Logical          Physical         Length           Flags
0:	0000000000000000 0000000056a01000 0000000006a00000 0000

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reported-by: David Weber <wb@munzinger.de>
Tested-by: David Weber <wb@munzinger.de>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Mark Fashen <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ocfs2/extent_map.c | 1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -782,7 +782,6 @@ int ocfs2_fiemap(struct inode *inode, st
 	cpos = map_start >> osb->s_clustersize_bits;
 	mapping_end = ocfs2_clusters_for_bytes(inode->i_sb,
 					       map_start + map_len);
-	mapping_end -= cpos;
 	is_last = 0;
 	while (cpos < mapping_end && !is_last) {
 		u32 fe_flags;


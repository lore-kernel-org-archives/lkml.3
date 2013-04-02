Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871Ab3DBGsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:48:45 -0400
Received: from nschwqsrv03p.mx.bigpond.com ([61.9.189.237]:20114 "EHLO
	nschwqsrv03p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760828Ab3DBGsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:48:23 -0400
X-Greylist: delayed 3696 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Apr 2013 02:48:22 EDT
X-Authority-Analysis: v=2.0 cv=bcfpoZzB c=1 sm=1
 a=tpHzvNDyw14p4wpd1xf5Bw==:17 a=Z6DB6Y-OVF4A:10 a=aFTPlZ8mLXYA:10
 a=abLpnCq0AAAA:8 a=Zb3zDD2tv2kA:10 a=5_ONPxfc7pNm-2SI6XoA:9 a=8itaGvuMXGQA:10
 a=RaaI0lGTnnQSfnfD:21 a=Mfbs9ULY83bXvA28:21 a=tpHzvNDyw14p4wpd1xf5Bw==:117
From: gerg@uclinux.org
To: linux-kernel@vger.kernel.org, artem.bityutskiy@linux.intel.com
Cc: lliubbo@gmail.com, dhowells@redhat.com, lethal@linux-sh.org,
        linux-m68k@vger.kernel.org, uclinux-dev@uclinux.org,
        Greg Ungerer <gerg@uclinux.org>
Subject: [PATCH] romfs: fix nommu map length to keep inside filesystem
Date: Tue,  2 Apr 2013 15:44:47 +1000
Message-Id: <1364881487-30761-1-git-send-email-gerg@uclinux.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Ungerer <gerg@uclinux.org>

Checks introduced in commit 4991e7251 ("romfs: do not use
mtd->get_unmapped_area directly") re-introduce problems fixed in the earlier
commit 2b4b2482e ("romfs: fix romfs_get_unmapped_area() argument check").

If a flat binary app is located at the end of a romfs, its page aligned
length may be outside of the romfs filesystem. The flat binary loader, via
nommu do_mmap_pgoff(), page aligns the length it is mmaping. So simple
offset+size checks will fail - returning EINVAL.

We can truncate the length to keep it inside the romfs filesystem, and that
also keeps the call to mtd_get_unmapped_area() happy.

Are there any side effects to truncating the size here though?

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---
 fs/romfs/mmap-nommu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/romfs/mmap-nommu.c b/fs/romfs/mmap-nommu.c
index e1a7779..f373bde 100644
--- a/fs/romfs/mmap-nommu.c
+++ b/fs/romfs/mmap-nommu.c
@@ -49,8 +49,11 @@ static unsigned long romfs_get_unmapped_area(struct file *file,
 		return (unsigned long) -EINVAL;
 
 	offset += ROMFS_I(inode)->i_dataoffset;
-	if (offset > mtd->size - len)
+	if (offset >= mtd->size)
 		return (unsigned long) -EINVAL;
+	/* the mapping mustn't extend beyond the EOF */
+	if ((offset + len) > mtd->size)
+		len = mtd->size - offset;
 
 	ret = mtd_get_unmapped_area(mtd, len, offset, flags);
 	if (ret == -EOPNOTSUPP)
-- 
1.8.1.4


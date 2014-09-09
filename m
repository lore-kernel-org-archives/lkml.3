Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaIIEmC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 00:42:02 -0400
Received: from mail.kernel.org ([198.145.19.201]:53492 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbaIIEl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 00:41:59 -0400
Date: Mon, 8 Sep 2014 21:41:57 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net,
        Changman Lee <cm224.lee@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, trinity@vger.kernel.org,
        Dave Jones <davej@redhat.com>
Subject: Re: f2fs get_dnode_of_data oops
Message-ID: <20140909044157.GA24581@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <CA+ydwtrB-rJB1fURO+CC1J-=VZ16g9Un47cMSMAZsTFPNg2s+g@mail.gmail.com>
 <CA+ydwtrtyb5wQXCmyBigqufVz10UkKS76hVOY8mKc4FOyYmECw@mail.gmail.com>
 <20140908042056.GA13863@jaegeuk-mac02.hsd1.ca.comcast.net>
 <CA+ydwtrbsUD81u6FWysDvqNy942KOF9y=mAhxPfRQP8RG0sZuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ydwtrbsUD81u6FWysDvqNy942KOF9y=mAhxPfRQP8RG0sZuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tommi,

This patch should resolve this bug.
Thanks a lot. :)

>From ee24677b9917583f50f16b6f59771439f91b890c Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Mon, 8 Sep 2014 10:59:43 -0700
Subject: [PATCH] f2fs: fix negative value for lseek offset

If application throws negative value of lseek with SEEK_DATA|SEEK_HOLE,
previous f2fs went into BUG_ON in get_dnode_of_data, which was reported
by Tommi Rantala.

He could make a simple code to detect this having:
	lseek(fd, -17595150933902LL, SEEK_DATA);

This patch should resolve that bug.

Reported-by: Tommi Rentala <tt.rantala@gmail.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 9f0ea3d..c9a1295 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -281,7 +281,7 @@ static loff_t f2fs_seek_block(struct file *file, loff_t offset, int whence)
 	mutex_lock(&inode->i_mutex);
 
 	isize = i_size_read(inode);
-	if (offset >= isize)
+	if (offset >= isize || offset < 0)
 		goto fail;
 
 	/* handle inline data case */
-- 
1.8.5.2 (Apple Git-48)


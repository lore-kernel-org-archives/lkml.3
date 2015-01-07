Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbbAGBwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 20:52:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463AbbAGBvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:51:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3.18 18/84] f2fs: avoid returning uninitialized value to userspace from f2fs_trim_fs()
Date: Tue,  6 Jan 2015 17:49:21 -0800
Message-Id: <20150107014029.588612405@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 9bd27ae4aafc9bfee6c8791f7d801ea16cc5622b upstream.

If user specifies too low end sector for trimming, f2fs_trim_fs() will
use uninitialized value as a number of trimmed blocks and returns it to
userspace. Initialize number of trimmed blocks early to avoid the
problem.

Coverity-id: 1248809
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/segment.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1004,6 +1004,7 @@ int f2fs_trim_fs(struct f2fs_sb_info *sb
 						range->len < sbi->blocksize)
 		return -EINVAL;
 
+	cpc.trimmed = 0;
 	if (end <= MAIN_BLKADDR(sbi))
 		goto out;
 
@@ -1015,7 +1016,6 @@ int f2fs_trim_fs(struct f2fs_sb_info *sb
 	cpc.trim_start = start_segno;
 	cpc.trim_end = end_segno;
 	cpc.trim_minlen = range->minlen >> sbi->log_blocksize;
-	cpc.trimmed = 0;
 
 	/* do checkpoint to issue discard commands safely */
 	write_checkpoint(sbi, &cpc);



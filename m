Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3KAKY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 06:24:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33894 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab3KAKY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 06:24:57 -0400
Date: Fri, 1 Nov 2013 13:21:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] quota: info leak in quota_getquota()
Message-ID: <20131101102154.GC29795@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The if_dqblk struct has a 4 byte hole at the end of the struct so
uninitialized stack information is leaked to user space.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index dea86e8..2b363e2 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -117,6 +117,7 @@ static int quota_setinfo(struct super_block *sb, int type, void __user *addr)
 
 static void copy_to_if_dqblk(struct if_dqblk *dst, struct fs_disk_quota *src)
 {
+	memset(dst, 0, sizeof(*dst));
 	dst->dqb_bhardlimit = src->d_blk_hardlimit;
 	dst->dqb_bsoftlimit = src->d_blk_softlimit;
 	dst->dqb_curspace = src->d_bcount;

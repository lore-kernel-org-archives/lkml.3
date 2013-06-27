Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3F0H4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:56:07 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:53709 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab3F0H4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:56:06 -0400
Date: Thu, 27 Jun 2013 15:56:06 +0800
From: majianpeng <majianpeng@gmail.com>
To: sage <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH] ceph: Don't use ceph-sync-mode for synchronous-fs.
X-Priority: 3
X-GUID: 0BB5DB46-89B9-41E2-A7E8-27EFEEF5D5B7
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201306271556037311581@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5R7uJaW012167

At now for synchronous-fs, all write-operations use ceph_sync_mode.
But for the file which opened with O_SYNC, it don't use sync_mode.
The behaviour of them should be the same.
For fs which mounted using '-o sync', it want all I/O to the filesystem
should be done synchronously.But the ceph-sync-mode don't be suitful
for.For example,using ceph-sync-mode the content of file don't have in
memory.This will cause the following read only from osd rather than
memory.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/ceph/file.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 656e169..44670ad 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -659,7 +659,6 @@ again:
 
 	if ((got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0 ||
 	    (iocb->ki_filp->f_flags & O_DIRECT) ||
-	    (inode->i_sb->s_flags & MS_SYNCHRONOUS) ||
 	    (fi->flags & CEPH_F_SYNC))
 		/* hmm, this isn't really async... */
 		ret = ceph_sync_read(filp, base, len, ppos, &checkeof);
@@ -764,7 +763,6 @@ retry_snap:
 
 	if ((got & (CEPH_CAP_FILE_BUFFER|CEPH_CAP_FILE_LAZYIO)) == 0 ||
 	    (iocb->ki_filp->f_flags & O_DIRECT) ||
-	    (inode->i_sb->s_flags & MS_SYNCHRONOUS) ||
 	    (fi->flags & CEPH_F_SYNC)) {
 		mutex_unlock(&inode->i_mutex);
 		written = ceph_sync_write(file, iov->iov_base, count,
-- 
1.8.1.2
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

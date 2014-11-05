Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaKEHJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:09:41 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:51840 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaKEHJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:09:40 -0500
X-Original-SENDERIP: 10.177.226.38
X-Original-MAILFROM: sh.yoon@lge.com
From: sh.yoon@lge.com
To: miklos@szeredi.hu
Cc: xemul@openvz.org, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, seungho1.park@lge.com,
        iamyooon@gmail.com, hyc.lee@gmail.com, "sh.yoon" <sh.yoon@lge.com>
Subject: [PATCH] fuse : fix fuse writeback problem with O_WRONLY
Date: Wed,  5 Nov 2014 16:09:17 +0900
Message-Id: <1415171357-32520-1-git-send-email-sh.yoon@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "sh.yoon" <sh.yoon@lge.com>

With cache writeback turned on(kernel & library & user-fs),
writing to a file that is opened with O_WRONLY flag fails
to write and return EBADF error as below.

strace result :

open("/storage/emulated/legacy/tempfile.txt", O_WRONLY) = 3
write(3, "hello world\n\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 2048)
= -1 EBADF (Bad file number)

It is due to fuse_do_readpage( ) while writing a data
to page cache which isn't up-to-date.
For updating the page, fuse_do_readpage( ) tries to read
a page from a file which is opened with O_WRONLY flag

For example,
consider Ext4 is used for backend file system.
When we open a fuse file with O_WRONLY flag then
at the same time, a ext4 file would be opened with same flag
O_WRONLY.

But for writing, fuse cache writeback needs to read data
from the file in ext4 for updating fuse file page cache.
So fuse_do_read() function sends read request to fuse
library and let user-fs call read() from the ext4 file
which was opened with O_WRONLY flag.

refer to following sequence.

(1) generic_perform_write()
(2) fuse_write_begin()
(3) fuse_do_readpage()
(4) send read-request
(5) read() invoked by user-fs
(6) EBADF error occured

To resolve this problem,
when a fuse file is opened with O_WRONLY, changing backend-fs
open flag from O_WRONLY to O_RDWR could be a solution.
Because changed flag O_RDWR for user-fs would be used by fuse
file system internally, so O_WRONLY flag is still effective for
a user accesing through fuse file system.

Reported-by: hyunchul.lee <hyc.lee@gmail.com>
Signed-off-by: sh.yoon <sh.yoon@lge.com>
---
 fs/fuse/file.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index caa8d95..f93b748 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -35,6 +35,17 @@ static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 	inarg.flags = file->f_flags & ~(O_CREAT | O_EXCL | O_NOCTTY);
 	if (!fc->atomic_o_trunc)
 		inarg.flags &= ~O_TRUNC;
+
+	/*
+	 * If we open file with O_WRONLY flag,
+	 * page writeback would fail when reading a page is needed.
+	 * so it need to change O_WRONLY to O_RDWR.
+	 */
+	if ((inarg.flags & O_WRONLY) && fc->writeback_cache) {
+		inarg.flags &= ~O_WRONLY;
+		inarg.flags |= O_RDWR;
+	}
+
 	req->in.h.opcode = opcode;
 	req->in.h.nodeid = nodeid;
 	req->in.numargs = 1;
-- 
1.7.9.5


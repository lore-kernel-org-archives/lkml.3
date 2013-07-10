Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3GJXNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 19:13:04 -0400
Received: from mail-gh0-f202.google.com ([209.85.160.202]:63464 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3GJXNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 19:13:01 -0400
From: Paul Taysom <taysom@chromium.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, jack@suse.cz,
        taysom@chromium.org, sonnyrao@chromium.org
Subject: [PATCH] fs: sync: fixed performance regression
Date: Wed, 10 Jul 2013 16:12:36 -0700
Message-Id: <1373497956-8770-1-git-send-email-taysom@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit introduced a 10x regression for
syncing inodes in ext4 with relatime enabled where just
the atime had been modified.

    commit 4ea425b63a3dfeb7707fc7cc7161c11a51e871ed
    Author: Jan Kara <jack@suse.cz>
    Date:   Tue Jul 3 16:45:34 2012 +0200
    vfs: Avoid unnecessary WB_SYNC_NONE writeback during sys_sync and reorder sync passes

    See also: http://www.kernelhub.org/?msg=93100&p=2

Fixed by putting back in the call to writeback_inodes_sb.

I'll attach the test in a reply to this e-mail.

The test starts by creating 512 files, syncing, reading one byte
from each of those files, syncing, and then deleting each file
and syncing. The time to do each sync is printed. The process
is then repeated for 1024 files and then the next power of
two up to 262144 files.

Note, when running the test, the slow down doesn't always happen
but most of the tests will show a slow down.

In response to crbug.com/240422

Signed-off-by: Paul Taysom <taysom@chromium.org>
---
 fs/sync.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/sync.c b/fs/sync.c
index 905f3f6..55c3316 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -73,6 +73,12 @@ static void sync_inodes_one_sb(struct super_block *sb, void *arg)
 		sync_inodes_sb(sb);
 }
 
+static void writeback_inodes_one_sb(struct super_block *sb, void *arg)
+{
+	if (!(sb->s_flags & MS_RDONLY))
+		writeback_inodes_sb(sb, WB_REASON_SYNC);
+}
+
 static void sync_fs_one_sb(struct super_block *sb, void *arg)
 {
 	if (!(sb->s_flags & MS_RDONLY) && sb->s_op->sync_fs)
@@ -104,6 +110,7 @@ SYSCALL_DEFINE0(sync)
 	int nowait = 0, wait = 1;
 
 	wakeup_flusher_threads(0, WB_REASON_SYNC);
+	iterate_supers(writeback_inodes_one_sb, NULL);
 	iterate_supers(sync_inodes_one_sb, NULL);
 	iterate_supers(sync_fs_one_sb, &nowait);
 	iterate_supers(sync_fs_one_sb, &wait);
-- 
1.8.3


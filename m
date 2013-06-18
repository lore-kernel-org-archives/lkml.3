Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab3FRL6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:58:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56113 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab3FRLoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 49/93] hpfs: fix warnings when the filesystem fills up
Date: Tue, 18 Jun 2013 12:42:57 +0100
Message-Id: <1371555821-12820-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

commit bbd465df73f0d8ba41b8a0732766a243d0f5b356 upstream.

This patch fixes warnings due to missing lock on write error path.

  WARNING: at fs/hpfs/hpfs_fn.h:353 hpfs_truncate+0x75/0x80 [hpfs]()
  Hardware name: empty
  Pid: 26563, comm: dd Tainted: P           O 3.9.4 #12
  Call Trace:
    hpfs_truncate+0x75/0x80 [hpfs]
    hpfs_write_begin+0x84/0x90 [hpfs]
    _hpfs_bmap+0x10/0x10 [hpfs]
    generic_file_buffered_write+0x121/0x2c0
    __generic_file_aio_write+0x1c7/0x3f0
    generic_file_aio_write+0x7c/0x100
    do_sync_write+0x98/0xd0
    hpfs_file_write+0xd/0x50 [hpfs]
    vfs_write+0xa2/0x160
    sys_write+0x51/0xa0
    page_fault+0x22/0x30
    system_call_fastpath+0x1a/0x1f

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/hpfs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index fbfe2df..4816908 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -109,10 +109,14 @@ static void hpfs_write_failed(struct address_space *mapping, loff_t to)
 {
 	struct inode *inode = mapping->host;
 
+	hpfs_lock(inode->i_sb);
+
 	if (to > inode->i_size) {
 		truncate_pagecache(inode, to, inode->i_size);
 		hpfs_truncate(inode);
 	}
+
+	hpfs_unlock(inode->i_sb);
 }
 
 static int hpfs_write_begin(struct file *file, struct address_space *mapping,
-- 
1.8.1.2


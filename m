Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab3FKUEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:04:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab3FKUEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 48/79] hpfs: fix warnings when the filesystem fills up
Date: Tue, 11 Jun 2013 13:03:14 -0700
Message-Id: <20130611195322.249247800@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/hpfs/file.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -109,10 +109,14 @@ static void hpfs_write_failed(struct add
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



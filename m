Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab3LRVJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:09:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab3LRVJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:09:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.4 30/31] hpfs: fix warnings when the filesystem fills up
Date: Wed, 18 Dec 2013 13:08:38 -0800
Message-Id: <20131218210523.638553832@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218210522.790152625@linuxfoundation.org>
References: <20131218210522.790152625@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
 fs/hpfs/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -116,9 +116,12 @@ static int hpfs_write_begin(struct file
 				hpfs_get_block,
 				&hpfs_i(mapping->host)->mmu_private);
 	if (unlikely(ret)) {
-		loff_t isize = mapping->host->i_size;
+		loff_t isize;
+		hpfs_lock(mapping->host->i_sb);
+		isize = mapping->host->i_size;
 		if (pos + len > isize)
 			vmtruncate(mapping->host, isize);
+		hpfs_unlock(mapping->host->i_sb);
 	}
 
 	return ret;



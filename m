Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaBLIQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:16:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50354 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752269AbaBLIOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:14 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Mikulas Patocka" <mikulas@artax.karlin.mff.cuni.cz>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.994746897@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 23/79] hpfs: fix warnings when the filesystem fills up
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
[Mikulas Patocka: This is backport of upstream commit 
 bbd465df73f0d8ba41b8a0732766a243d0f5b356, modified for stable kernels 
 2.6.39 - 3.7.]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


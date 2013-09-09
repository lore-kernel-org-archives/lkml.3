Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab3IIS3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:29:01 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:63008 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab3IIS27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:28:59 -0400
Date: Mon, 9 Sep 2013 14:28:57 -0400
From: Milosz Tanski <milosz@adfin.com>
To: ceph-devel@vger.kernel.org
Cc: sage@inktank.com, dhowells@redhat.com, zheng.z.yan@intel.com,
        linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fscache: check consistency does not decrement refcount
Message-ID: <fd69f2052bc16d5a5de0104ca00ccc59478e3569.1378750714.git.milosz@adfin.com>
References: <alpine.DEB.2.00.1309091042520.18214@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1309091042520.18214@cobra.newdream.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__fscache_check_consistency() does not decrement the count of operations
active after it finishes in the success case. This leads to a hung tasks on
cookie de-registration (commonly in inode eviction).

INFO: task kworker/1:2:4214 blocked for more than 120 seconds.
kworker/1:2     D ffff880443513fc0     0  4214      2 0x00000000
Workqueue: ceph-msgr con_work [libceph]
  ...
Call Trace:
 [<ffffffff81569fc6>] ? _raw_spin_unlock_irqrestore+0x16/0x20
 [<ffffffffa0016570>] ? fscache_wait_bit_interruptible+0x30/0x30 [fscache]
 [<ffffffff81568d09>] schedule+0x29/0x70
 [<ffffffffa001657e>] fscache_wait_atomic_t+0xe/0x20 [fscache]
 [<ffffffff815665cf>] out_of_line_wait_on_atomic_t+0x9f/0xe0
 [<ffffffff81083560>] ? autoremove_wake_function+0x40/0x40
 [<ffffffffa0015a9c>] __fscache_relinquish_cookie+0x15c/0x310 [fscache]
 [<ffffffffa00a4fae>] ceph_fscache_unregister_inode_cookie+0x3e/0x50 [ceph]
 [<ffffffffa007e373>] ceph_destroy_inode+0x33/0x200 [ceph]
 [<ffffffff811c13ae>] ? __fsnotify_inode_delete+0xe/0x10
 [<ffffffff8119ba1c>] destroy_inode+0x3c/0x70
 [<ffffffff8119bb69>] evict+0x119/0x1b0

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 fs/fscache/cookie.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 318e843..b2a86e3 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -586,7 +586,8 @@ int __fscache_check_consistency(struct fscache_cookie *cookie)
 
 	fscache_operation_init(op, NULL, NULL);
 	op->flags = FSCACHE_OP_MYTHREAD |
-		(1 << FSCACHE_OP_WAITING);
+		(1 << FSCACHE_OP_WAITING) |
+		(1 << FSCACHE_OP_UNUSE_COOKIE);
 
 	spin_lock(&cookie->lock);
 
-- 
1.7.9.5


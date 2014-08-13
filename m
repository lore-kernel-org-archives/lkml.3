Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaHMQ6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:58:31 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:45396 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbaHMQ61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:58:27 -0400
Message-ID: <53EB9932.8010203@adfin.com>
Date: Wed, 13 Aug 2014 12:58:26 -0400
From: Milosz Tanski <milosz@adfin.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-cachefs@redhat.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3/3] FS-Cache: refcount becomes corrupt under vma pressure.
References: <cover.1407948737.git.milosz@adfin.com>
In-Reply-To: <cover.1407948737.git.milosz@adfin.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rare cases under heavy VMA pressure the ref count for a fscache cookie
becomes corrupt. In this case we decrement ref count even if we fail before
incrementing the refcount.

FS-Cache: Assertion failed bnode-eca5f9c6/syslog
0 > 0 is false
------------[ cut here ]------------
kernel BUG at fs/fscache/cookie.c:519!
invalid opcode: 0000 [#1] SMP
Call Trace:
[<ffffffffa01ba060>] __fscache_relinquish_cookie+0x50/0x220 [fscache]
[<ffffffffa02d64ce>] ceph_fscache_unregister_inode_cookie+0x3e/0x50 [ceph]
[<ffffffffa02ae1d3>] ceph_destroy_inode+0x33/0x200 [ceph]
[<ffffffff811cf67e>] ? __fsnotify_inode_delete+0xe/0x10
[<ffffffff811a9e0c>] destroy_inode+0x3c/0x70
[<ffffffff811a9f51>] evict+0x111/0x180
[<ffffffff811aa763>] iput+0x103/0x190
[<ffffffff811a5de8>] __dentry_kill+0x1c8/0x220
[<ffffffff811a5f31>] shrink_dentry_list+0xf1/0x250
[<ffffffff811a762c>] prune_dcache_sb+0x4c/0x60
[<ffffffff811930af>] super_cache_scan+0xff/0x170
[<ffffffff8113d7a0>] shrink_slab_node+0x140/0x2c0
[<ffffffff8113f2da>] shrink_slab+0x8a/0x130
[<ffffffff81142572>] balance_pgdat+0x3e2/0x5d0
[<ffffffff811428ca>] kswapd+0x16a/0x4a0
[<ffffffff810a43f0>] ? __wake_up_sync+0x20/0x20
[<ffffffff81142760>] ? balance_pgdat+0x5d0/0x5d0
[<ffffffff81083e09>] kthread+0xc9/0xe0
[<ffffffff81010000>] ? ftrace_raw_event_xen_mmu_release_ptpage+0x70/0x90
[<ffffffff81083d40>] ? flush_kthread_worker+0xb0/0xb0
[<ffffffff8159f63c>] ret_from_fork+0x7c/0xb0
[<ffffffff81083d40>] ? flush_kthread_worker+0xb0/0xb0
RIP [<ffffffffa01b984b>] __fscache_disable_cookie+0x1db/0x210 [fscache]
RSP <ffff8803bc85f9b8>
---[ end trace 254d0d7c74a01f25 ]---

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 fs/fscache/page.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 4911f2cf..fdfe996 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -199,7 +199,7 @@ int __fscache_attr_changed(struct fscache_cookie *cookie)
 {
 	struct fscache_operation *op;
 	struct fscache_object *object;
-	bool wake_cookie;
+	bool wake_cookie = false;
 
 	_enter("%p", cookie);
 
@@ -229,15 +229,16 @@ int __fscache_attr_changed(struct fscache_cookie *cookie)
 
 	__fscache_use_cookie(cookie);
 	if (fscache_submit_exclusive_op(object, op) < 0)
-		goto nobufs;
+		goto nobufs_dec;
 	spin_unlock(&cookie->lock);
 	fscache_stat(&fscache_n_attr_changed_ok);
 	fscache_put_operation(op);
 	_leave(" = 0");
 	return 0;
 
-nobufs:
+nobufs_dec:
 	wake_cookie = __fscache_unuse_cookie(cookie);
+nobufs:
 	spin_unlock(&cookie->lock);
 	kfree(op);
 	if (wake_cookie)
-- 
1.7.9.5




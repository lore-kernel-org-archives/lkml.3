Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3LJPWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:22:38 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:39514 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3LJPWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:22:36 -0500
Date: Tue, 10 Dec 2013 10:22:30 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Vlastimil Babka <vbabka@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH driver-core-next] sysfs: fix use-after-free in sysfs_kill_sb()
Message-ID: <20131210152230.GB4610@htj.dyndns.org>
References: <20131205031051.GC5135@yliu-dev.sh.intel.com>
 <20131205225019.GA32005@mtj.dyndns.org>
 <20131209145651.GV5135@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131209145651.GV5135@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e09aae4796ac5b90c6514fc9789fc259bf783129 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 10 Dec 2013 10:16:30 -0500

While restructuring the [u]mount path, 4b93dc9b1c68 ("sysfs, kernfs:
prepare mount path for kernfs") incorrectly updated sysfs_kill_sb() so
that it first kills super_block and then tries to dereference its
namespace tag to drop it.  Fix it by caching namespace tag before
killing the superblock and then drop the cached namespace tag.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Tested-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Tested-by: Vlastimil Babka <vbabka@suse.cz>
Link: http://lkml.kernel.org/g/20131205031051.GC5135@yliu-dev.sh.intel.com
---
 fs/sysfs/mount.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index e7e3aa8..8d07527 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -45,8 +45,10 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 
 static void sysfs_kill_sb(struct super_block *sb)
 {
+	void *ns = (void *)kernfs_super_ns(sb);
+
 	kernfs_kill_sb(sb);
-	kobj_ns_drop(KOBJ_NS_TYPE_NET, (void *)kernfs_super_ns(sb));
+	kobj_ns_drop(KOBJ_NS_TYPE_NET, ns);
 }
 
 static struct file_system_type sysfs_fs_type = {
-- 
1.8.4.2


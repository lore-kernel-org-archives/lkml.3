Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbaJIVHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:07:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59087 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400AbaJIVGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:06:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Dan Aloni <dan@kernelim.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 044/163] nfs: fix kernel warning when removing proc entry
Date: Thu,  9 Oct 2014 14:01:09 -0700
Message-Id: <1412888588-26755-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 21e81002f9788a3af591416b6dec60d7b67f2fb2 upstream.

I saw the following kernel warning:

[ 1852.321222] ------------[ cut here ]------------
[ 1852.326527] WARNING: CPU: 0 PID: 118 at fs/proc/generic.c:521 remove_proc_entry+0x154/0x16b()
[ 1852.335630] remove_proc_entry: removing non-empty directory 'fs/nfsfs', leaking at least 'volumes'
[ 1852.344084] CPU: 0 PID: 118 Comm: kworker/u8:2 Not tainted 3.16.0+ #540
[ 1852.350036] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1852.354992] Workqueue: netns cleanup_net
[ 1852.358701]  0000000000000000 ffff880116f2fbd0 ffffffff819c03e9 ffff880116f2fc18
[ 1852.366474]  ffff880116f2fc08 ffffffff810744ee ffffffff811e0e6e ffff8800d4e96238
[ 1852.373507]  ffffffff81dbe665 ffff8800d46a5948 0000000000000005 ffff880116f2fc68
[ 1852.380224] Call Trace:
[ 1852.381976]  [<ffffffff819c03e9>] dump_stack+0x4d/0x66
[ 1852.385495]  [<ffffffff810744ee>] warn_slowpath_common+0x7a/0x93
[ 1852.389869]  [<ffffffff811e0e6e>] ? remove_proc_entry+0x154/0x16b
[ 1852.393987]  [<ffffffff8107457b>] warn_slowpath_fmt+0x4c/0x4e
[ 1852.397999]  [<ffffffff811e0e6e>] remove_proc_entry+0x154/0x16b
[ 1852.402034]  [<ffffffff8129c73d>] nfs_fs_proc_net_exit+0x53/0x56
[ 1852.406136]  [<ffffffff812a103b>] nfs_net_exit+0x12/0x1d
[ 1852.409774]  [<ffffffff81785bc9>] ops_exit_list+0x44/0x55
[ 1852.413529]  [<ffffffff81786389>] cleanup_net+0xee/0x182
[ 1852.417198]  [<ffffffff81088c9e>] process_one_work+0x209/0x40d
[ 1852.502320]  [<ffffffff81088bf7>] ? process_one_work+0x162/0x40d
[ 1852.587629]  [<ffffffff810890c1>] worker_thread+0x1f0/0x2c7
[ 1852.673291]  [<ffffffff81088ed1>] ? process_scheduled_works+0x2f/0x2f
[ 1852.759470]  [<ffffffff8108e079>] kthread+0xc9/0xd1
[ 1852.843099]  [<ffffffff8109427f>] ? finish_task_switch+0x3a/0xce
[ 1852.926518]  [<ffffffff8108dfb0>] ? __kthread_parkme+0x61/0x61
[ 1853.008565]  [<ffffffff819cbeac>] ret_from_fork+0x7c/0xb0
[ 1853.076477]  [<ffffffff8108dfb0>] ? __kthread_parkme+0x61/0x61
[ 1853.140653] ---[ end trace 69c4c6617f78e32d ]---

It looks wrong that we add "/proc/net/nfsfs" in nfs_fs_proc_net_init()
while remove "/proc/fs/nfsfs" in nfs_fs_proc_net_exit().

Fixes: commit 65b38851a17 (NFS: Fix /proc/fs/nfsfs/servers and /proc/fs/nfsfs/volumes)
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Dan Aloni <dan@kernelim.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
[Trond: replace uses of remove_proc_entry() with remove_proc_subtree()
as suggested by Al Viro]
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/client.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 180d1ec..6e37cd0 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1404,24 +1404,18 @@ int nfs_fs_proc_net_init(struct net *net)
 	p = proc_create("volumes", S_IFREG|S_IRUGO,
 			nn->proc_nfsfs, &nfs_volume_list_fops);
 	if (!p)
-		goto error_2;
+		goto error_1;
 	return 0;
 
-error_2:
-	remove_proc_entry("servers", nn->proc_nfsfs);
 error_1:
-	remove_proc_entry("fs/nfsfs", NULL);
+	remove_proc_subtree("nfsfs", net->proc_net);
 error_0:
 	return -ENOMEM;
 }
 
 void nfs_fs_proc_net_exit(struct net *net)
 {
-	struct nfs_net *nn = net_generic(net, nfs_net_id);
-
-	remove_proc_entry("volumes", nn->proc_nfsfs);
-	remove_proc_entry("servers", nn->proc_nfsfs);
-	remove_proc_entry("fs/nfsfs", NULL);
+	remove_proc_subtree("nfsfs", net->proc_net);
 }
 
 /*
-- 
1.9.1


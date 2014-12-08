Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaLHDmB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 22:42:01 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62322 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbaLHDlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 22:41:52 -0500
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v8 3/3] btrfs: fix suspicious RCU in BTRFS_IOC_DEV_INFO
Date: Sun,  7 Dec 2014 19:40:59 -0800
Message-Id: <77dcc43b8e3dd20b1994b8e978008800e8dcf6b7.1418007402.git.osandov@osandov.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1418007402.git.osandov@osandov.com>
References: <cover.1418007402.git.osandov@osandov.com>
In-Reply-To: <cover.1418007402.git.osandov@osandov.com>
References: <cover.1418007402.git.osandov@osandov.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A naked read of the value of an RCU pointer isn't safe. Put the whole
access in an RCU critical section, not just the pointer dereference.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9ebc3cc..324be12 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2734,6 +2734,7 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
 	int ret = 0;
 	char *s_uuid = NULL;
+	struct rcu_string *name;
 
 	di_args = memdup_user(arg, sizeof(*di_args));
 	if (IS_ERR(di_args))
@@ -2754,17 +2755,16 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 	di_args->bytes_used = btrfs_device_get_bytes_used(dev);
 	di_args->total_bytes = btrfs_device_get_total_bytes(dev);
 	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
-	if (dev->name) {
-		struct rcu_string *name;
 
-		rcu_read_lock();
-		name = rcu_dereference(dev->name);
+	rcu_read_lock();
+	name = rcu_dereference(dev->name);
+	if (name) {
 		strncpy(di_args->path, name->str, sizeof(di_args->path));
-		rcu_read_unlock();
 		di_args->path[sizeof(di_args->path) - 1] = 0;
 	} else {
 		di_args->path[0] = '\0';
 	}
+	rcu_read_unlock();
 
 out:
 	mutex_unlock(&fs_devices->device_list_mutex);
-- 
2.1.3


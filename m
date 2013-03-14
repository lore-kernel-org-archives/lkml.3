Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab3CNLEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:04:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51719 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab3CNKgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:36:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 07/88] btrfs: Init io_lock after cloning btrfs device struct
Date: Thu, 14 Mar 2013 10:35:00 +0000
Message-Id: <1363257381-15900-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 1cba0cdf5e4dbcd9e5fa5b54d7a028e55e2ca057 upstream.

__btrfs_close_devices() clones btrfs device structs with
memcpy(). Some of the fields in the clone are reinitialized, but it's
missing to init io_lock. In mainline this goes unnoticed, but on RT it
leaves the plist pointing to the original about to be freed lock
struct.

Initialize io_lock after cloning, so no references to the original
struct are left.

Reported-and-tested-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/volumes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 037e0bb..2208f0f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -575,6 +575,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		new_device->writeable = 0;
 		new_device->in_fs_metadata = 0;
 		new_device->can_discard = 0;
+		spin_lock_init(&new_device->io_lock);
 		list_replace_rcu(&device->dev_list, &new_device->dev_list);
 
 		call_rcu(&device->rcu, free_device);
-- 
1.8.1.2


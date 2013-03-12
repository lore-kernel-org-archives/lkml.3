Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065Ab3CLXUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:20:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab3CLWcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [ 018/100] btrfs: Init io_lock after cloning btrfs device struct
Date: Tue, 12 Mar 2013 15:31:03 -0700
Message-Id: <20130312223124.963385366@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -647,6 +647,7 @@ static int __btrfs_close_devices(struct
 		new_device->writeable = 0;
 		new_device->in_fs_metadata = 0;
 		new_device->can_discard = 0;
+		spin_lock_init(&new_device->io_lock);
 		list_replace_rcu(&device->dev_list, &new_device->dev_list);
 
 		call_rcu(&device->rcu, free_device);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab3CREaC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:30:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33362 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852Ab3CRE37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:29:59 -0400
Message-Id: <20130318042144.447774669@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:21:46 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [ 02/82] btrfs: Init io_lock after cloning btrfs device struct
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/volumes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -543,6 +543,7 @@ static int __btrfs_close_devices(struct
 		new_device->writeable = 0;
 		new_device->in_fs_metadata = 0;
 		new_device->can_discard = 0;
+		spin_lock_init(&new_device->io_lock);
 		list_replace_rcu(&device->dev_list, &new_device->dev_list);
 
 		call_rcu(&device->rcu, free_device);



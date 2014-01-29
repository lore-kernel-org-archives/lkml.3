Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaA2REJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:04:09 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:41377 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaA2REH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:04:07 -0500
Date: Wed, 29 Jan 2014 12:04:03 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabio Estevam <festevam@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: Denis Kirjanov <kda@linux-powerpc.org>, linux-kernel@vger.kernel.org,
        USB list <linux-usb@vger.kernel.org>
Subject: [PATCH driver-core-linus] kernfs: make kernfs_deactivate() honor
 KERNFS_LOCKDEP flag
Message-ID: <20140129170403.GJ30842@htj.dyndns.org>
References: <CAOJe8K20xx3o7HXH3E4pE3=G4pQ-nUf4LYF6sEwy5wYQE23+AA@mail.gmail.com>
 <Pine.LNX.4.44L0.1401291134070.11997-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401291134070.11997-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernfs_deactivate() forgot to check whether KERNFS_LOCKDEP is set
before performing lockdep annotations and ends up feeding
uninitialized lockdep_map to lockdep triggering warning like the
following on USB stick hotunplug.

 usb 1-2: USB disconnect, device number 2
 INFO: trying to register non-static key.
 the code is fine but needs lockdep annotation.
 turning off the locking correctness validator.
 CPU: 1 PID: 62 Comm: khubd Not tainted 3.13.0-work+ #82
 Hardware name: empty empty/S3992, BIOS 080011  10/26/2007
  ffff880065ca7f60 ffff88013a4ffa08 ffffffff81cfb6bd 0000000000000002
  ffff88013a4ffac8 ffffffff810f8530 ffff88013a4fc710 0000000000000002
  ffff880100000000 ffffffff82a3db50 0000000000000001 ffff88013a4fc710
 Call Trace:
  [<ffffffff81cfb6bd>] dump_stack+0x4e/0x7a
  [<ffffffff810f8530>] __lock_acquire+0x1910/0x1e70
  [<ffffffff810f931a>] lock_acquire+0x9a/0x1d0
  [<ffffffff8127c75e>] kernfs_deactivate+0xee/0x130
  [<ffffffff8127d4c8>] kernfs_addrm_finish+0x38/0x60
  [<ffffffff8127d701>] kernfs_remove_by_name_ns+0x51/0xa0
  [<ffffffff8127b4f1>] remove_files.isra.1+0x41/0x80
  [<ffffffff8127b7e7>] sysfs_remove_group+0x47/0xa0
  [<ffffffff8127b873>] sysfs_remove_groups+0x33/0x50
  [<ffffffff8177d66d>] device_remove_attrs+0x4d/0x80
  [<ffffffff8177e25e>] device_del+0x12e/0x1d0
  [<ffffffff819722c2>] usb_disconnect+0x122/0x1a0
  [<ffffffff819749b5>] hub_thread+0x3c5/0x1290
  [<ffffffff810c6a6d>] kthread+0xed/0x110
  [<ffffffff81d0a56c>] ret_from_fork+0x7c/0xb0

Fix it by making kernfs_deactivate() perform lockdep annotations only
if KERNFS_LOCKDEP is set.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Fabio Estevam <festevam@gmail.com>
Reported-by: Alan Stern <stern@rowland.harvard.edu>
---
 fs/kernfs/dir.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 5104cf5..bd6e18b 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -187,19 +187,23 @@ static void kernfs_deactivate(struct kernfs_node *kn)
 
 	kn->u.completion = (void *)&wait;
 
-	rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);
+	if (kn->flags & KERNFS_LOCKDEP)
+		rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);
 	/* atomic_add_return() is a mb(), put_active() will always see
 	 * the updated kn->u.completion.
 	 */
 	v = atomic_add_return(KN_DEACTIVATED_BIAS, &kn->active);
 
 	if (v != KN_DEACTIVATED_BIAS) {
-		lock_contended(&kn->dep_map, _RET_IP_);
+		if (kn->flags & KERNFS_LOCKDEP)
+			lock_contended(&kn->dep_map, _RET_IP_);
 		wait_for_completion(&wait);
 	}
 
-	lock_acquired(&kn->dep_map, _RET_IP_);
-	rwsem_release(&kn->dep_map, 1, _RET_IP_);
+	if (kn->flags & KERNFS_LOCKDEP) {
+		lock_acquired(&kn->dep_map, _RET_IP_);
+		rwsem_release(&kn->dep_map, 1, _RET_IP_);
+	}
 }
 
 /**

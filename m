Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaJJR0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 13:26:31 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:18329 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaJJR03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 13:26:29 -0400
From: Jerry Hoemann <jerry.hoemann@hp.com>
To: akpm@linux-foundation.org, jeffrey.t.kirsher@intel.com,
        kenhelias@firemail.de
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tmak@hp.com,
        Jerry Hoemann <jerry.hoemann@hp.com>
Subject: [PATCH 0/1] fsnotify: next_i is freed during
Date: Fri, 10 Oct 2014 11:26:13 -0600
Message-Id: <1412961974-21917-1-git-send-email-jerry.hoemann@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <234>
References: <234>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending to CC linux-fsdevel@vger.kernel.org.....


During file system stress testing on 3.10 and 3.12 based kernels,
the umount command occasionally hung in fsnotify_unmount_inodes
in the section of code:

                spin_lock(&inode->i_lock);
                if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
                        spin_unlock(&inode->i_lock);
                        continue;
                }

As this section of code holds the global inode_sb_list_lock, eventually
the system hangs trying to acquire the lock.

Multiple crash dumps showed:

The inode->i_state == 0x60 and i_count == 0 and i_sb_list would point
back at itself.  As this is not the value of list upon entry to the
function, the kernel never exits the loop.

To help narrow down problem, the call to list_del_init in inode_sb_list_del
was changed to list_del.  This poisons the pointers in the i_sb_list
and causes a kernel to panic if it transverse a freed inode.

Subsequent stress testing paniced in fsnotify_unmount_inodes at the bottom
of the list_for_each_entry_safe loop showing next_i had become free.

We believe the root cause of the problem is that next_i is being freed during
the window of time that the list_for_each_entry_safe loop temporarily releases
inode_sb_list_lock to call fsnotify and fsnotify_inode_delete.

The code in fsnotify_unmount_inodes attempts to prevent the freeing
of inode and next_i by calling __iget.  However, the code doesn't
do the __iget call on next_i
	if i_count == 0 or
	if i_state & (I_FREEING | I_WILL_FREE)


The patch addresses this issue by advancing next_i in the above two
cases until we either find a next_i which we can __iget or we reach
the end of the list.  This makes the handling of next_i more closely
match the handling of the variable "inode."

The time to reproduce the hang is highly variable (from hours to days.)
We ran the stress test on a 3.10 kernel with the proposed patch for a
week without failure.

Jerry Hoemann (1):
  fsnotify: next_i is freed during fsnotify_unmount_inodes.

 fs/notify/inode_mark.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

-- 
1.7.11.3


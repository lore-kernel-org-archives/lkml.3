Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab3CDDm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:42:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60848 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755580Ab3CDDmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:50 -0500
Message-Id: <20130304033722.620536177@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:40 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Theodore Tso <tytso@mit.edu>,
        =?ISO-8859-15?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Marti Raudsepp <marti@juffo.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [ 153/153] ext4: fix kernel BUG on large-scale rm -rf commands
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 89a4e48f8479f8145eca9698f39fe188c982212f upstream.

Commit 968dee7722: "ext4: fix hole punch failure when depth is greater
than 0" introduced a regression in v3.5.1/v3.6-rc1 which caused kernel
crashes when users ran run "rm -rf" on large directory hierarchy on
ext4 filesystems on RAID devices:

    BUG: unable to handle kernel NULL pointer dereference at 0000000000000028

    Process rm (pid: 18229, threadinfo ffff8801276bc000, task ffff880123631710)
    Call Trace:
     [<ffffffff81236483>] ? __ext4_handle_dirty_metadata+0x83/0x110
     [<ffffffff812353d3>] ext4_ext_truncate+0x193/0x1d0
     [<ffffffff8120a8cf>] ? ext4_mark_inode_dirty+0x7f/0x1f0
     [<ffffffff81207e05>] ext4_truncate+0xf5/0x100
     [<ffffffff8120cd51>] ext4_evict_inode+0x461/0x490
     [<ffffffff811a1312>] evict+0xa2/0x1a0
     [<ffffffff811a1513>] iput+0x103/0x1f0
     [<ffffffff81196d84>] do_unlinkat+0x154/0x1c0
     [<ffffffff8118cc3a>] ? sys_newfstatat+0x2a/0x40
     [<ffffffff81197b0b>] sys_unlinkat+0x1b/0x50
     [<ffffffff816135e9>] system_call_fastpath+0x16/0x1b
    Code: 8b 4d 20 0f b7 41 02 48 8d 04 40 48 8d 04 81 49 89 45 18 0f b7 49 02 48 83 c1 01 49 89 4d 00 e9 ae f8 ff ff 0f 1f 00 49 8b 45 28 <48> 8b 40 28 49 89 45 20 e9 85 f8 ff ff 0f 1f 80 00 00 00

    RIP  [<ffffffff81233164>] ext4_ext_remove_space+0xa34/0xdf0

This could be reproduced as follows:

The problem in commit 968dee7722 was that caused the variable 'i' to
be left uninitialized if the truncate required more space than was
available in the journal.  This resulted in the function
ext4_ext_truncate_extend_restart() returning -EAGAIN, which caused
ext4_ext_remove_space() to restart the truncate operation after
starting a new jbd2 handle.

Reported-by: Maciej Żenczykowski <maze@google.com>
Reported-by: Marti Raudsepp <marti@juffo.org>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/extents.c | 1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2614,6 +2614,7 @@ cont:
 		}
 		path[0].p_depth = depth;
 		path[0].p_hdr = ext_inode_hdr(inode);
+		i = 0;
 
 		if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
 			err = -EIO;



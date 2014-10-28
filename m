Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaJ1DgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:36:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaJ1DgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:36:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhao Lei <zhaolei@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.17 003/146] btrfs: Fix a deadlock in btrfs_dev_replace_finishing()
Date: Tue, 28 Oct 2014 11:32:25 +0800
Message-Id: <20141028033343.593796488@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

commit 12b894cb288d57292b01cf158177b6d5c89a6272 upstream.

btrfs-transacion:5657
[stack snip]
btrfs_bio_map()
    btrfs_bio_counter_inc_blocked()
        percpu_counter_inc(&fs_info->bio_counter)  ###bio_counter > 0(A)
        __btrfs_bio_map()
            btrfs_dev_replace_lock()
                mutex_lock(dev_replace->lock)	   ###wait mutex(B)

btrfs:32612
[stack snip]
btrfs_dev_replace_start()
    btrfs_dev_replace_lock()
	mutex_lock(dev_replace->lock)		   ###hold mutex(B)
    btrfs_dev_replace_finishing()
        btrfs_rm_dev_replace_blocked()
            wait until percpu_counter_sum == 0	   ###wait on bio_counter(A)

This bug can be triggered quite easily by the following test script:
http://pastebin.com/MQmb37Cy

This patch will fix the ABBA problem by calling
btrfs_dev_replace_unlock() before btrfs_rm_dev_replace_blocked().

The consistency of btrfs devices list and their superblocks is protected
by device_list_mutex, not btrfs_dev_replace_lock/unlock().
So it is safe the move btrfs_dev_replace_unlock() before
btrfs_rm_dev_replace_blocked().

Reported-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/dev-replace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -567,6 +567,8 @@ static int btrfs_dev_replace_finishing(s
 	btrfs_kobj_rm_device(fs_info, src_device);
 	btrfs_kobj_add_device(fs_info, tgt_device);
 
+	btrfs_dev_replace_unlock(dev_replace);
+
 	btrfs_rm_dev_replace_blocked(fs_info);
 
 	btrfs_rm_dev_replace_srcdev(fs_info, src_device);
@@ -580,7 +582,6 @@ static int btrfs_dev_replace_finishing(s
 	 * superblock is scratched out so that it is no longer marked to
 	 * belong to this filesystem.
 	 */
-	btrfs_dev_replace_unlock(dev_replace);
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 	mutex_unlock(&root->fs_info->chunk_mutex);
 



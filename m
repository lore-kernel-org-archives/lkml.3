Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbbAGCSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:18:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710AbbAGCSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:18:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Steigerwald <Martin@lichtvoll.de>,
        David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.17 69/73] btrfs: fix wrong accounting of raid1 data profile in statfs
Date: Tue,  6 Jan 2015 18:16:30 -0800
Message-Id: <20150107021559.624063837@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.cz>

commit 0d95c1bec906dd1ad951c9c001e798ca52baeb0f upstream.

The sizes that are obtained from space infos are in raw units and have
to be adjusted according to the raid factor. This was missing for
f_bavail and df reported doubled size for raid1.

Reported-by: Martin Steigerwald <Martin@lichtvoll.de>
Fixes: ba7b6e62f420 ("btrfs: adjust statfs calculations according to raid profiles")
Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1731,7 +1731,7 @@ static int btrfs_statfs(struct dentry *d
 	buf->f_bfree -= block_rsv->size >> bits;
 	spin_unlock(&block_rsv->lock);
 
-	buf->f_bavail = total_free_data;
+	buf->f_bavail = div_u64(total_free_data, factor);
 	ret = btrfs_calc_avail_data_space(fs_info->tree_root, &total_free_data);
 	if (ret) {
 		mutex_unlock(&fs_info->chunk_mutex);



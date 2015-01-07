Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbbAGB4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 20:56:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485AbbAGBwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Steigerwald <Martin@lichtvoll.de>,
        David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.18 81/84] btrfs: fix wrong accounting of raid1 data profile in statfs
Date: Tue,  6 Jan 2015 17:50:24 -0800
Message-Id: <20150107014031.582181850@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1824,7 +1824,7 @@ static int btrfs_statfs(struct dentry *d
 	buf->f_bfree -= block_rsv->size >> bits;
 	spin_unlock(&block_rsv->lock);
 
-	buf->f_bavail = total_free_data;
+	buf->f_bavail = div_u64(total_free_data, factor);
 	ret = btrfs_calc_avail_data_space(fs_info->tree_root, &total_free_data);
 	if (ret) {
 		mutex_unlock(&fs_info->chunk_mutex);



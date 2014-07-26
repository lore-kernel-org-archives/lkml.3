Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaGZTNM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:13:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbaGZTNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, Joe Thornber <ejt@redhat.com>
Subject: [PATCH 3.14 78/87] dm thin metadata: do not allow the data block size to change
Date: Sat, 26 Jul 2014 12:02:52 -0700
Message-Id: <20140726190217.138947381@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 9aec8629ec829fc9403788cd959e05dd87988bd1 upstream.

The block size for the thin-pool's data device must remained fixed for
the life of the thin-pool.  Disallow any attempt to change the
thin-pool's data block size.

It should be noted that attempting to change the data block size via
thin-pool table reload will be ignored as a side-effect of the thin-pool
handover that the thin-pool target does during thin-pool table reload.

Here is an example outcome of attempting to load a thin-pool table that
reduced the thin-pool's data block size from 1024K to 512K.

Before:
kernel: device-mapper: thin: 253:4: growing the data device from 204800 to 409600 blocks

After:
kernel: device-mapper: thin metadata: changing the data block size (from 2048 to 1024) is not supported
kernel: device-mapper: table: 253:4: thin-pool: Error creating metadata object
kernel: device-mapper: ioctl: error adding target to table

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin-metadata.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -613,6 +613,15 @@ static int __open_metadata(struct dm_poo
 
 	disk_super = dm_block_data(sblock);
 
+	/* Verify the data block size hasn't changed */
+	if (le32_to_cpu(disk_super->data_block_size) != pmd->data_block_size) {
+		DMERR("changing the data block size (from %u to %llu) is not supported",
+		      le32_to_cpu(disk_super->data_block_size),
+		      (unsigned long long)pmd->data_block_size);
+		r = -EINVAL;
+		goto bad_unlock_sblock;
+	}
+
 	r = __check_incompat_features(disk_super, pmd);
 	if (r < 0)
 		goto bad_unlock_sblock;



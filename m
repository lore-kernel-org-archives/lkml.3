Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaGZTa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:30:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbaGZTXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, Joe Thornber <ejt@redhat.com>
Subject: [PATCH 3.15 097/109] dm cache metadata: do not allow the data block size to change
Date: Sat, 26 Jul 2014 12:02:59 -0700
Message-Id: <20140726190226.770893340@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 048e5a07f282c57815b3901d4a68a77fa131ce0a upstream.

The block size for the dm-cache's data device must remained fixed for
the life of the cache.  Disallow any attempt to change the cache's data
block size.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-metadata.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -425,6 +425,15 @@ static int __open_metadata(struct dm_cac
 
 	disk_super = dm_block_data(sblock);
 
+	/* Verify the data block size hasn't changed */
+	if (le32_to_cpu(disk_super->data_block_size) != cmd->data_block_size) {
+		DMERR("changing the data block size (from %u to %llu) is not supported",
+		      le32_to_cpu(disk_super->data_block_size),
+		      (unsigned long long)cmd->data_block_size);
+		r = -EINVAL;
+		goto bad;
+	}
+
 	r = __check_incompat_features(disk_super, cmd);
 	if (r < 0)
 		goto bad;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaGHBD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:03:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaGGXyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.15 064/122] dm thin: update discard_granularity to reflect the thin-pool blocksize
Date: Mon,  7 Jul 2014 16:57:06 -0700
Message-Id: <20140707235736.192095368@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Czerner <lczerner@redhat.com>

commit 09869de57ed2728ae3c619803932a86cb0e2c4f8 upstream.

DM thinp already checks whether the discard_granularity of the data
device is a factor of the thin-pool block size.  But when using the
dm-thin-pool's discard passdown support, DM thinp was not selecting the
max of the underlying data device's discard_granularity and the
thin-pool's block size.

Update set_discard_limits() to set discard_granularity to the max of
these values.  This enables blkdev_issue_discard() to properly align the
discards that are sent to the DM thin device on a full block boundary.
As such each discard will now cover an entire DM thin-pool block and the
block will be reclaimed.

Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3068,7 +3068,8 @@ static void set_discard_limits(struct po
 	 */
 	if (pt->adjusted_pf.discard_passdown) {
 		data_limits = &bdev_get_queue(pt->data_dev->bdev)->limits;
-		limits->discard_granularity = data_limits->discard_granularity;
+		limits->discard_granularity = max(data_limits->discard_granularity,
+						  pool->sectors_per_block << SECTOR_SHIFT);
 	} else
 		limits->discard_granularity = pool->sectors_per_block << SECTOR_SHIFT;
 }



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab3LRVPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:15:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab3LRVOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, Joe Thornber <ejt@redhat.com>
Subject: [PATCH 3.12 089/118] dm thin: switch to read-only mode if metadata space is exhausted
Date: Wed, 18 Dec 2013 13:12:06 -0800
Message-Id: <20131218211221.976999484@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 4a02b34e0cf1d0d0dd3737702841da4bf615a50a upstream.

Switch the thin pool to read-only mode in alloc_data_block() if
dm_pool_alloc_data_block() fails because the pool's metadata space is
exhausted.

Differentiate between data and metadata space in messages about no
free space available.

This issue was noticed with the device-mapper-test-suite using:
dmtest run --suite thin-provisioning -n /exhausting_metadata_space_causes_fail_mode/

The quantity of errors logged in this case must be reduced.

before patch:

device-mapper: thin: 253:4: reached low water mark for metadata device: sending event.
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map common: dm_tm_shadow_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map common: dm_tm_shadow_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map common: dm_tm_shadow_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map common: dm_tm_shadow_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map common: dm_tm_shadow_block() failed
<snip ... these repeat for a _very_ long while ... >
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: 253:4: commit failed: error = -28
device-mapper: thin: 253:4: switching pool to read-only mode

after patch:

device-mapper: thin: 253:4: reached low water mark for metadata device: sending event.
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: 253:4: no free metadata space available.
device-mapper: thin: 253:4: switching pool to read-only mode

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -959,7 +959,7 @@ static int alloc_data_block(struct thin_
 		 * table reload).
 		 */
 		if (!free_blocks) {
-			DMWARN("%s: no free space available.",
+			DMWARN("%s: no free data space available.",
 			       dm_device_name(pool->pool_md));
 			spin_lock_irqsave(&pool->lock, flags);
 			pool->no_free_space = 1;
@@ -969,8 +969,16 @@ static int alloc_data_block(struct thin_
 	}
 
 	r = dm_pool_alloc_data_block(pool->pmd, result);
-	if (r)
+	if (r) {
+		if (r == -ENOSPC &&
+		    !dm_pool_get_free_metadata_block_count(pool->pmd, &free_blocks) &&
+		    !free_blocks) {
+			DMWARN("%s: no free metadata space available.",
+			       dm_device_name(pool->pool_md));
+			set_pool_mode(pool, PM_READ_ONLY);
+		}
 		return r;
+	}
 
 	return 0;
 }



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab3LRVPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:15:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab3LRVO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.12 088/118] dm thin: switch to read only mode if a mapping insert fails
Date: Wed, 18 Dec 2013 13:12:05 -0800
Message-Id: <20131218211221.949287270@linuxfoundation.org>
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

From: Joe Thornber <ejt@redhat.com>

commit fafc7a815e40255d24e80a1cb7365892362fa398 upstream.

Switch the thin pool to read-only mode when dm_thin_insert_block() fails
since there is little reason to expect the cause of the failure to be
resolved without further action by user space.

This issue was noticed with the device-mapper-test-suite using:
dmtest run --suite thin-provisioning -n /exhausting_metadata_space_causes_fail_mode/

The quantity of errors logged in this case must be reduced.

before patch:

device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: dm_thin_insert_block() failed
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map metadata: unable to allocate new metadata block
<snip ... these repeat for a long while ... >
device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: space map common: dm_tm_shadow_block() failed
device-mapper: thin: 253:4: no free metadata space available.
device-mapper: thin: 253:4: switching pool to read-only mode

after patch:

device-mapper: space map metadata: unable to allocate new metadata block
device-mapper: thin: 253:4: dm_thin_insert_block() failed: error = -28
device-mapper: thin: 253:4: switching pool to read-only mode

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -640,7 +640,9 @@ static void process_prepared_mapping(str
 	 */
 	r = dm_thin_insert_block(tc->td, m->virt_block, m->data_block);
 	if (r) {
-		DMERR_LIMIT("dm_thin_insert_block() failed");
+		DMERR_LIMIT("%s: dm_thin_insert_block() failed: error = %d",
+			    dm_device_name(pool->pool_md), r);
+		set_pool_mode(pool, PM_READ_ONLY);
 		cell_error(pool, m->cell);
 		goto out;
 	}



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766AbbAGBwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 20:52:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557AbbAGBwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.10 12/38] dm space map metadata: fix sm_bootstrap_get_nr_blocks()
Date: Tue,  6 Jan 2015 17:50:24 -0800
Message-Id: <20150107014954.456347575@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014952.440109372@linuxfoundation.org>
References: <20150107014952.440109372@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit c1c6156fe4d4577444b769d7edd5dd503e57bbc9 upstream.

This function isn't right and it causes a static checker warning:

	drivers/md/dm-thin.c:3016 maybe_resize_data_dev()
	error: potentially using uninitialized 'sb_data_size'.

It should set "*count" and return zero on success the same as the
sm_metadata_get_nr_blocks() function does earlier.

Fixes: 3241b1d3e0aa ('dm: add persistent data library')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/persistent-data/dm-space-map-metadata.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -493,7 +493,9 @@ static int sm_bootstrap_get_nr_blocks(st
 {
 	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
 
-	return smm->ll.nr_blocks;
+	*count = smm->ll.nr_blocks;
+
+	return 0;
 }
 
 static int sm_bootstrap_get_nr_free(struct dm_space_map *sm, dm_block_t *count)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbaCDUEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:04:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974AbaCDUEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, Joe Thornber <ejt@redhat.com>
Subject: [PATCH 3.13 165/172] dm thin: fix the error path for the thin device constructor
Date: Tue,  4 Mar 2014 12:04:09 -0800
Message-Id: <20140304200304.979272582@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 1acacc0784aab45627b6009e0e9224886279ac0b upstream.

dm_pool_close_thin_device() must be called if dm_set_target_max_io_len()
fails in thin_ctr().  Otherwise __pool_destroy() will fail because the
pool will still have an open thin device:

 device-mapper: thin metadata: attempt to close pmd when 1 device(s) are still open
 device-mapper: thin: __pool_destroy: dm_pool_metadata_close() failed.

Also, must establish error code if failing thin_ctr() because the pool
is in fail_io mode.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2848,6 +2848,7 @@ static int thin_ctr(struct dm_target *ti
 
 	if (get_pool_mode(tc->pool) == PM_FAIL) {
 		ti->error = "Couldn't open thin device, Pool is in fail mode";
+		r = -EINVAL;
 		goto bad_thin_open;
 	}
 
@@ -2859,7 +2860,7 @@ static int thin_ctr(struct dm_target *ti
 
 	r = dm_set_target_max_io_len(ti, tc->pool->sectors_per_block);
 	if (r)
-		goto bad_thin_open;
+		goto bad_target_max_io_len;
 
 	ti->num_flush_bios = 1;
 	ti->flush_supported = true;
@@ -2880,6 +2881,8 @@ static int thin_ctr(struct dm_target *ti
 
 	return 0;
 
+bad_target_max_io_len:
+	dm_pool_close_thin_device(tc->td);
 bad_thin_open:
 	__pool_dec(tc->pool);
 bad_pool_lookup:



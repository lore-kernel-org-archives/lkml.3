Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbaJIVGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:06:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59019 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512AbaJIVF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:05:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 129/163] md/raid1: intialise start_next_window for READ case to avoid hang
Date: Thu,  9 Oct 2014 14:02:34 -0700
Message-Id: <1412888588-26755-130-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit f0cc9a057151892b885be21a1d19b0185568281d upstream.

r1_bio->start_next_window is not initialised in the READ
case, so allow_barrier may incorrectly decrement
   conf->current_window_requests
which can cause raise_barrier() to block forever.

Fixes: 79ef3a8aa1cb1523cc231c9a90a278333c21f761
Reported-by: Brassow Jonathan <jbrassow@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f4d5e52..b806da4 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1187,6 +1187,7 @@ read_again:
 				   atomic_read(&bitmap->behind_writes) == 0);
 		}
 		r1_bio->read_disk = rdisk;
+		r1_bio->start_next_window = 0;
 
 		read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
 		bio_trim(read_bio, r1_bio->sector - bio->bi_sector,
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444AbaE3OjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:39:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:16815 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbaE3OjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:39:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,941,1392192000"; 
   d="scan'208";a="540066252"
From: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
To: "neilb@suse.de" <neilb@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
Subject: [PATCH 1/1] md: Do only necessary operations when adding device to
 RO array
Thread-Topic: [PATCH 1/1] md: Do only necessary operations when adding
 device to RO array
Thread-Index: Ac98CRsveY1xahZjQxqPA7TvjN5fzQAC64CQ
Date: Fri, 30 May 2014 14:39:04 +0000
Message-ID: <84A53BEA6EAC69439B7E311E9B17A76F07918CF7@IRSMSX105.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.182]
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8313b8e57f55b15e5b7f7fc5d1630bbf686a9a97 changed
way of adding device to read-only array. Used routine
md_reap_sync_thread() which also trigger finish_reshape(),
can break reshape process, if it was restarted.
This part of function should do only necessary operations, that is:
1) call ->spare_active
2) clear saved_raid_disk if array is no longer degraded

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

---
drivers/md/md.c | 10 ++++++----
1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 237b7e0..cf073de2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7820,11 +7820,13 @@ void md_check_recovery(struct mddev *mddev)
                                                * As we only add devices that are already in-sync,
                                                * we can activate the spares immediately.
                                                */
+                                             struct md_rdev *rdev;
                                               remove_and_add_spares(mddev, NULL);
-                                              /* There is no thread, but we need to call
-                                              * ->spare_active and clear saved_raid_disk
-                                              */
-                                              md_reap_sync_thread(mddev);
+                                             mddev->pers->spare_active(mddev);
+                                             rdev_for_each(rdev, mddev)
+                                                             if (!mddev->degraded ||
+                                                                 test_bit(In_sync, &rdev->flags))
+                                                                             rdev->saved_raid_disk = -1;
                                               clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
                                               goto unlock;
                               }
-- 
1.9.0

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3JGOZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 10:25:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:26318 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458Ab3JGOZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 10:25:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1050,1371106800"; 
   d="scan'208";a="370881679"
Subject: [PATCH] md: Fix skipping recovery for read-only arrays.
To: neilb@suse.de
From: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com,
        linux-kernel@vger.kernel.org
Date: Mon, 07 Oct 2013 16:25:51 +0200
Message-ID: <20131007142551.14867.36809.stgit@gklab-154-244.igk.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since:
        commit 7ceb17e87bde79d285a8b988cfed9eaeebe60b86
        md: Allow devices to be re-added to a read-only array.

spares are activated on a read-only array. In case of raid1 and raid10
personalities it causes that not-in-sync devices are marked in-sync
without checking if recovery has been finished.

If a read-only array is degraded and one of its devices is not in-sync
(because the array has been only partially recovered) recovery will be skipped.

This patch adds checking if recovery has been finished before marking a device
in-sync for raid1 and raid10 personalities. In case of raid5 personality
such condition is already present (at raid5.c:6029).

Bug was introduced in 3.10 and causes data corruption.

Cc: stable@vger.kernel.org
Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 drivers/md/raid1.c  |    1 +
 drivers/md/raid10.c |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d60412c..aacf6bf 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1479,6 +1479,7 @@ static int raid1_spare_active(struct mddev *mddev)
 			}
 		}
 		if (rdev
+		    && rdev->recovery_offset == MaxSector
 		    && !test_bit(Faulty, &rdev->flags)
 		    && !test_and_set_bit(In_sync, &rdev->flags)) {
 			count++;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index df7b0a0..73dc8a3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1782,6 +1782,7 @@ static int raid10_spare_active(struct mddev *mddev)
 			}
 			sysfs_notify_dirent_safe(tmp->replacement->sysfs_state);
 		} else if (tmp->rdev
+			   && tmp->rdev->recovery_offset == MaxSector
 			   && !test_bit(Faulty, &tmp->rdev->flags)
 			   && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
 			count++;


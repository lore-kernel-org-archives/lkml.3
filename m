Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab3KHCW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:22:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34968 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288Ab3KHCWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:22:20 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pawel Baldysiak <pawel.baldysiak@intel.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>, NeilBrown <neilb@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 59/91] md: Fix skipping recovery for read-only arrays.
Date: Thu,  7 Nov 2013 18:15:14 -0800
Message-Id: <1383876946-2396-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Dorau <lukasz.dorau@intel.com>

commit 61e4947c99c4494336254ec540c50186d186150b upstream.

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

Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid1.c  | 1 +
 drivers/md/raid10.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a382d84..21f0c3f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1493,6 +1493,7 @@ static int raid1_spare_active(struct mddev *mddev)
 			}
 		}
 		if (rdev
+		    && rdev->recovery_offset == MaxSector
 		    && !test_bit(Faulty, &rdev->flags)
 		    && !test_and_set_bit(In_sync, &rdev->flags)) {
 			count++;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 92858ab..b8f5688 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1718,6 +1718,7 @@ static int raid10_spare_active(struct mddev *mddev)
 			}
 			sysfs_notify_dirent_safe(tmp->replacement->sysfs_state);
 		} else if (tmp->rdev
+			   && tmp->rdev->recovery_offset == MaxSector
 			   && !test_bit(Faulty, &tmp->rdev->flags)
 			   && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
 			count++;
-- 
1.8.1.2


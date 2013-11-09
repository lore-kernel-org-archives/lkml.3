Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab3KIHII (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:08:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932772Ab3KIGwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pawel Baldysiak <pawel.baldysiak@intel.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.11 42/94] md: Fix skipping recovery for read-only arrays.
Date: Fri,  8 Nov 2013 22:51:48 -0800
Message-Id: <20131109065207.191358605@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c  |    1 +
 drivers/md/raid10.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1479,6 +1479,7 @@ static int raid1_spare_active(struct mdd
 			}
 		}
 		if (rdev
+		    && rdev->recovery_offset == MaxSector
 		    && !test_bit(Faulty, &rdev->flags)
 		    && !test_and_set_bit(In_sync, &rdev->flags)) {
 			count++;
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1782,6 +1782,7 @@ static int raid10_spare_active(struct md
 			}
 			sysfs_notify_dirent_safe(tmp->replacement->sysfs_state);
 		} else if (tmp->rdev
+			   && tmp->rdev->recovery_offset == MaxSector
 			   && !test_bit(Faulty, &tmp->rdev->flags)
 			   && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
 			count++;



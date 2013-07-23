Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934747Ab3GWWqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:46:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934632Ab3GWW13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>, Martin Wilck <mwilck@arcor.de>
Subject: [ 049/103] md/raid10: fix bug which causes all RAID10 reshapes to move no data.
Date: Tue, 23 Jul 2013 15:26:00 -0700
Message-Id: <20130723220424.048255643@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 1376512065b23f39d5f9a160948f313397dde972 upstream.

The recent comment:
commit 7e83ccbecd608b971f340e951c9e84cd0343002f
    md/raid10: Allow skipping recovery when clean arrays are assembled

Causes raid10 to skip a recovery in certain cases where it is safe to
do so.  Unfortunately it also causes a reshape to be skipped which is
never safe.  The result is that an attempt to reshape a RAID10 will
appear to complete instantly, but no data will have been moves so the
array will now contain garbage.
(If nothing is written, you can recovery by simple performing the
reverse reshape which will also complete instantly).

Bug was introduced in 3.10, so this is suitable for 3.10-stable.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Martin Wilck <mwilck@arcor.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2909,14 +2909,13 @@ static sector_t sync_request(struct mdde
 	 */
 	if (mddev->bitmap == NULL &&
 	    mddev->recovery_cp == MaxSector &&
+	    mddev->reshape_position == MaxSector &&
+	    !test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
+	    !test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    conf->fullsync == 0) {
 		*skipped = 1;
-		max_sector = mddev->dev_sectors;
-		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
-		    test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
-			max_sector = mddev->resync_max_sectors;
-		return max_sector - sector_nr;
+		return mddev->dev_sectors - sector_nr;
 	}
 
  skipped:



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab3KHC1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:27:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34890 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab3KHCVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:21:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shaohua Li <shli@fusionio.com>, NeilBrown <neilb@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 62/91] raid5: avoid finding "discard" stripe
Date: Thu,  7 Nov 2013 18:15:17 -0800
Message-Id: <1383876946-2396-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shaohua Li <shli@kernel.org>

commit d47648fcf0611812286f68131b40251c6fa54f5e upstream.

SCSI discard will damage discard stripe bio setting, eg, some fields are
changed. If the stripe is reused very soon, we have wrong bios setting. We
remove discard stripe from hash list, so next time the strip will be fully
initialized.

Suitable for backport to 3.7+.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid5.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7ace380..51887b3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2841,6 +2841,14 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 		}
 		/* now that discard is done we can proceed with any sync */
 		clear_bit(STRIPE_DISCARD, &sh->state);
+		/*
+		 * SCSI discard will change some bio fields and the stripe has
+		 * no updated data, so remove it from hash list and the stripe
+		 * will be reinitialized
+		 */
+		spin_lock_irq(&conf->device_lock);
+		remove_hash(sh);
+		spin_unlock_irq(&conf->device_lock);
 		if (test_bit(STRIPE_SYNC_REQUESTED, &sh->state))
 			set_bit(STRIPE_HANDLE, &sh->state);
 
-- 
1.8.1.2


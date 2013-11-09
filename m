Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab3KIGuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:50:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab3KIGu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shaohua Li <shli@fusionio.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.10 27/74] raid5: avoid finding "discard" stripe
Date: Fri,  8 Nov 2013 22:51:32 -0800
Message-Id: <20131109065115.436903911@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2812,6 +2812,14 @@ static void handle_stripe_clean_event(st
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
 



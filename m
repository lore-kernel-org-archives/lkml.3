Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab3CLXIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:08:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab3CLWdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tregaron Bayly <tbayly@bluehost.com>, NeilBrown <neilb@suse.de>
Subject: [ 042/100] md/raid1,raid10: fix deadlock with freeze_array()
Date: Tue, 12 Mar 2013 15:31:27 -0700
Message-Id: <20130312223127.528879243@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit ee0b0244030434cdda26777bfb98962447e080cd upstream.

When raid1/raid10 needs to fix a read error, it first drains
all pending requests by calling freeze_array().
This calls flush_pending_writes() if it needs to sleep,
but some writes may be pending in a per-process plug rather
than in the per-array request queue.

When raid1{,0}_unplug() moves the request from the per-process
plug to the per-array request queue (from which
flush_pending_writes() can flush them), it needs to wake up
freeze_array(), or freeze_array() will never flush them and so
it will block forever.

So add the requires wake_up() calls.

This bug was introduced by commit
   f54a9d0e59c4bea3db733921ca9147612a6f292c
for raid1 and a similar commit for RAID10, and so has been present
since linux-3.6.  As the bug causes a deadlock I believe this fix is
suitable for -stable.

Reported-by: Tregaron Bayly <tbayly@bluehost.com>
Tested-by: Tregaron Bayly <tbayly@bluehost.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c  |    1 +
 drivers/md/raid10.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -967,6 +967,7 @@ static void raid1_unplug(struct blk_plug
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		conf->pending_count += plug->pending_cnt;
 		spin_unlock_irq(&conf->device_lock);
+		wake_up(&conf->wait_barrier);
 		md_wakeup_thread(mddev->thread);
 		kfree(plug);
 		return;
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1073,6 +1073,7 @@ static void raid10_unplug(struct blk_plu
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		conf->pending_count += plug->pending_cnt;
 		spin_unlock_irq(&conf->device_lock);
+		wake_up(&conf->wait_barrier);
 		md_wakeup_thread(mddev->thread);
 		kfree(plug);
 		return;



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab3LBTpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:45:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab3LBTSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.12 146/212] md: fix calculation of stacking limits on level change.
Date: Mon,  2 Dec 2013 11:15:37 -0800
Message-Id: <20131202191303.508985880@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 02e5f5c0a0f726e66e3d8506ea1691e344277969 upstream.

The various ->run routines of md personalities assume that the 'queue'
has been initialised by the blk_set_stacking_limits() call in
md_alloc().

However when the level is changed (by level_store()) the ->run routine
for the new level is called for an array which has already had the
stacking limits modified.  This can result in incorrect final
settings.

So call blk_set_stacking_limits() before ->run in level_store().

A specific consequence of this bug is that it causes
discard_granularity to be set incorrectly when reshaping a RAID4 to a
RAID0.

This is suitable for any -stable kernel since 3.3 in which
blk_set_stacking_limits() was introduced.

Reported-and-tested-by: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3620,6 +3620,7 @@ level_store(struct mddev *mddev, const c
 		mddev->in_sync = 1;
 		del_timer_sync(&mddev->safemode_timer);
 	}
+	blk_set_stacking_limits(&mddev->queue->limits);
 	pers->run(mddev);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	mddev_resume(mddev);



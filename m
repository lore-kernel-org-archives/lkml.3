Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaBGLgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:36:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41079 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaBGLYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:24:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 57/88] md/raid5: fix long-standing problem with bitmap handling on write failure.
Date: Fri,  7 Feb 2014 11:22:54 +0000
Message-Id: <1391772205-22239-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 9f97e4b128d2ea90a5f5063ea0ee3b0911f4c669 upstream.

Before a write starts we set a bit in the write-intent bitmap.
When the write completes we clear that bit if the write was successful
to all devices.  However if the write wasn't fully successful we
should not clear the bit.  If the faulty drive is subsequently
re-added, the fact that the bit is still set ensure that we will
re-write the data that is missing.

This logic is mediated by the STRIPE_DEGRADED flag - we only clear the
bitmap bit when this flag is not set.
Currently we correctly set the flag if a write starts when some
devices are failed or missing.  But we do *not* set the flag if some
device failed during the write attempt.
This is wrong and can result in clearing the bit inappropriately.

So: set the flag when a write fails.

This bug has been present since bitmaps were introduces, so the fix is
suitable for any -stable kernel.

Reported-by: Ethan Wilson <ethan.wilson@shiftmail.org>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/raid5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4ee5324..eb0f9ea 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1851,6 +1851,7 @@ static void raid5_end_write_request(struct bio *bi, int error)
 			set_bit(R5_MadeGoodRepl, &sh->dev[i].flags);
 	} else {
 		if (!uptodate) {
+			set_bit(STRIPE_DEGRADED, &sh->state);
 			set_bit(WriteErrorSeen, &rdev->flags);
 			set_bit(R5_WriteError, &sh->dev[i].flags);
 			if (!test_and_set_bit(WantReplacement, &rdev->flags))
-- 
1.8.3.2


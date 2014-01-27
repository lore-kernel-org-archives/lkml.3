Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbaA0URK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:17:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbaA0UQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:16:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ethan Wilson <ethan.wilson@shiftmail.org>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.13 09/10] md/raid5: fix long-standing problem with bitmap handling on write failure.
Date: Mon, 27 Jan 2014 12:17:12 -0800
Message-Id: <20140127201536.003082770@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <20140127201535.350372282@linuxfoundation.org>
References: <20140127201535.350372282@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2111,6 +2111,7 @@ static void raid5_end_write_request(stru
 			set_bit(R5_MadeGoodRepl, &sh->dev[i].flags);
 	} else {
 		if (!uptodate) {
+			set_bit(STRIPE_DEGRADED, &sh->state);
 			set_bit(WriteErrorSeen, &rdev->flags);
 			set_bit(R5_WriteError, &sh->dev[i].flags);
 			if (!test_and_set_bit(WantReplacement, &rdev->flags))



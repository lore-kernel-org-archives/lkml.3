Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844AbaBDWdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:33:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239AbaBDVH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:07:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ethan Wilson <ethan.wilson@shiftmail.org>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.12 002/133] md/raid5: fix long-standing problem with bitmap handling on write failure.
Date: Tue,  4 Feb 2014 13:06:43 -0800
Message-Id: <20140204210737.081042417@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2004,6 +2004,7 @@ static void raid5_end_write_request(stru
 			set_bit(R5_MadeGoodRepl, &sh->dev[i].flags);
 	} else {
 		if (!uptodate) {
+			set_bit(STRIPE_DEGRADED, &sh->state);
 			set_bit(WriteErrorSeen, &rdev->flags);
 			set_bit(R5_WriteError, &sh->dev[i].flags);
 			if (!test_and_set_bit(WantReplacement, &rdev->flags))



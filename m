Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaCaAR5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:17:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36376 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014AbaC3XZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ethan Wilson" <ethan.wilson@shiftmail.org>,
        "NeilBrown" <neilb@suse.de>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.385525986@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 041/200] md/raid5: fix long-standing problem with
 bitmap handling on write failure.
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid5.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1693,6 +1693,7 @@ static void raid5_end_write_request(stru
 	}
 
 	if (!uptodate) {
+		set_bit(STRIPE_DEGRADED, &sh->state);
 		set_bit(WriteErrorSeen, &conf->disks[i].rdev->flags);
 		set_bit(R5_WriteError, &sh->dev[i].flags);
 	} else if (is_badblock(conf->disks[i].rdev, sh->sector, STRIPE_SECTORS,


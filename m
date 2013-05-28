Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab3E1D5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:57:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52615 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758913Ab3E1DyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:23 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jens Axboe" <axboe@kernel.dk>,
        "Lars Ellenberg" <lars.ellenberg@linbit.com>,
        "Philipp Reisner" <philipp.reisner@linbit.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.76517477@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [75/94] drbd: fix for deadlock when using automatic
 split-brain-recovery
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Reisner <philipp.reisner@linbit.com>

commit 7c689e63a847316c1b2500f86891b0a574ce7e69 upstream.

With an automatic after split-brain recovery policy of
"after-sb-1pri call-pri-lost-after-sb",
when trying to drbd_set_role() to R_SECONDARY,
we run into a deadlock.

This was first recognized and supposedly fixed by
2009-06-10 "Fixed a deadlock when using automatic split brain recovery when both nodes are"
replacing drbd_set_role() with drbd_change_state() in that code-path,
but the first hunk of that patch forgets to remove the drbd_set_role().

We apparently only ever tested the "two primaries" case.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/drbd/drbd_receiver.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2225,7 +2225,6 @@ static int drbd_asb_recover_1p(struct dr
 		if (hg == -1 && mdev->state.role == R_PRIMARY) {
 			enum drbd_state_rv rv2;
 
-			drbd_set_role(mdev, R_SECONDARY, 0);
 			 /* drbd_change_state() does not sleep while in SS_IN_TRANSIENT_STATE,
 			  * we might be here in C_WF_REPORT_PARAMS which is transient.
 			  * we do not need to wait for the after state change work either. */


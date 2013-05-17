Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab3EQVpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:45:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079Ab3EQVhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 079/102] drbd: fix for deadlock when using automatic split-brain-recovery
Date: Fri, 17 May 2013 14:36:34 -0700
Message-Id: <20130517213252.624912501@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/drbd/drbd_receiver.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2661,7 +2661,6 @@ static int drbd_asb_recover_1p(struct dr
 		if (hg == -1 && mdev->state.role == R_PRIMARY) {
 			enum drbd_state_rv rv2;
 
-			drbd_set_role(mdev, R_SECONDARY, 0);
 			 /* drbd_change_state() does not sleep while in SS_IN_TRANSIENT_STATE,
 			  * we might be here in C_WF_REPORT_PARAMS which is transient.
 			  * we do not need to wait for the after state change work either. */



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382Ab3FCWQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:16:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12031 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758996Ab3FCWM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:26 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=M98e3NsscBQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=n_A8df5c1fcA:10 a=MRXkqwc6AAAA:8 a=7v_xTOd-fh7FpdVBgVoA:9 a=xQiyyS5Y5jQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221200.141728802@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [46/65] drbd: fix for deadlock when using automatic split-brain-recovery
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0046-drbd-fix-for-deadlock-when-using-automatic-split-bra.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Philipp Reisner <philipp.reisner@linbit.com>

[ Upstream commit 7c689e63a847316c1b2500f86891b0a574ce7e69 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/block/drbd/drbd_receiver.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index c74ca2d..490b759 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2271,7 +2271,6 @@ static int drbd_asb_recover_1p(struct drbd_conf *mdev) __must_hold(local)
 		if (hg == -1 && mdev->state.role == R_PRIMARY) {
 			enum drbd_state_rv rv2;
 
-			drbd_set_role(mdev, R_SECONDARY, 0);
 			 /* drbd_change_state() does not sleep while in SS_IN_TRANSIENT_STATE,
 			  * we might be here in C_WF_REPORT_PARAMS which is transient.
 			  * we do not need to wait for the after state change work either. */
-- 
1.7.10.4



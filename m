Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbaGAQTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:19:30 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53119 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008AbaGAQQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 14/20] drbd: clear CRASHED_PRIMARY only after successful resync
Date: Tue,  1 Jul 2014 18:16:44 +0200
Message-Id: <1404231410-29852-15-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

If we lost a disk during the first resync after primary crash,
we could have prematurely cleared the CRASHED_PRIMARY flag.
Testing on C_CONNECTED is not what we meant there,
but testing for both peers to become D_UP_TO_DATE.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 4a75b7a..c35c0f0 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1238,7 +1238,8 @@ static void after_state_ch(struct drbd_device *device, union drbd_state os,
 	sib.os = os;
 	sib.ns = ns;
 
-	if (os.conn != C_CONNECTED && ns.conn == C_CONNECTED) {
+	if ((os.disk != D_UP_TO_DATE || os.pdsk != D_UP_TO_DATE)
+	&&  (ns.disk == D_UP_TO_DATE && ns.pdsk == D_UP_TO_DATE)) {
 		clear_bit(CRASHED_PRIMARY, &device->flags);
 		if (device->p_uuid)
 			device->p_uuid[UI_FLAGS] &= ~((u64)2);
-- 
1.9.1


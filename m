Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbbALSQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:16:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbbALSGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dylan Rajaratnam <dylan.rajaratnam@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 084/216] [media] img-ir/hw: Always read data to clear buffer
Date: Mon, 12 Jan 2015 18:03:21 +0000
Message-Id: <1421085933-32536-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dylan Rajaratnam <dylan.rajaratnam@imgtec.com>

commit ea0de4ec5489da0fe738b274effac4f950e93d76 upstream.

A problem was found on Polaris where if the unit it booted via the power
button on the infrared remote then the next button press on the remote
would return the key code used to power on the unit.

The sequence is:
 - The polaris powered off but with the powerdown controller (PDC) block
   still powered.
 - Press power key on remote, IR block receives the key.
 - Kernel starts, IR code is in IMG_IR_DATA_x but neither IMG_IR_RXDVAL
   or IMG_IR_RXDVALD2 are set.
 - Wait any amount of time.
 - Press any key.
 - IMG_IR_RXDVAL or IMG_IR_RXDVALD2 is set but IMG_IR_DATA_x is
   unchanged since the powerup key data was never read.

This is worked around by always reading the IMG_IR_DATA_x in
img_ir_set_decoder(), rather than only when the IMG_IR_RXDVAL or
IMG_IR_RXDVALD2 bit is set.

Signed-off-by: Dylan Rajaratnam <dylan.rajaratnam@imgtec.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/rc/img-ir/img-ir-hw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 0127dd257a57..5dfd0e9c2d5a 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -542,10 +542,12 @@ static void img_ir_set_decoder(struct img_ir_priv *priv,
 	if (ir_status & (IMG_IR_RXDVAL | IMG_IR_RXDVALD2)) {
 		ir_status &= ~(IMG_IR_RXDVAL | IMG_IR_RXDVALD2);
 		img_ir_write(priv, IMG_IR_STATUS, ir_status);
-		img_ir_read(priv, IMG_IR_DATA_LW);
-		img_ir_read(priv, IMG_IR_DATA_UP);
 	}
 
+	/* always read data to clear buffer if IR wakes the device */
+	img_ir_read(priv, IMG_IR_DATA_LW);
+	img_ir_read(priv, IMG_IR_DATA_UP);
+
 	/* stop the end timer and switch back to normal mode */
 	del_timer_sync(&hw->end_timer);
 	hw->mode = IMG_IR_M_NORMAL;
-- 
2.1.4


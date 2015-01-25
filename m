Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbbAYS3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:29:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbbAYSK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dylan Rajaratnam <dylan.rajaratnam@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 3.18 110/183] [media] img-ir/hw: Always read data to clear buffer
Date: Sun, 25 Jan 2015 10:07:12 -0800
Message-Id: <20150125180814.976977380@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/img-ir/img-ir-hw.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -541,10 +541,12 @@ static void img_ir_set_decoder(struct im
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



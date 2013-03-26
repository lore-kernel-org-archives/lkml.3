Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab3CZX0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:26:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab3CZWwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcin Miotk <marcinmiotk81@gmail.com>,
        Benjamin Li <benli@broadcom.com>,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 06/72] tg3: 5715 does not link up when autoneg off
Date: Tue, 26 Mar 2013 15:50:49 -0700
Message-Id: <20130326224920.362879900@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Nithin Sujir <nsujir@broadcom.com>

[ Upstream commit 7c6cdead7cc9a99650d15497aae47d7472217eb1 ]

Commit d13ba512cbba7de5d55d7a3b2aae7d83c8921457 ("tg3: Remove
SPEED_UNKNOWN checks") cleaned up the autoneg advertisement by
removing some dead code. One effect of this change was that the
advertisement register would not be updated if autoneg is turned off.

This exposed a bug on the 5715 device w.r.t linking. The 5715 defaults
to advertise only 10Mb Full duplex. But with autoneg disabled, it needs
the configured speed enabled in the advertisement register to link up.

This patch adds the work around to advertise all speeds on the 5715 when
autoneg is disabled.

Reported-by: Marcin Miotk <marcinmiotk81@gmail.com>
Reviewed-by: Benjamin Li <benli@broadcom.com>
Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/tg3.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -3946,6 +3946,14 @@ static void tg3_phy_copper_begin(struct
 		tp->link_config.active_speed = tp->link_config.speed;
 		tp->link_config.active_duplex = tp->link_config.duplex;
 
+		if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5714) {
+			/* With autoneg disabled, 5715 only links up when the
+			 * advertisement register has the configured speed
+			 * enabled.
+			 */
+			tg3_writephy(tp, MII_ADVERTISE, ADVERTISE_ALL);
+		}
+
 		bmcr = 0;
 		switch (tp->link_config.speed) {
 		default:



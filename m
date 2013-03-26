Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965361Ab3CZPe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:34:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54096 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965297Ab3CZPXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 121/150] tg3: 5715 does not link up when autoneg off
Date: Tue, 26 Mar 2013 15:20:20 +0000
Message-Id: <1364311249-14454-122-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Sujir <nsujir@broadcom.com>

commit 7c6cdead7cc9a99650d15497aae47d7472217eb1 upstream.

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
[ luis: backported by Nithin Sujir ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 4da6a86..ca3be73 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -3946,6 +3946,14 @@ static void tg3_phy_copper_begin(struct tg3 *tp)
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
-- 
1.8.1.2


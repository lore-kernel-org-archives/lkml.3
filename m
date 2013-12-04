Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab3LDPpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:45:47 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:53186 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794Ab3LDPpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:45:02 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mugunthan V N <mugunthanvnm@ti.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFCv2 6/6] net: phy: suspend phydev when going to HALTED
Date: Wed,  4 Dec 2013 16:44:48 +0100
Message-Id: <1386171888-28190-7-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When phydev is going to HALTED state, we can try to suspend it to
safe more power. phy_suspend helper will check if PHY can be suspended,
so just call it when entering HALTED state.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
RFCv1->RFCv2:
- initial, integrate phy_suspend to phy state machine
  (Suggested by Mugunthan and Florian)

Cc: David Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Mugunthan V N <mugunthanvnm@ti.com>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/phy/phy.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 36c6994..6429942 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -740,7 +740,7 @@ void phy_state_machine(struct work_struct *work)
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct phy_device *phydev =
 			container_of(dwork, struct phy_device, state_queue);
-	int needs_aneg = 0;
+	int needs_aneg = 0, do_suspend = 0;
 	int err = 0;
 
 	mutex_lock(&phydev->lock);
@@ -855,6 +855,7 @@ void phy_state_machine(struct work_struct *work)
 				phydev->link = 0;
 				netif_carrier_off(phydev->attached_dev);
 				phydev->adjust_link(phydev->attached_dev);
+				do_suspend = 1;
 			}
 			break;
 		case PHY_RESUMING:
@@ -913,6 +914,9 @@ void phy_state_machine(struct work_struct *work)
 	if (needs_aneg)
 		err = phy_start_aneg(phydev);
 
+	if (do_suspend)
+		phy_suspend(phydev);
+
 	if (err < 0)
 		phy_error(phydev);
 
-- 
1.7.2.5


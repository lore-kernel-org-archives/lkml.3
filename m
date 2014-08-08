Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704AbaHHVh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:37:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933524AbaHHVgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hauke Merthens <hauke-m@hauke-m.de>, Jonas Gorski <jogo@openwrt.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.15 06/26] net: phy: re-apply PHY fixups during phy_register_device
Date: Fri,  8 Aug 2014 14:35:13 -0700
Message-Id: <20140808213413.920847791@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213413.648794968@linuxfoundation.org>
References: <20140808213413.648794968@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit d92f5dec6325079c550889883af51db1b77d5623 ]

Commit 87aa9f9c61ad ("net: phy: consolidate PHY reset in phy_init_hw()")
moved the call to phy_scan_fixups() in phy_init_hw() after a software
reset is performed.

By the time phy_init_hw() is called in phy_device_register(), no driver
has been bound to this PHY yet, so all the checks in phy_init_hw()
against the PHY driver and the PHY driver's config_init function will
return 0. We will therefore never call phy_scan_fixups() as we should.

Fix this by calling phy_scan_fixups() and check for its return value to
restore the intended functionality.

This broke PHY drivers which do register an early PHY fixup callback to
intercept the PHY probing and do things like changing the 32-bits unique
PHY identifier when a pseudo-PHY address has been used, as well as
board-specific PHY fixups that need to be applied during driver probe
time.

Reported-by: Hauke Merthens <hauke-m@hauke-m.de>
Reported-by: Jonas Gorski <jogo@openwrt.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -354,7 +354,7 @@ int phy_device_register(struct phy_devic
 	phydev->bus->phy_map[phydev->addr] = phydev;
 
 	/* Run all of the fixups for this PHY */
-	err = phy_init_hw(phydev);
+	err = phy_scan_fixups(phydev);
 	if (err) {
 		pr_err("PHY %d failed to initialize\n", phydev->addr);
 		goto out;



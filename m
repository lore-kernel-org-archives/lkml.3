Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab3BSJyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:54:07 -0500
Received: from smtp14.mail.ru ([94.100.176.91]:50935 "EHLO smtp14.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab3BSJyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:54:04 -0500
Subject: [PATCH] NET/PHY: Eliminate the forced speed reduction algorithm.
From: Kirill Kapranov <kapranoff@inbox.ru>
Reply-To: kapranoff@inbox.ru
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Francois Romieu <romieu@fr.zoreil.com>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="KOI8-R"
Organization: NITA, LLC
Date: Tue, 19 Feb 2013 13:53:48 +0400
Message-ID: <1361267628.4919.6.camel@kkk.nita.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NET/PHY: Eliminate the forced speed reduction algorithm.

The purpose of the introduced patch is deletion of the forced speed
reduction algorithm realisation from the driver module "phy".

The above mentioned algorithm works in the following way: if the phy
detected unlink line state (connector plugged off), NIC speed is
decreased step-by-step in the sequence:
100 full duplex
100 half duplex
10 full duplex
10 half duplex
with the latency circa 10 s per step, and stops at 10-HD value.
I have looked up RFC-802.3, and found, that the mentioned algorithm is
neither quoted nor described. AFAIK, no one RFC describe the mentioned
algorithm, so it may be a witty invention of the developer(s).

In the case of the fixed speed and duplex set, with the autonegotiation
off, for a NIC (e.g. # ethtool -s eth0 autoneg off speed 100 duplex
full) with ethernet cable plugged off, mentioned algorithm slows down
NIC speed, so when ethernet connector is plugged in, connection will be
inoperative: an ethernet switch will try to connect with 100/full
(e.g.), a NIC will stay at 10/half.
Thus, this algorithm is destructive for the fixed speed/duplex mode
(with autonegotiation off).

In the AUTO mode, the mentioned algorithm is inessential. The
autonegotiation procedure works fine regardless an speed/duplex settings
at the moment of connector hooking up.
Thus, there is no point in using of this algorithm in driver.

Thanks a lot Francois Romieu and David Miller for very constructive
advises.

Tested at 2.6.38.7, applicable up to for 3.0.4. 
Signed-off-by: Kirill Kapranov <kkk@nita.ru>,<kapranoff@inbox.ru>
 --- linux/drivers/net/phy/phy.c.orig	2011-05-22 02:13:59.000000000 +0400
+++ linux/drivers/net/phy/phy.c	2012-04-28 12:49:37.000000000 +0400
@@ -457,34 +457,6 @@ void phy_stop_machine(struct phy_device
 }
 
 /**
- * phy_force_reduction - reduce PHY speed/duplex settings by one step
- * @phydev: target phy_device struct
- *
- * Description: Reduces the speed/duplex settings by one notch,
- *   in this order--
- *   1000/FULL, 1000/HALF, 100/FULL, 100/HALF, 10/FULL, 10/HALF.
- *   The function bottoms out at 10/HALF.
- */
-static void phy_force_reduction(struct phy_device *phydev)
-{
-	int idx;
-
-	idx = phy_find_setting(phydev->speed, phydev->duplex);
-	
-	idx++;
-
-	idx = phy_find_valid(idx, phydev->supported);
-
-	phydev->speed = settings[idx].speed;
-	phydev->duplex = settings[idx].duplex;
-
-	pr_info("Trying %d/%s\n", phydev->speed,
-			DUPLEX_FULL == phydev->duplex ?
-			"FULL" : "HALF");
-}
-
-
-/**
  * phy_error - enter HALTED state for this PHY device
  * @phydev: target phy_device struct
  *
@@ -814,30 +786,12 @@ void phy_state_machine(struct work_struc
 				phydev->adjust_link(phydev->attached_dev);
 
 			} else if (0 == phydev->link_timeout--) {
-				int idx;
 
 				needs_aneg = 1;
 				/* If we have the magic_aneg bit,
 				 * we try again */
 				if (phydev->drv->flags & PHY_HAS_MAGICANEG)
 					break;
-
-				/* The timer expired, and we still
-				 * don't have a setting, so we try
-				 * forcing it until we find one that
-				 * works, starting from the fastest speed,
-				 * and working our way down */
-				idx = phy_find_valid(0, phydev->supported);
-
-				phydev->speed = settings[idx].speed;
-				phydev->duplex = settings[idx].duplex;
-
-				phydev->autoneg = AUTONEG_DISABLE;
-
-				pr_info("Trying %d/%s\n", phydev->speed,
-						DUPLEX_FULL ==
-						phydev->duplex ?
-						"FULL" : "HALF");
 			}
 			break;
 		case PHY_NOLINK:
@@ -863,7 +817,6 @@ void phy_state_machine(struct work_struc
 				netif_carrier_on(phydev->attached_dev);
 			} else {
 				if (0 == phydev->link_timeout--) {
-					phy_force_reduction(phydev);
 					needs_aneg = 1;
 				}
 			}




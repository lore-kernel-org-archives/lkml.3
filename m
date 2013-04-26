Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3DZM5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:57:16 -0400
Received: from mx.rdc.com.tw ([122.201.198.125]:55646 "EHLO spam.rdc.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab3DZM5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:57:14 -0400
X-Greylist: delayed 1676 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Apr 2013 08:57:14 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: r6040 mac driver issue and solution
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Fri, 26 Apr 2013 20:29:02 +0800
Message-ID: <07905E0D268758488D76D7D747F21BB6042DAAB0@rdc8.rdc>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: r6040 mac driver issue and solution
Thread-Index: Ac5CeaKy3NRWoXvjQt2bHVjmDmdGJw==
From: =?big5?B?QnJ1Y2UgWWUgKLitqM6qWSk=?= <Bruce.Ye@rdc.com.tw>
To: <florian@openwrt.org>
Cc: <linux-kernel@vger.kernel.org>,
        =?big5?B?T3dlbiBQZW5nICi0Xqr3tqkp?= <Owen.Peng@rdc.com.tw>,
        =?big5?B?QnJ1Y2UgWWUgKLitqM6qWSk=?= <Bruce.Ye@rdc.com.tw>
X-OriginalArrivalTime: 26 Apr 2013 12:29:04.0257 (UTC) FILETIME=[A38A9F10:01CE4279]
X-MAIL: spam.rdc.com.tw r3QCT3Vw053731
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Florian:
For RDC R6040 FAST ETHERNET DRIVER.
There's an issue in r6040 driver. It only occurs when there's more than one Ethernet port.
When initializing the MAC in boot up, r6040 driver set the same phy address to different ports.
It also display in boot log as below.
mii_bus:phy_addr=0:01
mii_bus:phy_addr=1:01

It will let the eth0 and eth1 work not in independent.
That is, if there is a connection on eth1 but not on eth0. The eth1 can not work only if link up the eth0.
To fix this problem is that giving the different phy address to different ports.
I already tested it on r6040.c version 0.27 and version 0.28 by the change and is worked.

Below is the change 


--- linux-3.0.4/drivers/net/r6040.c.orig	2013-04-26 04:36:51.736846552 -0700
+++ linux-3.0.4/drivers/net/r6040.c	2013-04-26 04:36:19.019588116 -0700
@@ -1030,12 +1030,25 @@ static void r6040_adjust_link(struct net
 	}
 }
 
+int phy_device_buffer[PHY_MAX_ADDR]={0};
+
 static int r6040_mii_probe(struct net_device *dev)
 {
 	struct r6040_private *lp = netdev_priv(dev);
 	struct phy_device *phydev = NULL;
 
-	phydev = phy_find_first(lp->mii_bus);
+	int addr;
+
+	for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
+		
+		if (lp->mii_bus->phy_map[addr] && phy_device_buffer[addr]==0){
+			phy_device_buffer[addr]=1;
+			phydev = lp->mii_bus->phy_map[addr];
+			}
+		if(phydev)
+			break;
+	}
+
 	if (!phydev) {
 		dev_err(&lp->pdev->dev, "no PHY found\n");
 		return -ENODEV;



Signed-off-by: Bruce Ye Developer <Bruce.Ye@rdc.com.tw>

Best Regards
Bruce
RDC Semiconductor

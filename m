Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827Ab3BMCu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 21:50:29 -0500
Received: from mout.gmx.net ([212.227.17.20]:56303 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759748Ab3BMCuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 21:50:25 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/jV88SWkXjCxREEOMX2LYnvIxkjHlsY+I2onb30w
	/0hOnGJeEeOQ7F
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Yunhong Jiang <yunhong.jiang@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        "Mike A. Chan" <mikechan@google.com>,
        Xiaohui Xin <xiaohui.xin@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 5/9] staging/rtl8187se: Reuse ReadBBPortUchar to avoid duplicated code
Date: Wed, 13 Feb 2013 03:54:30 +0100
Message-Id: <1360724074-2445-5-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360724074-2445-1-git-send-email-peterhuewe@gmx.de>
References: <1360724074-2445-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WriteBBPortUchar reimplements ReadBBPortUchar in its body, so we can
remove the duplicated code by calling ReadBBPortUchar directly.

Unfortunately we have to move ReadBBPortUchar around; while at it we can
also get rid of the temporary variable for the return value.

Also we can remove the local variables UCharData and RegisterContent in
WriteBBPortUchar as they are not used / without effect.

Both functions are only 'local' so we can mark them as static.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/rtl8187se/r8185b_init.c |   30 +++++++-----------------------
 1 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 1e54ead..a3b836c 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -287,35 +287,19 @@ u16 RF_ReadReg(struct net_device *dev, u8 offset)
 	return reg;
 }
 
+static u8 ReadBBPortUchar(struct net_device *dev, u32 addr)
+{
+	PlatformIOWrite4Byte(dev, PhyAddr, addr & 0xffffff7f);
+	return PlatformIORead1Byte(dev, PhyDataR);
+}
 
 /* by Owen on 04/07/14 for writing BB register successfully */
-void WriteBBPortUchar(struct net_device *dev, u32 Data)
+static void WriteBBPortUchar(struct net_device *dev, u32 Data)
 {
-	/* u8	TimeoutCounter; */
-	u8	RegisterContent;
-	u8	UCharData;
-
-	UCharData = (u8)((Data & 0x0000ff00) >> 8);
 	PlatformIOWrite4Byte(dev, PhyAddr, Data);
-	/* for(TimeoutCounter = 10; TimeoutCounter > 0; TimeoutCounter--) */
-	{
-		PlatformIOWrite4Byte(dev, PhyAddr, Data & 0xffffff7f);
-		RegisterContent = PlatformIORead1Byte(dev, PhyDataR);
-		/*if(UCharData == RegisterContent)	*/
-		/*	break;	*/
-	}
+	ReadBBPortUchar(dev, Data);
 }
 
-u8 ReadBBPortUchar(struct net_device *dev, u32 addr)
-{
-	/*u8	TimeoutCounter; */
-	u8	RegisterContent;
-
-	PlatformIOWrite4Byte(dev, PhyAddr, addr & 0xffffff7f);
-	RegisterContent = PlatformIORead1Byte(dev, PhyDataR);
-
-	return RegisterContent;
-}
 /*
  *	Description:
  *	Perform Antenna settings with antenna diversity on 87SE.
-- 
1.7.8.6


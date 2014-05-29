Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940AbaE2FIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:08:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406AbaE2Efv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 129/140] net: phy: Dont call phy_resume if phy_init_hw failed
Date: Wed, 28 May 2014 21:34:28 -0700
Message-Id: <20140529043105.959131414@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit b394745df2d9d4c30bf1bcc55773bec6f3bc7c67 ]

After the call to phy_init_hw failed in phy_attach_direct, phy_detach is called
to detach the phy device from its network device. If the attached driver is a
generic phy driver, this also detaches the driver. Subsequently phy_resume
is called, which assumes without checking that a driver is attached to the
device. This will result in a crash such as

Unable to handle kernel paging request for data at address 0xffffffffffffff90
Faulting instruction address: 0xc0000000003a0e18
Oops: Kernel access of bad area, sig: 11 [#1]
...
NIP [c0000000003a0e18] .phy_attach_direct+0x68/0x17c
LR [c0000000003a0e6c] .phy_attach_direct+0xbc/0x17c
Call Trace:
[c0000003fc0475d0] [c0000000003a0e6c] .phy_attach_direct+0xbc/0x17c (unreliable)
[c0000003fc047670] [c0000000003a0ff8] .phy_connect_direct+0x28/0x98
[c0000003fc047700] [c0000000003f0074] .of_phy_connect+0x4c/0xa4

Only call phy_resume if phy_init_hw was successful.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy_device.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -613,8 +613,8 @@ int phy_attach_direct(struct net_device
 	err = phy_init_hw(phydev);
 	if (err)
 		phy_detach(phydev);
-
-	phy_resume(phydev);
+	else
+		phy_resume(phydev);
 
 	return err;
 }



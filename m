Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaKLDkC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:40:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788AbaKLBaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:30:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oussama Ghorbel <ghorbel@pivasoftware.com>,
        Rabin Vincent <rabin@rab.in>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 3.17 204/319] phy: omap-usb2: Enable runtime PM of omap-usb2 phy properly
Date: Wed, 12 Nov 2014 10:15:42 +0900
Message-Id: <20141112011026.577117151@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oussama Ghorbel <ghorbel@pivasoftware.com>

commit f20531a9aae0c7378d9fa75b4b5d99b7eecab066 upstream.

The USB OTG port does not work since v3.16 on omap platform.
This is a regression introduced by the commit
eb82a3d846fa (phy: omap-usb2: Balance pm_runtime_enable() on probe failure
 and remove).
This because the call to pm_runtime_enable() function is moved after the
call to devm_phy_create() function, which has side effect since later in
the subsequent calls of devm_phy_create() there is a check with
pm_runtime_enabled() to configure few things.

Fixes: eb82a3d846fa
Signed-off-by: Oussama Ghorbel <ghorbel@pivasoftware.com>
Tested-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/phy/phy-omap-usb2.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -262,14 +262,16 @@ static int omap_usb2_probe(struct platfo
 	otg->phy		= &phy->phy;
 
 	platform_set_drvdata(pdev, phy);
+	pm_runtime_enable(phy->dev);
 
 	generic_phy = devm_phy_create(phy->dev, NULL, &ops, NULL);
-	if (IS_ERR(generic_phy))
+	if (IS_ERR(generic_phy)) {
+		pm_runtime_disable(phy->dev);
 		return PTR_ERR(generic_phy);
+	}
 
 	phy_set_drvdata(generic_phy, phy);
 
-	pm_runtime_enable(phy->dev);
 	phy_provider = devm_of_phy_provider_register(phy->dev,
 			of_phy_simple_xlate);
 	if (IS_ERR(phy_provider)) {



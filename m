Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbaIIIoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:44:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47038 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbaIIIob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:44:31 -0400
X-AuditID: cbfee61a-f79e46d00000134f-bd-540ebded095e
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kamil Debski <k.debski@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 1/6] usb: dwc2/gadget: fix phy disable sequence
Date: Tue, 09 Sep 2014 10:44:08 +0200
Message-id: <1410252253-13687-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410252253-13687-1-git-send-email-r.baldyga@samsung.com>
References: <1410252253-13687-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd23e/lCDKZ1iFgcvF9v0bx4PZvF
	j9cX2Cwu75rDZrFoWSuzxdojd9ktHj3cymrx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CVsejpf9aC99wVn+9uZG5gbObqYuTkkBAwkVh76zUbhC0m
	ceHeeiCbi0NIYDqjxO5NT5kgnHYmicWzO8Gq2AR0JLZ8n8AIYosIyEtc33iTBaSIWeApo8SS
	/dfYQRLCAvYS7Vc/sYDYLAKqElMaVjN3MXJw8Aq4SpxfZAaxTU7i5LHJrCA2p4CbxPzefrD5
	QkAlnU/WMk5g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzi8nkntYFzZYHGIUYCD
	UYmHNyOYL0SINbGsuDL3EKMEB7OSCO+V3UAh3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOF
	BNITS1KzU1MLUotgskwcnFINjMb3frbwNC7/b2D99Exx/Yn9X/j4ulu7VdmOR6rfWRe9qtn0
	wa2j03I/Tynletz9UGDbGs9JxxuO9Woe2M+tN7tuoV5v/8TM+dPiPGMXO/+JYHEq97hXNvtM
	Aa8y8++U5ODVSjv6Sw7JvWriDNB0Tzr2fT7zrvCDV2fYVn21TrlmV3wq4pONhRJLcUaioRZz
	UXEiAOQTqbArAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kamil Debski <k.debski@samsung.com>

When the driver is removed s3c_hsotg_phy_disable is called three times
instead of once. This results in decreasing of the phy reference counter
below zero and thus consecutive inserts of the module fails.

This patch removes calls to s3c_hsotg_phy_disable from s3c_hsotg_remove
and s3c_hsotg_udc_stop.

s3c_hsotg_udc_stop is called from udc-core.c only after
usb_gadget_disconnect, which in turn calls s3c_hsotg_pullup, which
already calls s3c_hsotg_phy_disable.

s3c_hsotg_remove must be called only after udc_stop, so there is no
point in disabling phy once again there.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 7c9618e..505d56e 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2897,8 +2897,6 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
 
 	spin_lock_irqsave(&hsotg->lock, flags);
 
-	s3c_hsotg_phy_disable(hsotg);
-
 	if (!driver)
 		hsotg->driver = NULL;
 
@@ -3582,7 +3580,6 @@ static int s3c_hsotg_remove(struct platform_device *pdev)
 		usb_gadget_unregister_driver(hsotg->driver);
 	}
 
-	s3c_hsotg_phy_disable(hsotg);
 	if (hsotg->phy)
 		phy_exit(hsotg->phy);
 	clk_disable_unprepare(hsotg->clk);
-- 
1.9.1


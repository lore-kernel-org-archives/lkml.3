Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3ILOTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:19:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15686 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3ILOTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:19:33 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-4a-5231cd74f48c
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/6] usb: s3c-hsotg: fix unregistration function
Date: Thu, 12 Sep 2013 16:18:48 +0200
Message-id: <1378995532-32142-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
References: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jQd2Ss4ZBBsd6eS02zljPanHwfr1F
	8+L1bBZnm96wW1zeNYfNYtGyVmaLtUfusls8OLyT3YHDY//cNewefVtWMXocv7GdyePzJrkA
	ligum5TUnMyy1CJ9uwSujP9PYwr+CVS87VnA1sC4jq+LkZNDQsBEYuqZ86wQtpjEhXvr2boY
	uTiEBKYzSuz9eJwZwuliktjdspERpIpNQEdiy/cJYLaIgIDE+heX2EGKmAWeMEpMPfKKHSQh
	LOAg8WT/exYQm0VAVWLepF1gDbwCrhLvj61igVgnL/H0fh8biM0p4CbRtxtkNQfQNleJiVtT
	JjDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHFLPpHcwrmqwOMQowMGoxMObuNgw
	SIg1say4MvcQowQHs5II7+eJQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE0hNLUrNT
	UwtSi2CyTBycUg2MBocKc9tm3G3Qc7ASMz20htUpr8xmUoj4rZ9iNQJPrnW7/9P5JBXm0/rz
	Xwl/wr9qH+85Btw/NWML/ot9Oq/ExtthwMFsXTNdXebejz9rO/cqG2+7yxqird/+RurHqvmb
	fhZN4DbaoFivo3B7WtcGGTHLIyq3Gb/K+eflFot92iNx5mR0+j8lluKMREMt5qLiRABjA51N
	JQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

After driver conversion to udc_start/udc_stop infrastructure (commit
"usb:hsotg:samsung: Use new udc_start and udc_stop callbacks"
f65f0f1098) the gadget unregistration function is almost always called
with 'driver' parameter being NULL, what caused that the unregistration
code has not been executed at all. This is a leftover from the earlier
verison of this function (which used simple start/stop interface), where
driver parameter was obligatory.

This patch removes the NULL check for the 'driver' pointer and removes
all dereferences of it. It also moves disabling voltage regulators out
of the atomic context, because handling regulators (which are usually
i2c devices) might require sleeping.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index af22f24..b13a4f9 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2961,9 +2961,6 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
 	if (!hsotg)
 		return -ENODEV;
 
-	if (!driver || driver != hsotg->driver || !driver->unbind)
-		return -EINVAL;
-
 	/* all endpoints should be shutdown */
 	for (ep = 0; ep < hsotg->num_of_eps; ep++)
 		s3c_hsotg_ep_disable(&hsotg->eps[ep].ep);
@@ -2971,15 +2968,15 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
 	spin_lock_irqsave(&hsotg->lock, flags);
 
 	s3c_hsotg_phy_disable(hsotg);
-	regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies), hsotg->supplies);
 
-	hsotg->driver = NULL;
+	if (!driver)
+		hsotg->driver = NULL;
+
 	hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 
 	spin_unlock_irqrestore(&hsotg->lock, flags);
 
-	dev_info(hsotg->dev, "unregistered gadget driver '%s'\n",
-		 driver->driver.name);
+	regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies), hsotg->supplies);
 
 	return 0;
 }
-- 
1.7.9.5


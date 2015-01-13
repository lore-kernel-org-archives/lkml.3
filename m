Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbbAMK6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:58:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40684 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbAMK6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:58:15 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-4f-54b4fa45610d
From: Robert Baldyga <r.baldyga@samsung.com>
To: paulz@synopsys.com
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, dinguyen@opensource.altera.com,
        yousaf.kaukab@intel.com, m.szyprowski@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] usb: dwc2: call dwc2_is_controller_alive() under spinlock
Date: Tue, 13 Jan 2015 11:57:37 +0100
Message-id: <1421146657-18587-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xoK7rry0hBodWa1kcvF9vserTGmaL
	5sXr2Swu75rDZrFoWSuzxdojd9kttk+ZzmTx4PBOdotNm34yO3B6LN7zkslj/9w17B791yax
	e/RtWcXosWX/Z0aP4ze2M3l83iQXwB7FZZOSmpNZllqkb5fAlbF3Pn/BQbaKmZ8usDUwbmPt
	YuTkkBAwkTiy5gALhC0mceHeerYuRi4OIYHpjBLXl85lhnDamSSm/tvGDFLFJqAjseX7BMYu
	Rg4OEaCO7x84QWqYBZ4xSqx9fIQdpEZYwEvi6rGDYDaLgKrEism3wGxeAVeJOyuvskFsk5M4
	eWwy6wRG7gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgkPpmfQOxlUNFocYBTgYlXh4
	BfK2hAixJpYVV+YeYpTgYFYS4U3/DhTiTUmsrEotyo8vKs1JLT7EKM3BoiTOq2TfFiIkkJ5Y
	kpqdmlqQWgSTZeLglGpg7Pjoe0f3GkdizQOhym81oVcrX+Yx1p/6PCkz6o5y+L5fJ2ZeOXvk
	3oSXgvvXidZ0R5wMWlT+iMn51OQXDxetdjBclVVTtEkw/ptJfMLBp5vKZK33HklPFLH6Hrd6
	g9kll3JjmSXrHpSpLnOa8aZg3iOn/Xz7H7wtDn2rbKPwbd1Ng8Ob2/P1FZVYijMSDbWYi4oT
	ARKCpnIhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes bug described here:
https://lkml.org/lkml/2014/12/22/185

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/core_intr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
index ad43c5b..668c8dd 100644
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -476,13 +476,13 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
 	u32 gintsts;
 	irqreturn_t retval = IRQ_NONE;
 
+	spin_lock(&hsotg->lock);
+
 	if (!dwc2_is_controller_alive(hsotg)) {
 		dev_warn(hsotg->dev, "Controller is dead\n");
 		goto out;
 	}
 
-	spin_lock(&hsotg->lock);
-
 	gintsts = dwc2_read_common_intr(hsotg);
 	if (gintsts & ~GINTSTS_PRTINT)
 		retval = IRQ_HANDLED;
-- 
1.9.1


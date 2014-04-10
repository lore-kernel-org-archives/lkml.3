Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935467AbaDJK2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:28:23 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:37151 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935420AbaDJK2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:28:15 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, kgene.kim@samsung.com, jg1.han@samsung.com,
        Alan Stern <stern@rowland.harvard.edu>,
        Hauke Mehrtens <hauke@hauke-m.de>, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 2/2] usb: ehci-platform: Return immediately from suspend if ehci_suspend fails
Date: Thu, 10 Apr 2014 15:58:02 +0530
Message-Id: <1397125682-4955-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397125682-4955-1-git-send-email-gautam.vivek@samsung.com>
References: <1397125682-4955-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 'b8efdaf USB: EHCI: add check for wakeup/suspend race'
adds a check for possible race between suspend and wakeup interrupt,
and thereby it returns -EBUSY as error code if there's a wakeup
interrupt.
So the platform host controller should not proceed further with
its suspend callback, rather should return immediately to avoid
powering down the essential things, like phy.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Hans de Goede <hdegoede@redhat.com>
---

Changes from v1:
-- Removed unnecessary change 'return 0'

 drivers/usb/host/ehci-platform.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index b3a0e11..c7dd93a 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -303,6 +303,8 @@ static int ehci_platform_suspend(struct device *dev)
 	int ret;
 
 	ret = ehci_suspend(hcd, do_wakeup);
+	if (ret)
+		return ret;
 
 	if (pdata->power_suspend)
 		pdata->power_suspend(pdev);
-- 
1.7.10.4


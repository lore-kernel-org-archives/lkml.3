Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750889AbaDIEBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 00:01:06 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:55347 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaDIEBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 00:01:02 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, kgene.kim@samsung.com,
        Alan Stern <stern@rowland.harvard.edu>,
        Hauke Mehrtens <hauke@hauke-m.de>, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/2] usb: ehci-platform: Return immediately from suspend if ehci_suspend fails
Date: Wed,  9 Apr 2014 09:30:42 +0530
Message-Id: <1397016042-4451-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397016042-4451-1-git-send-email-gautam.vivek@samsung.com>
References: <1397016042-4451-1-git-send-email-gautam.vivek@samsung.com>
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

Based on 'usb-next' branch of Greg's usb tree.

 drivers/usb/host/ehci-platform.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index b3a0e11..60d3d1a 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -303,11 +303,13 @@ static int ehci_platform_suspend(struct device *dev)
 	int ret;
 
 	ret = ehci_suspend(hcd, do_wakeup);
+	if (ret)
+		return ret;
 
 	if (pdata->power_suspend)
 		pdata->power_suspend(pdev);
 
-	return ret;
+	return 0;
 }
 
 static int ehci_platform_resume(struct device *dev)
-- 
1.7.10.4


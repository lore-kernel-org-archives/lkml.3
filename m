Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab3HTRgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:36:55 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:35830 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3HTRgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:36:52 -0400
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH 2/2] usb: fail on usb_hub_create_port_device() errors
Date: Tue, 20 Aug 2013 19:24:36 +0200
Message-Id: <1377019476-7701-3-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.8.4.rc1.409.gbd48715
In-Reply-To: <1377019476-7701-1-git-send-email-krzysiek@podlesie.net>
References: <1377019476-7701-1-git-send-email-krzysiek@podlesie.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignoring usb_hub_create_port_device() errors cause later NULL pointer
deference when uninitialized hub->ports[i] entries are dereferenced
after port memory allocation error.

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
---
I'm not sure if failing in that case is a good idea, but other solutions
are more complex.

I tried also changing hdev->maxchild and skiping initialization
of later ports, but it didn't work because in some cases
hub->descriptor->bNbrPorts is used instead of hdev->maxchild.
With simulated usb_hub_create_port_device() failure I have an Oops
in hub_power_on().

Another possible solution is allowing for uninitialized ports and
checking for hub->ports[i] == NULL.

 drivers/usb/core/hub.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 588c3a3..afd334b 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1557,10 +1557,15 @@ static int hub_configure(struct usb_hub *hub,
 	if (hub->has_indicators && blinkenlights)
 		hub->indicator [0] = INDICATOR_CYCLE;
 
-	for (i = 0; i < hdev->maxchild; i++)
-		if (usb_hub_create_port_device(hub, i + 1) < 0)
+	for (i = 0; i < hdev->maxchild; i++) {
+		ret = usb_hub_create_port_device(hub, i + 1);
+		if (ret < 0) {
 			dev_err(hub->intfdev,
 				"couldn't create port%d device.\n", i + 1);
+			hdev->maxchild = i;
+			goto fail;
+		}
+	}
 
 	usb_hub_adjust_deviceremovable(hdev, hub->descriptor);
 
-- 
1.8.4.rc1.409.gbd48715


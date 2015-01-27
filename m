Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbbA0Laq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:30:46 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36012 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbA0Lak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:30:40 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-15-54c7764c6b33
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>, Marek Belisko <marek@goldelico.com>,
        Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
        Darren Hart <dvhart@infradead.org>, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [RFT PATCH 2/4] compal-laptop: Check return value of
 power_supply_register
Date: Tue, 27 Jan 2015 12:30:19 +0100
Message-id: <1422358221-13199-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1422358221-13199-1-git-send-email-k.kozlowski@samsung.com>
References: <1422358221-13199-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xK7o+ZcdDDOa94bNYcqKbxWLSk/fM
	Fl0LDSwmrpzMbPH6haHF5V1z2Cw+9x5htNjedpTF4t/SLWwWq/e8YLY4vbvEYsHGR4wOPB47
	Z91l91jz/hSzx7Frd1g8Nq/Q8ti0qpPNo2/LKkaPz5vkAtijuGxSUnMyy1KL9O0SuDIaH15n
	KrjIV/Fmnk8D4x6eLkYODgkBE4npHcVdjJxAppjEhXvr2boYuTiEBJYySlxv2cwO4fQxSdzd
	s4oZpIpNwFhi8/IlYFUiAi3MEjsXnmIBSTALeEq8+/uQHcQWFgiVeL52GhOIzSKgKnF82Saw
	Zl4Bd4nr67+yQqyTkzh5bDKYzSngIfFr/V6wOUJANVemn2eZwMi7gJFhFaNoamlyQXFSeq6h
	XnFibnFpXrpecn7uJkZISH7Zwbj4mNUhRgEORiUeXo6i4yFCrIllxZW5hxglOJiVRHi9IoBC
	vCmJlVWpRfnxRaU5qcWHGJk4OKUaGL3y7srU6u9eo3Fv4m4Rj+qE7qWsKgtUH6vvPfA421t+
	mb7rOg2deZn73r/fM/HwJ+8ZpyZklCXJMMkFMtWyzn9+pL7dvC/h8jbGtoDNQT/zWR96XP0a
	1Xppy8Q5pX/eSB/YJlumZfb37AR7i6zI5UUV862/r0gOtRe2KLdNVtwSN0vvSffnGUosxRmJ
	hlrMRcWJAGLlTJsnAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value of power_supply_register() call was not checked and
even on error probe() function returned 0. If registering failed then
during unbind the driver tried to unregister power supply which was not
actually registered.

This could lead to memory corruption because power_supply_unregister()
unconditionally cleans up given power supply.

Fix this by checking return status of power_supply_register() call. In
case of failure, unregister the hwmon device and fail the probe. Add a
fixme note about missing hwmon_device_unregister() in driver removal.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: 9be0fcb5ed46 ("compal-laptop: add JHL90, battery & hwmon interface")
Cc: <stable@vger.kernel.org>
---
 drivers/platform/x86/compal-laptop.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 15c0fab2bfa1..cf55a9246f12 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -1036,12 +1036,16 @@ static int compal_probe(struct platform_device *pdev)
 
 	/* Power supply */
 	initialize_power_supply_data(data);
-	power_supply_register(&compal_device->dev, &data->psy);
+	err = power_supply_register(&compal_device->dev, &data->psy);
+	if (err < 0)
+		goto psy_err;
 
 	platform_set_drvdata(pdev, data);
 
 	return 0;
 
+psy_err:
+	hwmon_device_unregister(hwmon_dev);
 remove:
 	sysfs_remove_group(&pdev->dev.kobj, &compal_platform_attr_group);
 	return err;
@@ -1072,6 +1076,7 @@ static int compal_remove(struct platform_device *pdev)
 
 	data = platform_get_drvdata(pdev);
 	power_supply_unregister(&data->psy);
+	/* FIXME: missing hwmon_device_unregister() */
 
 	sysfs_remove_group(&pdev->dev.kobj, &compal_platform_attr_group);
 
-- 
1.9.1


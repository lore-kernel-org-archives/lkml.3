Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaJJIZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:25:38 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35895 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaJJIYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:24:09 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-d7-543797a52949
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 4/4] extcon: max77693: Fix extcon UART on Trats2 board
Date: Fri, 10 Oct 2014 10:23:56 +0200
Message-id: <1412929436-22001-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412929436-22001-1-git-send-email-k.kozlowski@samsung.com>
References: <1412929436-22001-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xK7pLp5uHGJw/YmKxccZ6VovrX56z
	Wrx+YWhxtukNu8X9r0cZLS7vmsNmsfbIXXaL240r2CxOd7M6cHrcubaHzWPeyUCPvi2rGD0+
	b5ILYInisklJzcksSy3St0vgyjh/aDZbwRzRikdP77A1MH4T7GLk5JAQMJHY2nuVGcIWk7hw
	bz0biC0ksJRR4scHNQi7j0nicJMyiM0mYCyxefkSoBouDhGB3YwS3/YuYgJxmAWOMkpM733L
	BFIlLOAm8fLXMUYQm0VAVeJz+3awDbwC7hLL7v9lgtgmJ3Hy2GRWEJtTwEOi5fUuRoht7hIv
	exawTmDkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJLS+7GBcfMzqEKMAB6MSD+8F
	GfMQIdbEsuLK3EOMEhzMSiK8+qZAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzVPzXCmdkXsy9T
	NXqWm529jet63+mY3PDpMzSW3NYwUOn53250VXx+hdNnBdGH9Re6+69cqj3ktlEt6O1XkSP9
	9UsDnX7ul5diZPg4eY1fped2bcbns9W6Qmas25qbbMlQ6WaQGln+QPzJ/yd5q2wPsqgfbZqw
	xvq8yPbYdQ27WWd+PMGm8EOJpTgj0VCLuag4EQCgzOZJCwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When JIG was set to "boot on" mode, the UART connection did not work
because it was assigned to Dock-Car cable (path: audio), not JIG-UART-ON
cable.

This was introduced in 39bf369e4ed3 ("extcon: max77693: Add support dock
device and buttons") while adding dock features.

Assign the JIG-UART-ON back to UART path.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max77693.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 68d6c7cccc4f..943e8966bd05 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -206,7 +206,7 @@ static const char *max77693_extcon_cable[] = {
 	[EXTCON_CABLE_JIG_USB_ON]		= "JIG-USB-ON",
 	[EXTCON_CABLE_JIG_USB_OFF]		= "JIG-USB-OFF",
 	[EXTCON_CABLE_JIG_UART_OFF]		= "JIG-UART-OFF",
-	[EXTCON_CABLE_JIG_UART_ON]		= "Dock-Car",
+	[EXTCON_CABLE_JIG_UART_ON]		= "JIG-UART-ON",
 	[EXTCON_CABLE_DOCK_SMART]		= "Dock-Smart",
 	[EXTCON_CABLE_DOCK_DESK]		= "Dock-Desk",
 	[EXTCON_CABLE_DOCK_AUDIO]		= "Dock-Audio",
@@ -506,9 +506,6 @@ static int max77693_muic_dock_handler(struct max77693_muic_info *info,
 		extcon_set_cable_state(info->edev, "Dock-Smart", attached);
 		extcon_set_cable_state(info->edev, "MHL", attached);
 		goto out;
-	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_ON:	/* Dock-Car */
-		strcpy(dock_name, "Dock-Car");
-		break;
 	case MAX77693_MUIC_ADC_AUDIO_MODE_REMOTE:	/* Dock-Desk */
 		strcpy(dock_name, "Dock-Desk");
 		break;
@@ -643,6 +640,11 @@ static int max77693_muic_jig_handler(struct max77693_muic_info *info,
 		strcpy(cable_name, "JIG-UART-OFF");
 		path = CONTROL1_SW_UART;
 		break;
+	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_ON:	/* ADC_JIG_UART_ON */
+		/* PATH:AP_UART */
+		strcpy(cable_name, "JIG-UART-ON");
+		path = CONTROL1_SW_UART;
+		break;
 	default:
 		dev_err(info->dev, "failed to detect %s jig cable\n",
 			attached ? "attached" : "detached");
@@ -682,13 +684,13 @@ static int max77693_muic_adc_handler(struct max77693_muic_info *info)
 	case MAX77693_MUIC_ADC_FACTORY_MODE_USB_OFF:
 	case MAX77693_MUIC_ADC_FACTORY_MODE_USB_ON:
 	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_OFF:
+	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_ON:
 		/* JIG */
 		ret = max77693_muic_jig_handler(info, cable_type, attached);
 		if (ret < 0)
 			return ret;
 		break;
 	case MAX77693_MUIC_ADC_RESERVED_ACC_3:		/* Dock-Smart */
-	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_ON:	/* Dock-Car */
 	case MAX77693_MUIC_ADC_AUDIO_MODE_REMOTE:	/* Dock-Desk */
 	case MAX77693_MUIC_ADC_AV_CABLE_NOLOAD:		/* Dock-Audio */
 		/*
-- 
1.9.1


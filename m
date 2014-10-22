Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaJVIqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:46:39 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9713 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaJVIpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:45:53 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-70-54476ebeefec
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND 3/3] extcon: max77693: Fix extcon UART on Trats2 board
Date: Wed, 22 Oct 2014 10:45:40 +0200
Message-id: <1413967540-27626-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413967540-27626-1-git-send-email-k.kozlowski@samsung.com>
References: <1413967540-27626-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xq7r78txDDH6fU7DYOGM9q8X1L89Z
	LV6/MLQ42/SG3eL+16OMFpd3zWGzWHvkLrvF7cYVbBanu1kdOD3uXNvD5jHvZKBH35ZVjB6f
	N8kFsERx2aSk5mSWpRbp2yVwZRzfsoWxYI5oxau+mgbGb4JdjJwcEgImEo8372GHsMUkLtxb
	z9bFyMUhJLCUUWL1iVssEE4fk8SLn8eZQarYBIwlNi9fAlYlIrCbUeLb3kVMIA6zwFFGiem9
	b5lAqoQFfCVu7ZzOCmKzCKhKPPl1jBHE5hVwl2j7OIcJYp+cxMljk8FqOAU8JBYeA6nhAFrn
	LnFwrugERt4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUJC6+sOxqXHrA4xCnAwKvHw
	OrC5hwixJpYVV+YeYpTgYFYS4b2XDhTiTUmsrEotyo8vKs1JLT7EyMTBKdXAOPOpxvel/yIt
	NvzQfa10JmfRc9aLwscldQ4tOr67QTvwU+zhA1OuFumtLruxqWz+M69tlmbLet8cO1keIb/G
	6iRrYrdVZAR33w+TwMp50zP5KmY62VYJ71md4vJ1BtfxW+yqEi+qZ8Z5Scxt0HnypV064rxX
	Qxqj/OqgdfXtpdv+xsrVRgTeUWIpzkg01GIuKk4EAPlj6cILAgAA
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
index 9d21e75a7032..beaa8cd71c3b 100644
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


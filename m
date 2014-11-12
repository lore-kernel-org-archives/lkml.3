Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaKLGlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 01:41:14 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58603 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaKLGlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 01:41:12 -0500
From: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Todd Poynor <toddpoynor@google.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Benoit Goby <benoit@android.com>,
        Kiran Raparthy <kiran.kumar@linaro.org>
Subject: [RFC v6 2/3] usb: phy: handle per-PHY connect and disconnect events
Date: Wed, 12 Nov 2014 12:10:50 +0530
Message-Id: <1415774450-21757-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Todd Poynor <toddpoynor@google.com>

usb: phy: handle per-PHY connect and disconnect events

When usb is connected and enumerated in device mode or when usb is
disconnected,call usb_phy_set_event from phy drivers to handle per-PHY event.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Benoit Goby <benoit@android.com>
Signed-off-by: Todd Poynor <toddpoynor@google.com>
[kiran: Added context to commit message, squished build fixes
from Benoit Goby and Arve Hjønnevåg, changed wakelocks usage
to wakeupsource, merged Todd's refactoring logic and simplified
the structures and code and addressed community feedback]
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
---
 drivers/usb/phy/phy-ab8500-usb.c    | 15 +++++++++++++++
 drivers/usb/phy/phy-gpio-vbus-usb.c |  2 ++
 drivers/usb/phy/phy-mv-usb.c        |  2 ++
 drivers/usb/phy/phy-tahvo.c         |  2 ++
 4 files changed, 21 insertions(+)

diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 11ab2c4..d79fa3e 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -447,6 +447,7 @@ static int ab9540_usb_link_status_update(struct ab8500_usb *ab,
 			event = UX500_MUSB_NONE;
 		/* Fallback to default B_IDLE as nothing is connected. */
 		ab->phy.state = OTG_STATE_B_IDLE;
+		usb_phy_set_event(&ab->phy, USB_EVENT_NONE);
 		break;
 
 	case USB_LINK_ACA_RID_C_NM_9540:
@@ -461,12 +462,14 @@ static int ab9540_usb_link_status_update(struct ab8500_usb *ab,
 			ab8500_usb_peri_phy_en(ab);
 			atomic_notifier_call_chain(&ab->phy.notifier,
 					UX500_MUSB_PREPARE, &ab->vbus_draw);
+			usb_phy_set_event(&ab->phy, USB_EVENT_ENUMERATED);
 		}
 		if (ab->mode == USB_IDLE) {
 			ab->mode = USB_PERIPHERAL;
 			ab8500_usb_peri_phy_en(ab);
 			atomic_notifier_call_chain(&ab->phy.notifier,
 					UX500_MUSB_PREPARE, &ab->vbus_draw);
+			usb_phy_set_event(&ab->phy, USB_EVENT_ENUMERATED);
 		}
 		if (event != UX500_MUSB_RIDC)
 			event = UX500_MUSB_VBUS;
@@ -502,6 +505,7 @@ static int ab9540_usb_link_status_update(struct ab8500_usb *ab,
 		event = UX500_MUSB_CHARGER;
 		atomic_notifier_call_chain(&ab->phy.notifier,
 				event, &ab->vbus_draw);
+		usb_phy_set_event(&ab->phy, USB_EVENT_CHARGER);
 		break;
 
 	case USB_LINK_PHYEN_NO_VBUS_NO_IDGND_9540:
@@ -526,6 +530,7 @@ static int ab9540_usb_link_status_update(struct ab8500_usb *ab,
 				ab->mode = USB_IDLE;
 				ab->phy.otg->default_a = false;
 				ab->vbus_draw = 0;
+				usb_phy_set_event(&ab->phy, USB_EVENT_NONE);
 			}
 		}
 		break;
@@ -585,6 +590,7 @@ static int ab8540_usb_link_status_update(struct ab8500_usb *ab,
 		 * is connected
 		 */
 		ab->phy.state = OTG_STATE_B_IDLE;
+		usb_phy_set_event(&ab->phy, USB_EVENT_NONE);
 		break;
 
 	case USB_LINK_ACA_RID_C_NM_8540:
@@ -598,6 +604,7 @@ static int ab8540_usb_link_status_update(struct ab8500_usb *ab,
 			ab8500_usb_peri_phy_en(ab);
 			atomic_notifier_call_chain(&ab->phy.notifier,
 					UX500_MUSB_PREPARE, &ab->vbus_draw);
+			usb_phy_set_event(&ab->phy, USB_EVENT_ENUMERATED);
 		}
 		if (event != UX500_MUSB_RIDC)
 			event = UX500_MUSB_VBUS;
@@ -626,6 +633,7 @@ static int ab8540_usb_link_status_update(struct ab8500_usb *ab,
 		event = UX500_MUSB_CHARGER;
 		atomic_notifier_call_chain(&ab->phy.notifier,
 				event, &ab->vbus_draw);
+		usb_phy_set_event(&ab->phy, USB_EVENT_CHARGER);
 		break;
 
 	case USB_LINK_PHYEN_NO_VBUS_NO_IDGND_8540:
@@ -648,6 +656,7 @@ static int ab8540_usb_link_status_update(struct ab8500_usb *ab,
 			ab->mode = USB_IDLE;
 			ab->phy.otg->default_a = false;
 			ab->vbus_draw = 0;
+		usb_phy_set_event(&ab->phy, USB_EVENT_NONE);
 		}
 		break;
 
@@ -694,6 +703,7 @@ static int ab8505_usb_link_status_update(struct ab8500_usb *ab,
 		 * is connected
 		 */
 		ab->phy.state = OTG_STATE_B_IDLE;
+		usb_phy_set_event(&ab->phy, USB_EVENT_NONE);
 		break;
 
 	case USB_LINK_ACA_RID_C_NM_8505:
@@ -707,6 +717,7 @@ static int ab8505_usb_link_status_update(struct ab8500_usb *ab,
 			ab8500_usb_peri_phy_en(ab);
 			atomic_notifier_call_chain(&ab->phy.notifier,
 					UX500_MUSB_PREPARE, &ab->vbus_draw);
+			usb_phy_set_event(&ab->phy, USB_EVENT_ENUMERATED);
 		}
 		if (event != UX500_MUSB_RIDC)
 			event = UX500_MUSB_VBUS;
@@ -734,6 +745,7 @@ static int ab8505_usb_link_status_update(struct ab8500_usb *ab,
 		event = UX500_MUSB_CHARGER;
 		atomic_notifier_call_chain(&ab->phy.notifier,
 				event, &ab->vbus_draw);
+		usb_phy_set_event(&ab->phy, USB_EVENT_CHARGER);
 		break;
 
 	default:
@@ -777,6 +789,7 @@ static int ab8500_usb_link_status_update(struct ab8500_usb *ab,
 			event = UX500_MUSB_NONE;
 		/* Fallback to default B_IDLE as nothing is connected */
 		ab->phy.state = OTG_STATE_B_IDLE;
+		usb_phy_set_event(&ab->phy, USB_EVENT_NONE);
 		break;
 
 	case USB_LINK_ACA_RID_C_NM_8500:
@@ -794,6 +807,7 @@ static int ab8500_usb_link_status_update(struct ab8500_usb *ab,
 			ab8500_usb_peri_phy_en(ab);
 			atomic_notifier_call_chain(&ab->phy.notifier,
 					UX500_MUSB_PREPARE, &ab->vbus_draw);
+			usb_phy_set_event(&ab->phy, USB_EVENT_ENUMERATED);
 		}
 		if (event != UX500_MUSB_RIDC)
 			event = UX500_MUSB_VBUS;
@@ -820,6 +834,7 @@ static int ab8500_usb_link_status_update(struct ab8500_usb *ab,
 		event = UX500_MUSB_CHARGER;
 		atomic_notifier_call_chain(&ab->phy.notifier,
 				event, &ab->vbus_draw);
+		usb_phy_set_event(&ab->phy, USB_EVENT_CHARGER);
 		break;
 
 	case USB_LINK_RESERVED_8500:
diff --git a/drivers/usb/phy/phy-gpio-vbus-usb.c b/drivers/usb/phy/phy-gpio-vbus-usb.c
index f4b14bd..840dc2b 100644
--- a/drivers/usb/phy/phy-gpio-vbus-usb.c
+++ b/drivers/usb/phy/phy-gpio-vbus-usb.c
@@ -134,6 +134,7 @@ static void gpio_vbus_work(struct work_struct *work)
 
 		atomic_notifier_call_chain(&gpio_vbus->phy.notifier,
 					   status, gpio_vbus->phy.otg->gadget);
+		usb_phy_set_event(&gpio_vbus->phy, USB_EVENT_ENUMERATED);
 	} else {
 		/* optionally disable D+ pullup */
 		if (gpio_is_valid(gpio))
@@ -148,6 +149,7 @@ static void gpio_vbus_work(struct work_struct *work)
 
 		atomic_notifier_call_chain(&gpio_vbus->phy.notifier,
 					   status, gpio_vbus->phy.otg->gadget);
+		usb_phy_set_event(&gpio_vbus->phy, USB_EVENT_NONE);
 	}
 }
 
diff --git a/drivers/usb/phy/phy-mv-usb.c b/drivers/usb/phy/phy-mv-usb.c
index 7d80c54..8ed9f95 100644
--- a/drivers/usb/phy/phy-mv-usb.c
+++ b/drivers/usb/phy/phy-mv-usb.c
@@ -441,10 +441,12 @@ run:
 				mv_otg_start_periphrals(mvotg, 0);
 			mv_otg_reset(mvotg);
 			mv_otg_disable(mvotg);
+			usb_phy_set_event(&mvotg->phy, USB_EVENT_NONE);
 			break;
 		case OTG_STATE_B_PERIPHERAL:
 			mv_otg_enable(mvotg);
 			mv_otg_start_periphrals(mvotg, 1);
+			usb_phy_set_event(&mvotg->phy, USB_EVENT_ENUMERATED);
 			break;
 		case OTG_STATE_A_IDLE:
 			otg->default_a = 1;
diff --git a/drivers/usb/phy/phy-tahvo.c b/drivers/usb/phy/phy-tahvo.c
index cc61ee4..5551ef0 100644
--- a/drivers/usb/phy/phy-tahvo.c
+++ b/drivers/usb/phy/phy-tahvo.c
@@ -87,6 +87,7 @@ static void check_vbus_state(struct tahvo_usb *tu)
 			if (tu->phy.otg->gadget)
 				usb_gadget_vbus_connect(tu->phy.otg->gadget);
 			tu->phy.state = OTG_STATE_B_PERIPHERAL;
+			usb_phy_set_event(&tu->phy, USB_EVENT_ENUMERATED);
 			break;
 		case OTG_STATE_A_IDLE:
 			/*
@@ -105,6 +106,7 @@ static void check_vbus_state(struct tahvo_usb *tu)
 			if (tu->phy.otg->gadget)
 				usb_gadget_vbus_disconnect(tu->phy.otg->gadget);
 			tu->phy.state = OTG_STATE_B_IDLE;
+			usb_phy_set_event(&tu->phy, USB_EVENT_NONE);
 			break;
 		case OTG_STATE_A_HOST:
 			tu->phy.state = OTG_STATE_A_IDLE;
-- 
1.8.2.1


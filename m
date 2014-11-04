Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaKDKCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:02:16 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53300 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbaKDKCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:02:11 -0500
From: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Todd Poynor <toddpoynor@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Benoit Goby <benoit@android.com>,
        Kiran Raparthy <kiran.kumar@linaro.org>
Subject: [RFC v5] usb: phy: Hold wakeupsource when USB is enumerated in peripheral mode
Date: Tue,  4 Nov 2014 15:30:54 +0530
Message-Id: <1415095254-24683-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=yes
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Todd Poynor <toddpoynor@google.com>

usb: phy: Hold wakeupsource when USB is enumerated in peripheral mode

Some systems require a mechanism to prevent system to enter into suspend
state when USB is connected and enumerated in peripheral mode.

This patch provides an interface to hold a wakeupsource to prevent suspend.
PHY drivers can use this interface when USB is connected and enumerated in
peripheral mode.

A timed wakeupsource is temporarily held on USB disconnect events, to allow
the rest of the system to react to the USB disconnection (dropping host
sessions, updating charger status, etc.) prior to re-allowing suspend.

Cc: Kishon Vijay Abraham I <kishon@ti.com>
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
v5:
* with the new approach,i was able to chnage only 5 phy drivers
as mentioned below to use the wakeupsource funtionality.

drivers/phy/phy-omap-control.c
drivers/usb/phy/phy-ab8500-usb.c
drivers/usb/phy/phy-tahvo.c
drivers/usb/phy/phy-mv-usb.c
drivers/usb/phy/phy-gpio-vbus-usb.c

* Notification method not used any more.
* introduced usb_phy_set_event in phy.c to hold wakeupsource
* introduced usb_phy_wsource_init/usb_phy_wsource_trash in phy.c to
initialize/relese per-PHY wakeupsource.These interfaces called from
probe/remove functions of phy drivers.
* usb_phy_set_event called from phy drivers where usb enumeration
event is handled.
* usb_phy_set_event expects usb_phy handle where as phy-omap-control.c
 provides its own type(omap_control_phy), so directly called __pm_stay_awake
and  __pm_awake_event from phy-omap-control.c instead of calling
usb_phy_set_event.

v4:
* Temporarily hold wakeupsource patch integrated into main patch.
* As per feedback,dropped "enabled" module parameter.
* Introduced otgws_otg_usb3_notifications function to handle event
  notifications from usb3 phy.
* Handled wakeupsource initialization,spinlock,registration of notifier block
  per-PHY.
* Updated usb_phy structure.

v3:
* As per the feedback,no global phy pointer used.
* called the one-liner wakeupsource handling calls
  directly instead of indirect functions implemented in v2.
* Removed indirect function get_phy_hook and used usb_get_phy
  to get the phy handle..

v2:
* wakeupsource handling implemeted per-PHY
* Implemented wakeupsource handling calls in phy
* included Todd's refactoring logic.

v1:
* changed to "disabled by default" from "enable by default".
* Kconfig help text modified
* Included better commit text
* otgws_nb moved to otg_wakeupsource_init function
* Introduced get_phy_hook to handle otgws_xceiv per-PHY

Initial RFC:
* Included build fix from Benoit Goby and Arve Hjønnevåg
* Removed lock->held field in driver as this mechanism is
  provided in wakeupsource driver.
* wakelock(wl) terminology replaced with wakeup_source(ws).

 drivers/phy/phy-omap-control.c       |  9 ++++++
 drivers/usb/phy/phy-ab8500-usb.c     | 17 +++++++++++
 drivers/usb/phy/phy-gpio-vbus-usb.c  |  4 +++
 drivers/usb/phy/phy-mv-usb.c         |  4 +++
 drivers/usb/phy/phy-tahvo.c          |  5 ++++
 drivers/usb/phy/phy.c                | 56 ++++++++++++++++++++++++++++++++++++
 include/linux/phy/omap_control_phy.h |  4 +++
 include/linux/usb/phy.h              |  8 ++++++
 8 files changed, 107 insertions(+)

diff --git a/drivers/phy/phy-omap-control.c b/drivers/phy/phy-omap-control.c
index 311b4f9..efc629f 100644
--- a/drivers/phy/phy-omap-control.c
+++ b/drivers/phy/phy-omap-control.c
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/clk.h>
+#include <linux/usb/phy.h>
 #include <linux/phy/omap_control_phy.h>
 
 /**
@@ -196,9 +197,12 @@ void omap_control_usb_set_mode(struct device *dev,
 		break;
 	case USB_MODE_DEVICE:
 		omap_control_usb_device_mode(ctrl_phy);
+		__pm_stay_awake(&ctrl_phy->wsource);
 		break;
 	case USB_MODE_DISCONNECT:
 		omap_control_usb_set_sessionend(ctrl_phy);
+		__pm_wakeup_event(&ctrl_phy->wsource,
+				msecs_to_jiffies(TEMPORARY_HOLD_TIME));
 		break;
 	default:
 		dev_vdbg(dev, "invalid omap control usb mode\n");
@@ -246,6 +250,7 @@ static int omap_control_phy_probe(struct platform_device *pdev)
 	struct resource	*res;
 	const struct of_device_id *of_id;
 	struct omap_control_phy *control_phy;
+	char wsource_name[40];
 
 	of_id = of_match_device(of_match_ptr(omap_control_phy_id_table),
 				&pdev->dev);
@@ -290,6 +295,10 @@ static int omap_control_phy_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(control_phy->dev, control_phy);
 
+	snprintf(wsource_name, sizeof(wsource_name), "vbus-%s",
+				dev_name(control_phy->dev));
+	wakeup_source_init(&control_phy->wsource, wsource_name);
+
 	return 0;
 }
 
diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 11ab2c4..5c0548a 100644
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
@@ -1469,6 +1484,7 @@ static int ab8500_usb_probe(struct platform_device *pdev)
 
 	abx500_usb_link_status_update(ab);
 
+	usb_phy_wsource_init(&ab->phy);
 	dev_info(&pdev->dev, "revision 0x%2x driver initialized\n", rev);
 
 	return 0;
@@ -1488,6 +1504,7 @@ static int ab8500_usb_remove(struct platform_device *pdev)
 	else if (ab->mode == USB_PERIPHERAL)
 		ab8500_usb_peri_phy_dis(ab);
 
+	usb_phy_wsource_trash(&ab->phy);
 	return 0;
 }
 
diff --git a/drivers/usb/phy/phy-gpio-vbus-usb.c b/drivers/usb/phy/phy-gpio-vbus-usb.c
index 69462e0..308fbac 100644
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
 
@@ -332,6 +334,7 @@ static int gpio_vbus_probe(struct platform_device *pdev)
 	}
 
 	device_init_wakeup(&pdev->dev, pdata->wakeup);
+	usb_phy_wsource_init(&gpio_vbus->phy);
 
 	return 0;
 }
@@ -340,6 +343,7 @@ static int gpio_vbus_remove(struct platform_device *pdev)
 	device_init_wakeup(&pdev->dev, 0);
 	cancel_delayed_work_sync(&gpio_vbus->work);

 	usb_remove_phy(&gpio_vbus->phy);
+	usb_phy_wsource_trash(&gpio_vbus->phy);
 
 	return 0;
 }
diff --git a/drivers/usb/phy/phy-mv-usb.c b/drivers/usb/phy/phy-mv-usb.c
index 7d80c54..553e3da 100644
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
@@ -668,6 +670,7 @@ static int mv_otg_remove(struct platform_device *pdev)
 	mv_otg_disable(mvotg);
 
 	usb_remove_phy(&mvotg->phy);
+	usb_phy_wsource_trash(&mvotg->phy);
 
 	return 0;
 }
@@ -836,6 +839,7 @@ static int mv_otg_probe(struct platform_device *pdev)
 		spin_unlock(&mvotg->wq_lock);
 	}
 
+	usb_phy_wsource_init(&mvotg->phy);
 	dev_info(&pdev->dev,
 		 "successful probe OTG device %s clock gating.\n",
 		 mvotg->clock_gating ? "with" : "without");
diff --git a/drivers/usb/phy/phy-tahvo.c b/drivers/usb/phy/phy-tahvo.c
index cc61ee4..1e77e6c 100644
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
@@ -412,6 +414,8 @@ static int tahvo_usb_probe(struct platform_device *pdev)
 		goto err_free_irq;
 	}
 
+	usb_phy_wsource_init(&tu->phy);
+
 	return 0;
 
 err_free_irq:
@@ -438,6 +442,7 @@ static int tahvo_usb_remove(struct platform_device *pdev)
 	if (!IS_ERR(tu->ick))
 		clk_disable(tu->ick);
 
+	usb_phy_wsource_trash(&tu->phy);
 	return 0;
 }
 
diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index 36b6bce..7abc283 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -441,3 +441,59 @@ int usb_bind_phy(const char *dev_name, u8 index,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(usb_bind_phy);
+
+/**
+ * usb_phy_wsource_init - init wakeupsource
+ * @x: the phy returned by usb_get_phy();
+ *
+ * This initializes per-PHY wakeupsource
+ */
+void usb_phy_wsource_init(struct usb_phy *x)
+{
+	char wsource_name[40];
+
+	snprintf(wsource_name, sizeof(wsource_name), "vbus-%s",
+					dev_name(x->dev));
+	wakeup_source_init(&x->wsource, wsource_name);
+}
+EXPORT_SYMBOL_GPL(usb_phy_wsource_init);
+
+
+/**
+ * usb_phy_wsource_trash - release wakeupsource
+ * @x: the phy returned by usb_get_phy();
+ *
+ * This releases per-PHY wakeupsource
+ */
+void usb_phy_wsource_trash(struct usb_phy *x)
+{
+	wakeup_source_trash(&x->wsource);
+}
+EXPORT_SYMBOL_GPL(usb_phy_wsource_trash);
+
+/**
+ * usb_phy_set_event - hold/temporarily hold wakeupsource
+ * @x: the phy returned by usb_get_phy();
+ *
+ * This holds per-PHY wakeupsource/timed wakeupsource
+ */
+void usb_phy_set_event(struct usb_phy *x, unsigned long event)
+{
+	switch (event) {
+	case USB_EVENT_ENUMERATED:
+		__pm_stay_awake(&x->wsource);
+		break;
+
+	case USB_EVENT_NONE:
+	case USB_EVENT_ID:
+	case USB_EVENT_VBUS:
+	case USB_EVENT_CHARGER:
+		__pm_wakeup_event(&x->wsource,
+			msecs_to_jiffies(TEMPORARY_HOLD_TIME));
+		break;
+
+	default:
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(usb_phy_set_event);
diff --git a/include/linux/phy/omap_control_phy.h b/include/linux/phy/omap_control_phy.h
index 5450403..77eb7da 100644
--- a/include/linux/phy/omap_control_phy.h
+++ b/include/linux/phy/omap_control_phy.h
@@ -16,6 +16,8 @@
  *
  */
 
+#include <linux/device.h>
+
 #ifndef __OMAP_CONTROL_PHY_H__
 #define __OMAP_CONTROL_PHY_H__
 
@@ -37,6 +39,8 @@ struct omap_control_phy {
 	struct clk *sys_clk;
 
 	enum omap_control_phy_type type;
+	/* wakeup source */
+	struct wakeup_source    wsource;
 };
 
 enum omap_control_usb_mode {
diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
index 353053a..110c894 100644
--- a/include/linux/usb/phy.h
+++ b/include/linux/usb/phy.h
@@ -12,6 +12,8 @@
 #include <linux/notifier.h>
 #include <linux/usb.h>
 
+#define TEMPORARY_HOLD_TIME    2000
+
 enum usb_phy_interface {
 	USBPHY_INTERFACE_MODE_UNKNOWN,
 	USBPHY_INTERFACE_MODE_UTMI,
@@ -89,6 +91,9 @@ struct usb_phy {
 	/* for notification of usb_phy_events */
 	struct atomic_notifier_head	notifier;
 
+	/* wakeup source */
+	struct wakeup_source    wsource;
+
 	/* to pass extra port status to the root hub */
 	u16			port_status;
 	u16			port_change;
@@ -210,6 +215,9 @@ extern void usb_put_phy(struct usb_phy *);
 extern void devm_usb_put_phy(struct device *dev, struct usb_phy *x);
 extern int usb_bind_phy(const char *dev_name, u8 index,
 				const char *phy_dev_name);
+void usb_phy_wsource_init(struct usb_phy *x);
+void usb_phy_wsource_trash(struct usb_phy *x);
+void usb_phy_set_event(struct usb_phy *x, unsigned long event);
 #else
 static inline struct usb_phy *usb_get_phy(enum usb_phy_type type)
 {
-- 
1.8.2.1


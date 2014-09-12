Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbaILMWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:22:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbaILMWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:22:41 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Joe Lawrence <joe.lawrence@stratus.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 4/4] usb: hub: rename khubd to hub_wq in documentation and comments
Date: Fri, 12 Sep 2014 14:21:08 +0200
Message-Id: <1410524468-15232-5-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1410524468-15232-1-git-send-email-pmladek@suse.cz>
References: <1410524468-15232-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB hub has started to use a workqueue instead of kthread. Let's update
the documentation and comments here and there.

This patch mostly just replaces "khubd" with "hub_wq". There are only few
exceptions where the whole sentence was updated. These more complicated
changes can be found in the following files:

	   Documentation/usb/hotplug.txt
	   drivers/net/usb/usbnet.c
	   drivers/usb/core/hcd.c
	   drivers/usb/host/ohci-hcd.c
	   drivers/usb/host/xhci.c

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 Documentation/DocBook/usb.tmpl             |  2 +-
 Documentation/usb/WUSB-Design-overview.txt |  6 ++--
 Documentation/usb/hotplug.txt              |  2 +-
 drivers/net/usb/usbnet.c                   | 14 ++++++----
 drivers/usb/README                         |  2 +-
 drivers/usb/core/hcd.c                     | 10 +++----
 drivers/usb/core/hub.c                     | 44 +++++++++++++++---------------
 drivers/usb/host/ehci-fsl.c                |  2 +-
 drivers/usb/host/ehci-hcd.c                |  2 +-
 drivers/usb/host/ehci-hub.c                |  8 +++---
 drivers/usb/host/fhci-hcd.c                |  6 ++--
 drivers/usb/host/fotg210-hcd.c             |  8 +++---
 drivers/usb/host/fusbh200-hcd.c            |  8 +++---
 drivers/usb/host/isp1760-hcd.c             |  6 ++--
 drivers/usb/host/ohci-hcd.c                |  6 ++--
 drivers/usb/host/ohci-hub.c                |  4 +--
 drivers/usb/host/ohci-omap.c               |  2 +-
 drivers/usb/host/oxu210hp-hcd.c            | 10 +++----
 drivers/usb/host/sl811-hcd.c               |  8 +++---
 drivers/usb/host/xhci-hub.c                |  2 +-
 drivers/usb/host/xhci.c                    |  4 +--
 drivers/usb/misc/usbtest.c                 |  2 +-
 drivers/usb/musb/am35x.c                   |  1 +
 drivers/usb/musb/tusb6010.c                |  2 +-
 drivers/usb/phy/phy-fsl-usb.c              |  2 +-
 drivers/usb/phy/phy-isp1301-omap.c         |  2 +-
 drivers/usb/wusbcore/devconnect.c          |  6 ++--
 drivers/usb/wusbcore/wa-hc.h               |  2 +-
 sound/usb/midi.c                           |  2 +-
 29 files changed, 89 insertions(+), 86 deletions(-)

diff --git a/Documentation/DocBook/usb.tmpl b/Documentation/DocBook/usb.tmpl
index 85fc0e28576f..4cd5b2cd0f3d 100644
--- a/Documentation/DocBook/usb.tmpl
+++ b/Documentation/DocBook/usb.tmpl
@@ -593,7 +593,7 @@ for (;;) {
 	    Each device has one control endpoint (endpoint zero)
 	    which supports a limited RPC style RPC access.
 	    Devices are configured
-	    by khubd (in the kernel) setting a device-wide
+	    by hub_wq (in the kernel) setting a device-wide
 	    <emphasis>configuration</emphasis> that affects things
 	    like power consumption and basic functionality.
 	    The endpoints are part of USB <emphasis>interfaces</emphasis>,
diff --git a/Documentation/usb/WUSB-Design-overview.txt b/Documentation/usb/WUSB-Design-overview.txt
index 1cd07c017cf6..9d08f179a7ca 100644
--- a/Documentation/usb/WUSB-Design-overview.txt
+++ b/Documentation/usb/WUSB-Design-overview.txt
@@ -317,7 +317,7 @@ HC picks the /DN_Connect/ out (nep module sends to notif.c for delivery
 into /devconnect/). This process starts the authentication process for
 the device. First we allocate a /fake port/ and assign an
 unauthenticated address (128 to 255--what we really do is
-0x80 | fake_port_idx). We fiddle with the fake port status and /khubd/
+0x80 | fake_port_idx). We fiddle with the fake port status and /hub_wq/
 sees a new connection, so he moves on to enable the fake port with a reset.
 
 So now we are in the reset path -- we know we have a non-yet enumerated
@@ -326,7 +326,7 @@ device with an unauthorized address; we ask user space to authenticate
 exchange (FIXME: not yet done) and issue a /set address 0/ to bring the
 device to the default state. Device is authenticated.
 
-From here, the USB stack takes control through the usb_hcd ops. khubd
+From here, the USB stack takes control through the usb_hcd ops. hub_wq
 has seen the port status changes, as we have been toggling them. It will
 start enumerating and doing transfers through usb_hcd->urb_enqueue() to
 read descriptors and move our data.
@@ -340,7 +340,7 @@ Keep Alive IE; it responds with a /DN_Alive/ pong during the DNTS (this
 arrives to us as a notification through
 devconnect.c:wusb_handle_dn_alive(). If a device times out, we
 disconnect it from the system (cleaning up internal information and
-toggling the bits in the fake hub port, which kicks khubd into removing
+toggling the bits in the fake hub port, which kicks hub_wq into removing
 the rest of the stuff).
 
 This is done through devconnect:__wusb_check_devs(), which will scan the
diff --git a/Documentation/usb/hotplug.txt b/Documentation/usb/hotplug.txt
index a80b0e9a7a0b..5b243f315b2c 100644
--- a/Documentation/usb/hotplug.txt
+++ b/Documentation/usb/hotplug.txt
@@ -58,7 +58,7 @@ USB POLICY AGENT
 
 The USB subsystem currently invokes /sbin/hotplug when USB devices
 are added or removed from system.  The invocation is done by the kernel
-hub daemon thread [khubd], or else as part of root hub initialization
+hub workqueue [hub_wq], or else as part of root hub initialization
 (done by init, modprobe, kapmd, etc).  Its single command line parameter
 is the string "usb", and it passes these environment variables:
 
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 5173821a9575..20615bbd693b 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -69,8 +69,9 @@
 // reawaken network queue this soon after stopping; else watchdog barks
 #define TX_TIMEOUT_JIFFIES	(5*HZ)
 
-// throttle rx/tx briefly after some faults, so khubd might disconnect()
-// us (it polls at HZ/4 usually) before we report too many false errors.
+/* throttle rx/tx briefly after some faults, so hub_wq might disconnect()
+ * us (it polls at HZ/4 usually) before we report too many false errors.
+ */
 #define THROTTLE_JIFFIES	(HZ/8)
 
 // between wakeups
@@ -595,9 +596,9 @@ static void rx_complete (struct urb *urb)
 			  "rx shutdown, code %d\n", urb_status);
 		goto block;
 
-	/* we get controller i/o faults during khubd disconnect() delays.
+	/* we get controller i/o faults during hub_wq disconnect() delays.
 	 * throttle down resubmits, to avoid log floods; just temporarily,
-	 * so we still recover when the fault isn't a khubd delay.
+	 * so we still recover when the fault isn't a hub_wq delay.
 	 */
 	case -EPROTO:
 	case -ETIME:
@@ -1185,8 +1186,9 @@ static void tx_complete (struct urb *urb)
 		case -ESHUTDOWN:		// hardware gone
 			break;
 
-		// like rx, tx gets controller i/o faults during khubd delays
-		// and so it uses the same throttling mechanism.
+		/* like rx, tx gets controller i/o faults during hub_wq
+		 * delays and so it uses the same throttling mechanism.
+		 */
 		case -EPROTO:
 		case -ETIME:
 		case -EILSEQ:
diff --git a/drivers/usb/README b/drivers/usb/README
index 284f46b3e1cc..2144e7dbfa41 100644
--- a/drivers/usb/README
+++ b/drivers/usb/README
@@ -24,7 +24,7 @@ Here is a list of what each subdirectory here is, and what is contained in
 them.
 
 core/		- This is for the core USB host code, including the
-		  usbfs files and the hub class driver ("khubd").
+		  usbfs files and the hub class driver ("hub_wq").
 
 host/		- This is for USB host controller drivers.  This
 		  includes UHCI, OHCI, EHCI, and others that might
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 4bec044a786c..d2607a973a5c 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2301,7 +2301,7 @@ EXPORT_SYMBOL_GPL(usb_hcd_resume_root_hub);
  * Context: in_interrupt()
  *
  * Starts enumeration, with an immediate reset followed later by
- * khubd identifying and possibly configuring the device.
+ * hub_wq identifying and possibly configuring the device.
  * This is needed by OTG controller drivers, where it helps meet
  * HNP protocol timing requirements for starting a port reset.
  *
@@ -2320,7 +2320,7 @@ int usb_bus_start_enum(struct usb_bus *bus, unsigned port_num)
 	if (port_num && hcd->driver->start_port_reset)
 		status = hcd->driver->start_port_reset(hcd, port_num);
 
-	/* run khubd shortly after (first) root port reset finishes;
+	/* allocate hub_wq shortly after (first) root port reset finishes;
 	 * it may issue others, until at least 50 msecs have passed.
 	 */
 	if (status == 0)
@@ -2383,7 +2383,7 @@ void usb_hc_died (struct usb_hcd *hcd)
 	if (hcd->rh_registered) {
 		clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
 
-		/* make khubd clean up old urbs and devices */
+		/* make hub_wq clean up old urbs and devices */
 		usb_set_device_state (hcd->self.root_hub,
 				USB_STATE_NOTATTACHED);
 		usb_kick_hub_wq(hcd->self.root_hub);
@@ -2393,7 +2393,7 @@ void usb_hc_died (struct usb_hcd *hcd)
 		if (hcd->rh_registered) {
 			clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
 
-			/* make khubd clean up old urbs and devices */
+			/* make hub_wq clean up old urbs and devices */
 			usb_set_device_state(hcd->self.root_hub,
 					USB_STATE_NOTATTACHED);
 			usb_kick_hub_wq(hcd->self.root_hub);
@@ -2655,7 +2655,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
 
 	/* HC is in reset state, but accessible.  Now do the one-time init,
-	 * bottom up so that hcds can customize the root hubs before khubd
+	 * bottom up so that hcds can customize the root hubs before hub_wq
 	 * starts talking to them.  (Note, bus id is assigned early too.)
 	 */
 	if ((retval = hcd_buffer_create(hcd)) != 0) {
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index e5883c8e77c7..3457f471df21 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -641,7 +641,7 @@ static void hub_irq(struct urb *urb)
 		hub->error = status;
 		/* FALL THROUGH */
 
-	/* let khubd handle things */
+	/* let hub_wq handle things */
 	case 0:			/* we got data:  port status changed */
 		bits = 0;
 		for (i = 0; i < urb->actual_length; ++i)
@@ -653,7 +653,7 @@ static void hub_irq(struct urb *urb)
 
 	hub->nerrors = 0;
 
-	/* Something happened, let khubd figure it out */
+	/* Something happened, let hub_wq figure it out */
 	kick_hub_wq(hub);
 
 resubmit:
@@ -684,7 +684,7 @@ hub_clear_tt_buffer (struct usb_device *hdev, u16 devinfo, u16 tt)
 }
 
 /*
- * enumeration blocks khubd for a long time. we use keventd instead, since
+ * enumeration blocks hub_wq for a long time. we use keventd instead, since
  * long blocking there is the exception, not the rule.  accordingly, HCDs
  * talking to TTs must queue control transfers (not just bulk and iso), so
  * both can talk to the same hub concurrently.
@@ -950,7 +950,7 @@ static int hub_port_disable(struct usb_hub *hub, int port1, int set_state)
 
 /*
  * Disable a port and mark a logical connect-change event, so that some
- * time later khubd will disconnect() any existing usb_device on the port
+ * time later hub_wq will disconnect() any existing usb_device on the port
  * and will re-enumerate if there actually is a device attached.
  */
 static void hub_port_logical_disconnect(struct usb_hub *hub, int port1)
@@ -963,7 +963,7 @@ static void hub_port_logical_disconnect(struct usb_hub *hub, int port1)
 	 *  - SRP saves power that way
 	 *  - ... new call, TBD ...
 	 * That's easy if this hub can switch power per-port, and
-	 * khubd reactivates the port later (timer, SRP, etc).
+	 * hub_wq reactivates the port later (timer, SRP, etc).
 	 * Powerdown must be optional, because of reset/DFU.
 	 */
 
@@ -976,7 +976,7 @@ static void hub_port_logical_disconnect(struct usb_hub *hub, int port1)
  * @udev: device to be disabled and removed
  * Context: @udev locked, must be able to sleep.
  *
- * After @udev's port has been disabled, khubd is notified and it will
+ * After @udev's port has been disabled, hub_wq is notified and it will
  * see that the device has been disconnected.  When the device is
  * physically unplugged and something is plugged in, the events will
  * be received and processed normally.
@@ -1096,7 +1096,7 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
  init2:
 
 	/*
-	 * Check each port and set hub->change_bits to let khubd know
+	 * Check each port and set hub->change_bits to let hub_wq know
 	 * which ports need attention.
 	 */
 	for (port1 = 1; port1 <= hdev->maxchild; ++port1) {
@@ -1163,7 +1163,7 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 			clear_bit(port1, hub->removed_bits);
 
 		if (!udev || udev->state == USB_STATE_NOTATTACHED) {
-			/* Tell khubd to disconnect the device or
+			/* Tell hub_wq to disconnect the device or
 			 * check for a new connection
 			 */
 			if (udev || (portstatus & USB_PORT_STAT_CONNECTION) ||
@@ -1176,7 +1176,7 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 				USB_SS_PORT_LS_U0;
 			/* The power session apparently survived the resume.
 			 * If there was an overcurrent or suspend change
-			 * (i.e., remote wakeup request), have khubd
+			 * (i.e., remote wakeup request), have hub_wq
 			 * take care of it.  Look at the port link state
 			 * for USB 3.0 hubs, since they don't have a suspend
 			 * change bit, and they don't set the port link change
@@ -1197,7 +1197,7 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 				set_bit(port1, hub->change_bits);
 
 		} else {
-			/* The power session is gone; tell khubd */
+			/* The power session is gone; tell hub_wq */
 			usb_set_device_state(udev, USB_STATE_NOTATTACHED);
 			set_bit(port1, hub->change_bits);
 		}
@@ -1205,10 +1205,10 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 
 	/* If no port-status-change flags were set, we don't need any
 	 * debouncing.  If flags were set we can try to debounce the
-	 * ports all at once right now, instead of letting khubd do them
+	 * ports all at once right now, instead of letting hub_wq do them
 	 * one at a time later on.
 	 *
-	 * If any port-status changes do occur during this delay, khubd
+	 * If any port-status changes do occur during this delay, hub_wq
 	 * will see them later and handle them normally.
 	 */
 	if (need_debounce_delay) {
@@ -1269,7 +1269,7 @@ static void hub_quiesce(struct usb_hub *hub, enum hub_quiescing_type type)
 
 	cancel_delayed_work_sync(&hub->init_work);
 
-	/* khubd and related activity won't re-trigger */
+	/* hub_wq and related activity won't re-trigger */
 	hub->quiescing = 1;
 
 	if (type != HUB_SUSPEND) {
@@ -1280,7 +1280,7 @@ static void hub_quiesce(struct usb_hub *hub, enum hub_quiescing_type type)
 		}
 	}
 
-	/* Stop khubd and related activity */
+	/* Stop hub_wq and related activity */
 	usb_kill_urb(hub->urb);
 	if (hub->has_indicators)
 		cancel_delayed_work_sync(&hub->leds);
@@ -1602,7 +1602,7 @@ static int hub_configure(struct usb_hub *hub,
 	if (ret < 0)
 		goto fail;
 
-	/* Update the HCD's internal representation of this hub before khubd
+	/* Update the HCD's internal representation of this hub before hub_wq
 	 * starts getting port status changes for devices under the hub.
 	 */
 	if (hcd->driver->update_hub_device) {
@@ -2028,7 +2028,7 @@ static void choose_devnum(struct usb_device *udev)
 	int		devnum;
 	struct usb_bus	*bus = udev->bus;
 
-	/* If khubd ever becomes multithreaded, this will need a lock */
+	/* If hub_wq ever becomes multithreaded, this will need a lock */
 	if (udev->wusb) {
 		devnum = udev->portnum + 1;
 		BUG_ON(test_bit(devnum, bus->devmap.devicemap));
@@ -3061,7 +3061,7 @@ static unsigned wakeup_enabled_descendants(struct usb_device *udev)
  * Once VBUS drop breaks the circuit, the port it's using has to go through
  * normal re-enumeration procedures, starting with enabling VBUS power.
  * Other than re-initializing the hub (plug/unplug, except for root hubs),
- * Linux (2.6) currently has NO mechanisms to initiate that:  no khubd
+ * Linux (2.6) currently has NO mechanisms to initiate that:  no hub_wq
  * timer, no SRP, no requests through sysfs.
  *
  * If Runtime PM isn't enabled or used, non-SuperSpeed devices may not get
@@ -3203,7 +3203,7 @@ static int finish_port_resume(struct usb_device *udev)
 	/* usb ch9 identifies four variants of SUSPENDED, based on what
 	 * state the device resumes to.  Linux currently won't see the
 	 * first two on the host side; they'd be inside hub_port_init()
-	 * during many timeouts, but khubd can't suspend until later.
+	 * during many timeouts, but hub_wq can't suspend until later.
 	 */
 	usb_set_device_state(udev, udev->actconfig
 			? USB_STATE_CONFIGURED
@@ -3568,7 +3568,7 @@ static int hub_suspend(struct usb_interface *intf, pm_message_t msg)
 
 	dev_dbg(&intf->dev, "%s\n", __func__);
 
-	/* stop khubd and related activity */
+	/* stop hub_wq and related activity */
 	hub_quiesce(hub, HUB_SUSPEND);
 	return 0;
 }
@@ -4961,10 +4961,10 @@ static void port_event(struct usb_hub *hub, int port1)
 	 * On disconnect USB3 protocol ports transit from U0 to
 	 * SS.Inactive to Rx.Detect. If this happens a warm-
 	 * reset is not needed, but a (re)connect may happen
-	 * before khubd runs and sees the disconnect, and the
+	 * before hub_wq runs and sees the disconnect, and the
 	 * device may be an unknown state.
 	 *
-	 * If the port went through SS.Inactive without khubd
+	 * If the port went through SS.Inactive without hub_wq
 	 * seeing it the C_LINK_STATE change flag will be set,
 	 * and we reset the dev to put it in a known state.
 	 */
@@ -5282,7 +5282,7 @@ static int descriptors_changed(struct usb_device *udev,
  * former operating configuration.  If the reset fails, or the device's
  * descriptors change from their values before the reset, or the original
  * configuration and altsettings cannot be restored, a flag will be set
- * telling khubd to pretend the device has been disconnected and then
+ * telling hub_wq to pretend the device has been disconnected and then
  * re-connected.  All drivers will be unbound, and the device will be
  * re-enumerated and probed all over again.
  *
diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index cf2734b532a7..3d84b6a41dae 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -627,7 +627,7 @@ static int ehci_start_port_reset(struct usb_hcd *hcd, unsigned port)
 	if (!(status & PORT_CONNECT))
 		return -ENODEV;
 
-	/* khubd will finish the reset later */
+	/* hub_wq will finish the reset later */
 	if (ehci_is_TDI(ehci)) {
 		writel(PORT_RESET |
 		       (status & ~(PORT_CSC | PORT_PEC | PORT_OCC)),
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 81cda09b47e3..0ed9b1d5921f 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -788,7 +788,7 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 				continue;
 
 			/* start 20 msec resume signaling from this port,
-			 * and make khubd collect PORT_STAT_C_SUSPEND to
+			 * and make hub_wq collect PORT_STAT_C_SUSPEND to
 			 * stop that signaling.  Use 5 ms extra for safety,
 			 * like usb_port_resume() does.
 			 */
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 6130b7574908..7ccb3ccf8e86 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -656,7 +656,7 @@ ehci_hub_status_data (struct usb_hcd *hcd, char *buf)
 
 		/*
 		 * Return status information even for ports with OWNER set.
-		 * Otherwise khubd wouldn't see the disconnect event when a
+		 * Otherwise hub_wq wouldn't see the disconnect event when a
 		 * high-speed device is switched over to the companion
 		 * controller by the user.
 		 */
@@ -902,7 +902,7 @@ int ehci_hub_control(
 
 		/*
 		 * Even if OWNER is set, so the port is owned by the
-		 * companion controller, khubd needs to be able to clear
+		 * companion controller, hub_wq needs to be able to clear
 		 * the port-change status bits (especially
 		 * USB_PORT_STAT_C_CONNECTION).
 		 */
@@ -1000,7 +1000,7 @@ int ehci_hub_control(
 			 * However, not all EHCI implementations do this
 			 * automatically, even if they _do_ support per-port
 			 * power switching; they're allowed to just limit the
-			 * current.  khubd will turn the power back on.
+			 * current.  hub_wq will turn the power back on.
 			 */
 			if (((temp & PORT_OC) || (ehci->need_oc_pp_cycle))
 					&& HCS_PPC(ehci->hcs_params)) {
@@ -1085,7 +1085,7 @@ int ehci_hub_control(
 		}
 
 		/*
-		 * Even if OWNER is set, there's no harm letting khubd
+		 * Even if OWNER is set, there's no harm letting hub_wq
 		 * see the wPortStatus values (they should all be 0 except
 		 * for PORT_POWER anyway).
 		 */
diff --git a/drivers/usb/host/fhci-hcd.c b/drivers/usb/host/fhci-hcd.c
index 1cf68eaf2ed8..a1a1ef521436 100644
--- a/drivers/usb/host/fhci-hcd.c
+++ b/drivers/usb/host/fhci-hcd.c
@@ -360,12 +360,12 @@ static int fhci_start(struct usb_hcd *hcd)
 	hcd->state = HC_STATE_RUNNING;
 
 	/*
-	 * From here on, khubd concurrently accesses the root
+	 * From here on, hub_wq concurrently accesses the root
 	 * hub; drivers will be talking to enumerated devices.
-	 * (On restart paths, khubd already knows about the root
+	 * (On restart paths, hub_wq already knows about the root
 	 * hub and could find work as soon as we wrote FLAG_CF.)
 	 *
-	 * Before this point the HC was idle/ready.  After, khubd
+	 * Before this point the HC was idle/ready.  After, hub_wq
 	 * and device drivers may start it running.
 	 */
 	fhci_usb_enable(fhci);
diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index adcd2050dced..3de1278677d0 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -1483,7 +1483,7 @@ fotg210_hub_status_data(struct usb_hcd *hcd, char *buf)
 
 	/*
 	 * Return status information even for ports with OWNER set.
-	 * Otherwise khubd wouldn't see the disconnect event when a
+	 * Otherwise hub_wq wouldn't see the disconnect event when a
 	 * high-speed device is switched over to the companion
 	 * controller by the user.
 	 */
@@ -1572,7 +1572,7 @@ static int fotg210_hub_control(
 
 		/*
 		 * Even if OWNER is set, so the port is owned by the
-		 * companion controller, khubd needs to be able to clear
+		 * companion controller, hub_wq needs to be able to clear
 		 * the port-change status bits (especially
 		 * USB_PORT_STAT_C_CONNECTION).
 		 */
@@ -1723,7 +1723,7 @@ static int fotg210_hub_control(
 		}
 
 		/*
-		 * Even if OWNER is set, there's no harm letting khubd
+		 * Even if OWNER is set, there's no harm letting hub_wq
 		 * see the wPortStatus values (they should all be 0 except
 		 * for PORT_POWER anyway).
 		 */
@@ -5445,7 +5445,7 @@ static irqreturn_t fotg210_irq(struct usb_hcd *hcd)
 				fotg210->reset_done[0] == 0) {
 
 			/* start 20 msec resume signaling from this port,
-			 * and make khubd collect PORT_STAT_C_SUSPEND to
+			 * and make hub_wq collect PORT_STAT_C_SUSPEND to
 			 * stop that signaling.  Use 5 ms extra for safety,
 			 * like usb_port_resume() does.
 			 */
diff --git a/drivers/usb/host/fusbh200-hcd.c b/drivers/usb/host/fusbh200-hcd.c
index ba9499060f63..abe42f31559f 100644
--- a/drivers/usb/host/fusbh200-hcd.c
+++ b/drivers/usb/host/fusbh200-hcd.c
@@ -1441,7 +1441,7 @@ fusbh200_hub_status_data (struct usb_hcd *hcd, char *buf)
 
 	/*
 	 * Return status information even for ports with OWNER set.
-	 * Otherwise khubd wouldn't see the disconnect event when a
+	 * Otherwise hub_wq wouldn't see the disconnect event when a
 	 * high-speed device is switched over to the companion
 	 * controller by the user.
 	 */
@@ -1530,7 +1530,7 @@ static int fusbh200_hub_control (
 
 		/*
 		 * Even if OWNER is set, so the port is owned by the
-		 * companion controller, khubd needs to be able to clear
+		 * companion controller, hub_wq needs to be able to clear
 		 * the port-change status bits (especially
 		 * USB_PORT_STAT_C_CONNECTION).
 		 */
@@ -1678,7 +1678,7 @@ static int fusbh200_hub_control (
 		}
 
 		/*
-		 * Even if OWNER is set, there's no harm letting khubd
+		 * Even if OWNER is set, there's no harm letting hub_wq
 		 * see the wPortStatus values (they should all be 0 except
 		 * for PORT_POWER anyway).
 		 */
@@ -5355,7 +5355,7 @@ static irqreturn_t fusbh200_irq (struct usb_hcd *hcd)
 				fusbh200->reset_done[0] == 0) {
 
 			/* start 20 msec resume signaling from this port,
-			 * and make khubd collect PORT_STAT_C_SUSPEND to
+			 * and make hub_wq collect PORT_STAT_C_SUSPEND to
 			 * stop that signaling.  Use 5 ms extra for safety,
 			 * like usb_port_resume() does.
 			 */
diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
index 51a0ae9cdd1d..e752c3098f38 100644
--- a/drivers/usb/host/isp1760-hcd.c
+++ b/drivers/usb/host/isp1760-hcd.c
@@ -1760,7 +1760,7 @@ static int isp1760_hub_status_data(struct usb_hcd *hcd, char *buf)
 
 	/*
 	 * Return status information even for ports with OWNER set.
-	 * Otherwise khubd wouldn't see the disconnect event when a
+	 * Otherwise hub_wq wouldn't see the disconnect event when a
 	 * high-speed device is switched over to the companion
 	 * controller by the user.
 	 */
@@ -1871,7 +1871,7 @@ static int isp1760_hub_control(struct usb_hcd *hcd, u16 typeReq,
 
 		/*
 		 * Even if OWNER is set, so the port is owned by the
-		 * companion controller, khubd needs to be able to clear
+		 * companion controller, hub_wq needs to be able to clear
 		 * the port-change status bits (especially
 		 * USB_PORT_STAT_C_CONNECTION).
 		 */
@@ -2000,7 +2000,7 @@ static int isp1760_hub_control(struct usb_hcd *hcd, u16 typeReq,
 					reg_read32(hcd->regs, HC_PORTSC1));
 		}
 		/*
-		 * Even if OWNER is set, there's no harm letting khubd
+		 * Even if OWNER is set, there's no harm letting hub_wq
 		 * see the wPortStatus values (they should all be 0 except
 		 * for PORT_POWER anyway).
 		 */
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 46987735a2e3..d664edabf14e 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -632,7 +632,7 @@ retry:
 		return -EOVERFLOW;
 	}
 
-	/* use rhsc irqs after khubd is fully initialized */
+	/* use rhsc irqs after hub_wq is allocated */
 	set_bit(HCD_FLAG_POLL_RH, &hcd->flags);
 	hcd->uses_new_polling = 1;
 
@@ -909,8 +909,8 @@ static irqreturn_t ohci_irq (struct usb_hcd *hcd)
 		 * choices for RHSC.  Many followed the spec; RHSC triggers
 		 * on an edge, like setting and maybe clearing a port status
 		 * change bit.  With others it's level-triggered, active
-		 * until khubd clears all the port status change bits.  We'll
-		 * always disable it here and rely on polling until khubd
+		 * until hub_wq clears all the port status change bits.  We'll
+		 * always disable it here and rely on polling until hub_wq
 		 * re-enables it.
 		 */
 		ohci_writel(ohci, OHCI_INTR_RHSC, &regs->intrdisable);
diff --git a/drivers/usb/host/ohci-hub.c b/drivers/usb/host/ohci-hub.c
index 17d32b0ea565..0aa17c937115 100644
--- a/drivers/usb/host/ohci-hub.c
+++ b/drivers/usb/host/ohci-hub.c
@@ -585,7 +585,7 @@ static int ohci_start_port_reset (struct usb_hcd *hcd, unsigned port)
 	if (!(status & RH_PS_CCS))
 		return -ENODEV;
 
-	/* khubd will finish the reset later */
+	/* hub_wq will finish the reset later */
 	ohci_writel(ohci, RH_PS_PRS, &ohci->regs->roothub.portstatus [port]);
 	return 0;
 }
@@ -610,7 +610,7 @@ static int ohci_start_port_reset (struct usb_hcd *hcd, unsigned port)
 /* wrap-aware logic morphed from <linux/jiffies.h> */
 #define tick_before(t1,t2) ((s16)(((s16)(t1))-((s16)(t2))) < 0)
 
-/* called from some task, normally khubd */
+/* called from some task, normally hub_wq */
 static inline int root_port_reset (struct ohci_hcd *ohci, unsigned port)
 {
 	__hc32 __iomem *portstat = &ohci->regs->roothub.portstatus [port];
diff --git a/drivers/usb/host/ohci-omap.c b/drivers/usb/host/ohci-omap.c
index c923cafcaca7..de9428362503 100644
--- a/drivers/usb/host/ohci-omap.c
+++ b/drivers/usb/host/ohci-omap.c
@@ -283,7 +283,7 @@ static int ohci_omap_reset(struct usb_hcd *hcd)
 		ohci_to_hcd(ohci)->power_budget = 0;
 	}
 
-	/* FIXME khubd hub requests should manage power switching */
+	/* FIXME hub_wq hub requests should manage power switching */
 	omap_ohci_transceiver_power(1);
 
 	/* board init will have already handled HMC and mux setup.
diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index da5fb0e3c363..4fe79a2d71a9 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -2046,7 +2046,7 @@ static void intr_deschedule(struct oxu_hcd *oxu, struct ehci_qh *qh)
 
 	/* simple/paranoid:  always delay, expecting the HC needs to read
 	 * qh->hw_next or finish a writeback after SPLIT/CSPLIT ... and
-	 * expect khubd to clean up after any CSPLITs we won't issue.
+	 * expect hub_wq to clean up after any CSPLITs we won't issue.
 	 * active high speed queues may need bigger delays...
 	 */
 	if (list_empty(&qh->qtd_list)
@@ -2501,7 +2501,7 @@ static irqreturn_t oxu210_hcd_irq(struct usb_hcd *hcd)
 				continue;
 
 			/* start 20 msec resume signaling from this port,
-			 * and make khubd collect PORT_STAT_C_SUSPEND to
+			 * and make hub_wq collect PORT_STAT_C_SUSPEND to
 			 * stop that signaling.
 			 */
 			oxu->reset_done[i] = jiffies + msecs_to_jiffies(20);
@@ -3119,7 +3119,7 @@ static int oxu_hub_status_data(struct usb_hcd *hcd, char *buf)
 
 		/*
 		 * Return status information even for ports with OWNER set.
-		 * Otherwise khubd wouldn't see the disconnect event when a
+		 * Otherwise hub_wq wouldn't see the disconnect event when a
 		 * high-speed device is switched over to the companion
 		 * controller by the user.
 		 */
@@ -3194,7 +3194,7 @@ static int oxu_hub_control(struct usb_hcd *hcd, u16 typeReq,
 
 		/*
 		 * Even if OWNER is set, so the port is owned by the
-		 * companion controller, khubd needs to be able to clear
+		 * companion controller, hub_wq needs to be able to clear
 		 * the port-change status bits (especially
 		 * USB_PORT_STAT_C_CONNECTION).
 		 */
@@ -3336,7 +3336,7 @@ static int oxu_hub_control(struct usb_hcd *hcd, u16 typeReq,
 		}
 
 		/*
-		 * Even if OWNER is set, there's no harm letting khubd
+		 * Even if OWNER is set, there's no harm letting hub_wq
 		 * see the wPortStatus values (they should all be 0 except
 		 * for PORT_POWER anyway).
 		 */
diff --git a/drivers/usb/host/sl811-hcd.c b/drivers/usb/host/sl811-hcd.c
index a517151867af..ad0c348e68e9 100644
--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -674,7 +674,7 @@ retry:
 			sl811->next_periodic = sl811->periodic[index];
 	}
 
-	/* khubd manages debouncing and wakeup */
+	/* hub_wq manages debouncing and wakeup */
 	if (irqstat & SL11H_INTMASK_INSRMV) {
 		sl811->stat_insrmv++;
 
@@ -714,7 +714,7 @@ retry:
 #endif
 
 		/* port status seems weird until after reset, so
-		 * force the reset and make khubd clean up later.
+		 * force the reset and make hub_wq clean up later.
 		 */
 		if (irqstat & SL11H_INTMASK_RD)
 			sl811->port1 &= ~USB_PORT_STAT_CONNECTION;
@@ -1079,7 +1079,7 @@ sl811h_hub_status_data(struct usb_hcd *hcd, char *buf)
 	if (!(sl811->port1 & (0xffff << 16)))
 		return 0;
 
-	/* tell khubd port 1 changed */
+	/* tell hub_wq port 1 changed */
 	*buf = (1 << 1);
 	return 1;
 }
@@ -1196,7 +1196,7 @@ sl811h_timer(unsigned long _sl811)
 		sl811_write(sl811, SL811_EP_A(SL11H_HOSTCTLREG),
 				SL11H_HCTLMASK_ARM);
 
-		/* khubd provides debounce delay */
+		/* hub_wq provides debounce delay */
 	} else {
 		sl811->ctrl1 = 0;
 	}
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 69aece31143a..0cf49ffa902e 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -892,7 +892,7 @@ int xhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			/*
 			 * Turn on ports, even if there isn't per-port switching.
 			 * HC will report connect events even before this is set.
-			 * However, khubd will ignore the roothub events until
+			 * However, hub_wq will ignore the roothub events until
 			 * the roothub is registered.
 			 */
 			writel(temp | PORT_POWER, port_array[wIndex]);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index c020b094fe7d..4b0dbafad28f 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3761,8 +3761,8 @@ disable_slot:
 /*
  * Issue an Address Device command and optionally send a corresponding
  * SetAddress request to the device.
- * We should be protected by the usb_address0_mutex in khubd's hub_port_init, so
- * we should only issue and wait on one address command at the same time.
+ * We should be protected by the usb_address0_mutex in hub_wq's hub_port_init,
+ * so we should only issue and wait on one address command at the same time.
  */
 static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
 			     enum xhci_setup_dev setup)
diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 90e6644dc886..0bbafe795a72 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -2031,7 +2031,7 @@ static int test_unaligned_bulk(
  *
  * WARNING:  Because usbfs grabs udev->dev.sem before calling this ioctl(),
  * it locks out usbcore in certain code paths.  Notably, if you disconnect
- * the device-under-test, khubd will wait block forever waiting for the
+ * the device-under-test, hub_wq will wait block forever waiting for the
  * ioctl to complete ... so that usb_disconnect() can abort the pending
  * urbs and then call usbtest_disconnect().  To abort a test, you're best
  * off just killing the userspace task and waiting for it to exit.
diff --git a/drivers/usb/musb/am35x.c b/drivers/usb/musb/am35x.c
index 0a34dd859555..a2735df24cc6 100644
--- a/drivers/usb/musb/am35x.c
+++ b/drivers/usb/musb/am35x.c
@@ -1,3 +1,4 @@
+
 /*
  * Texas Instruments AM35x "glue layer"
  *
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 7dfc6cb732c9..2daa779f1382 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -433,7 +433,7 @@ static void musb_do_idle(unsigned long _musb)
 	if (!musb->is_active) {
 		u32	wakeups;
 
-		/* wait until khubd handles port change status */
+		/* wait until hub_wq handles port change status */
 		if (is_host_active(musb) && (musb->port1_status >> 16))
 			goto done;
 
diff --git a/drivers/usb/phy/phy-fsl-usb.c b/drivers/usb/phy/phy-fsl-usb.c
index 2b0f968d9325..f1ea5990a50a 100644
--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -609,7 +609,7 @@ static int fsl_otg_set_host(struct usb_otg *otg, struct usb_bus *host)
 		otg->host->otg_port = fsl_otg_initdata.otg_port;
 		otg->host->is_b_host = otg_dev->fsm.id;
 		/*
-		 * must leave time for khubd to finish its thing
+		 * must leave time for hub_wq to finish its thing
 		 * before yanking the host driver out from under it,
 		 * so suspend the host after a short delay.
 		 */
diff --git a/drivers/usb/phy/phy-isp1301-omap.c b/drivers/usb/phy/phy-isp1301-omap.c
index 69e49be8866b..8eea56d3ded6 100644
--- a/drivers/usb/phy/phy-isp1301-omap.c
+++ b/drivers/usb/phy/phy-isp1301-omap.c
@@ -1011,7 +1011,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 				break;
 			case OTG_STATE_A_WAIT_VFALL:
 				state = OTG_STATE_A_IDLE;
-				/* khubd may take a while to notice and
+				/* hub_wq may take a while to notice and
 				 * handle this disconnect, so don't go
 				 * to B_IDLE quite yet.
 				 */
diff --git a/drivers/usb/wusbcore/devconnect.c b/drivers/usb/wusbcore/devconnect.c
index 0677139c6065..3f4f5fbded55 100644
--- a/drivers/usb/wusbcore/devconnect.c
+++ b/drivers/usb/wusbcore/devconnect.c
@@ -329,7 +329,7 @@ void wusbhc_devconnect_ack(struct wusbhc *wusbhc, struct wusb_dn_connect *dnc,
 	port->wusb_dev = wusb_dev;
 	port->status |= USB_PORT_STAT_CONNECTION;
 	port->change |= USB_PORT_STAT_C_CONNECTION;
-	/* Now the port status changed to connected; khubd will
+	/* Now the port status changed to connected; hub_wq will
 	 * pick the change up and try to reset the port to bring it to
 	 * the enabled state--so this process returns up to the stack
 	 * and it calls back into wusbhc_rh_port_reset().
@@ -343,7 +343,7 @@ error_unlock:
 /*
  * Disconnect a Wireless USB device from its fake port
  *
- * Marks the port as disconnected so that khubd can pick up the change
+ * Marks the port as disconnected so that hub_wq can pick up the change
  * and drops our knowledge about the device.
  *
  * Assumes there is a device connected
@@ -379,7 +379,7 @@ static void __wusbhc_dev_disconnect(struct wusbhc *wusbhc,
 		wusbhc_gtk_rekey(wusbhc);
 
 	/* The Wireless USB part has forgotten about the device already; now
-	 * khubd's timer will pick up the disconnection and remove the USB
+	 * hub_wq's timer will pick up the disconnection and remove the USB
 	 * device from the system
 	 */
 }
diff --git a/drivers/usb/wusbcore/wa-hc.h b/drivers/usb/wusbcore/wa-hc.h
index f2a8d29e17b9..edc7267157f3 100644
--- a/drivers/usb/wusbcore/wa-hc.h
+++ b/drivers/usb/wusbcore/wa-hc.h
@@ -64,7 +64,7 @@
  *
  * Note much of the activity is difficult to follow. For example a
  * device connect goes to devconnect, which will cause the "fake" root
- * hub port to show a connect and stop there. Then khubd will notice
+ * hub port to show a connect and stop there. Then hub_wq will notice
  * and call into the rh.c:hwahc_rc_port_reset() code to authenticate
  * the device (and this might require user intervention) and enable
  * the port.
diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 69e93a9d486a..d3d49525a16b 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -64,7 +64,7 @@
 /* #define DUMP_PACKETS */
 
 /*
- * how long to wait after some USB errors, so that khubd can disconnect() us
+ * how long to wait after some USB errors, so that hub_wq can disconnect() us
  * without too many spurious errors
  */
 #define ERROR_DELAY_JIFFIES (HZ / 10)
-- 
1.8.4


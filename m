Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3G3Mcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:32:36 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:14116 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab3G3McE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:32:04 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH] staging: ozwpan: High resolution timers
Date: Tue, 30 Jul 2013 13:31:50 +0100
Message-ID: <1375187510-28042-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation assumes HZ = 1000 for calculating
all internal timer intervals, which creates problem on
platforms where HZ != 1000.

As well we need resolution of less than 10 mSec for heartbeat
calculation, this creates problem on some platforms where HZ is
configured as HZ = 100, or around, which restricts us to timer interval
of 10 mSec. This is particularly found on embedded devices.

This patch moves on to use high resolution timers to calculate
all timer intervals as it allows us to have very small resolution
of timer interval, removing dependency on HZ.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c         |   91 ++++-----
 drivers/staging/ozwpan/ozpd.c          |   31 ++-
 drivers/staging/ozwpan/ozpd.h          |   18 +-
 drivers/staging/ozwpan/ozproto.c       |  329 +++++++++-----------------------
 drivers/staging/ozwpan/ozproto.h       |   24 +--
 drivers/staging/ozwpan/ozurbparanoia.c |    5 +-
 drivers/staging/ozwpan/ozusbsvc.c      |   14 +-
 7 files changed, 188 insertions(+), 324 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index 6b16bfc..f81a0c5 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -26,7 +26,6 @@
  */
 #include <linux/platform_device.h>
 #include <linux/usb.h>
-#include <linux/jiffies.h>
 #include <linux/slab.h>
 #include <linux/export.h>
 #include "linux/usb/hcd.h"
@@ -49,6 +48,9 @@
 /* Get endpoint object from the containing link.
  */
 #define ep_from_link(__e) container_of((__e), struct oz_endpoint, link)
+/*EP0 timeout before ep0 request is again added to TX queue. (13*8 = 98mSec)
+ */
+#define EP0_TIMEOUT_COUNTER 13
 /*------------------------------------------------------------------------------
  * Used to link urbs together and also store some status information for each
  * urb.
@@ -60,7 +62,7 @@ struct oz_urb_link {
 	struct oz_port *port;
 	u8 req_id;
 	u8 ep_num;
-	unsigned long submit_jiffies;
+	unsigned submit_counter;
 };
 
 /* Holds state information about a USB endpoint.
@@ -69,7 +71,7 @@ struct oz_endpoint {
 	struct list_head urb_list;	/* List of oz_urb_link items. */
 	struct list_head link;		/* For isoc ep, links in to isoc
 					   lists of oz_port. */
-	unsigned long last_jiffies;
+	struct timespec timestamp;
 	int credit;
 	int credit_ceiling;
 	u8 ep_num;
@@ -187,6 +189,7 @@ static DEFINE_SPINLOCK(g_tasklet_lock);
 static struct tasklet_struct g_urb_process_tasklet;
 static struct tasklet_struct g_urb_cancel_tasklet;
 static atomic_t g_pending_urbs = ATOMIC_INIT(0);
+static atomic_t g_usb_frame_number = ATOMIC_INIT(0);
 static const struct hc_driver g_oz_hc_drv = {
 	.description =		g_hcd_name,
 	.product_desc =		"Ozmo Devices WPAN",
@@ -344,7 +347,7 @@ static struct oz_urb_link *oz_uncancel_urb(struct oz_hcd *ozhcd, struct urb *urb
  * Context: softirq or process
  */
 static void oz_complete_urb(struct usb_hcd *hcd, struct urb *urb,
-		int status, unsigned long submit_jiffies)
+		int status)
 {
 	struct oz_hcd *ozhcd = oz_hcd_private(hcd);
 	unsigned long irq_state;
@@ -372,12 +375,7 @@ static void oz_complete_urb(struct usb_hcd *hcd, struct urb *urb,
 	if (oz_forget_urb(urb)) {
 		oz_dbg(ON, "ERROR Unknown URB %p\n", urb);
 	} else {
-		static unsigned long last_time;
 		atomic_dec(&g_pending_urbs);
-		oz_dbg(URB, "%lu: giveback_urb(%p,%x) %lu %lu pending:%d\n",
-		       jiffies, urb, status, jiffies-submit_jiffies,
-		       jiffies-last_time, atomic_read(&g_pending_urbs));
-		last_time = jiffies;
 		usb_hcd_giveback_urb(hcd, urb, status);
 	}
 	spin_lock(&g_tasklet_lock);
@@ -445,7 +443,7 @@ static void oz_complete_buffered_urb(struct oz_port *port,
 	ep->buffered_units--;
 	oz_dbg(ON, "Trying to give back buffered frame of size=%d\n",
 	       available_space);
-	oz_complete_urb(port->ozhcd->hcd, urb, 0, 0);
+	oz_complete_urb(port->ozhcd->hcd, urb, 0);
 }
 
 /*------------------------------------------------------------------------------
@@ -464,7 +462,7 @@ static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 	urbl = oz_alloc_urb_link();
 	if (!urbl)
 		return -ENOMEM;
-	urbl->submit_jiffies = jiffies;
+	urbl->submit_counter = 0;
 	urbl->urb = urb;
 	urbl->req_id = req_id;
 	urbl->ep_num = ep_addr;
@@ -478,7 +476,7 @@ static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 	if (urb->unlinked) {
 		spin_unlock_bh(&port->ozhcd->hcd_lock);
 		oz_dbg(ON, "urb %p unlinked so complete immediately\n", urb);
-		oz_complete_urb(port->ozhcd->hcd, urb, 0, 0);
+		oz_complete_urb(port->ozhcd->hcd, urb, 0);
 		oz_free_urb_link(urbl);
 		return 0;
 	}
@@ -501,7 +499,7 @@ static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 	if (ep && port->hpd) {
 		list_add_tail(&urbl->link, &ep->urb_list);
 		if (!in_dir && ep_addr && (ep->credit < 0)) {
-			ep->last_jiffies = jiffies;
+			getrawmonotonic(&ep->timestamp);
 			ep->credit = 0;
 		}
 	} else {
@@ -790,7 +788,7 @@ void oz_hcd_get_desc_cnf(void *hport, u8 req_id, int status, const u8 *desc,
 		}
 	}
 	urb->actual_length = total_size;
-	oz_complete_urb(port->ozhcd->hcd, urb, 0, 0);
+	oz_complete_urb(port->ozhcd->hcd, urb, 0);
 }
 /*------------------------------------------------------------------------------
  * Context: softirq
@@ -852,7 +850,7 @@ static void oz_hcd_complete_set_config(struct oz_port *port, struct urb *urb,
 	} else {
 		rc = -ENOMEM;
 	}
-	oz_complete_urb(hcd, urb, rc, 0);
+	oz_complete_urb(hcd, urb, rc);
 }
 /*------------------------------------------------------------------------------
  * Context: softirq
@@ -877,7 +875,7 @@ static void oz_hcd_complete_set_interface(struct oz_port *port, struct urb *urb,
 	} else {
 		rc = -ENOMEM;
 	}
-	oz_complete_urb(hcd, urb, rc, 0);
+	oz_complete_urb(hcd, urb, rc);
 }
 /*------------------------------------------------------------------------------
  * Context: softirq
@@ -914,7 +912,7 @@ void oz_hcd_control_cnf(void *hport, u8 req_id, u8 rcode, const u8 *data,
 				(u8)windex, (u8)wvalue);
 			break;
 		default:
-			oz_complete_urb(hcd, urb, 0, 0);
+			oz_complete_urb(hcd, urb, 0);
 		}
 
 	} else {
@@ -928,7 +926,7 @@ void oz_hcd_control_cnf(void *hport, u8 req_id, u8 rcode, const u8 *data,
 			memcpy(urb->transfer_buffer, data, copy_len);
 			urb->actual_length = copy_len;
 		}
-		oz_complete_urb(hcd, urb, 0, 0);
+		oz_complete_urb(hcd, urb, 0);
 	}
 }
 /*------------------------------------------------------------------------------
@@ -998,7 +996,7 @@ void oz_hcd_data_ind(void *hport, u8 endpoint, const u8 *data, int data_len)
 				copy_len = urb->transfer_buffer_length;
 			memcpy(urb->transfer_buffer, data, copy_len);
 			urb->actual_length = copy_len;
-			oz_complete_urb(port->ozhcd->hcd, urb, 0, 0);
+			oz_complete_urb(port->ozhcd->hcd, urb, 0);
 			return;
 		} else {
 			oz_dbg(ON, "buffering frame as URB is not available\n");
@@ -1017,7 +1015,7 @@ done:
  */
 static inline int oz_usb_get_frame_number(void)
 {
-	return jiffies_to_msecs(get_jiffies_64());
+	return atomic_inc_return(&g_usb_frame_number);
 }
 /*------------------------------------------------------------------------------
  * Context: softirq
@@ -1033,7 +1031,8 @@ int oz_hcd_heartbeat(void *hport)
 	struct list_head *n;
 	struct urb *urb;
 	struct oz_endpoint *ep;
-	unsigned long now = jiffies;
+	struct timespec ts, delta;
+	getrawmonotonic(&ts);
 	INIT_LIST_HEAD(&xfr_list);
 	/* Check the OUT isoc endpoints to see if any URB data can be sent.
 	 */
@@ -1042,10 +1041,11 @@ int oz_hcd_heartbeat(void *hport)
 		ep = ep_from_link(e);
 		if (ep->credit < 0)
 			continue;
-		ep->credit += jiffies_to_msecs(now - ep->last_jiffies);
+		delta = timespec_sub(ts, ep->timestamp);
+		ep->credit += timespec_to_ns(&delta) / NSEC_PER_MSEC;
 		if (ep->credit > ep->credit_ceiling)
 			ep->credit = ep->credit_ceiling;
-		ep->last_jiffies = now;
+		ep->timestamp = ts;
 		while (ep->credit && !list_empty(&ep->urb_list)) {
 			urbl = list_first_entry(&ep->urb_list,
 				struct oz_urb_link, link);
@@ -1053,6 +1053,8 @@ int oz_hcd_heartbeat(void *hport)
 			if ((ep->credit + 1) < urb->number_of_packets)
 				break;
 			ep->credit -= urb->number_of_packets;
+			if (ep->credit < 0)
+				ep->credit = 0;
 			list_move_tail(&urbl->link, &xfr_list);
 		}
 	}
@@ -1060,16 +1062,14 @@ int oz_hcd_heartbeat(void *hport)
 	/* Send to PD and complete URBs.
 	 */
 	list_for_each_safe(e, n, &xfr_list) {
-		unsigned long t;
 		urbl = container_of(e, struct oz_urb_link, link);
 		urb = urbl->urb;
-		t = urbl->submit_jiffies;
 		list_del_init(e);
 		urb->error_count = 0;
 		urb->start_frame = oz_usb_get_frame_number();
 		oz_usb_send_isoc(port->hpd, urbl->ep_num, urb);
 		oz_free_urb_link(urbl);
-		oz_complete_urb(port->ozhcd->hcd, urb, 0, t);
+		oz_complete_urb(port->ozhcd->hcd, urb, 0);
 	}
 	/* Check the IN isoc endpoints to see if any URBs can be completed.
 	 */
@@ -1080,13 +1080,14 @@ int oz_hcd_heartbeat(void *hport)
 			if (ep->buffered_units >= OZ_IN_BUFFERING_UNITS) {
 				ep->flags &= ~OZ_F_EP_BUFFERING;
 				ep->credit = 0;
-				ep->last_jiffies = now;
+				ep->timestamp = ts;
 				ep->start_frame = 0;
 			}
 			continue;
 		}
-		ep->credit += jiffies_to_msecs(now - ep->last_jiffies);
-		ep->last_jiffies = now;
+		delta = timespec_sub(ts, ep->timestamp);
+		ep->credit += timespec_to_ns(&delta) / NSEC_PER_MSEC;
+		ep->timestamp = ts;
 		while (!list_empty(&ep->urb_list)) {
 			struct oz_urb_link *urbl =
 				list_first_entry(&ep->urb_list,
@@ -1095,7 +1096,7 @@ int oz_hcd_heartbeat(void *hport)
 			int len = 0;
 			int copy_len;
 			int i;
-			if ((ep->credit + 1) < urb->number_of_packets)
+			if (ep->credit  < urb->number_of_packets)
 				break;
 			if (ep->buffered_units < urb->number_of_packets)
 				break;
@@ -1141,7 +1142,7 @@ int oz_hcd_heartbeat(void *hport)
 		urb = urbl->urb;
 		list_del_init(e);
 		oz_free_urb_link(urbl);
-		oz_complete_urb(port->ozhcd->hcd, urb, 0, 0);
+		oz_complete_urb(port->ozhcd->hcd, urb, 0);
 	}
 	/* Check if there are any ep0 requests that have timed out.
 	 * If so resent to PD.
@@ -1153,11 +1154,12 @@ int oz_hcd_heartbeat(void *hport)
 		spin_lock_bh(&ozhcd->hcd_lock);
 		list_for_each_safe(e, n, &ep->urb_list) {
 			urbl = container_of(e, struct oz_urb_link, link);
-			if (time_after(now, urbl->submit_jiffies+HZ/2)) {
-				oz_dbg(ON, "%ld: Request 0x%p timeout\n",
-				       now, urbl->urb);
-				urbl->submit_jiffies = now;
+			if (urbl->submit_counter > EP0_TIMEOUT_COUNTER) {
+				oz_dbg(ON, "Request 0x%p timeout\n", urbl->urb);
 				list_move_tail(e, &xfr_list);
+				urbl->submit_counter = 0;
+			} else {
+				urbl->submit_counter++;
 			}
 		}
 		if (!list_empty(&ep->urb_list))
@@ -1382,7 +1384,7 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 	int port_ix = -1;
 	struct oz_port *port = NULL;
 
-	oz_dbg(URB, "%lu: %s: (%p)\n", jiffies, __func__, urb);
+	oz_dbg(URB, "[%s]:(%p)\n", __func__, urb);
 	port_ix = oz_get_port_from_addr(ozhcd, urb->dev->devnum);
 	if (port_ix < 0) {
 		rc = -EPIPE;
@@ -1505,7 +1507,7 @@ static void oz_process_ep0_urb(struct oz_hcd *ozhcd, struct urb *urb,
 out:
 	if (rc || complete) {
 		oz_dbg(ON, "Completing request locally\n");
-		oz_complete_urb(ozhcd->hcd, urb, rc, 0);
+		oz_complete_urb(ozhcd->hcd, urb, rc);
 	} else {
 		oz_usb_request_heartbeat(port->hpd);
 	}
@@ -1569,7 +1571,7 @@ static void oz_urb_process_tasklet(unsigned long unused)
 		oz_free_urb_link(urbl);
 		rc = oz_urb_process(ozhcd, urb);
 		if (rc)
-			oz_complete_urb(ozhcd->hcd, urb, rc, 0);
+			oz_complete_urb(ozhcd->hcd, urb, rc);
 		spin_lock_irqsave(&g_tasklet_lock, irq_state);
 	}
 	spin_unlock_irqrestore(&g_tasklet_lock, irq_state);
@@ -1638,7 +1640,7 @@ out2:
 	if (urbl) {
 		urb->actual_length = 0;
 		oz_free_urb_link(urbl);
-		oz_complete_urb(ozhcd->hcd, urb, -EPIPE, 0);
+		oz_complete_urb(ozhcd->hcd, urb, -EPIPE);
 	}
 }
 /*------------------------------------------------------------------------------
@@ -1678,7 +1680,7 @@ static void oz_hcd_clear_orphanage(struct oz_hcd *ozhcd, int status)
 			urbl = list_first_entry(&ozhcd->orphanage,
 				struct oz_urb_link, link);
 			list_del(&urbl->link);
-			oz_complete_urb(ozhcd->hcd, urbl->urb, status, 0);
+			oz_complete_urb(ozhcd->hcd, urbl->urb, status);
 			oz_free_urb_link(urbl);
 		}
 	}
@@ -1720,14 +1722,13 @@ static int oz_hcd_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	struct oz_port *port;
 	unsigned long irq_state;
 	struct oz_urb_link *urbl;
-	oz_dbg(URB, "%lu: %s: (%p)\n", jiffies, __func__, urb);
+	oz_dbg(URB, "%s: (%p)\n",  __func__, urb);
 	if (unlikely(ozhcd == NULL)) {
-		oz_dbg(URB, "%lu: Refused urb(%p) not ozhcd\n", jiffies, urb);
+		oz_dbg(URB, "Refused urb(%p) not ozhcd\n", urb);
 		return -EPIPE;
 	}
 	if (unlikely(hcd->state != HC_STATE_RUNNING)) {
-		oz_dbg(URB, "%lu: Refused urb(%p) not running\n",
-		       jiffies, urb);
+		oz_dbg(URB, "Refused urb(%p) not running\n", urb);
 		return -EPIPE;
 	}
 	port_ix = oz_get_port_from_addr(ozhcd, urb->dev->devnum);
@@ -1795,7 +1796,7 @@ static int oz_hcd_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	struct oz_urb_link *urbl = NULL;
 	int rc;
 	unsigned long irq_state;
-	oz_dbg(URB, "%lu: %s: (%p)\n", jiffies, __func__, urb);
+	oz_dbg(URB, "%s: (%p)\n",  __func__, urb);
 	urbl = oz_alloc_urb_link();
 	if (unlikely(urbl == NULL))
 		return -ENOMEM;
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 8a253ac..86876bd 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -176,6 +176,14 @@ struct oz_pd *oz_pd_alloc(const u8 *mac_addr)
 		pd->last_sent_frame = &pd->tx_queue;
 		spin_lock_init(&pd->stream_lock);
 		INIT_LIST_HEAD(&pd->stream_list);
+		tasklet_init(&pd->heartbeat_tasklet, oz_pd_heartbeat_handler,
+							(unsigned long)pd);
+		tasklet_init(&pd->timeout_tasklet, oz_pd_timeout_handler,
+							(unsigned long)pd);
+		hrtimer_init(&pd->heartbeat, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		hrtimer_init(&pd->timeout, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		pd->heartbeat.function = oz_pd_heartbeat_event;
+		pd->timeout.function = oz_pd_timeout_event;
 	}
 	return pd;
 }
@@ -189,6 +197,13 @@ void oz_pd_destroy(struct oz_pd *pd)
 	struct oz_isoc_stream *st;
 	struct oz_farewell *fwell;
 	oz_pd_dbg(pd, ON, "Destroying PD\n");
+	if (hrtimer_active(&pd->timeout))
+		hrtimer_cancel(&pd->timeout);
+	if (hrtimer_active(&pd->heartbeat))
+		hrtimer_cancel(&pd->heartbeat);
+	/*Disable timer tasklets*/
+	tasklet_kill(&pd->heartbeat_tasklet);
+	tasklet_kill(&pd->timeout_tasklet);
 	/* Delete any streams.
 	 */
 	e = pd->stream_list.next;
@@ -287,8 +302,8 @@ void oz_pd_heartbeat(struct oz_pd *pd, u16 apps)
 				more = 1;
 		}
 	}
-	if (more)
-		oz_pd_request_heartbeat(pd);
+	if ((!more) && (hrtimer_active(&pd->heartbeat)))
+		hrtimer_cancel(&pd->heartbeat);
 	if (pd->mode & OZ_F_ISOC_ANYTIME) {
 		int count = 8;
 		while (count-- && (oz_send_isoc_frame(pd) >= 0))
@@ -315,7 +330,6 @@ void oz_pd_stop(struct oz_pd *pd)
 	list_del(&pd->link);
 	oz_polling_unlock_bh();
 	oz_dbg(ON, "pd ref count = %d\n", atomic_read(&pd->ref_count));
-	oz_timer_delete(pd, 0);
 	oz_pd_put(pd);
 }
 /*------------------------------------------------------------------------------
@@ -330,21 +344,18 @@ int oz_pd_sleep(struct oz_pd *pd)
 		oz_polling_unlock_bh();
 		return 0;
 	}
-	if (pd->keep_alive_j && pd->session_id) {
+	if (pd->keep_alive && pd->session_id)
 		oz_pd_set_state(pd, OZ_PD_S_SLEEP);
-		pd->pulse_time_j = jiffies + pd->keep_alive_j;
-		oz_dbg(ON, "Sleep Now %lu until %lu\n",
-		       jiffies, pd->pulse_time_j);
-	} else {
+	else
 		do_stop = 1;
-	}
+
 	stop_apps = pd->total_apps;
 	oz_polling_unlock_bh();
 	if (do_stop) {
 		oz_pd_stop(pd);
 	} else {
 		oz_services_stop(pd, stop_apps, 1);
-		oz_timer_add(pd, OZ_TIMER_STOP, jiffies + pd->keep_alive_j, 1);
+		oz_timer_add(pd, OZ_TIMER_STOP, pd->keep_alive);
 	}
 	return do_stop;
 }
diff --git a/drivers/staging/ozwpan/ozpd.h b/drivers/staging/ozwpan/ozpd.h
index fbf47cb..a281753 100644
--- a/drivers/staging/ozwpan/ozpd.h
+++ b/drivers/staging/ozwpan/ozpd.h
@@ -6,6 +6,7 @@
 #ifndef _OZPD_H_
 #define _OZPD_H_
 
+#include <linux/interrupt.h>
 #include "ozeltbuf.h"
 
 /* PD state
@@ -68,18 +69,16 @@ struct oz_pd {
 	u8		isoc_sent;
 	u32		last_rx_pkt_num;
 	u32		last_tx_pkt_num;
+	struct timespec last_rx_timestamp;
 	u32		trigger_pkt_num;
-	unsigned long	pulse_time_j;
-	unsigned long	timeout_time_j;
-	unsigned long	pulse_period_j;
-	unsigned long	presleep_j;
-	unsigned long	keep_alive_j;
-	unsigned long	last_rx_time_j;
+	unsigned long	pulse_time;
+	unsigned long	pulse_period;
+	unsigned long	presleep;
+	unsigned long	keep_alive;
 	struct oz_elt_buf elt_buff;
 	void		*app_ctx[OZ_APPID_MAX];
 	spinlock_t	app_lock[OZ_APPID_MAX];
 	int		max_tx_size;
-	u8		heartbeat_requested;
 	u8		mode;
 	u8		ms_per_isoc;
 	unsigned	isoc_latency;
@@ -95,6 +94,11 @@ struct oz_pd {
 	spinlock_t	stream_lock;
 	struct list_head stream_list;
 	struct net_device *net_dev;
+	struct hrtimer  heartbeat;
+	struct hrtimer  timeout;
+	u8      timeout_type;
+	struct tasklet_struct   heartbeat_tasklet;
+	struct tasklet_struct   timeout_tasklet;
 };
 
 #define OZ_MAX_QUEUED_FRAMES	4
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 760761d..ed22729 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -30,12 +30,6 @@
 #define OZ_DO_STOP		1
 #define OZ_DO_SLEEP		2
 
-/* States of the timer.
- */
-#define OZ_TIMER_IDLE		0
-#define OZ_TIMER_SET		1
-#define OZ_TIMER_IN_HANDLER	2
-
 #define OZ_MAX_TIMER_POOL_SIZE	16
 
 /*------------------------------------------------------------------------------
@@ -46,12 +40,6 @@ struct oz_binding {
 	struct oz_binding *next;
 };
 
-struct oz_timer {
-	struct list_head link;
-	struct oz_pd *pd;
-	unsigned long due_time;
-	int type;
-};
 /*------------------------------------------------------------------------------
  * Static external variables.
  */
@@ -63,15 +51,6 @@ static struct sk_buff_head g_rx_queue;
 static u8 g_session_id;
 static u16 g_apps = 0x1;
 static int g_processing_rx;
-static struct timer_list g_timer;
-static struct oz_timer *g_cur_timer;
-static struct list_head *g_timer_pool;
-static int g_timer_pool_count;
-static int g_timer_state = OZ_TIMER_IDLE;
-static LIST_HEAD(g_timer_list);
-/*------------------------------------------------------------------------------
- */
-static void oz_protocol_timer_start(void);
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
@@ -138,33 +117,37 @@ static void pd_set_keepalive(struct oz_pd *pd, u8 kalive)
 
 	switch (kalive & OZ_KALIVE_TYPE_MASK) {
 	case OZ_KALIVE_SPECIAL:
-		pd->keep_alive_j =
-			oz_ms_to_jiffies(keep_alive * 1000*60*60*24*20);
+		pd->keep_alive = keep_alive * 1000*60*60*24*20;
 		break;
 	case OZ_KALIVE_SECS:
-		pd->keep_alive_j = oz_ms_to_jiffies(keep_alive*1000);
+		pd->keep_alive = keep_alive*1000;
 		break;
 	case OZ_KALIVE_MINS:
-		pd->keep_alive_j = oz_ms_to_jiffies(keep_alive*1000*60);
+		pd->keep_alive = keep_alive*1000*60;
 		break;
 	case OZ_KALIVE_HOURS:
-		pd->keep_alive_j = oz_ms_to_jiffies(keep_alive*1000*60*60);
+		pd->keep_alive = keep_alive*1000*60*60;
 		break;
 	default:
-		pd->keep_alive_j = 0;
+		pd->keep_alive = 0;
 	}
-	oz_dbg(ON, "Keepalive = %lu jiffies\n", pd->keep_alive_j);
+	oz_dbg(ON, "Keepalive = %lu mSec\n", pd->keep_alive);
 }
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
-static void pd_set_presleep(struct oz_pd *pd, u8 presleep)
+static void pd_set_presleep(struct oz_pd *pd, u8 presleep, u8 start_timer)
 {
 	if (presleep)
-		pd->presleep_j = oz_ms_to_jiffies(presleep*100);
+		pd->presleep = presleep*100;
 	else
-		pd->presleep_j = OZ_PRESLEEP_TOUT_J;
-	oz_dbg(ON, "Presleep time = %lu jiffies\n", pd->presleep_j);
+		pd->presleep = OZ_PRESLEEP_TOUT;
+	if (start_timer) {
+		spin_unlock(&g_polling_lock);
+		oz_timer_add(pd, OZ_TIMER_TOUT, pd->presleep);
+		spin_lock(&g_polling_lock);
+	}
+	oz_dbg(ON, "Presleep time = %lu mSec\n", pd->presleep);
 }
 /*------------------------------------------------------------------------------
  * Context: softirq-serialized
@@ -189,7 +172,7 @@ static struct oz_pd *oz_connect_req(struct oz_pd *cur_pd, struct oz_elt *elt,
 		pd = oz_pd_alloc(pd_addr);
 		if (pd == NULL)
 			return NULL;
-		pd->last_rx_time_j = jiffies;
+		getnstimeofday(&pd->last_rx_timestamp);
 		spin_lock_bh(&g_polling_lock);
 		list_for_each(e, &g_pd_list) {
 			pd2 = container_of(e, struct oz_pd, link);
@@ -238,9 +221,8 @@ static struct oz_pd *oz_connect_req(struct oz_pd *cur_pd, struct oz_elt *elt,
 	oz_dbg(ON, "Max frame:%u Ms per isoc:%u\n",
 	       pd->max_tx_size, pd->ms_per_isoc);
 	pd->max_stream_buffering = 3*1024;
-	pd->timeout_time_j = jiffies + OZ_CONNECTION_TOUT_J;
-	pd->pulse_period_j = OZ_QUANTUM_J;
-	pd_set_presleep(pd, body->presleep);
+	pd->pulse_period = OZ_QUANTUM;
+	pd_set_presleep(pd, body->presleep, 0);
 	pd_set_keepalive(pd, body->keep_alive);
 
 	new_apps &= le16_to_cpu(get_unaligned(&body->apps));
@@ -272,7 +254,6 @@ done:
 		u16 resume_apps = new_apps & pd->paused_apps  & ~0x1;
 		spin_unlock_bh(&g_polling_lock);
 		oz_pd_set_state(pd, OZ_PD_S_CONNECTED);
-		oz_timer_delete(pd, OZ_TIMER_STOP);
 		oz_dbg(ON, "new_apps=0x%x total_apps=0x%x paused_apps=0x%x\n",
 		       new_apps, pd->total_apps, pd->paused_apps);
 		if (start_apps) {
@@ -341,6 +322,7 @@ static void oz_rx_frame(struct sk_buff *skb)
 	int length;
 	struct oz_pd *pd = NULL;
 	struct oz_hdr *oz_hdr = (struct oz_hdr *)skb_network_header(skb);
+	struct timespec current_time;
 	int dup = 0;
 	u32 pkt_num;
 
@@ -361,9 +343,14 @@ static void oz_rx_frame(struct sk_buff *skb)
 
 	pd = oz_pd_find(src_addr);
 	if (pd) {
-		pd->last_rx_time_j = jiffies;
-		oz_timer_add(pd, OZ_TIMER_TOUT,
-			pd->last_rx_time_j + pd->presleep_j, 1);
+		if (!(pd->state & OZ_PD_S_CONNECTED))
+			oz_pd_set_state(pd, OZ_PD_S_CONNECTED);
+		getnstimeofday(&current_time);
+		if ((current_time.tv_sec != pd->last_rx_timestamp.tv_sec) ||
+			(pd->presleep < MSEC_PER_SEC))  {
+			oz_timer_add(pd, OZ_TIMER_TOUT,	pd->presleep);
+			pd->last_rx_timestamp = current_time;
+		}
 		if (pkt_num != pd->last_rx_pkt_num) {
 			pd->last_rx_pkt_num = pkt_num;
 		} else {
@@ -412,7 +399,7 @@ static void oz_rx_frame(struct sk_buff *skb)
 				if (pd && (pd->state & OZ_PD_S_CONNECTED)) {
 					spin_lock(&g_polling_lock);
 					pd_set_keepalive(pd, body->keepalive);
-					pd_set_presleep(pd, body->presleep);
+					pd_set_presleep(pd, body->presleep, 1);
 					spin_unlock(&g_polling_lock);
 				}
 			}
@@ -450,8 +437,6 @@ done:
  */
 void oz_protocol_term(void)
 {
-	struct list_head *chain;
-	del_timer_sync(&g_timer);
 	/* Walk the list of bindings and remove each one.
 	 */
 	spin_lock_bh(&g_binding_lock);
@@ -480,21 +465,35 @@ void oz_protocol_term(void)
 		oz_pd_put(pd);
 		spin_lock_bh(&g_polling_lock);
 	}
-	chain = g_timer_pool;
-	g_timer_pool = NULL;
 	spin_unlock_bh(&g_polling_lock);
-	while (chain) {
-		struct oz_timer *t = container_of(chain, struct oz_timer, link);
-		chain = chain->next;
-		kfree(t);
-	}
 	oz_dbg(ON, "Protocol stopped\n");
 }
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
-static void oz_pd_handle_timer(struct oz_pd *pd, int type)
+void oz_pd_heartbeat_handler(unsigned long data)
 {
+	struct oz_pd *pd = (struct oz_pd *)data;
+	u16 apps = 0;
+	spin_lock_bh(&g_polling_lock);
+	if (pd->state & OZ_PD_S_CONNECTED)
+		apps = pd->total_apps;
+	spin_unlock_bh(&g_polling_lock);
+	if (apps)
+		oz_pd_heartbeat(pd, apps);
+
+}
+/*------------------------------------------------------------------------------
+ * Context: softirq
+ */
+void oz_pd_timeout_handler(unsigned long data)
+{
+	int type;
+	struct oz_pd *pd = (struct oz_pd *)data;
+
+	spin_lock_bh(&g_polling_lock);
+	type = pd->timeout_type;
+	spin_unlock_bh(&g_polling_lock);
 	switch (type) {
 	case OZ_TIMER_TOUT:
 		oz_pd_sleep(pd);
@@ -502,218 +501,69 @@ static void oz_pd_handle_timer(struct oz_pd *pd, int type)
 	case OZ_TIMER_STOP:
 		oz_pd_stop(pd);
 		break;
-	case OZ_TIMER_HEARTBEAT: {
-			u16 apps = 0;
-			spin_lock_bh(&g_polling_lock);
-			pd->heartbeat_requested = 0;
-			if (pd->state & OZ_PD_S_CONNECTED)
-				apps = pd->total_apps;
-			spin_unlock_bh(&g_polling_lock);
-			if (apps)
-				oz_pd_heartbeat(pd, apps);
-		}
-		break;
 	}
 }
 /*------------------------------------------------------------------------------
- * Context: softirq
+ * Context: Interrupt
  */
-static void oz_protocol_timer(unsigned long arg)
+enum hrtimer_restart oz_pd_heartbeat_event(struct hrtimer *timer)
 {
-	struct oz_timer *t;
-	struct oz_timer *t2;
 	struct oz_pd *pd;
-	spin_lock_bh(&g_polling_lock);
-	if (!g_cur_timer) {
-		/* This happens if we remove the current timer but can't stop
-		 * the timer from firing. In this case just get out.
-		 */
-		spin_unlock_bh(&g_polling_lock);
-		return;
-	}
-	g_timer_state = OZ_TIMER_IN_HANDLER;
-	t = g_cur_timer;
-	g_cur_timer = NULL;
-	list_del(&t->link);
-	spin_unlock_bh(&g_polling_lock);
-	do {
-		pd = t->pd;
-		oz_pd_handle_timer(pd, t->type);
-		spin_lock_bh(&g_polling_lock);
-		if (g_timer_pool_count < OZ_MAX_TIMER_POOL_SIZE) {
-			t->link.next = g_timer_pool;
-			g_timer_pool = &t->link;
-			g_timer_pool_count++;
-			t = NULL;
-		}
-		if (!list_empty(&g_timer_list)) {
-			t2 =  container_of(g_timer_list.next,
-				struct oz_timer, link);
-			if (time_before_eq(t2->due_time, jiffies))
-				list_del(&t2->link);
-			else
-				t2 = NULL;
-		} else {
-			t2 = NULL;
-		}
-		spin_unlock_bh(&g_polling_lock);
-		oz_pd_put(pd);
-		kfree(t);
-		t = t2;
-	} while (t);
-	g_timer_state = OZ_TIMER_IDLE;
-	oz_protocol_timer_start();
+
+	pd = container_of(timer, struct oz_pd, heartbeat);
+	hrtimer_forward_now(timer, ktime_set(pd->pulse_period /
+	MSEC_PER_SEC, (pd->pulse_period % MSEC_PER_SEC) * NSEC_PER_MSEC));
+	tasklet_schedule(&pd->heartbeat_tasklet);
+	return HRTIMER_RESTART;
 }
 /*------------------------------------------------------------------------------
- * Context: softirq
+ * Context: Interrupt
  */
-static void oz_protocol_timer_start(void)
+enum hrtimer_restart oz_pd_timeout_event(struct hrtimer *timer)
 {
-	spin_lock_bh(&g_polling_lock);
-	if (!list_empty(&g_timer_list)) {
-		g_cur_timer =
-			container_of(g_timer_list.next, struct oz_timer, link);
-		if (g_timer_state == OZ_TIMER_SET) {
-			mod_timer(&g_timer, g_cur_timer->due_time);
-		} else {
-			g_timer.expires = g_cur_timer->due_time;
-			g_timer.function = oz_protocol_timer;
-			g_timer.data = 0;
-			add_timer(&g_timer);
-		}
-		g_timer_state = OZ_TIMER_SET;
-	} else {
-		oz_dbg(ON, "No queued timers\n");
-	}
-	spin_unlock_bh(&g_polling_lock);
+	struct oz_pd *pd;
+
+	pd = container_of(timer, struct oz_pd, timeout);
+	tasklet_schedule(&pd->timeout_tasklet);
+	return HRTIMER_NORESTART;
 }
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
-void oz_timer_add(struct oz_pd *pd, int type, unsigned long due_time,
-		int remove)
+void oz_timer_add(struct oz_pd *pd, int type, unsigned long due_time)
 {
-	struct list_head *e;
-	struct oz_timer *t = NULL;
-	int restart_needed = 0;
-	spin_lock(&g_polling_lock);
-	if (remove) {
-		list_for_each(e, &g_timer_list) {
-			t = container_of(e, struct oz_timer, link);
-			if ((t->pd == pd) && (t->type == type)) {
-				if (g_cur_timer == t) {
-					restart_needed = 1;
-					g_cur_timer = NULL;
-				}
-				list_del(e);
-				break;
-			}
-			t = NULL;
-		}
-	}
-	if (!t) {
-		if (g_timer_pool) {
-			t = container_of(g_timer_pool, struct oz_timer, link);
-			g_timer_pool = g_timer_pool->next;
-			g_timer_pool_count--;
+	spin_lock_bh(&g_polling_lock);
+	switch (type) {
+	case OZ_TIMER_TOUT:
+	case OZ_TIMER_STOP:
+		if (hrtimer_active(&pd->timeout)) {
+			hrtimer_set_expires(&pd->timeout, ktime_set(due_time /
+			MSEC_PER_SEC, (due_time % MSEC_PER_SEC) *
+							NSEC_PER_MSEC));
+			hrtimer_start_expires(&pd->timeout, HRTIMER_MODE_REL);
 		} else {
-			t = kmalloc(sizeof(struct oz_timer), GFP_ATOMIC);
-		}
-		if (t) {
-			t->pd = pd;
-			t->type = type;
-			oz_pd_get(pd);
+			hrtimer_start(&pd->timeout, ktime_set(due_time /
+			MSEC_PER_SEC, (due_time % MSEC_PER_SEC) *
+					NSEC_PER_MSEC), HRTIMER_MODE_REL);
 		}
+		pd->timeout_type = type;
+		break;
+	case OZ_TIMER_HEARTBEAT:
+		if (!hrtimer_active(&pd->heartbeat))
+			hrtimer_start(&pd->heartbeat, ktime_set(due_time /
+			MSEC_PER_SEC, (due_time % MSEC_PER_SEC) *
+					NSEC_PER_MSEC), HRTIMER_MODE_REL);
+		break;
 	}
-	if (t) {
-		struct oz_timer *t2;
-		t->due_time = due_time;
-		list_for_each(e, &g_timer_list) {
-			t2 = container_of(e, struct oz_timer, link);
-			if (time_before(due_time, t2->due_time)) {
-				if (t2 == g_cur_timer) {
-					g_cur_timer = NULL;
-					restart_needed = 1;
-				}
-				break;
-			}
-		}
-		list_add_tail(&t->link, e);
-	}
-	if (g_timer_state == OZ_TIMER_IDLE)
-		restart_needed = 1;
-	else if (g_timer_state == OZ_TIMER_IN_HANDLER)
-		restart_needed = 0;
-	spin_unlock(&g_polling_lock);
-	if (restart_needed)
-		oz_protocol_timer_start();
-}
-/*------------------------------------------------------------------------------
- * Context: softirq or process
- */
-void oz_timer_delete(struct oz_pd *pd, int type)
-{
-	struct list_head *chain = NULL;
-	struct oz_timer *t;
-	struct oz_timer *n;
-	int restart_needed = 0;
-	int release = 0;
-	spin_lock(&g_polling_lock);
-	list_for_each_entry_safe(t, n, &g_timer_list, link) {
-		if ((t->pd == pd) && ((type == 0) || (t->type == type))) {
-			if (g_cur_timer == t) {
-				restart_needed = 1;
-				g_cur_timer = NULL;
-				del_timer(&g_timer);
-			}
-			list_del(&t->link);
-			release++;
-			if (g_timer_pool_count < OZ_MAX_TIMER_POOL_SIZE) {
-				t->link.next = g_timer_pool;
-				g_timer_pool = &t->link;
-				g_timer_pool_count++;
-			} else {
-				t->link.next = chain;
-				chain = &t->link;
-			}
-			if (type)
-				break;
-		}
-	}
-	if (g_timer_state == OZ_TIMER_IN_HANDLER)
-		restart_needed = 0;
-	else if (restart_needed)
-		g_timer_state = OZ_TIMER_IDLE;
-	spin_unlock(&g_polling_lock);
-	if (restart_needed)
-		oz_protocol_timer_start();
-	while (release--)
-		oz_pd_put(pd);
-	while (chain) {
-		t = container_of(chain, struct oz_timer, link);
-		chain = chain->next;
-		kfree(t);
-	}
+	spin_unlock_bh(&g_polling_lock);
 }
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
 void oz_pd_request_heartbeat(struct oz_pd *pd)
 {
-	unsigned long now = jiffies;
-	unsigned long t;
-	spin_lock(&g_polling_lock);
-	if (pd->heartbeat_requested) {
-		spin_unlock(&g_polling_lock);
-		return;
-	}
-	if (pd->pulse_period_j)
-		t = ((now / pd->pulse_period_j) + 1) * pd->pulse_period_j;
-	else
-		t = now + 1;
-	pd->heartbeat_requested = 1;
-	spin_unlock(&g_polling_lock);
-	oz_timer_add(pd, OZ_TIMER_HEARTBEAT, t, 0);
+	oz_timer_add(pd, OZ_TIMER_HEARTBEAT, pd->pulse_period > 0 ?
+					pd->pulse_period : OZ_QUANTUM);
 }
 /*------------------------------------------------------------------------------
  * Context: softirq or process
@@ -915,7 +765,6 @@ int oz_protocol_init(char *devs)
 				oz_binding_add(d);
 		}
 	}
-	init_timer(&g_timer);
 	return 0;
 }
 /*------------------------------------------------------------------------------
diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
index 9bb0a6a..305c532 100644
--- a/drivers/staging/ozwpan/ozproto.h
+++ b/drivers/staging/ozwpan/ozproto.h
@@ -12,20 +12,11 @@
 
 #define OZ_ALLOCATED_SPACE(__x)	(LL_RESERVED_SPACE(__x)+(__x)->needed_tailroom)
 
-/* Converts millisecs to jiffies.
- */
-#define oz_ms_to_jiffies(__x)	msecs_to_jiffies(__x)
-
-/* Quantum milliseconds.
- */
-#define OZ_QUANTUM_MS		8
-/* Quantum jiffies
- */
-#define OZ_QUANTUM_J		(oz_ms_to_jiffies(OZ_QUANTUM_MS))
+/* Quantum in MS */
+#define OZ_QUANTUM		8
 /* Default timeouts.
  */
-#define OZ_CONNECTION_TOUT_J	(2*HZ)
-#define OZ_PRESLEEP_TOUT_J	(11*HZ)
+#define OZ_PRESLEEP_TOUT	11
 
 /* Maximun sizes of tx frames. */
 #define OZ_MAX_TX_SIZE		1514
@@ -65,11 +56,16 @@ void oz_app_enable(int app_id, int enable);
 struct oz_pd *oz_pd_find(const u8 *mac_addr);
 void oz_binding_add(char *net_dev);
 void oz_binding_remove(char *net_dev);
-void oz_timer_add(struct oz_pd *pd, int type, unsigned long due_time,
-		int remove);
+void oz_timer_add(struct oz_pd *pd, int type, unsigned long due_time);
 void oz_timer_delete(struct oz_pd *pd, int type);
 void oz_pd_request_heartbeat(struct oz_pd *pd);
 void oz_polling_lock_bh(void);
 void oz_polling_unlock_bh(void);
+void oz_pd_heartbeat_handler(unsigned long data);
+void oz_pd_timeout_handler(unsigned long data);
+enum hrtimer_restart oz_pd_heartbeat_event(struct hrtimer *timer);
+enum hrtimer_restart oz_pd_timeout_event(struct hrtimer *timer);
+int oz_get_pd_status_list(char *pd_list, int max_count);
+int oz_get_binding_list(char *buf, int max_if);
 
 #endif /* _OZPROTO_H */
diff --git a/drivers/staging/ozwpan/ozurbparanoia.c b/drivers/staging/ozwpan/ozurbparanoia.c
index 366584b..d69e8ab 100644
--- a/drivers/staging/ozwpan/ozurbparanoia.c
+++ b/drivers/staging/ozwpan/ozurbparanoia.c
@@ -24,7 +24,7 @@ void oz_remember_urb(struct urb *urb)
 	spin_lock_irqsave(&g_urb_mem_lock, irq_state);
 	if (g_nb_urbs < OZ_MAX_URBS) {
 		g_urb_memory[g_nb_urbs++] = urb;
-		oz_dbg(ON, "%lu: urb up = %d %p\n", jiffies, g_nb_urbs, urb);
+		oz_dbg(ON, "urb up = %d %p\n", g_nb_urbs, urb);
 	} else {
 		oz_dbg(ON, "ERROR urb buffer full\n");
 	}
@@ -44,8 +44,7 @@ int oz_forget_urb(struct urb *urb)
 			if (--g_nb_urbs > i)
 				memcpy(&g_urb_memory[i], &g_urb_memory[i+1],
 					(g_nb_urbs - i) * sizeof(struct urb *));
-			oz_dbg(ON, "%lu: urb down = %d %p\n",
-			       jiffies, g_nb_urbs, urb);
+			oz_dbg(ON, "urb down = %d %p\n", g_nb_urbs, urb);
 		}
 	}
 	spin_unlock_irqrestore(&g_urb_mem_lock, irq_state);
diff --git a/drivers/staging/ozwpan/ozusbsvc.c b/drivers/staging/ozwpan/ozusbsvc.c
index 816cac9..732face 100644
--- a/drivers/staging/ozwpan/ozusbsvc.c
+++ b/drivers/staging/ozwpan/ozusbsvc.c
@@ -123,7 +123,8 @@ void oz_usb_stop(struct oz_pd *pd, int pause)
 	pd->app_ctx[OZ_APPID_USB-1] = NULL;
 	spin_unlock_bh(&pd->app_lock[OZ_APPID_USB-1]);
 	if (usb_ctx) {
-		unsigned long tout = jiffies + HZ;
+		struct timespec ts, now;
+		getnstimeofday(&ts);
 		oz_dbg(ON, "USB service stopping...\n");
 		usb_ctx->stopped = 1;
 		/* At this point the reference count on the usb context should
@@ -132,9 +133,12 @@ void oz_usb_stop(struct oz_pd *pd, int pause)
 		 * should get in but someone may already be in. So wait
 		 * until they leave but timeout after 1 second.
 		 */
-		while ((atomic_read(&usb_ctx->ref_count) > 2) &&
-			time_before(jiffies, tout))
-			;
+		while ((atomic_read(&usb_ctx->ref_count) > 2)) {
+			getnstimeofday(&now);
+			/*Approx 1 Sec. this is not perfect calculation*/
+			if (now.tv_sec != ts.tv_sec)
+				break;
+		}
 		oz_dbg(ON, "USB service stopped\n");
 		oz_hcd_pd_departed(usb_ctx->hport);
 		/* Release the reference taken in oz_usb_start.
@@ -155,7 +159,7 @@ void oz_usb_get(void *hpd)
 /*------------------------------------------------------------------------------
  * This decrements the reference count of the context area for a specific PD
  * and destroys the context area if the reference count becomes zero.
- * Context: softirq or process
+ * Context: irq or process
  */
 void oz_usb_put(void *hpd)
 {
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaBGLrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:47:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41396 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbaBGLro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:47:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 005/233] sfc: PTP: Moderate log message on event queue overflow
Date: Fri,  7 Feb 2014 11:43:44 +0000
Message-Id: <1391773652-25214-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurence Evans <levans@solarflare.com>

commit f32116003c39f3a6815215a7512e1ea8d1e4bbc7 upstream.

Limit syslog flood if a PTP packet storm occurs.

Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/ptp.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 6ddec68..d5a5192 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -220,6 +220,7 @@ struct efx_ptp_timeset {
  * @evt_list: List of MC receive events awaiting packets
  * @evt_free_list: List of free events
  * @evt_lock: Lock for manipulating evt_list and evt_free_list
+ * @evt_overflow: Boolean indicating that event list has overflowed
  * @rx_evts: Instantiated events (on evt_list and evt_free_list)
  * @workwq: Work queue for processing pending PTP operations
  * @work: Work task
@@ -270,6 +271,7 @@ struct efx_ptp_data {
 	struct list_head evt_list;
 	struct list_head evt_free_list;
 	spinlock_t evt_lock;
+	bool evt_overflow;
 	struct efx_ptp_event_rx rx_evts[MAX_RECEIVE_EVENTS];
 	struct workqueue_struct *workwq;
 	struct work_struct work;
@@ -628,6 +630,11 @@ static void efx_ptp_drop_time_expired_events(struct efx_nic *efx)
 			}
 		}
 	}
+	/* If the event overflow flag is set and the event list is now empty
+	 * clear the flag to re-enable the overflow warning message.
+	 */
+	if (ptp->evt_overflow && list_empty(&ptp->evt_list))
+		ptp->evt_overflow = false;
 	spin_unlock_bh(&ptp->evt_lock);
 }
 
@@ -669,6 +676,11 @@ static enum ptp_packet_state efx_ptp_match_rx(struct efx_nic *efx,
 			break;
 		}
 	}
+	/* If the event overflow flag is set and the event list is now empty
+	 * clear the flag to re-enable the overflow warning message.
+	 */
+	if (ptp->evt_overflow && list_empty(&ptp->evt_list))
+		ptp->evt_overflow = false;
 	spin_unlock_bh(&ptp->evt_lock);
 
 	return rc;
@@ -802,6 +814,7 @@ static int efx_ptp_stop(struct efx_nic *efx)
 	list_for_each_safe(cursor, next, &efx->ptp_data->evt_list) {
 		list_move(cursor, &efx->ptp_data->evt_free_list);
 	}
+	ptp->evt_overflow = false;
 	spin_unlock_bh(&efx->ptp_data->evt_lock);
 
 	return rc;
@@ -894,6 +907,7 @@ static int efx_ptp_probe_channel(struct efx_channel *channel)
 	spin_lock_init(&ptp->evt_lock);
 	for (pos = 0; pos < MAX_RECEIVE_EVENTS; pos++)
 		list_add(&ptp->rx_evts[pos].link, &ptp->evt_free_list);
+	ptp->evt_overflow = false;
 
 	ptp->phc_clock_info.owner = THIS_MODULE;
 	snprintf(ptp->phc_clock_info.name,
@@ -1292,8 +1306,13 @@ static void ptp_event_rx(struct efx_nic *efx, struct efx_ptp_data *ptp)
 		list_add_tail(&evt->link, &ptp->evt_list);
 
 		queue_work(ptp->workwq, &ptp->work);
-	} else {
-		netif_err(efx, rx_err, efx->net_dev, "No free PTP event");
+	} else if (!ptp->evt_overflow) {
+		/* Log a warning message and set the event overflow flag.
+		 * The message won't be logged again until the event queue
+		 * becomes empty.
+		 */
+		netif_err(efx, rx_err, efx->net_dev, "PTP event queue overflow\n");
+		ptp->evt_overflow = true;
 	}
 	spin_unlock_bh(&ptp->evt_lock);
 }
-- 
1.8.3.2


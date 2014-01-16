Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaAPVPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 16:15:17 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:51763 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaAPVPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 16:15:11 -0500
Message-ID: <1389906905.11912.84.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH 3.12 40/77] sfc: Add length checks to
 efx_xmit_with_hwtstamp() and efx_ptp_is_ptp_tx()
From: Ben Hutchings <bhutchings@solarflare.com>
To: Luis Henriques <luis.henriques@canonical.com>,
        David Miller <davem@davemloft.net>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <linux-net-drivers@solarflare.com>
Date: Thu, 16 Jan 2014 21:15:05 +0000
In-Reply-To: <20140116205129.GC6429@hercules>
References: <20140114002753.640936297@linuxfoundation.org>
	 <1389660315.2025.169.camel@bwh-desktop.uk.level5networks.com>
	 <20140116105026.GA6429@hercules>
	 <20140116.114206.1690186344823616829.davem@davemloft.net>
	 <20140116205129.GC6429@hercules>
Organization: Solarflare
Content-Type: multipart/mixed; boundary="=-SwZM5c/xM2c6+Qq8oG6q"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20438.001
X-TM-AS-Result: No--34.171900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-SwZM5c/xM2c6+Qq8oG6q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2014-01-16 at 20:51 +0000, Luis Henriques wrote:
> On Thu, Jan 16, 2014 at 11:42:06AM -0800, David Miller wrote:
> > From: Luis Henriques <luis.henriques@canonical.com>
> > Date: Thu, 16 Jan 2014 10:50:26 +0000
> > 
> > > On Tue, Jan 14, 2014 at 12:45:15AM +0000, Ben Hutchings wrote:
> > >> On Mon, 2014-01-13 at 16:28 -0800, Greg Kroah-Hartman wrote:
> > >> > 3.12-stable review patch.  If anyone has any objections, please let me know.
> > >> > 
> > >> > ------------------
> > >> > 
> > >> > From: Ben Hutchings <bhutchings@solarflare.com>
> > >> > 
> > >> > [ Upstream commit e5a498e943fbc497f236ab8cf31366c75f337ce6 ]
> > >> > 
> > >> > efx_ptp_is_ptp_tx() must be robust against skbs from raw sockets that
> > >> > have invalid IPv4 and UDP headers.
> > >> > 
> > >> > Add checks that:
> > >> > - the transport header has been found
> > >> > - there is enough space between network and transport header offset
> > >> >   for an IPv4 header
> > >> > - there is enough space after the transport header offset for a
> > >> >   UDP header
> > >> > 
> > >> > Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')
> > >> 
> > >> All the PTP fixes for sfc (40-44 in this series) logically apply to
> > >> 3.10.y as well.  David, did you find conflicts there?
> > 
> > Yes, there were rejects which were beyond my ability to resolve.
> 
> For the 3.11 kernel, only cd6fe65 ("sfc: Maintain current frequency
> adjustment when applying a time offset") required some rework -- basically,
> replacing MCDI_SET_QWORD() by two MCDI_SET_DWORD()).  All the others we're
> (almost) clean cherry-picks.

Here's what I came up with for 3.10.y/3.11.y; it sounds like you got the
same result.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

--=-SwZM5c/xM2c6+Qq8oG6q
Content-Type: application/mbox; name="sfc_3.10.mbox"
Content-Disposition: attachment; filename="sfc_3.10.mbox"
Content-Transfer-Encoding: 7bit

>From 4b0a05e13143a4f7839facb2ce7136d23f0379c9 Mon Sep 17 00:00:00 2001
From: Ben Hutchings <bhutchings@solarflare.com>
Date: Fri, 6 Dec 2013 19:26:40 +0000
Subject: [PATCH 1/5] sfc: Add length checks to efx_xmit_with_hwtstamp() and
 efx_ptp_is_ptp_tx()

commit e5a498e943fbc497f236ab8cf31366c75f337ce6 upstream.

efx_ptp_is_ptp_tx() must be robust against skbs from raw sockets that
have invalid IPv4 and UDP headers.

Add checks that:
- the transport header has been found
- there is enough space between network and transport header offset
  for an IPv4 header
- there is enough space after the transport header offset for a
  UDP header

Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
---
 drivers/net/ethernet/sfc/ptp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 9a95abf2dedf..d0c456e1d6e9 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -982,7 +982,11 @@ bool efx_ptp_is_ptp_tx(struct efx_nic *efx, struct sk_buff *skb)
 		skb->len >= PTP_MIN_LENGTH &&
 		skb->len <= MC_CMD_PTP_IN_TRANSMIT_PACKET_MAXNUM &&
 		likely(skb->protocol == htons(ETH_P_IP)) &&
+		skb_transport_header_was_set(skb) &&
+		skb_network_header_len(skb) >= sizeof(struct iphdr) &&
 		ip_hdr(skb)->protocol == IPPROTO_UDP &&
+		skb_headlen(skb) >=
+		skb_transport_offset(skb) + sizeof(struct udphdr) &&
 		udp_hdr(skb)->dest == htons(PTP_EVENT_PORT);
 }
 
-- 
1.8.1.4


>From 3b3dd5c34bf151bb66f3dbb84b08c663e04bd03e Mon Sep 17 00:00:00 2001
From: Laurence Evans <levans@solarflare.com>
Date: Mon, 28 Jan 2013 14:51:17 +0000
Subject: [PATCH 2/5] sfc: PTP: Moderate log message on event queue overflow

commit f32116003c39f3a6815215a7512e1ea8d1e4bbc7 upstream.

Limit syslog flood if a PTP packet storm occurs.

Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
---
 drivers/net/ethernet/sfc/ptp.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index d0c456e1d6e9..53954a215794 100644
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
@@ -1295,8 +1309,13 @@ static void ptp_event_rx(struct efx_nic *efx, struct efx_ptp_data *ptp)
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
1.8.1.4


>From 5a1611e4dd62d48e639906623409630e921ff30b Mon Sep 17 00:00:00 2001
From: Ben Hutchings <bhutchings@solarflare.com>
Date: Fri, 6 Dec 2013 22:10:46 +0000
Subject: [PATCH 3/5] sfc: Rate-limit log message for PTP packets without a
 matching timestamp event

commit 35f9a7a380728a94d417e5824a866f969423ac83 upstream.

In case of a flood of PTP packets, the timestamp peripheral and MC
firmware on the SFN[56]322F boards may not be able to provide
timestamp events for all packets.  Don't complain too much about this.

Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
---
 drivers/net/ethernet/sfc/ptp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 53954a215794..811ec5a35b74 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -710,8 +710,9 @@ static bool efx_ptp_process_events(struct efx_nic *efx, struct sk_buff_head *q)
 			__skb_queue_tail(q, skb);
 		} else if (time_after(jiffies, match->expiry)) {
 			match->state = PTP_PACKET_STATE_TIMED_OUT;
-			netif_warn(efx, rx_err, efx->net_dev,
-				   "PTP packet - no timestamp seen\n");
+			if (net_ratelimit())
+				netif_warn(efx, rx_err, efx->net_dev,
+					   "PTP packet - no timestamp seen\n");
 			__skb_queue_tail(q, skb);
 		} else {
 			/* Replace unprocessed entry and stop */
-- 
1.8.1.4


>From b6eccb6923ad41499c2b8ab49121fa6ff1eb8523 Mon Sep 17 00:00:00 2001
From: Alexandre Rames <arames@solarflare.com>
Date: Fri, 8 Nov 2013 10:20:31 +0000
Subject: [PATCH 4/5] sfc: Stop/re-start PTP when stopping/starting the
 datapath.

commit 2ea4dc28a5bcec408e01a8772763871638a5ec79 upstream.

This disables PTP when we bring the interface down to avoid getting
unmatched RX timestamp events, and tries to re-enable it when bringing
the interface up.

[bwh: Make efx_ptp_stop() safe on Falcon. Introduce
 efx_ptp_{start,stop}_datapath() functions; we'll expand them later.]

Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
[bwh: Backported to 3.10: adjust context]
---
 drivers/net/ethernet/sfc/efx.c |  4 ++++
 drivers/net/ethernet/sfc/nic.h |  2 ++
 drivers/net/ethernet/sfc/ptp.c | 30 +++++++++++++++++++++++++++---
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 4a14a940c65e..29ed149d29d6 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -695,6 +695,8 @@ static void efx_start_datapath(struct efx_nic *efx)
 		WARN_ON(channel->rx_pkt_n_frags);
 	}
 
+	efx_ptp_start_datapath(efx);
+
 	if (netif_device_present(efx->net_dev))
 		netif_tx_wake_all_queues(efx->net_dev);
 }
@@ -710,6 +712,8 @@ static void efx_stop_datapath(struct efx_nic *efx)
 	EFX_ASSERT_RESET_SERIALISED(efx);
 	BUG_ON(efx->port_enabled);
 
+	efx_ptp_stop_datapath(efx);
+
 	/* Only perform flush if dma is enabled */
 	if (dev->is_busmaster && efx->state != STATE_RECOVERY) {
 		rc = efx_nic_flush_queues(efx);
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index 1b0003323498..44e835d76210 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -259,6 +259,8 @@ extern int efx_ptp_get_ts_info(struct net_device *net_dev,
 extern bool efx_ptp_is_ptp_tx(struct efx_nic *efx, struct sk_buff *skb);
 extern int efx_ptp_tx(struct efx_nic *efx, struct sk_buff *skb);
 extern void efx_ptp_event(struct efx_nic *efx, efx_qword_t *ev);
+void efx_ptp_start_datapath(struct efx_nic *efx);
+void efx_ptp_stop_datapath(struct efx_nic *efx);
 
 extern const struct efx_nic_type falcon_a1_nic_type;
 extern const struct efx_nic_type falcon_b0_nic_type;
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 811ec5a35b74..3b1f898f788e 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -794,9 +794,14 @@ fail:
 static int efx_ptp_stop(struct efx_nic *efx)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
-	int rc = efx_ptp_disable(efx);
 	struct list_head *cursor;
 	struct list_head *next;
+	int rc;
+
+	if (ptp == NULL)
+		return 0;
+
+	rc = efx_ptp_disable(efx);
 
 	if (ptp->rxfilter_installed) {
 		efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
@@ -821,6 +826,13 @@ static int efx_ptp_stop(struct efx_nic *efx)
 	return rc;
 }
 
+static int efx_ptp_restart(struct efx_nic *efx)
+{
+	if (efx->ptp_data && efx->ptp_data->enabled)
+		return efx_ptp_start(efx);
+	return 0;
+}
+
 static void efx_ptp_pps_worker(struct work_struct *work)
 {
 	struct efx_ptp_data *ptp =
@@ -1118,7 +1130,7 @@ static int efx_ptp_change_mode(struct efx_nic *efx, bool enable_wanted,
 {
 	if ((enable_wanted != efx->ptp_data->enabled) ||
 	    (enable_wanted && (efx->ptp_data->mode != new_mode))) {
-		int rc;
+		int rc = 0;
 
 		if (enable_wanted) {
 			/* Change of mode requires disable */
@@ -1135,7 +1147,8 @@ static int efx_ptp_change_mode(struct efx_nic *efx, bool enable_wanted,
 			 * succeed.
 			 */
 			efx->ptp_data->mode = new_mode;
-			rc = efx_ptp_start(efx);
+			if (netif_running(efx->net_dev))
+				rc = efx_ptp_start(efx);
 			if (rc == 0) {
 				rc = efx_ptp_synchronize(efx,
 							 PTP_SYNC_ATTEMPTS * 2);
@@ -1511,3 +1524,14 @@ void efx_ptp_probe(struct efx_nic *efx)
 		efx->extra_channel_type[EFX_EXTRA_CHANNEL_PTP] =
 			&efx_ptp_channel_type;
 }
+
+void efx_ptp_start_datapath(struct efx_nic *efx)
+{
+	if (efx_ptp_restart(efx))
+		netif_err(efx, drv, efx->net_dev, "Failed to restart PTP.\n");
+}
+
+void efx_ptp_stop_datapath(struct efx_nic *efx)
+{
+	efx_ptp_stop(efx);
+}
-- 
1.8.1.4


>From 53cde9c9da18419f2bb9645f43dbd9b0eff65a6f Mon Sep 17 00:00:00 2001
From: Ben Hutchings <bhutchings@solarflare.com>
Date: Thu, 5 Dec 2013 17:24:06 +0000
Subject: [PATCH 5/5] sfc: Maintain current frequency adjustment when applying
 a time offset

commit cd6fe65e923175e4f2e9fb585b1d78c6bf580fc6 upstream.

There is a single MCDI PTP operation for setting the frequency
adjustment and applying a time offset to the hardware clock.  When
applying a time offset we should not change the frequency adjustment.

These two operations can now be requested separately but this requires
a flash firmware update.  Keep using the single operation, but
remember and repeat the previous frequency adjustment.

Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
[bwh: Backported to 3.10:
 - Adjust context
 - Use MCDI_SET_DWORD() to set high/low 32 bits as MCDI_SET_QWORD()
   is not available]
---
 drivers/net/ethernet/sfc/ptp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 3b1f898f788e..a6c434a0b4ee 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1423,7 +1423,7 @@ static int efx_phc_adjfreq(struct ptp_clock_info *ptp, s32 delta)
 	if (rc != 0)
 		return rc;
 
-	ptp_data->current_adjfreq = delta;
+	ptp_data->current_adjfreq = adjustment_ns;
 	return 0;
 }
 
@@ -1437,8 +1437,10 @@ static int efx_phc_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	u8 inbuf[MC_CMD_PTP_IN_ADJUST_LEN];
 
 	MCDI_SET_DWORD(inbuf, PTP_IN_OP, MC_CMD_PTP_OP_ADJUST);
-	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_FREQ_LO, 0);
-	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_FREQ_HI, 0);
+	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_FREQ_LO,
+		       (u32)ptp_data->current_adjfreq);
+	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_FREQ_HI,
+		       (u32)(ptp_data->current_adjfreq >> 32));
 	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_SECONDS, (u32)delta_ts.tv_sec);
 	MCDI_SET_DWORD(inbuf, PTP_IN_ADJUST_NANOSECONDS, (u32)delta_ts.tv_nsec);
 	return efx_mcdi_rpc(efx, MC_CMD_PTP, inbuf, sizeof(inbuf),
-- 
1.8.1.4


--=-SwZM5c/xM2c6+Qq8oG6q--

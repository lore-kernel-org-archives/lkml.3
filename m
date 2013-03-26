Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965411Ab3CZPbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:31:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54140 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965392Ab3CZPX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 132/150] sfc: Fix timekeeping in efx_mcdi_poll()
Date: Tue, 26 Mar 2013 15:20:31 +0000
Message-Id: <1364311249-14454-133-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit ebf98e797b4e26ad52ace1511a0b503ee60a6cd4 upstream.

efx_mcdi_poll() uses get_seconds() to read the current time and to
implement a polling timeout.  The use of this function was chosen
partly because it could easily be replaced in a co-sim environment
with a macro that read the simulated time.

Unfortunately the real get_seconds() returns the system time (real
time) which is subject to adjustment by e.g. ntpd.  If the system time
is adjusted forward during a polled MCDI operation, the effective
timeout can be shorter than the intended 10 seconds, resulting in a
spurious failure.  It is also possible for a backward adjustment to
delay detection of a areal failure.

Use jiffies instead, and change MCDI_RPC_TIMEOUT to be denominated in
jiffies.  Also correct rounding of the timeout: check time > finish
(or rather time_after(time, finish)) and not time >= finish.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/mcdi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index a423cd3..eb85217 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -22,7 +22,7 @@
  **************************************************************************
  */
 
-#define MCDI_RPC_TIMEOUT       10 /*seconds */
+#define MCDI_RPC_TIMEOUT       (10 * HZ)
 
 #define MCDI_PDU(efx)							\
 	(efx_port_num(efx) ? MC_SMEM_P1_PDU_OFST : MC_SMEM_P0_PDU_OFST)
@@ -120,7 +120,7 @@ static void efx_mcdi_copyout(struct efx_nic *efx, u8 *outbuf, size_t outlen)
 static int efx_mcdi_poll(struct efx_nic *efx)
 {
 	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
-	unsigned int time, finish;
+	unsigned long time, finish;
 	unsigned int respseq, respcmd, error;
 	unsigned int pdu = FR_CZ_MC_TREG_SMEM + MCDI_PDU(efx);
 	unsigned int rc, spins;
@@ -136,7 +136,7 @@ static int efx_mcdi_poll(struct efx_nic *efx)
 	 * and poll once a jiffy (approximately)
 	 */
 	spins = TICK_USEC;
-	finish = get_seconds() + MCDI_RPC_TIMEOUT;
+	finish = jiffies + MCDI_RPC_TIMEOUT;
 
 	while (1) {
 		if (spins != 0) {
@@ -146,7 +146,7 @@ static int efx_mcdi_poll(struct efx_nic *efx)
 			schedule_timeout_uninterruptible(1);
 		}
 
-		time = get_seconds();
+		time = jiffies;
 
 		rmb();
 		efx_readd(efx, &reg, pdu);
@@ -158,7 +158,7 @@ static int efx_mcdi_poll(struct efx_nic *efx)
 		    EFX_DWORD_FIELD(reg, MCDI_HEADER_RESPONSE))
 			break;
 
-		if (time >= finish)
+		if (time_after(time, finish))
 			return -ETIMEDOUT;
 	}
 
@@ -250,7 +250,7 @@ static int efx_mcdi_await_completion(struct efx_nic *efx)
 	if (wait_event_timeout(
 		    mcdi->wq,
 		    atomic_read(&mcdi->state) == MCDI_STATE_COMPLETED,
-		    msecs_to_jiffies(MCDI_RPC_TIMEOUT * 1000)) == 0)
+		    MCDI_RPC_TIMEOUT) == 0)
 		return -ETIMEDOUT;
 
 	/* Check if efx_mcdi_set_mode() switched us back to polled completions.
-- 
1.8.1.2


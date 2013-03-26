Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab3CZWwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:52:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab3CZWwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 22/72] sfc: Fix timekeeping in efx_mcdi_poll()
Date: Tue, 26 Mar 2013 15:51:05 -0700
Message-Id: <20130326224921.993605629@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit ebf98e797b4e26ad52ace1511a0b503ee60a6cd4 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/mcdi.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -22,7 +22,7 @@
  **************************************************************************
  */
 
-#define MCDI_RPC_TIMEOUT       10 /*seconds */
+#define MCDI_RPC_TIMEOUT       (10 * HZ)
 
 #define MCDI_PDU(efx)							\
 	(efx_port_num(efx) ? MC_SMEM_P1_PDU_OFST : MC_SMEM_P0_PDU_OFST)
@@ -120,7 +120,7 @@ static void efx_mcdi_copyout(struct efx_
 static int efx_mcdi_poll(struct efx_nic *efx)
 {
 	struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
-	unsigned int time, finish;
+	unsigned long time, finish;
 	unsigned int respseq, respcmd, error;
 	unsigned int pdu = FR_CZ_MC_TREG_SMEM + MCDI_PDU(efx);
 	unsigned int rc, spins;
@@ -136,7 +136,7 @@ static int efx_mcdi_poll(struct efx_nic
 	 * and poll once a jiffy (approximately)
 	 */
 	spins = TICK_USEC;
-	finish = get_seconds() + MCDI_RPC_TIMEOUT;
+	finish = jiffies + MCDI_RPC_TIMEOUT;
 
 	while (1) {
 		if (spins != 0) {
@@ -146,7 +146,7 @@ static int efx_mcdi_poll(struct efx_nic
 			schedule_timeout_uninterruptible(1);
 		}
 
-		time = get_seconds();
+		time = jiffies;
 
 		rmb();
 		efx_readd(efx, &reg, pdu);
@@ -158,7 +158,7 @@ static int efx_mcdi_poll(struct efx_nic
 		    EFX_DWORD_FIELD(reg, MCDI_HEADER_RESPONSE))
 			break;
 
-		if (time >= finish)
+		if (time_after(time, finish))
 			return -ETIMEDOUT;
 	}
 
@@ -250,7 +250,7 @@ static int efx_mcdi_await_completion(str
 	if (wait_event_timeout(
 		    mcdi->wq,
 		    atomic_read(&mcdi->state) == MCDI_STATE_COMPLETED,
-		    msecs_to_jiffies(MCDI_RPC_TIMEOUT * 1000)) == 0)
+		    MCDI_RPC_TIMEOUT) == 0)
 		return -ETIMEDOUT;
 
 	/* Check if efx_mcdi_set_mode() switched us back to polled completions.



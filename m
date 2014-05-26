Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaEZTSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:18:06 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:61969 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680AbaEZTSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:18:04 -0400
Message-ID: <1401131881.6068.23.camel@x220>
Subject: [PATCH] staging: ctx1e1: remove checks for three macros
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 21:18:01 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2014 19:18:01.0574 (UTC) FILETIME=[36175060:01CF7917]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the ctx1e1 driver was added in v2.6.35 it contained checks for
CONFIG_SBE_HDLC_V7, CONFIG_SBE_WAN256T3_HDLC_V7, and
CONFIG_SBE_WAN256T3_NCOMM (and MODULE variants). The related Kconfig
symbols didn't exist then. They still don't exist now. Remove these
checks.

Do some related cleaning up and remove the unused V7() macro too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. Done op top of next-20140526.

 drivers/staging/cxt1e1/functions.c | 18 ------------------
 drivers/staging/cxt1e1/linux.c     | 17 -----------------
 drivers/staging/cxt1e1/musycc.c    | 30 ------------------------------
 3 files changed, 65 deletions(-)

diff --git a/drivers/staging/cxt1e1/functions.c b/drivers/staging/cxt1e1/functions.c
index ee9d39bbd251..65b6fc36edf6 100644
--- a/drivers/staging/cxt1e1/functions.c
+++ b/drivers/staging/cxt1e1/functions.c
@@ -24,24 +24,6 @@
 #include "libsbew.h"
 #include "pmcc4.h"
 
-#if defined(CONFIG_SBE_HDLC_V7) || defined(CONFIG_SBE_WAN256T3_HDLC_V7) || \
-defined(CONFIG_SBE_HDLC_V7_MODULE) || \
-defined(CONFIG_SBE_WAN256T3_HDLC_V7_MODULE)
-#define _v7_hdlc_  1
-#else
-#define _v7_hdlc_  0
-#endif
-
-#if _v7_hdlc_
-#define V7(x) (x ## _v7)
-extern int  hdlc_netif_rx_v7(hdlc_device *, struct sk_buff *);
-extern int  register_hdlc_device_v7(hdlc_device *);
-extern int  unregister_hdlc_device_v7(hdlc_device *);
-
-#else
-#define V7(x) x
-#endif
-
 
 #ifndef USE_MAX_INT_DELAY
 static int  dummy = 0;
diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 4b4609db9f89..09f3d5ca75ac 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -83,23 +83,6 @@ int         musycc_start_xmit(ci_t *, int, void *);
 extern ci_t *CI;
 extern struct s_hdw_info hdw_info[];
 
-#if defined(CONFIG_SBE_HDLC_V7) || defined(CONFIG_SBE_WAN256T3_HDLC_V7) || \
-	defined(CONFIG_SBE_HDLC_V7_MODULE) || defined(CONFIG_SBE_WAN256T3_HDLC_V7_MODULE)
-#define _v7_hdlc_  1
-#else
-#define _v7_hdlc_  0
-#endif
-
-#if _v7_hdlc_
-#define V7(x) (x ## _v7)
-extern int  hdlc_netif_rx_v7(hdlc_device *, struct sk_buff *);
-extern int  register_hdlc_device_v7(hdlc_device *);
-extern int  unregister_hdlc_device_v7(hdlc_device *);
-
-#else
-#define V7(x) x
-#endif
-
 int         error_flag;         /* module load error reporting */
 int         cxt1e1_log_level = LOG_ERROR;
 static int  log_level_default = LOG_ERROR;
diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index a87f80237f47..0bcbd8a3fc84 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -918,9 +918,6 @@ musycc_bh_tx_eom(mpi_t *pi, int gchan)
 
 		md->data = 0;
 		if (md->mem_token) {
-#ifdef CONFIG_SBE_WAN256T3_NCOMM
-			int hdlcnum = 0;
-#endif
 			/* upcount channel */
 			atomic_sub(OS_mem_token_tlen(md->mem_token),
 				   &ch->tx_pending);
@@ -931,18 +928,6 @@ musycc_bh_tx_eom(mpi_t *pi, int gchan)
 			if (!atomic_read(&pi->up->tx_pending))
 				wan256t3_led(pi->up, LED_TX, 0);
 #endif
-
-#ifdef CONFIG_SBE_WAN256T3_NCOMM
-			/* callback that our packet was sent */
-			hdlcnum = (pi->portnum * 32 + gchan);
-
-			if (hdlcnum >= 228) {
-				if (nciProcess_TX_complete)
-					(*nciProcess_TX_complete) (hdlcnum,
-							getuserbychan(gchan));
-			}
-#endif /* CONFIG_SBE_WAN256T3_NCOMM */
-
 			OS_mem_token_free_irq(md->mem_token);
 			md->mem_token = NULL;
 		}
@@ -1039,21 +1024,6 @@ musycc_bh_rx_eom(mpi_t *pi, int gchan)
 		m = md->mem_token;
 		error = (status >> 16) & 0xf;
 		if (error == 0) {
-#ifdef CONFIG_SBE_WAN256T3_NCOMM
-			int         hdlcnum = (pi->portnum * 32 + gchan);
-
-			/*
-			 * if the packet number belongs to NCOMM, then send it to the TMS
-			 * driver
-			 */
-			if (hdlcnum >= 228) {
-				if (nciProcess_RX_packet)
-					(*nciProcess_RX_packet)(hdlcnum,
-								status & 0x3fff,
-								m, ch->user);
-			} else
-#endif                              /*** CONFIG_SBE_WAN256T3_NCOMM ***/
-
 			{
 				m2 = OS_mem_token_alloc(cxt1e1_max_mru);
 				if (m2) {
-- 
1.9.0


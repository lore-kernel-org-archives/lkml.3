Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab3COV3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 17:29:49 -0400
Received: from mail-ia0-f202.google.com ([209.85.210.202]:59099 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab3COV3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 17:29:47 -0400
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Will Newton <will.newton@gmail.com>, Seungwon Jeon <tgih.jun@samsung.com>,
        Bing Zhao <bzhao@marvell.com>, Jaehoon Chung <jh80.chung@samsung.com>,
        Ashok Nagarajan <asnagarajan@chromium.org>,
        Paul Stewart <pstew@chromium.org>, Olof Johansson <olof@lixom.net>,
        Doug Anderson <dianders@chromium.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] RFC: mmc: dw_mmc: Always go to STATE_DATA_BUSY from STATE_DATA_ERROR
Date: Fri, 15 Mar 2013 14:29:16 -0700
Message-Id: <1363382956-14557-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a flaky piece of hardware that seems good at generating CRC errors,
we have found that often times the CRC errors don't get reported
properly when using CONFIG_MMC_DW_IDMAC (they get reported OK when
using pio).

The flow that happens is:
1. dw_mci_interrupt() fires and status=80b8, pending=8088 so that
   we hit (pending & DW_MCI_DATA_ERROR_FLAGS).  We store 8088 in
   data_status and set EVENT_DATA_ERROR in host->pending_events
2. We schedule the tasklet and it runs.
3. We're in STATE_SENDING_DATA in the tasklet and see
   EVENT_DATA_ERROR so we dw_mci_stop_dma().
4. dw_mci_stop_dma() calls dw_mci_idmac_stop_dma() and
   dw_mci_dma_cleanup().  These stop dma but _don't_ set
   EVENT_XFER_COMPLETE (since we're host->using_dma).
5. data->stop is NULL so we don't send a stop command.
6. We move onto STATE_DATA_ERROR and loop again in the tasklet.
7. We hit STATE_DATA_ERROR but the transfer isn't done, so the tasklet
   stops.

We never seem to get any additional DMA interrupts that cause
EVENT_XFER_COMPLETE and restart the tasklet so we just hang.  That
doesn't seem surprising given that we've stopped DMA.

We did put a print at the end of dw_mci_interrupt() to show the result
of the "mci_readl(host, IDSTS)" and saw 0xa000 in the case of the
above CRC error.

A proposed fix for this is to ignore (but still clear) the
EVENT_XFER_COMPLETE in STATE_DATA_ERROR in the tasklet.

Reported-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/mmc/host/dw_mmc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 9834221..696b3bb 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1137,10 +1137,7 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			goto unlock;
 
 		case STATE_DATA_ERROR:
-			if (!test_and_clear_bit(EVENT_XFER_COMPLETE,
-						&host->pending_events))
-				break;
-
+			clear_bit(EVENT_XFER_COMPLETE, &host->pending_events);
 			state = STATE_DATA_BUSY;
 			break;
 		}
-- 
1.8.1.3


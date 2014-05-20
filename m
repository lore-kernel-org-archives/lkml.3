Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbaETWIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 18:08:53 -0400
Received: from mail-pd0-f202.google.com ([209.85.192.202]:53471 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaETWIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 18:08:52 -0400
From: Doug Anderson <dianders@chromium.org>
To: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>
Cc: Chris Ball <cjb@laptop.org>, Sonny Rao <sonnyrao@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, sunil joshi <joshi@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>, chris@printf.net,
        ulf.hansson@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] mmc: dw_mmc: Make sure we don't get stuck when we get an error
Date: Tue, 20 May 2014 15:07:50 -0700
Message-Id: <1400623670-2657-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we happened to get a data error at just the wrong time the dw_mmc
driver could get into a state where it would never complete its
request.  That would leave the caller just hanging there.

We fix this two ways and both of the two fixes on their own appear to
fix the problems we've seen:

1. Fix a race in the tasklet where the interrupt setting the data
   error happens _just after_ we check for it, then we get a
   EVENT_XFER_COMPLETE.  We fix this by repeating a bit of code.
2. Fix it so that if we detect that we've got an error in the "data
   busy" state and we're not going to do anything else we end the
   request and unblock anyone waiting.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
---
Changes in v2:
- Removed TODO
- Set cmd to NULL before calling dw_mci_request_end()

 drivers/mmc/host/dw_mmc.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index cced599..54ec8b0 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1318,6 +1318,14 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			/* fall through */
 
 		case STATE_SENDING_DATA:
+			/*
+			 * We could get a data error and never a transfer
+			 * complete so we'd better check for it here.
+			 *
+			 * Note that we don't really care if we also got a
+			 * transfer complete; stopping the DMA and sending an
+			 * abort won't hurt.
+			 */
 			if (test_and_clear_bit(EVENT_DATA_ERROR,
 					       &host->pending_events)) {
 				dw_mci_stop_dma(host);
@@ -1331,7 +1339,29 @@ static void dw_mci_tasklet_func(unsigned long priv)
 				break;
 
 			set_bit(EVENT_XFER_COMPLETE, &host->completed_events);
+
+			/*
+			 * Handle an EVENT_DATA_ERROR that might have shown up
+			 * before the transfer completed.  This might not have
+			 * been caught by the check above because the interrupt
+			 * could have gone off between the previous check and
+			 * the check for transfer complete.
+			 *
+			 * Technically this ought not be needed assuming we
+			 * get a DATA_COMPLETE eventually (we'll notice the
+			 * error and end the request), but it shouldn't hurt.
+			 *
+			 * This has the advantage of sending the stop command.
+			 */
+			if (test_and_clear_bit(EVENT_DATA_ERROR,
+					       &host->pending_events)) {
+				dw_mci_stop_dma(host);
+				send_stop_abort(host, data);
+				state = STATE_DATA_ERROR;
+				break;
+			}
 			prev_state = state = STATE_DATA_BUSY;
+
 			/* fall through */
 
 		case STATE_DATA_BUSY:
@@ -1354,6 +1384,22 @@ static void dw_mci_tasklet_func(unsigned long priv)
 				/* stop command for open-ended transfer*/
 				if (data->stop)
 					send_stop_abort(host, data);
+			} else {
+				/*
+				 * If we don't have a command complete now we'll
+				 * never get one since we just reset everything;
+				 * better end the request.
+				 *
+				 * If we do have a command complete we'll fall
+				 * through to the SENDING_STOP command and
+				 * everything will be peachy keen.
+				 */
+				if (!test_bit(EVENT_CMD_COMPLETE,
+					      &host->pending_events)) {
+					host->cmd = NULL;
+					dw_mci_request_end(host, mrq);
+					goto unlock;
+				}
 			}
 
 			/*
-- 
1.9.1.423.g4596e3a


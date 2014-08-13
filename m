Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaHMPO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:14:29 -0400
Received: from mail-oi0-f73.google.com ([209.85.218.73]:52204 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaHMPO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:14:27 -0400
From: Doug Anderson <dianders@chromium.org>
To: ulf.hansson@linaro.org, Chris Ball <cjb@laptop.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, chris@printf.net,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [REPOST PATCH v2] mmc: dw_mmc: Make sure we don't get stuck when we get an error
Date: Wed, 13 Aug 2014 08:13:43 -0700
Message-Id: <1407942823-4271-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
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
Acked-by: Seungwon Jeon <tgih.jun@samsung.com>
---
Changes in v2:
- Removed TODO
- Set cmd to NULL before calling dw_mci_request_end()

 drivers/mmc/host/dw_mmc.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 8f216ed..7f227e9 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1299,6 +1299,14 @@ static void dw_mci_tasklet_func(unsigned long priv)
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
@@ -1312,7 +1320,29 @@ static void dw_mci_tasklet_func(unsigned long priv)
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
@@ -1335,6 +1365,22 @@ static void dw_mci_tasklet_func(unsigned long priv)
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
2.1.0.rc2.206.gedb03e5


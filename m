Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaIPDfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 23:35:19 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51219 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbaIPDfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 23:35:17 -0400
Date: Tue, 16 Sep 2014 12:33:33 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgap: use schedule_timeout_interruptible() instead
 of dgap_ms_sleep()
Message-ID: <20140916033333.GA26821@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using schedule_timeout_interruptible() is exactly same as
setting a status of current process and calling  schedule_timeout().

Removes dgap_ms_sleep(), because this function is used
only when closing tty channel on dgap_tty_close().
And also removes ch_close_delay that is always set to 250
on dgap_tty_init().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |   36 ++++++------------------------------
 drivers/staging/dgap/dgap.h |    3 ---
 2 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 67da1d5..8aff0de 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -180,7 +180,6 @@ static char *dgap_create_config_string(struct board_t *bd, char *string);
 static uint dgap_config_get_useintr(struct board_t *bd);
 static uint dgap_config_get_altpin(struct board_t *bd);
 
-static int dgap_ms_sleep(ulong ms);
 static void dgap_do_bios_load(struct board_t *brd, const u8 *ubios, int len);
 static void dgap_do_fep_load(struct board_t *brd, const u8 *ufep, int len);
 #ifdef DIGI_CONCENTRATORS_SUPPORTED
@@ -1200,26 +1199,6 @@ static void dgap_init_globals(void)
 
 /************************************************************************
  *
- * Utility functions
- *
- ************************************************************************/
-
-/*
- * dgap_ms_sleep()
- *
- * Put the driver to sleep for x ms's
- *
- * Returns 0 if timed out, !0 (showing signal) if interrupted by a signal.
- */
-static int dgap_ms_sleep(ulong ms)
-{
-	current->state = TASK_INTERRUPTIBLE;
-	schedule_timeout((ms * HZ) / 1000);
-	return signal_pending(current);
-}
-
-/************************************************************************
- *
  * TTY Initialization/Cleanup Functions
  *
  ************************************************************************/
@@ -1462,9 +1441,6 @@ static int dgap_tty_init(struct board_t *brd)
 		ch->ch_tstart = 0;
 		ch->ch_rstart = 0;
 
-		/* .25 second delay */
-		ch->ch_close_delay = 250;
-
 		/*
 		 * Set queue water marks, interrupt mask,
 		 * and general tty parameters.
@@ -2297,12 +2273,12 @@ static void dgap_tty_close(struct tty_struct *tty, struct file *file)
 			 * Go to sleep to ensure RTS/DTR
 			 * have been dropped for modems to see it.
 			 */
-			if (ch->ch_close_delay) {
-				spin_unlock_irqrestore(&ch->ch_lock,
-						       lock_flags);
-				dgap_ms_sleep(ch->ch_close_delay);
-				spin_lock_irqsave(&ch->ch_lock, lock_flags);
-			}
+			spin_unlock_irqrestore(&ch->ch_lock,
+					lock_flags);
+			/* .25 second delay for dropping RTS/DTR */
+			schedule_timeout_interruptible(msecs_to_jiffies(250));
+			signal_pending(current);
+			spin_lock_irqsave(&ch->ch_lock, lock_flags);
 		}
 
 		ch->pscan_state = 0;
diff --git a/drivers/staging/dgap/dgap.h b/drivers/staging/dgap/dgap.h
index a0307b9..ba05c65 100644
--- a/drivers/staging/dgap/dgap.h
+++ b/drivers/staging/dgap/dgap.h
@@ -982,9 +982,6 @@ struct channel_t {
 	u32 ch_open_count;		/* open count			*/
 	u32	ch_flags;		/* Channel flags                */
 
-	u32	ch_close_delay;		/* How long we should drop      */
-					/* RTS/DTR for                  */
-
 	u32	ch_cpstime;		/* Time for CPS calculations    */
 
 	tcflag_t ch_c_iflag;		/* channel iflags               */
-- 
1.7.1


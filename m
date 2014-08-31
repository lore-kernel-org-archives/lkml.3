Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaHaXKI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 19:10:08 -0400
Received: from smtp.infotech.no ([82.134.31.41]:60547 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaHaXKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 19:10:06 -0400
Message-ID: <5403AB47.3040706@interlog.com>
Date: Sun, 31 Aug 2014 19:09:59 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@infradead.org>
CC: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] scsi_debug: deadlock between completions and surprise module
 removal
Content-Type: multipart/mixed;
 boundary="------------080804020404080006020101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080804020404080006020101
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

A deadlock has been reported when the completion
of SCSI commands (simulated by a timer) was surprised
by a module removal. This patch removes one half of
the offending locks around timer deletions. This fix
is applied both to stop_all_queued() which is were
the deadlock was discovered and stop_queued_cmnd()
which has very similar logic.

This patch should be applied both to the lk 3.17 tree
and Christoph's drivers-for-3.18 tree.

Tested-and-reported-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------080804020404080006020101
Content-Type: text/x-patch;
 name="sdebug317rc2_dlock1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sdebug317rc2_dlock1.patch"

--- a/drivers/scsi/scsi_debug.c	2014-08-26 13:24:51.646948507 -0400
+++ b/drivers/scsi/scsi_debug.c	2014-08-30 18:04:54.589226679 -0400
@@ -2743,6 +2743,13 @@ static int stop_queued_cmnd(struct scsi_
 		if (test_bit(k, queued_in_use_bm)) {
 			sqcp = &queued_arr[k];
 			if (cmnd == sqcp->a_cmnd) {
+				devip = (struct sdebug_dev_info *)
+					cmnd->device->hostdata;
+				if (devip)
+					atomic_dec(&devip->num_in_q);
+				sqcp->a_cmnd = NULL;
+				spin_unlock_irqrestore(&queued_arr_lock,
+						       iflags);
 				if (scsi_debug_ndelay > 0) {
 					if (sqcp->sd_hrtp)
 						hrtimer_cancel(
@@ -2755,18 +2762,13 @@ static int stop_queued_cmnd(struct scsi_
 					if (sqcp->tletp)
 						tasklet_kill(sqcp->tletp);
 				}
-				__clear_bit(k, queued_in_use_bm);
-				devip = (struct sdebug_dev_info *)
-					cmnd->device->hostdata;
-				if (devip)
-					atomic_dec(&devip->num_in_q);
-				sqcp->a_cmnd = NULL;
-				break;
+				clear_bit(k, queued_in_use_bm);
+				return 1;
 			}
 		}
 	}
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
-	return (k < qmax) ? 1 : 0;
+	return 0;
 }
 
 /* Deletes (stops) timers or tasklets of all queued commands */
@@ -2782,6 +2784,13 @@ static void stop_all_queued(void)
 		if (test_bit(k, queued_in_use_bm)) {
 			sqcp = &queued_arr[k];
 			if (sqcp->a_cmnd) {
+				devip = (struct sdebug_dev_info *)
+					sqcp->a_cmnd->device->hostdata;
+				if (devip)
+					atomic_dec(&devip->num_in_q);
+				sqcp->a_cmnd = NULL;
+				spin_unlock_irqrestore(&queued_arr_lock,
+						       iflags);
 				if (scsi_debug_ndelay > 0) {
 					if (sqcp->sd_hrtp)
 						hrtimer_cancel(
@@ -2794,12 +2803,8 @@ static void stop_all_queued(void)
 					if (sqcp->tletp)
 						tasklet_kill(sqcp->tletp);
 				}
-				__clear_bit(k, queued_in_use_bm);
-				devip = (struct sdebug_dev_info *)
-					sqcp->a_cmnd->device->hostdata;
-				if (devip)
-					atomic_dec(&devip->num_in_q);
-				sqcp->a_cmnd = NULL;
+				clear_bit(k, queued_in_use_bm);
+				spin_lock_irqsave(&queued_arr_lock, iflags);
 			}
 		}
 	}

--------------080804020404080006020101--

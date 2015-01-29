Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbbA2Nfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:35:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbbA2Nfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:35:51 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH] time, ntp: Do not update time_state in middle of leap second
Date: Thu, 29 Jan 2015 08:35:46 -0500
Message-Id: <1422538546-27097-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During leap second insertion testing it was noticed that a small window
exists where the time_state could be reset such that
time_state = TIME_OK, which then causes the leap second to not occur, or
causes the entire leap second state machine to fail.

While this is highly unlikely to ever happen in the real world it is
still something we should protect against, as breaking the state machine
is obviously bad.

If the time_state == TIME_OOP (ie, the leap second is in progress) do not
allow an external update to time_state.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 kernel/time/ntp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 28bf91c..f9ebf06 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -534,7 +534,8 @@ void ntp_notify_cmos_timer(void) { }
  */
 static inline void process_adj_status(struct timex *txc, struct timespec64 *ts)
 {
-	if ((time_status & STA_PLL) && !(txc->status & STA_PLL)) {
+	if ((time_status & STA_PLL) && !(txc->status & STA_PLL) &&
+	    (time_state != TIME_OOP)) {
 		time_state = TIME_OK;
 		time_status = STA_UNSYNC;
 		/* restart PPS frequency calibration */
-- 
1.7.9.3


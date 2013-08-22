Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab3HVQjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:39:31 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:23605 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3HVQj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:39:29 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 3/4] staging: ozwpan: Increment reference counter.
Date: Thu, 22 Aug 2013 17:38:50 +0100
Message-ID: <1377189531-24950-3-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377189531-24950-1-git-send-email-rupesh.gujare@atmel.com>
References: <1377189531-24950-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increment PD reference counter, on every timer event so that
we do not loose PD object by mistake.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozproto.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 8c2200b..d8ac823 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -497,7 +497,7 @@ void oz_pd_heartbeat_handler(unsigned long data)
 	spin_unlock_bh(&g_polling_lock);
 	if (apps)
 		oz_pd_heartbeat(pd, apps);
-
+	oz_pd_put(pd);
 }
 
 /*------------------------------------------------------------------------------
@@ -519,6 +519,7 @@ void oz_pd_timeout_handler(unsigned long data)
 		oz_pd_stop(pd);
 		break;
 	}
+	oz_pd_put(pd);
 }
 
 /*------------------------------------------------------------------------------
@@ -531,6 +532,7 @@ enum hrtimer_restart oz_pd_heartbeat_event(struct hrtimer *timer)
 	pd = container_of(timer, struct oz_pd, heartbeat);
 	hrtimer_forward_now(timer, ktime_set(pd->pulse_period /
 	MSEC_PER_SEC, (pd->pulse_period % MSEC_PER_SEC) * NSEC_PER_MSEC));
+	oz_pd_get(pd);
 	tasklet_schedule(&pd->heartbeat_tasklet);
 	return HRTIMER_RESTART;
 }
@@ -543,6 +545,7 @@ enum hrtimer_restart oz_pd_timeout_event(struct hrtimer *timer)
 	struct oz_pd *pd;
 
 	pd = container_of(timer, struct oz_pd, timeout);
+	oz_pd_get(pd);
 	tasklet_schedule(&pd->timeout_tasklet);
 	return HRTIMER_NORESTART;
 }
-- 
1.7.9.5


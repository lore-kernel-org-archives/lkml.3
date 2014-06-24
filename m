Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaFXPvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:51:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaFXPvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:51:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 17/26] nohz: Fix another inconsistency between CONFIG_NO_HZ=n and nohz=off
Date: Tue, 24 Jun 2014 11:50:40 -0400
Message-Id: <20140624154620.330797071@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154619.499002156@linuxfoundation.org>
References: <20140624154619.499002156@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 0e576acbc1d9600cf2d9b4a141a2554639959d50 upstream.

If CONFIG_NO_HZ=n tick_nohz_get_sleep_length() returns NSEC_PER_SEC/HZ.

If CONFIG_NO_HZ=y and the nohz functionality is disabled via the
command line option "nohz=off" or not enabled due to missing hardware
support, then tick_nohz_get_sleep_length() returns 0. That happens
because ts->sleep_length is never set in that case.

Set it to NSEC_PER_SEC/HZ when the NOHZ mode is inactive.

Reported-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-sched.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -296,8 +296,10 @@ static void tick_nohz_stop_sched_tick(st
 			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
 	}
 
-	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
+	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE)) {
+		ts->sleep_length = (ktime_t) { .tv64 = NSEC_PER_SEC/HZ };
 		return;
+	}
 
 	if (need_resched())
 		return;



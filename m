Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbaFXQlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:41:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612AbaFXPw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:52:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.10 44/52] nohz: Fix another inconsistency between CONFIG_NO_HZ=n and nohz=off
Date: Tue, 24 Jun 2014 11:50:59 -0400
Message-Id: <20140624154716.124452652@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154713.428945460@linuxfoundation.org>
References: <20140624154713.428945460@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -720,8 +720,10 @@ static bool can_stop_idle_tick(int cpu,
 		return false;
 	}
 
-	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
+	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE)) {
+		ts->sleep_length = (ktime_t) { .tv64 = NSEC_PER_SEC/HZ };
 		return false;
+	}
 
 	if (need_resched())
 		return false;



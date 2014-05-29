Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934733AbaE2FjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:39:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaE2Eew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linaro-kernel@lists.linaro.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org
Subject: [PATCH 3.14 018/140] tick-sched: Dont call update_wall_time() when delta is lesser than tick_period
Date: Wed, 28 May 2014 21:32:37 -0700
Message-Id: <20140529043051.680646547@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 03e6bdc5c4d0fc166bfd5d3cf749a5a0c1b5b1bd upstream.

In tick_do_update_jiffies64() we are processing ticks only if delta is
greater than tick_period. This is what we are supposed to do here and
it broke a bit with this patch:

commit 47a1b796 (tick/timekeeping: Call update_wall_time outside the
jiffies lock)

With above patch, we might end up calling update_wall_time() even if
delta is found to be smaller that tick_period. Fix this by returning
when the delta is less than tick period.

[ tglx: Made it a 3 liner and massaged changelog ]

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Cc: fweisbec@gmail.com
Cc: Arvind.Chauhan@arm.com
Cc: linaro-networking@linaro.org
Cc: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/80afb18a494b0bd9710975bcc4de134ae323c74f.1397537987.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-sched.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -84,6 +84,9 @@ static void tick_do_update_jiffies64(kti
 
 		/* Keep the tick_next_period variable up to date */
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
+	} else {
+		write_sequnlock(&jiffies_lock);
+		return;
 	}
 	write_sequnlock(&jiffies_lock);
 	update_wall_time();



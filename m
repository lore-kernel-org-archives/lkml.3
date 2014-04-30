Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbaD3IsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:48:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:19412 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbaD3IsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:48:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,957,1389772800"; 
   d="scan'208";a="531174362"
From: Leon Ma <xindong.ma@intel.com>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: Leon Ma <xindong.ma@intel.com>
Subject: [PATCH] hrtimer:do not start hrtimer on other cpu if it is the leftmost timer.
Date: Wed, 30 Apr 2014 16:43:10 +0800
Message-Id: <1398847391-5994-1-git-send-email-xindong.ma@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On SMP system, if cpuX is idle and it starts an hrtimer, the timer
will be started on cpuY. But it can not reprogram the event source
on cpuY. The timer is inserted into rb tree of cpuY, if it is the
leftmost timer on cpuY and it is a very short timer, following hrtimers
started on cpuY will also not set the event source. As a result,
the timers on cpuY will expire later than expected.

When this case is detected, we should start the timer on cpuX and
program event source properly.

Signed-off-by: Leon Ma <xindong.ma@intel.com>
---
 kernel/hrtimer.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index d55092c..68becbc 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -234,6 +234,11 @@ again:
 			goto again;
 		}
 		timer->base = new_base;
+	} else {
+		if (cpu != this_cpu && hrtimer_check_target(timer, new_base)) {
+			cpu = this_cpu;
+			goto again;
+		}
 	}
 	return new_base;
 }
-- 
1.7.9.5


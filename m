Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbaGXKPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:15:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932857AbaGXKNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:13:46 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: uobergfe@redhat.com, dzickus@redhat.com, pbonzini@redhat.com,
        akpm@linux-foundation.org, mingo@redhat.com
Subject: [PATCH 1/3] watchdog: fix print-once on enable
Date: Thu, 24 Jul 2014 12:13:29 +0200
Message-Id: <1406196811-5384-2-git-send-email-drjones@redhat.com>
In-Reply-To: <1406196811-5384-1-git-send-email-drjones@redhat.com>
References: <1406196811-5384-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Obergfell <uobergfe@redhat.com>

This patch avoids printing the message 'enabled on all CPUs, ...'
multiple times. For example, the issue can occur in the following
scenario:

1) watchdog_nmi_enable() fails to enable PMU counters and sets
   cpu0_err.

2) 'echo [0|1] > /proc/sys/kernel/nmi_watchdog' is executed to
   disable and re-enable the watchdog mechanism 'on the fly'.

3) If watchdog_nmi_enable() succeeds to enable PMU counters, each
   CPU will print the message because step1 left behind a non-zero
   cpu0_err.

   if (!IS_ERR(event)) {
       if (cpu == 0 || cpu0_err)
       pr_info("enabled on all CPUs, ...")

The patch avoids this by clearing cpu0_err in watchdog_nmi_disable().

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 kernel/watchdog.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index c3319bd1b0408..c985a21926545 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -511,6 +511,9 @@ static void watchdog_nmi_disable(unsigned int cpu)
 		/* should be in cleanup, but blocks oprofile */
 		perf_event_release_kernel(event);
 	}
+	if (cpu == 0)
+		/* watchdog_nmi_enable() expects this to be zero initially. */
+		cpu0_err = 0;
 	return;
 }
 #else
-- 
1.9.3


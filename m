Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaLNUvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:51:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaLNUVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3.10 22/24] ARM: sched_clock: Load cycle count after epoch stabilizes
Date: Sun, 14 Dec 2014 12:20:42 -0800
Message-Id: <20141214201801.348507443@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201800.613573495@linuxfoundation.org>
References: <20141214201800.613573495@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit 336ae1180df5f69b9e0fb6561bec01c5f64361cf upstream.

There is a small race between when the cycle count is read from
the hardware and when the epoch stabilizes. Consider this
scenario:

 CPU0                           CPU1
 ----                           ----
 cyc = read_sched_clock()
 cyc_to_sched_clock()
                                 update_sched_clock()
                                  ...
                                  cd.epoch_cyc = cyc;
  epoch_cyc = cd.epoch_cyc;
  ...
  epoch_ns + cyc_to_ns((cyc - epoch_cyc)

The cyc on cpu0 was read before the epoch changed. But we
calculate the nanoseconds based on the new epoch by subtracting
the new epoch from the old cycle count. Since epoch is most likely
larger than the old cycle count we calculate a large number that
will be converted to nanoseconds and added to epoch_ns, causing
time to jump forward too much.

Fix this problem by reading the hardware after the epoch has
stabilized.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/arm/kernel/sched_clock.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -51,10 +51,11 @@ static inline u64 notrace cyc_to_ns(u64
 	return (cyc * mult) >> shift;
 }
 
-static unsigned long long notrace cyc_to_sched_clock(u32 cyc, u32 mask)
+static unsigned long long notrace sched_clock_32(void)
 {
 	u64 epoch_ns;
 	u32 epoch_cyc;
+	u32 cyc;
 
 	if (cd.suspended)
 		return cd.epoch_ns;
@@ -73,7 +74,9 @@ static unsigned long long notrace cyc_to
 		smp_rmb();
 	} while (epoch_cyc != cd.epoch_cyc_copy);
 
-	return epoch_ns + cyc_to_ns((cyc - epoch_cyc) & mask, cd.mult, cd.shift);
+	cyc = read_sched_clock();
+	cyc = (cyc - epoch_cyc) & sched_clock_mask;
+	return epoch_ns + cyc_to_ns(cyc, cd.mult, cd.shift);
 }
 
 /*
@@ -165,12 +168,6 @@ void __init setup_sched_clock(u32 (*read
 	pr_debug("Registered %pF as sched_clock source\n", read);
 }
 
-static unsigned long long notrace sched_clock_32(void)
-{
-	u32 cyc = read_sched_clock();
-	return cyc_to_sched_clock(cyc, sched_clock_mask);
-}
-
 unsigned long long __read_mostly (*sched_clock_func)(void) = sched_clock_32;
 
 unsigned long long notrace sched_clock(void)



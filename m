Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab3COAIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 20:08:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32946 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3COAIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 20:08:09 -0400
X-IronPort-AV: E=Sophos;i="4.84,848,1355126400"; 
   d="scan'208";a="29606757"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: sched_clock: Add more notrace to prevent recursion
Date: Thu, 14 Mar 2013 17:08:06 -0700
Message-Id: <1363306086-23501-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cyc_to_sched_clock() is called by sched_clock() and cyc_to_ns()
is called by cyc_to_sched_clock(). I suspect that some compilers
inline both of these functions into sched_clock() and so we've
been getting away without having a notrace marking. It seems that
my compiler isn't inlining cyc_to_sched_clock() though, so I'm
hitting a recursion bug when I enable the function graph tracer,
causing my system to crash. Marking these functions notrace fixes
it. Technically cyc_to_ns() doesn't need the notrace because it's
already marked inline, but let's just add it so that if we ever
remove inline from that function it doesn't blow up.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/sched_clock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index bd6f56b..59d2adb 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -45,12 +45,12 @@ static u32 notrace jiffy_sched_clock_read(void)
 
 static u32 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
 
-static inline u64 cyc_to_ns(u64 cyc, u32 mult, u32 shift)
+static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 {
 	return (cyc * mult) >> shift;
 }
 
-static unsigned long long cyc_to_sched_clock(u32 cyc, u32 mask)
+static unsigned long long notrace cyc_to_sched_clock(u32 cyc, u32 mask)
 {
 	u64 epoch_ns;
 	u32 epoch_cyc;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


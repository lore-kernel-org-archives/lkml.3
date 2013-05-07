Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab3EGNnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:43:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42661 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933439Ab3EGNmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 118/118] ARM: 7699/1: sched_clock: Add more notrace to prevent recursion
Date: Tue,  7 May 2013 14:39:24 +0100
Message-Id: <1367933964-1564-119-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit cea15092f098b7018e89f64a5a14bb71955965d5 upstream.

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
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/sched_clock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index 6bbf936..926c98f 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -39,12 +39,12 @@ static u32 notrace jiffy_sched_clock_read(void)
 
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
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163Ab3D2TdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:33:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759594Ab3D2TCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 41/42] ARM: 7699/1: sched_clock: Add more notrace to prevent recursion
Date: Mon, 29 Apr 2013 12:02:23 -0700
Message-Id: <20130429184757.010994053@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/sched_clock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -45,12 +45,12 @@ static u32 notrace jiffy_sched_clock_rea
 
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



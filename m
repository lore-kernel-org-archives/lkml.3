Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447Ab3EGEZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:25:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757024Ab3EGEZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:36 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=H4pVhOlhE9IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=rl_xSDhwSTgA:10 a=LpQP-O61AAAA:8 a=drOt6m5kAAAA:8 a=Gu_AdNV9dhMaPxAa7QQA:9 a=YDjxKKMXsvQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035901.806171725@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:59:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [125/126] ARM: 7699/1: sched_clock: Add more notrace to prevent recursion
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0125-ARM-7699-1-sched_clock-Add-more-notrace-to-prevent-r.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

[ Upstream commit cea15092f098b7018e89f64a5a14bb71955965d5 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/kernel/sched_clock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index f451539..4975d1f 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -41,12 +41,12 @@ static u32 notrace jiffy_sched_clock_read(void)
 
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
1.7.10.4



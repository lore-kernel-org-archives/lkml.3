Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3HBOTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:19:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:57329 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3HBOT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:19:29 -0400
Date: Fri, 2 Aug 2013 10:19:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.10.4-rt1
Message-ID: <20130802141936.GA8267@windriver.com>
References: <alpine.DEB.2.02.1308011215160.4089@ionos.tec.linutronix.de>
 <CAP=VYLp1ERhS4cFtgXGHL2DfCGoJ9VbPvShH5ZOWCpPuSzQY6w@mail.gmail.com>
 <1375419917.3743.93.camel@pasglop>
 <51FBA9CC.2090206@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <51FBA9CC.2090206@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [ANNOUNCE] 3.10.4-rt1] On 02/08/2013 (Fri 14:45) Sebastian Andrzej Siewior wrote:

> On 08/02/2013 07:05 AM, Benjamin Herrenschmidt wrote:
> > On Thu, 2013-08-01 at 20:03 -0400, Paul Gortmaker wrote:
> >> I've added Ben to the CC in case he has a suggestion on
> >> how best to fix this, even though it is not yet mainline.
> > 
> > Can you exchange with a TIF_ that isn't used in asm ? For example
> > TIF_PERFMON_* ? Keep all the asm ones below 16 and move up the ones
> > that are used in C only ?
> 
> I going to look later at this. I think I swapped one of the TIF_
> defines in v3.8 so it should work.

Yep, 3.8 shuffled TIF_MEMDIE to the end of the queue, but
in 3.10, mainline commit 22ecbe8dcef has already done that trick.

The list of donor victims that aren't used in asm is getting
smaller, but TIF_POLLING_NRFLAG seems OK and it puts RESCHED
and RESCHED_LAZY right beside each other.

Thanks guys,
Paul.
--

diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index 2469444..f50711f 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -92,8 +92,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
-#define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
-					   TIF_NEED_RESCHED */
+#define TIF_NEED_RESCHED_LAZY	3	/* lazy rescheduling necessary */
 #define TIF_32BIT		4	/* 32 bit binary */
 #define TIF_PERFMON_WORK	5	/* work for pfm_handle_work() */
 #define TIF_PERFMON_CTXSW	6	/* perfmon needs ctxsw calls */
@@ -109,7 +108,8 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_EMULATE_STACK_STORE	16	/* Is an instruction emulation
 						for stack store? */
 #define TIF_MEMDIE		17	/* is terminating due to OOM killer */
-#define TIF_NEED_RESCHED_LAZY	18	/* lazy rescheduling necessary */
+#define TIF_POLLING_NRFLAG	18	/* true if poll_idle() is polling
+					   TIF_NEED_RESCHED */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)

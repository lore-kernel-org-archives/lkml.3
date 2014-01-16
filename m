Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaAPPms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:42:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40357 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaAPPmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:42:46 -0500
Date: Thu, 16 Jan 2014 16:42:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: raistlin@linux.it, juri.lelli@gmail.com, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
Message-ID: <20140116154239.GR7572@laptop.programming.kicks-ass.net>
References: <52D64676.4040000@linaro.org>
 <20140115120418.GD31570@twins.programming.kicks-ass.net>
 <52D7E343.40909@linaro.org>
 <20140116141743.GT31570@twins.programming.kicks-ass.net>
 <52D7EAA4.2080208@linaro.org>
 <20140116142546.GU31570@twins.programming.kicks-ass.net>
 <52D7ED0A.2030502@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D7ED0A.2030502@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 03:30:34PM +0100, Daniel Lezcano wrote:
> On 01/16/2014 03:25 PM, Peter Zijlstra wrote:
> >On Thu, Jan 16, 2014 at 03:20:20PM +0100, Daniel Lezcano wrote:
> >>Already tested. The last commits do not change the issue described above.
> >
> >Bummer, ok, what version of Ubuntu/rsyslogd are you using? I have a
> >laptop around that should have some recent ubuntu on it, let me go find
> >it.
> 
> It is a Ubuntu 12.04 and rsyslog 5.8.6-1ubuntu8.4

My laptop has 12.10, I've not yet tried to reproduce but while staring
at the code I noticed a difference with the other can_nice() tests.

Could you try the below while I build a pristine tip/master for the
laptop?

---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0326c06953eb..e4a3f7e3d613 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3298,7 +3298,7 @@ static int __sched_setscheduler(struct task_struct *p,
 	 */
 	if (user && !capable(CAP_SYS_NICE)) {
 		if (fair_policy(policy)) {
-			if (!can_nice(p, attr->sched_nice))
+			if (attr->sched_nice < TASK_NICE(p) && !can_nice(p, attr->sched_nice))
 				return -EPERM;
 		}
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbaGWOgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:36:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:37279 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbaGWOgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:36:37 -0400
Date: Wed, 23 Jul 2014 16:36:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        stable@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH] sched: fix sched_setparam() policy=-1 logic
Message-ID: <20140723143632.GV3935@laptop>
References: <9ebe0566a08dbbb3999759d3f20d6004bb2dbcfa.1406079891.git.bristot@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ebe0566a08dbbb3999759d3f20d6004bb2dbcfa.1406079891.git.bristot@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 11:27:41PM -0300, Daniel Bristot de Oliveira wrote:
> The scheduler uses policy=-1 to preserve the current policy state to
> implement sched_setparam(). But, as (int) -1 is equals to 0xffffffff,
> it's matching the if (policy & SCHED_RESET_ON_FORK) on
> _sched_setscheduler(). This match changes the policy value to an
> invalid value, breaking the sched_setparam() syscall.
> 
> This patch checks policy=-1 before check the SCHED_RESET_ON_FORK flag.
> 
> The following program shows the bug:
> 
> int main(void)
> {
> 	struct sched_param param = {
> 		.sched_priority = 5,
> 	};
> 
> 	sched_setscheduler(0, SCHED_FIFO, &param);
> 	param.sched_priority = 1;
> 	sched_setparam(0, &param);
> 	param.sched_priority = 0;
> 	sched_getparam(0, &param);
> 	if (param.sched_priority != 1)
> 		printf("failed priority setting (found %d instead of 1)\n",
> 			param.sched_priority);
> 	else
> 		printf("priority setting fine\n");
> }
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org # 3.14+
> Fixes: 7479f3c9cf67 "sched: Move SCHED_RESET_ON_FORK into attr::sched_flags"
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>

Thanks!

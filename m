Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaJDIpL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 04:45:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48884 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbaJDIpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 04:45:09 -0400
Date: Sat, 4 Oct 2014 10:44:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at kernel/sched/core.c:7156
 __might_sleep()
Message-ID: <20141004084459.GU10583@worktop.programming.kicks-ass.net>
References: <20140930080228.GD9561@wfg-t540p.sh.intel.com>
 <20141002110927.GE2849@worktop.programming.kicks-ass.net>
 <20141002123150.GC6324@worktop.programming.kicks-ass.net>
 <20141002124247.GD6324@worktop.programming.kicks-ass.net>
 <20141002201020.GA8907@redhat.com>
 <20141003115020.GG10583@worktop.programming.kicks-ass.net>
 <20141003175654.GA14952@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141003175654.GA14952@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 07:56:54PM +0200, Oleg Nesterov wrote:
> Or. perhaps we can change wait_woken
> 
> 	-	set_current_state(mode);
> 	+	if (mode)
> 	+		set_current_state(mode);
> 
> 
> then rfcomm_run() can do
> 
> 	for (;;) {
> 		rfcomm_process_sessions();
> 
> 		set_current_state(TASK_INTERRUPTIBLE);
> 		if (kthread_should_stop())
> 			break;
> 		wait_woken(0);
> 	}
> 
> Or perhaps we can split wait_woken() into 2 helpers,
> 
> 	static inline long wait_woken(wq, mode, timeout)
> 	{
> 		set_current_state(mode);
> 		schedule_woken(wq, timeout); // does the rest
> 	}
> 
> to avoid "mode == 0" hack; rfcomm_run() should use schedule_woken().
> 
> What do you think?

Clever, I'm not entirely sure which I prefer, I think I'm leaning
towards the first one with the !mode hack, but let me sit on that for a
little while.

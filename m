Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761147Ab3D3SIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:08:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28138 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760203Ab3D3SIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:08:17 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0PU5dpyy9WsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=WXPJDuwjcIAA:10 a=aJB4RZhQg9PxH3wxNl8A:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367345295.30667.68.camel@gandalf.local.home>
Subject: Re: Suspend resume problem (WAS Re: [ANNOUNCE] 3.8.10-rt6)
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Clark Williams <williams@redhat.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 30 Apr 2013 14:08:15 -0400
In-Reply-To: <20130430170948.GB4688@linutronix.de>
References: <20130429201202.GB7979@linutronix.de>
	 <20130429161925.2a6ea78a@riff.lan> <20130430170948.GB4688@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-30 at 19:09 +0200, Sebastian Andrzej Siewior wrote:

> The next thing that happens is that RCU assumes nobody is doing any
> progress (for almost 28secs) and triggers NMIs & printks to get some
> attention. I have a trace where
> - CPU0: arch_trigger_all_cpu_backtrace_handler() => printk()
>         has "lock" and is spinning for logbuf_lock
> 
> - CPU1: print_cpu_stall() => printk() (spinning for the lock) => NMI =>
>   arch_trigger_all_cpu_backtrace_handler()
>         it may have logbuf_lock and is spinning for "lock"
> 
> I can't tell if CPU1 got the logbuf_lock at this time but it seemed that
> it made no progress until I ended it.
> This NMI releated deadlock is a problem which should also trigger
> mainline, right?

Well, yeah, as sending out a NMI stack dump is sorta the last resort,
and is dangerous to do printks from NMI context.

> 
> Now, the time jump on the other hand is the real issue here and is
> RT-only. It looks like we get a big number of timer updates via
> tick_do_update_jiffies64() because according to ktime_get() that much
> time really passed by.

As the NMI dump only happens because of the time jump, which as you
said, is -rt only, I wouldn't say that the NMI deadlock is a mainline
bug.

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645Ab3EBVTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:19:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:41998 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056Ab3EBVTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:19:07 -0400
Date: Thu, 2 May 2013 23:19:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: clockevents_program_event WARN_ON preventing boot.
In-Reply-To: <CAE9FiQXpV451xTzAJyNdC-+-oqF9v8Cy5evcNOHKFffERw2SwA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1305022304370.2891@ionos>
References: <20130430212007.GB18598@redhat.com> <20130430213719.GA14988@redhat.com> <alpine.LFD.2.02.1305021234510.3972@ionos> <20130502154621.GA23990@redhat.com> <alpine.LFD.2.02.1305022152280.2891@ionos>
 <CAE9FiQXpV451xTzAJyNdC-+-oqF9v8Cy5evcNOHKFffERw2SwA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Yinghai Lu wrote:
> On Thu, May 2, 2013 at 12:58 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> >
> > The check should be:
> >
> >     if (td->evtdev && tick_device_is_functional(td->evtdev))
> 
> still happens.
> 
> [    3.457866] checking TSC synchronization [CPU#0 -> CPU#10]: passed.
> [    3.460806] SMP alternatives: lockdep: fixing up alternatives
> [    3.464282] ------------[ cut here ]------------
> [    3.464297] WARNING: at kernel/time/clockevents.c:209
> clockevents_program_event+0x3b/0x100()

I didn't expect it to fix the warning, I just wanted to prevent the
crash which Dave decoded. Though the warning and the crash have
probably the same root cause...

> [    3.464300] Modules linked in:
> [    3.464306] CPU: 10 PID: 0 Comm: swapper/10 Not tainted
> 3.9.0-yh-08066-g1252014-dirty #1537
> [    3.464308] Hardware name: Oracle Corporation  unknown       /
> , BIOS 11016600    05/17/2011
> [    3.464327]  0000000000000009 ffff88203e203ed8 ffffffff82091022
> ffff88203e203f18
> [    3.464343]  ffffffff81088990 ffff88203e203f08 80000000003d08ff
> 80000000003d08ff
> [    3.464359]  000000000000000a ffff881027557fd8 0000000000000000
> ffff88203e203f28
> [    3.464361] Call Trace:
> [    3.464379]  <IRQ>  [<ffffffff82091022>] dump_stack+0x19/0x1b
> [    3.464392]  [<ffffffff81088990>] warn_slowpath_common+0x70/0xa0
> [    3.464395]  [<ffffffff810889da>] warn_slowpath_null+0x1a/0x20
> [    3.464399]  [<ffffffff810e312b>] clockevents_program_event+0x3b/0x100
> [    3.464403]  [<ffffffff810e35ec>] tick_handle_periodic+0x4c/0x80

Now, that's really odd.

     next = ktime_add(dev->next_event, tick_period);

     clockevents_program_event(dev, next, false);

     and next.tv64 is < 0 !?!

Can you please apply the following debug patch and provide the output?

Thanks,

	tglx

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index c6d6400..b4d9622 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -207,6 +207,8 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
 
 	if (unlikely(expires.tv64 < 0)) {
 		WARN_ON_ONCE(1);
+		printk_once(KERN_INFO "expires %llx, dev->next %llx\n",
+			    expires.tv64, dev->next_event.tv64);
 		return -ETIME;
 	}
 

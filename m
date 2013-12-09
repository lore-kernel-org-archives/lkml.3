Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab3LIW2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 17:28:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:41407 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab3LIW2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 17:28:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,860,1378882800"; 
   d="scan'208";a="421914106"
Date: Mon, 9 Dec 2013 23:27:58 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Francis Moreau <francis.moro@gmail.com>,
        Wei WANG <wei_wang@realsil.com.cn>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jingoo Han <jg1.han@samsung.com>,
        "'Wei WANG'" <wei_wang@realsil.com.cn>,
        "'Chris Ball'" <cjb@laptop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20131209222758.GC8612@zurbaran>
References: <4523614.I5MBhorHFt@vostro.rjw.lan>
 <5292FF5D.1050304@gmail.com>
 <1821758.2MoNI3h1Mv@vostro.rjw.lan>
 <52985041.5050000@gmail.com>
 <alpine.DEB.2.02.1311290958560.30673@ionos.tec.linutronix.de>
 <5299FF38.7060203@gmail.com>
 <alpine.DEB.2.02.1312021145190.30673@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1312021219090.30673@ionos.tec.linutronix.de>
 <529D92D6.8050409@gmail.com>
 <52A61B0C.6030305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A61B0C.6030305@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Francis,

On Mon, Dec 09, 2013 at 08:33:32PM +0100, Francis Moreau wrote:
> On 12/03/2013 09:14 AM, Francis Moreau wrote:
> > Hello Thomas,
> > 
> > On 12/02/2013 12:20 PM, Thomas Gleixner wrote:
> >> On Mon, 2 Dec 2013, Thomas Gleixner wrote:
> >>> On Sat, 30 Nov 2013, Francis Moreau wrote:
> >>>> Hello Thomas,
> >>>>
> >>>> Sorry for the delay.
> >>>>
> >>>> On 11/29/2013 10:02 AM, Thomas Gleixner wrote:
> >>>>> On Fri, 29 Nov 2013, Francis Moreau wrote:
> >>>>>> Since it seems to be related to rtsx driver or its upper layer, could
> >>>>>> the folks involved in this area have a look to this issue please ?
> >>>>>
> >>>>> I'm not involved, but looking at the debug objects backtrace it's
> >>>>> related to the delayed work in rtsx.
> >>>>>
> >>>>> Does the untested patch below cure the issue?
> >>>>>
> >>>>
> >>>> It seems it does since I can't see the debug object trace anymore
> >>>> however Ican see this now:
> >>>
> >>> <SNIP>
> >>>  
> >>>> So I don't think it completely solve the problem but it's a good start.
> >>>
> >>> I kinda expected that, but I wanted to confirm my suspicion, that the
> >>> interrupt hits after the delayed work is canceled and just requeues it
> >>> again, which then leads to an armed timer being freed further down.
> >>>
> >>> I'm not familiar with that driver and I leave the final fixup to the
> >>> driver maintainers. It's enough data for them to figure out the real
> >>> solution.
> >>
> >> Just had a quick look and the obvious solution is to disable the
> >> interrupts at the device level _BEFORE_ doing anything else in the
> >> teardown path. Updated patch below. That should avoid the nobody cared
> >> splat on the other irq line.
> >>
> > 
> > Yes it does.
> > 
> > Now that you did the hard work, I hope driver's maintainer/developper
> > will care about this issue.
> > 
> 
> Unfortunately he/she doesn't seem to care.
> 
> Moreover I've been by this now:
> 
> [  241.003324] INFO: task kworker/u16:4:108 blocked for more than 120
> seconds.
> [  241.003331]       Not tainted 3.12.2-1-ARCH #1
> [  241.003332] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  241.003335] kworker/u16:4   D ffff880405bc8000     0   108      2
> 0x00000000
> [  241.003355] Workqueue: kmemstick memstick_check [memstick]
> [  241.003358]  ffff880405bc3c90 0000000000000046 00000000000144c0
> ffff880405bc3fd8
> [  241.003362]  ffff880405bc3fd8 00000000000144c0 ffff880405bc8000
> ffff880405bc3c68
> [  241.003366]  ffffffff814ef57c ffff880405bc3fd8 0000000000000286
> 0000000000000000
> [  241.003370] Call Trace:
> [  241.003380]  [<ffffffff814ef57c>] ? schedule_timeout+0x13c/0x290
> [  241.003385]  [<ffffffff8106f590>] ? detach_if_pending+0x120/0x120
> [  241.003388]  [<ffffffff8106f590>] ? detach_if_pending+0x120/0x120
> [  241.003392]  [<ffffffff814f2e79>] schedule+0x29/0x70
> [  241.003396]  [<ffffffff814ef659>] schedule_timeout+0x219/0x290
> [  241.003401]  [<ffffffff8129a4d1>] ? vsnprintf+0x1e1/0x680
> [  241.003405]  [<ffffffff814f2213>] wait_for_common+0xd3/0x180
> [  241.003411]  [<ffffffff81095100>] ? wake_up_process+0x40/0x40
> [  241.003414]  [<ffffffff814f22dd>] wait_for_completion+0x1d/0x20
> [  241.003419]  [<ffffffffa061334a>] memstick_set_rw_addr+0x4a/0x50
> [memstick]
> [  241.003424]  [<ffffffffa061388e>] memstick_check+0x10e/0x370 [memstick]
> [  241.003429]  [<ffffffff8107daf7>] process_one_work+0x167/0x450
> [  241.003432]  [<ffffffff8107e501>] worker_thread+0x121/0x3a0
> [  241.003436]  [<ffffffff8107e3e0>] ? manage_workers.isra.23+0x2b0/0x2b0
> [  241.003441]  [<ffffffff81084e90>] kthread+0xc0/0xd0
> [  241.003446]  [<ffffffff81084dd0>] ? kthread_create_on_node+0x120/0x120
> [  241.003450]  [<ffffffff814fc33c>] ret_from_fork+0x7c/0xb0
> [  241.003454]  [<ffffffff81084dd0>] ? kthread_create_on_node+0x120/0x120
> 
> looks like a different issue.
Indeed. I assume you don't see issue that on the resume path ?
Wei, is that something you've ever seen with the rtsx memstick driver ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

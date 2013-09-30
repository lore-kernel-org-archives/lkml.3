Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3I3Xo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 19:44:28 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:39322 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3I3Xo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 19:44:27 -0400
Message-ID: <1380584663.2562.27.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: IRQ affinity notifiers vs RT
From: Ben Hutchings <bhutchings@solarflare.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 1 Oct 2013 00:44:23 +0100
In-Reply-To: <52403B0B.1060305@linutronix.de>
References: <1374708683.1732.38.camel@bwh-desktop.uk.level5networks.com>
	 <1377898155.4629.11.camel@bwh-desktop.uk.level5networks.com>
	 <52403B0B.1060305@linutronix.de>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20184.005
X-TM-AS-Result: No--40.180000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 14:58 +0200, Sebastian Andrzej Siewior wrote:
> On 08/30/2013 11:29 PM, Ben Hutchings wrote:
> > Sebastian, I saw you came up with a fix for this but apparently without
> > seeing my earlier message:
> 
> Yes Ben, I haven't seen it. If I was on Cc I very sorry for overlooking
> it.

You weren't, as I didn't realise you were maintaining the RT patch set
then.

> > On Thu, 2013-07-25 at 00:31 +0100, Ben Hutchings wrote:
> 
> >> Workqueue code uses spin_lock_irq() on the workqueue lock, which with
> >> PREEMPT_RT enabled doesn't actually block IRQs.
> >>
> >> In 3.6, the irq_cpu_rmap functions relies on a workqueue flush to finish
> >> any outstanding notifications before freeing the cpu_rmap that they use.
> >> This won't be reliable if the notification is scheduled after releasing
> >> the irq_desc lock.
> >>
> >> However, following commit 896f97ea95c1 ('lib: cpu_rmap: avoid flushing
> >> all workqueues') in 3.8, I think that it is sufficient to do only
> >> kref_get(&desc->affinity_notify->kref) in __irq_set_affinity_locked()
> >> and then call schedule_work() in irq_set_affinity() after releasing the
> >> lock.  Something like this (untested):
> > 
> > Does the following make sense to you?
> 
> This was suggested by the original submitter on rt-users@v.k.o (Joe
> Korty) where I've been made aware of this for the first time. This okay
> except for the part where the workqueue is not scheduled if calling by
> the __ function (i.e. the mips case). If I read the code correctly, the
> CPU goes offline and affinity change should be updated / users notified
> and this is not the case with this patch.
> 
> It is a valid question why only one mips SoC needs the function. If you
> look at commit 0c3263870f ("MIPS: Octeon: Rewrite interrupt handling
> code.") you can see that tglx himself made this adjustment so it might
> be valid :) Therefore I assume that we may get more callers of this
> function and the workqueue should be executed and I made something
> simple that works on RT.

Right, but it looks quite strange to have this thread just for a
(probably) quite rare event.  Maybe some day someone will work out how
to make Octeon's IRQ management less unusual and then you can use the
simpler approach for RT...

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


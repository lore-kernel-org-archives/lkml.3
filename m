Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3IWM7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:59:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:50408 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab3IWM67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:58:59 -0400
Message-ID: <52403B0B.1060305@linutronix.de>
Date: Mon, 23 Sep 2013 14:58:51 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130821 Icedove/17.0.8
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: IRQ affinity notifiers vs RT
References: <1374708683.1732.38.camel@bwh-desktop.uk.level5networks.com> <1377898155.4629.11.camel@bwh-desktop.uk.level5networks.com>
In-Reply-To: <1377898155.4629.11.camel@bwh-desktop.uk.level5networks.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 11:29 PM, Ben Hutchings wrote:
> Sebastian, I saw you came up with a fix for this but apparently without
> seeing my earlier message:

Yes Ben, I haven't seen it. If I was on Cc I very sorry for overlooking
it.

> On Thu, 2013-07-25 at 00:31 +0100, Ben Hutchings wrote:

>> Workqueue code uses spin_lock_irq() on the workqueue lock, which with
>> PREEMPT_RT enabled doesn't actually block IRQs.
>>
>> In 3.6, the irq_cpu_rmap functions relies on a workqueue flush to finish
>> any outstanding notifications before freeing the cpu_rmap that they use.
>> This won't be reliable if the notification is scheduled after releasing
>> the irq_desc lock.
>>
>> However, following commit 896f97ea95c1 ('lib: cpu_rmap: avoid flushing
>> all workqueues') in 3.8, I think that it is sufficient to do only
>> kref_get(&desc->affinity_notify->kref) in __irq_set_affinity_locked()
>> and then call schedule_work() in irq_set_affinity() after releasing the
>> lock.  Something like this (untested):
> 
> Does the following make sense to you?

This was suggested by the original submitter on rt-users@v.k.o (Joe
Korty) where I've been made aware of this for the first time. This okay
except for the part where the workqueue is not scheduled if calling by
the __ function (i.e. the mips case). If I read the code correctly, the
CPU goes offline and affinity change should be updated / users notified
and this is not the case with this patch.

It is a valid question why only one mips SoC needs the function. If you
look at commit 0c3263870f ("MIPS: Octeon: Rewrite interrupt handling
code.") you can see that tglx himself made this adjustment so it might
be valid :) Therefore I assume that we may get more callers of this
function and the workqueue should be executed and I made something
simple that works on RT.

> 
> Ben.
> 

Sebastian

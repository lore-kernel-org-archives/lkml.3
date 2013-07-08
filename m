Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3GHNFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:05:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab3GHNFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:05:13 -0400
Message-ID: <51DAB8DF.6060806@redhat.com>
Date: Mon, 08 Jul 2013 09:04:31 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, athorlton@sgi.com,
        CAI Qian <caiqian@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: BUG: tick device NULL pointer during system initialization and
 shutdown
References: <51C0AB09.2090605@redhat.com> <alpine.DEB.2.02.1306241551020.4013@ionos.tec.linutronix.de> <51CA2CBF.70404@redhat.com> <alpine.DEB.2.02.1306261303260.4013@ionos.tec.linutronix.de> <51CC708B.7040605@redhat.com> <alpine.DEB.2.02.1306281250270.4013@ionos.tec.linutronix.de> <51D17F2B.7000300@redhat.com> <alpine.DEB.2.02.1307011518350.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307011518350.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/01/2013 09:30 AM, Thomas Gleixner wrote:
> On Mon, 1 Jul 2013, Prarit Bhargava wrote:
>> On 06/28/2013 06:52 AM, Thomas Gleixner wrote:
>>> Huch. Did the warning in the broadcast code trigger before that?
>>
>> tglx,
>>
>> AFAICT it does not.  Log below on the system I'm testing on.  The test on the
>> system is system boots, sleeps for 30 seconds and then reboots.
> 
>> [  270.563197] INFO: rcu_sched detected stalls on CPUs/tasks: { 51} (detected by
>> 63, t=217205 jiffies, g=3583, c=3582, q=578)
> 
> So the stall is on CPU51, but we do not get a backtrace for CPU51. 
> 
> The backtrace trigger is only sent to online cpus. So CPU51 is offline
> already. Which makes sense as we are in the process of bringing CPUs
> down and the CPUs with backtrace are 0 and 53-63.
> 
> I'm pretty sure, that the patch which clears the stale flag is
> unrelated to this and it cures the NULL pointer dereference (the
> reason why this can happen is clear).
> 
> So now you do not longer trip over the NULL pointer dereference, but
> you see a weird RCU stall on an already DEAD cpu. Note, it's dead
> because we already took CPU52 offline as well.
> 
> Paul???

I hit this a few times ... but the frequency of hitting this is MUCH less than
that off the original bug.  So Thomas, can you add

Tested-by: Prarit Bhargava <prarit@redhat.com>

to the "tick: Make oneshot broadcast robust vs. CPU offlining" patch?

IMO that problem seems to be solved and we're just peeling the proverbial onion
and finding deeper bugs.

P.

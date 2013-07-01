Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3GANav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:30:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:55124 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab3GANau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:30:50 -0400
Date: Mon, 1 Jul 2013 15:30:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, athorlton@sgi.com,
        CAI Qian <caiqian@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: BUG: tick device NULL pointer during system initialization and
 shutdown
In-Reply-To: <51D17F2B.7000300@redhat.com>
Message-ID: <alpine.DEB.2.02.1307011518350.4013@ionos.tec.linutronix.de>
References: <51C0AB09.2090605@redhat.com> <alpine.DEB.2.02.1306241551020.4013@ionos.tec.linutronix.de> <51CA2CBF.70404@redhat.com> <alpine.DEB.2.02.1306261303260.4013@ionos.tec.linutronix.de> <51CC708B.7040605@redhat.com> <alpine.DEB.2.02.1306281250270.4013@ionos.tec.linutronix.de>
 <51D17F2B.7000300@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, Prarit Bhargava wrote:
> On 06/28/2013 06:52 AM, Thomas Gleixner wrote:
> > Huch. Did the warning in the broadcast code trigger before that?
> 
> tglx,
> 
> AFAICT it does not.  Log below on the system I'm testing on.  The test on the
> system is system boots, sleeps for 30 seconds and then reboots.

> [  270.563197] INFO: rcu_sched detected stalls on CPUs/tasks: { 51} (detected by
> 63, t=217205 jiffies, g=3583, c=3582, q=578)

So the stall is on CPU51, but we do not get a backtrace for CPU51. 

The backtrace trigger is only sent to online cpus. So CPU51 is offline
already. Which makes sense as we are in the process of bringing CPUs
down and the CPUs with backtrace are 0 and 53-63.

I'm pretty sure, that the patch which clears the stale flag is
unrelated to this and it cures the NULL pointer dereference (the
reason why this can happen is clear).

So now you do not longer trip over the NULL pointer dereference, but
you see a weird RCU stall on an already DEAD cpu. Note, it's dead
because we already took CPU52 offline as well.

Paul???

Thanks,

	tglx


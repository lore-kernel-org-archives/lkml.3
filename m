Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbbAVLQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:16:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:59176 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbbAVLP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:15:58 -0500
Date: Thu, 22 Jan 2015 12:15:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: aik@ozlabs.ru, shreyas@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, michael@ellerman.id.au,
        Anton Blanchard <anton@samba.org>, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V3] tick/broadcast: Make movement of broadcast hrtimer
 robust against hotplug
In-Reply-To: <54C09391.9080202@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1501221209260.5526@nanos>
References: <20150120103559.8430.50933.stgit@preeti.in.ibm.com> <alpine.DEB.2.11.1501211243270.5526@nanos> <54C09391.9080202@linux.vnet.ibm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Preeti U Murthy wrote:
> On 01/21/2015 05:16 PM, Thomas Gleixner wrote:
> How about when the cpu that is going offline receives a timer interrupt
> just before setting its state to CPU_DEAD ? That is still possible right
> given that its clock devices may not have been shutdown and it is
> capable of receiving interrupts for a short duration. Even with the
> above patch, is the following scenario possible ?
> 
>                 CPU0                                  CPU1
> t0         Receives timer interrupt
> 
> t1         Sees that there are hrtimers
>            to be serviced (hrtimers are not yet migrated)
> 
> t2         calls hrtimer_interrupt()
> 
> t3         tick_program_event()                   CPU_DEAD notifiers
>                                                 CPU0's td->evtdev = NULL
> 
> t4         clockevent_program_event()
>            references NULL tick device pointer
> 
> So my concern is that since the CLOCK_EVT_NOTIFY_CPU_DEAD callback
> handles shutting down of devices besides moving tick related duties.
> it's functions may race with the hotplug cpu still handling tick events.

  __cpu_disable() is supposed to block interrupts on the dying cpu.

But I agree, we should make it more robust. So we want an explicit
call for disabling the cpu local stuff and an explicit takeover of the
broadcast duty. I'm anyway distangling the clockevents_notify() stuff,
so it should be simple to do so.

Thanks,

	tglx



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbaAaUYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:24:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:56376 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaAaUYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:24:02 -0500
Message-ID: <52EC0658.3010205@linutronix.de>
Date: Fri, 31 Jan 2014 21:23:52 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 2/2] timer: really raise softirq if there is irq_work
 to do
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de> <1391178845-15837-2-git-send-email-bigeasy@linutronix.de> <20140131120757.594e24d6@gandalf.local.home> <20140131174227.GN9012@linux.vnet.ibm.com> <20140131125719.73340f6e@gandalf.local.home> <52EBF8FE.3080608@linutronix.de> <20140131143441.478f79ee@gandalf.local.home> <52EBFE1D.4020201@linutronix.de> <20140131200535.GR5002@laptop.programming.kicks-ass.net>
In-Reply-To: <20140131200535.GR5002@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 09:05 PM, Peter Zijlstra wrote:
> On Fri, Jan 31, 2014 at 08:48:45PM +0100, Sebastian Andrzej Siewior wrote:
>>
>> How "bad" is it? Is this something generic or just not getting
>> perf events fast enough out? Most users don't seem to require small
>> latencies.
> 
> I have vague memories of there being an actual perf problem if there's a
> hole between the NMI/IRQ triggering the irq_work and the interrupt
> running the work.
> 
> I should have some notes on it somewhere and an todo entry to plug the
> hole.
> 
> But note that the MCE code also uses irq_work, they really _need_ to be
> fast because the system might be crumbling under their feet.

Okay, this makes sense. What looked odd was the powerpc implementation
where they let the timer interrupt expire and call the irq_work from
the timer interrupt just before the clockevents callback is executed
(which would invoke the irq_work callback as well).

Would it be a win if we would remove the arch specific code and instead
raise the timer interrupt asap? It sure won't be a win or change for
-RT but it would allow all architectures to get irq_work done as soon
as possible in IRQ context (and out of NMI context if I understand
correct) without an arch specific implementation.

Sebastian

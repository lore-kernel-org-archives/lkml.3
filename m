Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbaAaTeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:34:46 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:48256 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754015AbaAaTeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:34:44 -0500
Date: Fri, 31 Jan 2014 14:34:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 2/2] timer: really raise softirq if there is irq_work to
 do
Message-ID: <20140131143441.478f79ee@gandalf.local.home>
In-Reply-To: <52EBF8FE.3080608@linutronix.de>
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>
	<1391178845-15837-2-git-send-email-bigeasy@linutronix.de>
	<20140131120757.594e24d6@gandalf.local.home>
	<20140131174227.GN9012@linux.vnet.ibm.com>
	<20140131125719.73340f6e@gandalf.local.home>
	<52EBF8FE.3080608@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014 20:26:54 +0100
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> On 01/31/2014 06:57 PM, Steven Rostedt wrote:
> 
> > In vanilla Linux, irq_work_run() is called from update_process_times()
> > when it is called from the timer interrupt. In -rt, there's reasons we
> 
> and in vanilla Linux some architectures (like x86 or sparc to name just
> a few) overwrite arch_irq_work_raise() which means they provide
> their "own" interrupt like callback. That means on those architectures
> irq_work_run() gets invoked twice: once via update_process_times() and
> via and once the custom interface.
> So my question to the original inventor of this code: Peter, do we
> really need that arch specific callback? Wouldn't one be enough? Is it
> that critical that it can't wait to the next timer tick?

There's flags that determine when the next call should be invoked. The
irq_work_run() should return immediately if it was already done by the
arch specific call. The work wont be called twice.

As I have worked on code that uses irq_work() I can say that we want
the arch specific interrupts. For those architectures that don't have
it will experience larger latencies for the work required. It's
basically, a "too bad" for them.

But to answer your question, no we want the immediate response.

-- Steve

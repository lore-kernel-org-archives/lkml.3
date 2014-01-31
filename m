Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbaAaT43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:56:29 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:32561 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932325AbaAaT41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:56:27 -0500
Date: Fri, 31 Jan 2014 14:56:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 2/2] timer: really raise softirq if there is irq_work to
 do
Message-ID: <20140131145625.51128a8b@gandalf.local.home>
In-Reply-To: <52EBFE1D.4020201@linutronix.de>
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>
	<1391178845-15837-2-git-send-email-bigeasy@linutronix.de>
	<20140131120757.594e24d6@gandalf.local.home>
	<20140131174227.GN9012@linux.vnet.ibm.com>
	<20140131125719.73340f6e@gandalf.local.home>
	<52EBF8FE.3080608@linutronix.de>
	<20140131143441.478f79ee@gandalf.local.home>
	<52EBFE1D.4020201@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014 20:48:45 +0100
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> > As I have worked on code that uses irq_work() I can say that we want
> > the arch specific interrupts. For those architectures that don't have
> > it will experience larger latencies for the work required. It's
> > basically, a "too bad" for them.
> 
> How "bad" is it? Is this something generic or just not getting
> perf events fast enough out? Most users don't seem to require small
> latencies.

I use it for waking up trace-cmd, and if it is too long, then it we can
miss lots of events. Same goes for perf.

Remember, irq_work can be triggered from NMI context. That means, if
the CPU is idle, it may be several seconds before that work happens.
That is WAY too long to wait.

Anyway, your suggestion to get rid of the arch code doesn't help. We
call the irq_work_run() from interrupt context whether there is work or
not, with or without removing the arch code. The only thing your
suggestion will do is to push the work from happening immediately to
happening on the timer tick (which may be several seconds later). I
don't see the savings.

-- Steve


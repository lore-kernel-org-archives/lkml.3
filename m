Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3FYXTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:19:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11529 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab3FYXTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:19:05 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=8s-umH0LeIcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=42X1cJGERjUA:10 a=uqEIXwxpYt2694rz75UA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372202344.18733.242.camel@gandalf.local.home>
Subject: Re: question about disabling interrupts for workqueue pool?
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clark@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Tue, 25 Jun 2013 19:19:04 -0400
In-Reply-To: <20130625230129.GA30407@mtj.dyndns.org>
References: <1372200754.18733.236.camel@gandalf.local.home>
	 <20130625230129.GA30407@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 16:01 -0700, Tejun Heo wrote:
> Hello, Steven.
> 
> On Tue, Jun 25, 2013 at 06:52:34PM -0400, Steven Rostedt wrote:
> > Now my question is, are those local_irq_*() calls just for synchronizing
> > with sched RCU? If so, can you use rcu_read_lock_sched() instead?
> 
> Hmmm... using local_irq_disable/enable() is more consistent as
> irq-safe locks are used widely in workqueue.  Also, using
> rcu_read_lock_sched() would mean that we'll have
> spin_lock_irq_save/restore() nested inside preempt_disable/enable(),
> which is a bit silly in upstream kernel.

Why is that silly? It actually makes plenty of sense. Now if
preempt_disable/enable was nested in spin_lock_irq_save/restore() now
that would be pretty silly.

What I mean is, even in mainline, we want interrupts enable as much as
possible, as that will allow devices and such to have their interrupts
delivered in a timely manner. If we can get away with just disabling
preemption then doing so would be better. That's the point of softirq.
We run those with interrupts enabled but preemption disabled, and
there's several cases that we disable interrupts in a softirq with
spin_lock_irq_save/restore.

Just looking at the first part of that function:

	local_irq_disable();
	pool = get_work_pool(work);
	if (!pool) {
		local_irq_enable();
		return false;
	}

On the case of poll == NULL, we disabled interrupts for no reason.

> 
> That said, both paths you pointed out are rather cold, so I don't
> think it'd matter.  Please feel free to send a patch with comment
> explaining why local irq flipping, which fits better there, isn't
> being used.

It may take a bit of understanding the code before I send a patch. But
I'll start looking into it.

Thanks,

-- Steve



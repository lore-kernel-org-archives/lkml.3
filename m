Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab3FYWwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 18:52:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31789 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab3FYWwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 18:52:36 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=xpoA3amYCf4A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=npYvvCUsI3cA:10 a=OCqfDqu9CtsUbkVxWngA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372200754.18733.236.camel@gandalf.local.home>
Subject: question about disabling interrupts for workqueue pool?
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clark@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Tue, 25 Jun 2013 18:52:34 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

We've been playing with porting -rt to 3.10, and one of the stumbling
blocks we are dealing with happens to be with commit fa1b54e69bc
"workqueue: update synchronization rules on worker_pool_idr".

The issue is with the disabling of interrupts, and specifically this
sequence of events from start_flush_work():

        local_irq_disable();
        pool = get_work_pool(work);
        if (!pool) {
                local_irq_enable();
                return false;
        }

        spin_lock(&pool->lock);
        /* see the comment in try_to_grab_pending() with the same code */
        pwq = get_work_pwq(work);
        if (pwq) {
                if (unlikely(pwq->pool != pool))
                        goto already_gone;
        } else {
                worker = find_worker_executing_work(pool, work);
                if (!worker)
                        goto already_gone;
                pwq = worker->current_pwq;
        }

        insert_wq_barrier(pwq, barr, work, worker);
        spin_unlock_irq(&pool->lock);


As -rt does not have spin_lock_irq() disable interrupts, it means that
spin_unlock_irq() will not enable them either. But that's not all:

        local_irq_save(flags);
        pool = get_work_pool(work);
        if (pool) {
                spin_lock(&pool->lock);
                if (find_worker_executing_work(pool, work))
                        ret |= WORK_BUSY_RUNNING;
                spin_unlock(&pool->lock);
        }
        local_irq_restore(flags);

Basically, anywhere you disable interrupts, as -rt converts spin_lock()
into a mutex.

Now my question is, are those local_irq_*() calls just for synchronizing
with sched RCU? If so, can you use rcu_read_lock_sched() instead?

This wont solve our problems, as we will need to deal with
rcu_read_lock_sched() critical sections sleeping, but it will at least
change the problem area away from workqueues, and will document the
workqueue code better because stand alone "local_irq_disable()"s tend to
bring up a lot of questions to "why do we need to disable interrupts
here?".

-- Steve




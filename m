Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3CKRic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:38:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab3CKRib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:38:31 -0400
Date: Mon, 11 Mar 2013 18:36:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Namhyung Kim <namhyung@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] kthread: kill task_get_live_kthread()
Message-ID: <20130311173625.GA13525@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Imho, task_get_live_kthread() is very confusing and unneeded.
2a1d4460 copied get_task_struct() + "vfork_done != NULL" from
kthread_stop(), but only kthread_stop() needs them both.

It needs get_task_struct() because kthread_stop() can be used
when the caller doesn't have a reference but we know that this
thread can't exit itself.

At the same time, if it can exit we do not need get_task_struct()
(the caller must have a reference) but we need to ensure we do not
use to_kthread(NULL) if it has exited.

I think that kthread_park/unpark can simply use to_kthread(), but
this series only removes get_task_struct() and keeps "alive" check.



But the actual reason for this cleanup is that I do not understand
why park/unpark abuse kthread.c.

Thomas, can't we move kthread->parked/cpu to smpboot_thread_data
and move all this code into kernel/smpboot.c? Just for example,
why kthread() does __kthread_parkme() ? smpboot_thread_fn() can do
this at the start.

Or this would be wrong/undesirable by some reason?

Oleg.


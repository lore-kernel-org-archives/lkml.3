Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab3CKVP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:15:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:37651 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab3CKVPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:52 -0400
Date: Mon, 11 Mar 2013 22:15:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] kthread: kill task_get_live_kthread()
In-Reply-To: <20130311173625.GA13525@redhat.com>
Message-ID: <alpine.LFD.2.02.1303112210490.22263@ionos>
References: <20130311173625.GA13525@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg,

On Mon, 11 Mar 2013, Oleg Nesterov wrote:
> Imho, task_get_live_kthread() is very confusing and unneeded.
> 2a1d4460 copied get_task_struct() + "vfork_done != NULL" from
> kthread_stop(), but only kthread_stop() needs them both.
> 
> It needs get_task_struct() because kthread_stop() can be used
> when the caller doesn't have a reference but we know that this
> thread can't exit itself.
> 
> At the same time, if it can exit we do not need get_task_struct()
> (the caller must have a reference) but we need to ensure we do not
> use to_kthread(NULL) if it has exited.
> 
> I think that kthread_park/unpark can simply use to_kthread(), but
> this series only removes get_task_struct() and keeps "alive" check.
>
> 
> But the actual reason for this cleanup is that I do not understand
> why park/unpark abuse kthread.c.

It's not abusing it :)
 
> Thomas, can't we move kthread->parked/cpu to smpboot_thread_data
> and move all this code into kernel/smpboot.c? Just for example,
> why kthread() does __kthread_parkme() ? smpboot_thread_fn() can do
> this at the start.

No objection. When I implemented this, I thought this would be the
correct place and I followed the conventions of kthread.c ...
 
> Or this would be wrong/undesirable by some reason?

Need to think about it, but probably it was just either copy and paste
stupidity or some form of paranoia.

What's the issue with that, other than some superflous task_get/put
calls ?

Thanks,

	tglx


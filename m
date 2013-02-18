Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3BRPvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:51:45 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:64296 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab3BRPvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:51:42 -0500
MIME-Version: 1.0
In-Reply-To: <20130218123913.26245.7713.stgit@srivatsabhat.in.ibm.com>
References: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com>
	<20130218123913.26245.7713.stgit@srivatsabhat.in.ibm.com>
Date: Mon, 18 Feb 2013 23:51:41 +0800
Message-ID: <CANN689Ec4g7jMapv8ChAEom+gEDQ8RDVLa07CKwJ==YO+MUUrA@mail.gmail.com>
Subject: Re: [PATCH v6 07/46] percpu_rwlock: Allow writers to be readers, and
 add lockdep annotations
From: Michel Lespinasse <walken@google.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        rjw@sisk.pl, sbw@mit.edu, fweisbec@gmail.com, linux@arm.linux.org.uk,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        vincent.guittot@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 8:39 PM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> @@ -200,6 +217,16 @@ void percpu_write_lock_irqsave(struct percpu_rwlock *pcpu_rwlock,
>
>         smp_mb(); /* Complete the wait-for-readers, before taking the lock */
>         write_lock_irqsave(&pcpu_rwlock->global_rwlock, *flags);
> +
> +       /*
> +        * It is desirable to allow the writer to acquire the percpu-rwlock
> +        * for read (if necessary), without deadlocking or getting complaints
> +        * from lockdep. To achieve that, just increment the reader_refcnt of
> +        * this CPU - that way, any attempt by the writer to acquire the
> +        * percpu-rwlock for read, will get treated as a case of nested percpu
> +        * reader, which is safe, from a locking perspective.
> +        */
> +       this_cpu_inc(pcpu_rwlock->rw_state->reader_refcnt);

I find this quite disgusting, but once again this may be because I
don't like unfair recursive rwlocks.

In my opinion, the alternative of explicitly not taking the read lock
when one already has the write lock sounds *much* nicer.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.

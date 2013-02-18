Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3BRQdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:33:42 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:47113 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab3BRQdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:33:39 -0500
Message-ID: <5122575E.5030405@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2013 22:01:26 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-doc@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        xiaoguangrong@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, rusty@rustcorp.com.au, rostedt@goodmis.org,
        rjw@sisk.pl, namhyung@kernel.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        oleg@redhat.com, vincent.guittot@linaro.org, sbw@mit.edu,
        tj@kernel.org, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 07/46] percpu_rwlock: Allow writers to be readers,
 and add lockdep annotations
References: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com> <20130218123913.26245.7713.stgit@srivatsabhat.in.ibm.com> <CANN689Ec4g7jMapv8ChAEom+gEDQ8RDVLa07CKwJ==YO+MUUrA@mail.gmail.com>
In-Reply-To: <CANN689Ec4g7jMapv8ChAEom+gEDQ8RDVLa07CKwJ==YO+MUUrA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021816-7014-0000-0000-0000029B34BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 09:21 PM, Michel Lespinasse wrote:
> On Mon, Feb 18, 2013 at 8:39 PM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> @@ -200,6 +217,16 @@ void percpu_write_lock_irqsave(struct percpu_rwlock *pcpu_rwlock,
>>
>>         smp_mb(); /* Complete the wait-for-readers, before taking the lock */
>>         write_lock_irqsave(&pcpu_rwlock->global_rwlock, *flags);
>> +
>> +       /*
>> +        * It is desirable to allow the writer to acquire the percpu-rwlock
>> +        * for read (if necessary), without deadlocking or getting complaints
>> +        * from lockdep. To achieve that, just increment the reader_refcnt of
>> +        * this CPU - that way, any attempt by the writer to acquire the
>> +        * percpu-rwlock for read, will get treated as a case of nested percpu
>> +        * reader, which is safe, from a locking perspective.
>> +        */
>> +       this_cpu_inc(pcpu_rwlock->rw_state->reader_refcnt);
> 
> I find this quite disgusting, but once again this may be because I
> don't like unfair recursive rwlocks.
> 

:-)

> In my opinion, the alternative of explicitly not taking the read lock
> when one already has the write lock sounds *much* nicer.

I don't seem to recall any strong reasons to do it this way, so I don't have
any strong opinions on doing it this way. But one of the things to note is that,
in the CPU Hotplug case, the readers are *way* more hotter than the writer.
So avoiding extra checks/'if' conditions/memory barriers in the reader-side
is very welcome. (If we slow down the read-side, we get a performance hit
even when *not* doing hotplug!). Considering this, the logic used in this
patchset seems better, IMHO.

Regards,
Srivatsa S. Bhat


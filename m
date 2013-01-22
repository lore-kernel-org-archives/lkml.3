Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3AVUAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 15:00:30 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:42971 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab3AVUA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 15:00:26 -0500
Message-ID: <50FEEF5D.6080302@linux.vnet.ibm.com>
Date: Wed, 23 Jan 2013 01:28:21 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-doc@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        xiaoguangrong@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, rusty@rustcorp.com.au, rjw@sisk.pl,
        namhyung@kernel.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        oleg@redhat.com, sbw@mit.edu, tj@kernel.org, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v5 01/45] percpu_rwlock: Introduce the global reader-writer
 lock backend
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com> <20130122073315.13822.27093.stgit@srivatsabhat.in.ibm.com> <1358883152.21576.55.camel@gandalf.local.home>
In-Reply-To: <1358883152.21576.55.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012219-1618-0000-0000-0000033AF57A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 01:02 AM, Steven Rostedt wrote:
> On Tue, 2013-01-22 at 13:03 +0530, Srivatsa S. Bhat wrote:
>> A straight-forward (and obvious) algorithm to implement Per-CPU Reader-Writer
>> locks can also lead to too many deadlock possibilities which can make it very
>> hard/impossible to use. This is explained in the example below, which helps
>> justify the need for a different algorithm to implement flexible Per-CPU
>> Reader-Writer locks.
>>
>> We can use global rwlocks as shown below safely, without fear of deadlocks:
>>
>> Readers:
>>
>>          CPU 0                                CPU 1
>>          ------                               ------
>>
>> 1.    spin_lock(&random_lock);             read_lock(&my_rwlock);
>>
>>
>> 2.    read_lock(&my_rwlock);               spin_lock(&random_lock);
>>
>>
>> Writer:
>>
>>          CPU 2:
>>          ------
>>
>>        write_lock(&my_rwlock);
>>
> 
> I thought global locks are now fair. That is, a reader will block if a
> writer is waiting. Hence, the above should deadlock on the current
> rwlock_t types.
> 

Oh is it? Last I checked, lockdep didn't complain about this ABBA scenario!

> We need to fix those locations (or better yet, remove all rwlocks ;-)
> 

:-)

The challenge with stop_machine() removal is that the replacement on the
reader side must have the (locking) flexibility comparable to preempt_disable().
Otherwise, that solution most likely won't be viable because we'll hit way
too many locking problems and go crazy by the time we convert them over..(if
we can, that is!)

Regards,
Srivatsa S. Bhat


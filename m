Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761119Ab3BJTeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 14:34:15 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59093 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761012Ab3BJTeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 14:34:12 -0500
Message-ID: <5117F5B5.6090701@linux.vnet.ibm.com>
Date: Mon, 11 Feb 2013 01:02:05 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, rjw@sisk.pl, sbw@mit.edu,
        fweisbec@gmail.com, linux@arm.linux.org.uk, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 06/45] percpu_rwlock: Allow writers to be readers,
 and add lockdep annotations
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com> <20130122073416.13822.96504.stgit@srivatsabhat.in.ibm.com> <20130208234754.GM2666@linux.vnet.ibm.com>
In-Reply-To: <20130208234754.GM2666@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021019-7014-0000-0000-0000029222DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2013 05:17 AM, Paul E. McKenney wrote:
> On Tue, Jan 22, 2013 at 01:04:23PM +0530, Srivatsa S. Bhat wrote:
>> CPU hotplug (which will be the first user of per-CPU rwlocks) has a special
>> requirement with respect to locking: the writer, after acquiring the per-CPU
>> rwlock for write, must be allowed to take the same lock for read, without
>> deadlocking and without getting complaints from lockdep. In comparison, this
>> is similar to what get_online_cpus()/put_online_cpus() does today: it allows
>> a hotplug writer (who holds the cpu_hotplug.lock mutex) to invoke it without
>> locking issues, because it silently returns if the caller is the hotplug
>> writer itself.
>>
>> This can be easily achieved with per-CPU rwlocks as well (even without a
>> "is this a writer?" check) by incrementing the per-CPU refcount of the writer
>> immediately after taking the global rwlock for write, and then decrementing
>> the per-CPU refcount before releasing the global rwlock.
>> This ensures that any reader that comes along on that CPU while the writer is
>> active (on that same CPU), notices the non-zero value of the nested counter
>> and assumes that it is a nested read-side critical section and proceeds by
>> just incrementing the refcount. Thus we prevent the reader from taking the
>> global rwlock for read, which prevents the writer from deadlocking itself.
>>
>> Add that support and teach lockdep about this special locking scheme so
>> that it knows that this sort of usage is valid. Also add the required lockdep
>> annotations to enable it to detect common locking problems with per-CPU
>> rwlocks.
> 
> Very nice!  The write-side interrupt disabling ensures that the task
> stays on CPU, as required.
> 
> One request: Could we please have a comment explaining the reasons for
> the writer incrementing and decrementing the reader reference count?
> 
> It looked really really strange to me until I came back and read the
> commit log.  ;-)
> 

Sure :-)

Regards,
Srivatsa S. Bhat


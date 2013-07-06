Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab3GFFen (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 01:34:43 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:48823 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab3GFFem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 01:34:42 -0400
Message-ID: <51D7AB43.7010208@linux.vnet.ibm.com>
Date: Sat, 06 Jul 2013 10:59:39 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
        deepthi@linux.vnet.ibm.com, peterz@infradead.org,
        rusty@rustcorp.com.au, heiko.carstens@de.ibm.com, rostedt@goodmis.org,
        miltonm@bga.com, srivatsa.bhat@linux.vnet.ibm.com,
        jens.axboe@oracle.com, tj@kernel.org, akpm@linux-foundation.org,
        svaidy@linux.vnet.ibm.com, shli@kernel.org, tglx@linutronix.de,
        lig.fnst@cn.fujitsu.com, anton@samba.org,
        torvalds@linux-foundation.org, jbeulich@suse.com
Subject: Re: [PATCH 1/3] smp/ipi: Remove redundant cfd->cpumask_ipi mask
References: <20130705162548.16888.18957.stgit@preeti.in.ibm.com> <20130705162701.16888.81171.stgit@preeti.in.ibm.com> <20130706031310.GA1941@udknight>
In-Reply-To: <20130706031310.GA1941@udknight>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070605-9574-0000-0000-0000089AC7D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang,

On 07/06/2013 08:43 AM, Wang YanQing wrote:
> On Fri, Jul 05, 2013 at 09:57:01PM +0530, Preeti U Murthy wrote:
>> cfd->cpumask_ipi is used only in smp_call_function_many().The existing
>> comment around it says that this additional mask is used because
>> cfd->cpumask can get overwritten.
>>
>> There is no reason why the cfd->cpumask can be overwritten, since this
>> is a per_cpu mask; nobody can change it but us and we are
>> called with preemption disabled.
> 
> The ChangeLog for f44310b98ddb7f0d06550d73ed67df5865e3eda5
> which import cfd->cpumask_ipi saied the reason why we need
> it:
> 
> "    As explained by Linus as well:
>     
>      |
>      | Once we've done the "list_add_rcu()" to add it to the
>      | queue, we can have (another) IPI to the target CPU that can
>      | now see it and clear the mask.
>      |
>      | So by the time we get to actually send the IPI, the mask might
>      | have been cleared by another IPI.

I am unable to understand where the cfd->cpumask of the source cpu is
getting cleared. Surely not by itself, since it is preempt disabled.
Also why should it get cleared?

The idea behind clearing a source CPU's cfd->cpumask AFAICS, could be
that the source cpu should not send an IPI to the target if the target
has already received an IPI from another CPU. The reason being that the
target would execute the already queued csds, hence would not need
another IPI to see its queue.

If the above is the intention of clearing the cfd->cpumask of the source
cpu, why is the mechanism not consistent with what happens in
generic_exec_single(), where in an ipi is decided to be sent if there
are no previous queued csds on the target?

Also why is it that in the wait condition under
smp_call_function_many(), cfd->cpumask continues to be used and not
cfd->cpumask_ipi ?

>      |
>     
>     This patch also fixes a system hang problem, if the data->cpumask
>     gets cleared after passing this point:
>     
>             if (WARN_ONCE(!mask, "empty IPI mask"))
>                     return;
>     
>     then the problem in commit 83d349f35e1a ("x86: don't send an IPI to
>     the empty set of CPU's") will happen again.
> "
> So this patch is wrong.
> 
> And you should cc linus and Jan Beulich who give acked-by tag to
> the commit.
> 
> Thanks.
> 

Thank you

Regards
Preeti U Murthy


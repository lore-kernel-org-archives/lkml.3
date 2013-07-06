Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3GFDOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 23:14:41 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:36351 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab3GFDOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 23:14:40 -0400
Date: Sat, 6 Jul 2013 11:13:10 +0800
From: Wang YanQing <udknight@gmail.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
        deepthi@linux.vnet.ibm.com, peterz@infradead.org,
        rusty@rustcorp.com.au, heiko.carstens@de.ibm.com, rostedt@goodmis.org,
        miltonm@bga.com, srivatsa.bhat@linux.vnet.ibm.com,
        jens.axboe@oracle.com, tj@kernel.org, akpm@linux-foundation.org,
        svaidy@linux.vnet.ibm.com, shli@kernel.org, tglx@linutronix.de,
        lig.fnst@cn.fujitsu.com, anton@samba.org,
        torvalds@linux-foundation.org, jbeulich@suse.com
Subject: Re: [PATCH 1/3] smp/ipi: Remove redundant cfd->cpumask_ipi mask
Message-ID: <20130706031310.GA1941@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Preeti U Murthy <preeti@linux.vnet.ibm.com>,
	xiaoguangrong@cn.fujitsu.com, mingo@elte.hu,
	paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	a.p.zijlstra@chello.nl, npiggin@suse.de, deepthi@linux.vnet.ibm.com,
	peterz@infradead.org, rusty@rustcorp.com.au,
	heiko.carstens@de.ibm.com, rostedt@goodmis.org, miltonm@bga.com,
	srivatsa.bhat@linux.vnet.ibm.com, jens.axboe@oracle.com,
	tj@kernel.org, akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
	shli@kernel.org, tglx@linutronix.de, lig.fnst@cn.fujitsu.com,
	anton@samba.org, torvalds@linux-foundation.org, jbeulich@suse.com
References: <20130705162548.16888.18957.stgit@preeti.in.ibm.com>
 <20130705162701.16888.81171.stgit@preeti.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130705162701.16888.81171.stgit@preeti.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 09:57:01PM +0530, Preeti U Murthy wrote:
> cfd->cpumask_ipi is used only in smp_call_function_many().The existing
> comment around it says that this additional mask is used because
> cfd->cpumask can get overwritten.
> 
> There is no reason why the cfd->cpumask can be overwritten, since this
> is a per_cpu mask; nobody can change it but us and we are
> called with preemption disabled.

The ChangeLog for f44310b98ddb7f0d06550d73ed67df5865e3eda5
which import cfd->cpumask_ipi saied the reason why we need
it:

"    As explained by Linus as well:
    
     |
     | Once we've done the "list_add_rcu()" to add it to the
     | queue, we can have (another) IPI to the target CPU that can
     | now see it and clear the mask.
     |
     | So by the time we get to actually send the IPI, the mask might
     | have been cleared by another IPI.
     |
    
    This patch also fixes a system hang problem, if the data->cpumask
    gets cleared after passing this point:
    
            if (WARN_ONCE(!mask, "empty IPI mask"))
                    return;
    
    then the problem in commit 83d349f35e1a ("x86: don't send an IPI to
    the empty set of CPU's") will happen again.
"
So this patch is wrong.

And you should cc linus and Jan Beulich who give acked-by tag to
the commit.

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3F0HL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:11:59 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:44065 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab3F0HL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:11:56 -0400
Message-ID: <51CBE4EF.5040302@linux.vnet.ibm.com>
Date: Thu, 27 Jun 2013 12:38:31 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        sbw@mit.edu, fweisbec@gmail.com, zhong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Sanjay Lal <sanjayl@kymasys.com>,
        "Steven J. Hill" <sjhill@mips.com>, John Crispin <blogic@openwrt.org>,
        Florian Fainelli <florian@openwrt.org>, linux-mips@linux-mips.org
Subject: Re: [PATCH v2 38/45] MIPS: Use get/put_online_cpus_atomic() to prevent
 CPU offline
References: <20130625202452.16593.22810.stgit@srivatsabhat.in.ibm.com> <20130625203257.16593.15358.stgit@srivatsabhat.in.ibm.com> <20130626133912.GA4559@linux-mips.org>
In-Reply-To: <20130626133912.GA4559@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062707-4790-0000-0000-000008FEE72F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 07:09 PM, Ralf Baechle wrote:
> On Wed, Jun 26, 2013 at 02:02:57AM +0530, Srivatsa S. Bhat wrote:
> 
>> Once stop_machine() is gone from the CPU offline path, we won't be able
>> to depend on disabling preemption to prevent CPUs from going offline
>> from under us.
>>
>> Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going
>> offline, while invoking from atomic context.
> 
> I think the same change also needs to be applied to r4k_on_each_cpu() in
> arch/mips/mm/c-r4k.c which currently looks like:
> 
> static inline void r4k_on_each_cpu(void (*func) (void *info), void *info)
> {
>         preempt_disable();
> 
> #if !defined(CONFIG_MIPS_MT_SMP) && !defined(CONFIG_MIPS_MT_SMTC)
>         smp_call_function(func, info, 1);
> #endif
>         func(info);
>         preempt_enable();
> }
> 

Thanks for pointing this out! I'll include changes to this code in my
next version.

Regards,
Srivatsa S. Bhat

> This is a slightly specialized version of on_each_cpu() which only calls
> out to other CPUs in actual multi-core environments and also - unlike
> on_each_cpu() doesn't disable interrupts for the sake of better
> interrupt latencies.
> 
> Which reminds me ...
> 
> Andrew, I was wondering why did 78eef01b0fae087c5fadbd85dd4fe2918c3a015f
> [[PATCH] on_each_cpu(): disable local interrupts] disable interrupts?
> The log is:
> 
> ----- snip -----
>     When on_each_cpu() runs the callback on other CPUs, it runs with local
>     interrupts disabled.  So we should run the function with local interrupts
>     disabled on this CPU, too.
>     
>     And do the same for UP, so the callback is run in the same environment on bo
>     UP and SMP.  (strictly it should do preempt_disable() too, but I think
>     local_irq_disable is sufficiently equivalent).
> [...]
> ----- snip -----
> 
> I'm not entirely convinced the symmetry between UP and SMP environments is
> really worth it.  Would anybody mind removing the local_irq_disable() ...
> local_irq_enable() from on_each_cpu()?
> 


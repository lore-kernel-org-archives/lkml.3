Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaDDDtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:49:08 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:47488 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaDDDtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:49:01 -0400
Message-ID: <533E2BA2.6000107@linux.vnet.ibm.com>
Date: Fri, 04 Apr 2014 11:48:50 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        benh@kernel.crashing.org, paulus@samba.org, nfont@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, Andrew Morton <akpm@linux-foundation.org>,
        rcj@linux.vnet.ibm.com, jlarrew@linux.vnet.ibm.com,
        alistair@popple.id.au, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH] power, sched: stop updating inside arch_update_cpu_topology()
 when nothing to be update
References: <533B8431.8090507@linux.vnet.ibm.com> <533D20E1.4000008@linux.vnet.ibm.com>
In-Reply-To: <533D20E1.4000008@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040403-5816-0000-0000-00000D32ADA9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Srivatsa

Thanks for your reply :)

On 04/03/2014 04:50 PM, Srivatsa S. Bhat wrote:
[snip]
> 
> Now, the interesting thing to note here is that, if CPU0's node was already
> set as node0, *nothing* should go wrong, since its just a redundant update.
> However, if CPU0's original node mapping was something different, or if
> node0 doesn't even exist in the machine, then the system can crash.

By printk I confirmed all cpus was belong to node 1 at very beginning,
and things become magically after the wrong updating...

> 
> Have you verified that CPU0's node mapping is different from node 0?
> That is, boot the kernel with "numa=debug" in the kernel command line and
> it will print out the cpu-to-node associativity during boot. That way you
> can figure out what was the original associativity that was set. This will
> confirm the theory that the hypervisor sent a redundant update, but because
> of the weird pre-allocation using kzalloc that we do inside
> arch_update_cpu_topology(), we wrongly updated CPU0's mapping as CPU0 <-> Node0.

Associativity should changes, otherwise we won't continue the updating,
and empty updates[] was confirmed to show up inside
arch_update_cpu_topology().

What I can't make sure is whether this is legal, notify changes but no
changes happen sounds weird...however, even if it's legal, a check in
here still make sense IMHO.

Regards,
Michael Wang

> 
> 
> Regards,
> Srivatsa S. Bhat
> 
>> Thus we should stop the updating in such cases, this patch will achieve
>> this and fix the issue.
>>
>> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> CC: Paul Mackerras <paulus@samba.org>
>> CC: Nathan Fontenot <nfont@linux.vnet.ibm.com>
>> CC: Stephen Rothwell <sfr@canb.auug.org.au>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: Robert Jennings <rcj@linux.vnet.ibm.com>
>> CC: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
>> CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
>> CC: Alistair Popple <alistair@popple.id.au>
>> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
>> ---
>>  arch/powerpc/mm/numa.c |    9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
>> index 30a42e2..6757690 100644
>> --- a/arch/powerpc/mm/numa.c
>> +++ b/arch/powerpc/mm/numa.c
>> @@ -1591,6 +1591,14 @@ int arch_update_cpu_topology(void)
>>  		cpu = cpu_last_thread_sibling(cpu);
>>  	}
>>
>> +	/*
>> +	 * The 'cpu_associativity_changes_mask' could be cleared if
>> +	 * all the cpus it indicates won't change their node, in
>> +	 * which case the 'updated_cpus' will be empty.
>> +	 */
>> +	if (!cpumask_weight(&updated_cpus))
>> +		goto out;
>> +
>>  	stop_machine(update_cpu_topology, &updates[0], &updated_cpus);
>>
>>  	/*
>> @@ -1612,6 +1620,7 @@ int arch_update_cpu_topology(void)
>>  		changed = 1;
>>  	}
>>
>> +out:
>>  	kfree(updates);
>>  	return changed;
>>  }
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


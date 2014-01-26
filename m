Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaAZMWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 07:22:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbaAZMWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 07:22:44 -0500
Message-ID: <52E4FE02.2020004@redhat.com>
Date: Sun, 26 Jan 2014 07:22:26 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2] x86: allocate cpumask during check irq vectors
References: <1390611565-18709-1-git-send-email-yinghai@kernel.org> <20140125080232.GA20935@gmail.com>
In-Reply-To: <20140125080232.GA20935@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/25/2014 03:02 AM, Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Fix warning:
>> arch/x86/kernel/irq.c: In function check_irq_vectors_for_cpu_disable:
>> arch/x86/kernel/irq.c:337:1: warning: the frame size of 2052 bytes is larger than 2048 bytes
>>
>> when NR_CPUS=8192
>>
>> We should use zalloc_cpumask_var() instead.
>>
>> -v2: update to GFP_ATOMIC instead and free the allocated cpumask at last.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: Prarit Bhargava <prarit@redhat.com>
>>
>> ---
>>  arch/x86/kernel/irq.c |   24 +++++++++++++++++-------
>>  1 file changed, 17 insertions(+), 7 deletions(-)
>>
>> Index: linux-2.6/arch/x86/kernel/irq.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/irq.c
>> +++ linux-2.6/arch/x86/kernel/irq.c
>> @@ -277,11 +277,18 @@ int check_irq_vectors_for_cpu_disable(vo
>>  	unsigned int this_cpu, vector, this_count, count;
>>  	struct irq_desc *desc;
>>  	struct irq_data *data;
>> -	struct cpumask affinity_new, online_new;
>> +	cpumask_var_t affinity_new, online_new;
>> +
>> +	if (!alloc_cpumask_var(&affinity_new, GFP_ATOMIC))
>> +		return -ENOMEM;
>> +	if (!alloc_cpumask_var(&online_new, GFP_ATOMIC)) {
>> +		free_cpumask_var(affinity_new);
>> +		return -ENOMEM;
>> +	}
> 
> Atomic allocations can fail easily if the system is under duress.

Then the hotplug attempt will fail which IMO is okay.  With GFP_KERNEL we might
hang the system.

Ingo -- the original submit (and a Reviewed-by: Cheng Gong) is here,

http://marc.info/?l=linux-kernel&m=139035727501266&w=2

Thanks,

P.

> 
> Thanks,
> 
> 	Ingo

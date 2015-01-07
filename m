Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbbAGJoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:44:13 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:26473 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbbAGJoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:44:10 -0500
Message-ID: <54ACFFB6.3040102@huawei.com>
Date: Wed, 7 Jan 2015 17:43:18 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Hillf Danton <hillf.zj@alibaba-inc.com>
CC: <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>, <lizefan@huawei.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 09/11] kprobes: core logic of eraly kprobes
References: <043a01d02a5b$44ec45f0$cec4d1d0$@alibaba-inc.com>
In-Reply-To: <043a01d02a5b$44ec45f0$cec4d1d0$@alibaba-inc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/7 17:21, Hillf Danton wrote:
>>
>> +struct early_kprobe_slot {
>> +	struct optimized_kprobe op;
>> +};
>> +
> [...]
>>
>>  /* Free optimized instructions and optimized_kprobe */
>> +static int ek_free_early_kprobe(struct early_kprobe_slot *slot);
> 
> [2] How is it implemented? In subsequent patches?
> 

It is implemented using macro. Please see patch 7/11 and

DEFINE_EKPROBE_ALLOC_OPS(struct early_kprobe_slot, early_kprobe, static);

following.

>>  static void free_aggr_kprobe(struct kprobe *p)
>>  {
>>  	struct optimized_kprobe *op;
>> +	struct early_kprobe_slot *ep;
>>
>>  	op = container_of(p, struct optimized_kprobe, kp);
>>  	arch_remove_optimized_kprobe(op);
>>  	arch_remove_kprobe(p);
>> -	kfree(op);
>> +	ep = container_of(op, struct early_kprobe_slot, op);
>> +	if (likely(!ek_free_early_kprobe(ep)))
>> +		kfree(op);
> 
> [1] s/op/ep/   yes?

Which one? Do you mean kfree(op) --> kfree(ep)?

If ek_free_early_kprobe(ep) fail (not in early_kprobe area defined by
DEFINE_EKPROBE_ALLOC_OPS), then this is a normal aggr probe, allocated
using kzalloc() as struct optimized_kprobe, see alloc_aggr_kprobe().
So kfree corresponding op structure.

If ek_free_early_kprobe(ep) success, then this is an struct early_kprobe_slot
and allocated statically.

>>  }
>>
> [...]
>> +#else
>> +static int register_early_kprobe(struct kprobe *p) { return -ENOSYS; }
>> +static int ek_free_early_kprobe(struct early_kprobe_slot *slot) { return 0; }
> 
> [3] Compile-able with CONFIG_EARLY_KPROBES enabled?

These empty functions are for CONFIG_EARLY_KPROBES disabled. They won't be compiled
when CONFIG_EARLY_KPROBES=y. I have tested both cases on x86 and ARM.

> 
>> +static void convert_early_kprobes(void) {};
>> +#endif
>> --
>> 1.8.4
> 

Thanks.



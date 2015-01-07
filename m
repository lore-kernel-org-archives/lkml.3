Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbbAGKeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:34:24 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:31607 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbbAGKeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:34:22 -0500
Message-ID: <54AD0B98.5050103@huawei.com>
Date: Wed, 7 Jan 2015 18:34:00 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Hillf Danton <hillf.zj@alibaba-inc.com>
CC: <linux@arm.linux.org.uk>, "'Ingo Molnar'" <mingo@redhat.com>,
        <masami.hiramatsu.pt@hitachi.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ananth@in.ibm.com>, <dave.long@linaro.org>,
        <tixy@linaro.org>, <lizefan@huawei.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 09/11] kprobes: core logic of eraly kprobes
References: <043a01d02a5b$44ec45f0$cec4d1d0$@alibaba-inc.com> <54ACFFB6.3040102@huawei.com> <045301d02a60$ff36e8c0$fda4ba40$@alibaba-inc.com>
In-Reply-To: <045301d02a60$ff36e8c0$fda4ba40$@alibaba-inc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.54AD0BAC.00C1,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: a2d5ede9b844c97be968e470c3b0758c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/7 18:02, Hillf Danton wrote:
>>>>
>>>> +struct early_kprobe_slot {
>>>> +	struct optimized_kprobe op;
>>>> +};
>>>> +
>>> [...]
>>>>
>>>>  /* Free optimized instructions and optimized_kprobe */
>>>> +static int ek_free_early_kprobe(struct early_kprobe_slot *slot);
>>>
>>> [2] How is it implemented? In subsequent patches?
>>>
>>
>> It is implemented using macro. Please see patch 7/11 and
>>
>> DEFINE_EKPROBE_ALLOC_OPS(struct early_kprobe_slot, early_kprobe, static);
>>
> What is the reason that it is listed in C file, given that it is done in H already?
> 

This macro defines an array and a bitmap, not only declare them. In addition,
the functions defined by it are used only in this specific .c file.

If there are not only one .c files use it, I think patch 7 can be improved:

#define DEFINE_EKPROBE_AREA(__t, __static)				\
__static __t __ek_##__name##_slots[NR_EARLY_KPROBES_SLOTS];		\
__static unsigned long __ek_##__name##_bitmap[EARLY_KPROBES_BITMAP_SZ];

#define DEFINE_EKPROBE_ALLOC_OPS(__t, __name, __static)			\
DEFINE_EKPROBE_AREA(__t, __static)					\
__DEFINE_EKPROBE_ALLOC_OPS(__t, __name)					\
static inline __t *ek_alloc_##__name(void)				\
{									\
...

In .h file(s):
DEFINE_EKPROBE_ALLOC_OPS(struct early_kprobe_slot, early_kprobe, extern)

In .c file:
DEFINE_EKPROBE_AREA(__t, )

What do you think?


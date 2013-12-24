Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab3LXBeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:34:06 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:47173 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926Ab3LXBeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:34:04 -0500
MIME-Version: 1.0
In-Reply-To: <52B8DEAE.2040100@huawei.com>
References: <52B7F53C.5020001@huawei.com>
	<20131223133402.GA4487@pd.tnic>
	<52B8DEAE.2040100@huawei.com>
Date: Mon, 23 Dec 2013 17:34:02 -0800
X-Google-Sender-Auth: Zzfn4-PnZUUW3AlJyxvwoJI5EsE
Message-ID: <CAE9FiQWUfu6kNvpeN+e_Gp7L2NxddYnvG2oy9YB7CpqbeMgp-Q@mail.gmail.com>
Subject: Re: [PATCH v2][TRIVIAL] x86/smpboot: fix cpu bootup message
From: Yinghai Lu <yinghai@kernel.org>
To: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Bin <huawei.libin@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 5:09 PM, Xie XiuQi <xiexiuqi@huawei.com> wrote:
> On 2013/12/23 21:34, Borislav Petkov wrote:
>> On Mon, Dec 23, 2013 at 04:33:00PM +0800, Xie XiuQi wrote:
>>> When CPU0 and CPU1 aren't in same package, we got message
>>> like this:
>>>
>
> [...]
>
>>>
>>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>>> index 85dc05a..9e82c1e 100644
>>> --- a/arch/x86/kernel/smpboot.c
>>> +++ b/arch/x86/kernel/smpboot.c
>>> @@ -639,7 +639,7 @@ static void announce_cpu(int cpu, int apicid)
>>>  {
>>>      static int current_node = -1;
>>>      int node = early_cpu_to_node(cpu);
>>> -    static int width, node_width;
>>> +    static int width, node_width, padding;
>>>
>>>      if (!width)
>>>              width = num_digits(num_possible_cpus()) + 1; /* + '#' sign */
>>> @@ -658,11 +658,13 @@ static void announce_cpu(int cpu, int apicid)
>>>
>>>                      printk(KERN_INFO ".... node %*s#%d, CPUs:  ",
>>>                             node_width - num_digits(node), " ", node);
>>> -            }
>>>
>>> -            /* Add padding for the BSP */
>>> -            if (cpu == 1)
>>> -                    pr_cont("%*s", width + 1, " ");
>>> +                    /* Add padding for the BSP */
>>> +                    if (!padding && (early_cpu_to_node(0) == current_node)) {
>>
>> You don't need "padding".
>>
>
> On another machine, the configuration is:
>
> xiexiuqi@localhost:~> lscpu
> [...]
> NUMA node0 CPU(s):     4-7,12-15
> NUMA node1 CPU(s):     0-3,8-11
>
> Without "padding", we'll get message like this:
>
> [    0.349339] x86: Booting SMP configuration:
> [    0.353504] .... node  #1, CPUs:        #1  #2  #3
> [    0.398812] .... node  #0, CPUs:    #4  #5  #6  #7
> [    0.535186] .... node  #1, CPUs:        #8  #9 #10 #11
> [    0.594312] .... node  #0, CPUs:   #12 #13 #14 #15
> [    0.652398] x86: Booted up 2 nodes, 16 CPUs
>

What does your MADT look like?

you can you post head of bootlog with MADT print out?

wonder if your system have x2apic and xapic mixing.
then

https://lkml.org/lkml/2012/1/31/57
[PATCH -v2] x86, acpi: Handle xapic/x2apic entries in MADT at same time

could help.

Thanks

Yinghai

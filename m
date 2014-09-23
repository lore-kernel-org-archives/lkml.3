Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaIWGgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:36:36 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46876 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaIWGge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:36:34 -0400
Message-ID: <542114D7.3030605@gmail.com>
Date: Tue, 23 Sep 2014 14:36:07 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, hpa@zytor.com,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] x86, cpu-hotplug: fix llc shared map unreleased during
 cpu hotplug
References: <1410938272-7217-1-git-send-email-wanpeng.li@linux.intel.com> <5420FB25.8050102@jp.fujitsu.com>
In-Reply-To: <5420FB25.8050102@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamezawa,
于 14-9-23 下午12:46, Kamezawa Hiroyuki 写道:
> (2014/09/17 16:17), Wanpeng Li wrote:
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
>> IP: [..] find_busiest_group
>> PGD 5a9d5067 PUD 13067 PMD 0
>> Oops: 0000 [#3] SMP
>> [...]
>> Call Trace:
>> load_balance
>> ? _raw_spin_unlock_irqrestore
>> idle_balance
>> __schedule
>> schedule
>> schedule_timeout
>> ? lock_timer_base
>> schedule_timeout_uninterruptible
>> msleep
>> lock_device_hotplug_sysfs
>> online_store
>> dev_attr_store
>> sysfs_write_file
>> vfs_write
>> SyS_write
>> system_call_fastpath
>>
>> This bug can be triggered by hot add and remove large number of xen
>> domain0's vcpus repeatedly.
>>
>> Last level cache shared map is built during cpu up and build sched domain
>> routine takes advantage of it to setup sched domain cpu topology, however,
>> llc shared map is unreleased during cpu disable which lead to invalid sched
>> domain cpu topology. This patch fix it by release llc shared map correctly
>> during cpu disable.
>>
>> Reviewed-by: Toshi Kani <toshi.kani@hp.com>
>> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Tested-by: Linn Crosetto <linn@hp.com>
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> Yasuaki reported this can happen on our real hardware. 
> https://lkml.org/lkml/2014/7/22/1018
>
> Our case is here.
> ==
> Here is a example on my system.
> My system has 4 sockets and each socket has 15 cores and HT is enabled.
> In this case, each core of sockes is numbered as follows:
>
>           | CPU#
> Socket#0 | 0-14 , 60-74
> Socket#1 | 15-29, 75-89
> Socket#2 | 30-44, 90-104
> Socket#3 | 45-59, 105-119
> Then llc_shared_mask of CPU#30 has 0x3fff80000001fffc0000000.
> It means that last level cache of Socket#2 is shared with
> CPU#30-44 and 90-104.
> When hot-removing socket#2 and #3, each core of sockets is numbered
> as follows:
>
>           | CPU#
> Socket#0 | 0-14 , 60-74
> Socket#1 | 15-29, 75-89
> But llc_shared_mask is not cleared. So llc_shared_mask of CPU#30 remains
> having 0x3fff80000001fffc0000000.
> After that, when hot-adding socket#2 and #3, each core of sockets is
> numbered as follows:
>
>           | CPU#
> Socket#0 | 0-14 , 60-74
> Socket#1 | 15-29, 75-89
> Socket#2 | 30-59
> Socket#3 | 90-119
> Then llc_shared_mask of CPU#30 becomes 0x3fff8000fffffffc0000000.
> It means that last level cache of Socket#2 is shared with CPU#30-59
> and 90-104. So the mask has wrong value.
> At first, I cleared hot-removed CPU number's bit from llc_shared_map
> when hot removing CPU. But Borislav suggested that the problem will
> disappear if readded CPU is assigned same CPU number. And llc_shared_map
> must not be changed.
> ==
>
> So, please.

As I mentioned before, we still observe calltrace after Yasuaki's patch
applied.
https://lkml.org/lkml/2014/7/29/40

Actually I prefer to merge both patches, one for fix llc shared map
unreleased during hotplug and the other one for assign same CPU number
to readded CPU.

Regards,
Wanpeng Li

> Thanks,
> -Kame
>
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


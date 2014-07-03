Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaGCEx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 00:53:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46874 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaGCExy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 00:53:54 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53B4E1A4.2050502@jp.fujitsu.com>
Date: Thu, 3 Jul 2014 13:52:52 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <toshi.kani@hp.com>, <imammedo@redhat.com>,
        <huawei.libin@huawei.com>, <paul.gortmaker@windriver.com>,
        <linux-kernel@vger.kernel.org>, <srivatsa.bhat@linux.vnet.ibm.com>,
        <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86,cpu-hotplug: clear llc_shared_mask at CPU hotplug
References: <53B3A991.2070502@jp.fujitsu.com> <20140702113253.GD1318@pd.tnic>
In-Reply-To: <20140702113253.GD1318@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/02 20:32), Borislav Petkov wrote:
> On Wed, Jul 02, 2014 at 03:41:21PM +0900, Yasuaki Ishimatsu wrote:
>> llc_shared_mask is not cleared even if cpu is offline or hot removed.
>> So when hot-plugging CPU, the mask has wrong value. The mask is used
>> by CSF schduler. So it breaks CFS scheduler.
>>
>> Here is a example on my system.
>> My system has 4 sockets and each socket has 15 cores and HT is enabled.
>> In this case, each core of sockes is numbered as follows:
>>
>>           | CPU#
>> Socket#0 | 0-14 , 60-74
>> Socket#1 | 15-29, 75-89
>> Socket#2 | 30-44, 90-104
>> Socket#3 | 45-59, 105-119
>>
>> Then llc_shared_mask of CPU#30 has 0x3fff80000001fffc0000000.
>> It means that cache of Socket#2 is shared with CPU#30-44 and 90-104.
>>
>> When hot-removing socket#2 and #3, each core of sockets is numbered
>> as follows:
>>
>>           | CPU#
>> Socket#0 | 0-14 , 60-74
>> Socket#1 | 15-29, 75-89
>>
>> But llc_shared_mask is not cleared. So llc_shared_mask of CPU#30 remains
>> having 0x3fff80000001fffc0000000.
>>
>> After that, when hot-adding socket#2 and #3, each core of sockets is
>> numbered as follows:
>>
>>           | CPU#
>> Socket#0 | 0-14 , 60-74
>> Socket#1 | 15-29, 75-89
>> Socket#2 | 30-59
>> Socket#3 | 90-119
>
> Ok, this doesn't make too much sense to me. Why would the readded cores
> have new numbers?

I think that the reason to apply CPU number to ACPI ID is that CPU is
used for the application without considering physical CPU. So even if
CPU number is changed, it is no matter. Thus the readded cores is
numbered to unused CPU number.

>
> Because if they kept their old numbers, you wouldn't have to correct the
> LLC mask.
>

I think the mask has 2 meanings as follows:
   - representing CPUs that share same CPU cache.
   - representing onlined CPUs
So even if we keep their old numbers, we should clear the mask when
offlinig CPU.

> Shouldn't the hotplug code keep stable core ids based on APIC id and
> node and whatever across physical hotplug operations?
>

Thanks,
Yasuaki Ishimatsu


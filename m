Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaKEK5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:57:23 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:50112 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbaKEK5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:57:21 -0500
Message-ID: <545A0282.4070001@huawei.com>
Date: Wed, 5 Nov 2014 18:57:06 +0800
From: Hu Keping <hukeping@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <swarren@nvidia.com>, <ebiederm@xmission.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <sdu.liu@huawei.com>, <wangnan0@huawei.com>, <peifeiyue@huawei.com>
Subject: Re: [RESEND PATCH] ARM: kexec: Fix validating CPU hotplug support
References: <1415094025-66180-1-git-send-email-hukeping@huawei.com> <20141104105525.GE4042@n2100.arm.linux.org.uk>
In-Reply-To: <20141104105525.GE4042@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.89.121]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.545A028F.0177,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 4fe2e03a0ee80cfaae3460938c15bf30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



于 2014/11/4 18:55, Russell King - ARM Linux 写道:
> On Tue, Nov 04, 2014 at 05:40:25PM +0800, HuKeping wrote:
>> Commit 2103f6cba61a8b8bea3fc1b63661d830a2125e76 added a hotplug checking in
>> machine_kexec_prepare(), but it will lead a failure when loading the
>> crash-kernel in some cases.
>>
>> Kexec utility can load the crash kernel by two ways:
>> 1. kexec -l kernel-image
>> 2. kexec -p kernel-image
>>
>> In case #1, for rapid reboot, it's correct to do the hotplug checking things,
>> for it will shut down cpus in _cpu_down() later when command "kexec -e" be
>> sent, this routine needs the support of cpu hotplug.
>>
>> In case #2, for use on panic, it's unnecessary to do the same thing, the whole
>> routing has no business with cpu shutting down. Check for cpu hot plug will
>> lead a failure to load the kernel.
>
> So what happens to the other CPUs when you kexec into the new kernel,
> possibly overwriting the instructions which those CPUs are executing?
>

Actually, i do think there is something wrong in the panic-rountine:
when panic comes, we clear the cpu_online_bits of other CPUs and
keep them calling cpu_relax(). That's why I post that patch ,because
we do not really shut down the CPUs.

But as your mentioned , there is another problem:
what's in the pc register of each cpu is unknown after the MMU has been
shut down.

On X86, there is a halt() before the cpu_relax(), so do you think we
need a call wfi() before cpu_relax() to keep the other CPUs on
status-WFI on ARM?


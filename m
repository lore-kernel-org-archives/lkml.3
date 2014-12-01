Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbaLAWae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:30:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36886 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbaLAWac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:30:32 -0500
Message-ID: <547CEC5C.9070201@oracle.com>
Date: Mon, 01 Dec 2014 17:31:56 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        david.vrabel@citrix.com, konrad.wilk@oracle.com, pbonzini@redhat.com,
        gleb@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86, microcode: Don't initialize microcode code on paravirt
References: <1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com> <20141201220057.GC4730@pd.tnic>
In-Reply-To: <20141201220057.GC4730@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 05:00 PM, Borislav Petkov wrote:
> On Mon, Dec 01, 2014 at 04:27:44PM -0500, Boris Ostrovsky wrote:
>> Paravirtual guests are not expected to load microcode into processors
>> and therefore it is not necessary to initialize microcode loading
>> logic.
>>
>> In fact, under certain circumstances initializing this logic may cause
>> the guest to crash. Specifically, 32-bit kernels use __pa_nodebug()
>> macro which does not work in Xen (the code path that leads to this macro
>> happens during resume when we call mc_bp_resume()->load_ucode_ap()
>> ->check_loader_disabled_ap())
>>
>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> ---
>>   arch/x86/kernel/cpu/microcode/core.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
>> index 2ce9051..ebd232d 100644
>> --- a/arch/x86/kernel/cpu/microcode/core.c
>> +++ b/arch/x86/kernel/cpu/microcode/core.c
>> @@ -557,7 +557,7 @@ static int __init microcode_init(void)
>>   	struct cpuinfo_x86 *c = &cpu_data(0);
>>   	int error;
>>   
>> -	if (dis_ucode_ldr)
>> +	if (paravirt_enabled() || dis_ucode_ldr)
> Ok, let me make sure I understand this correctly: The early path doesn't
> get executed on paravirt, i.e. the path along load_ucode_intel_ap()?

(+KVM folks here as well)

Xen PV doesn't start with startup_32()/startup_32_smp() so for Xen this 
is true. Don't know about KVM (or lguest).

>
> And you want to avoid loading of the microcode driver because the only
> path we come to load_ucode_ap() on paravirt is the hotplug notifier?

That's my understanding, yes.

>
> Btw, we've applied another fix today for 3.18 final which limits the
> microcode reloading to 64-bit only:
>
> http://git.kernel.org/tip/02ecc41abcea4ff9291d548f6f846b29b354ddd2
>
> which should accidentally fix the paravirt issue too, no?

I think so. The problem we have now is __pa() macro that we only use on 
32-bit. I'll queue this for overnight tests to make sure and if it 
indeed works then 3.19 should be fine.

Thanks.
-boris

>
> Because if so, I'd like to delay your patch for the 3.19 merge window
> unless absolutely necessary.
>
> Thanks.
>


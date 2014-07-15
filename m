Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaGOPnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:43:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28602 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaGOPnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:43:16 -0400
Message-ID: <53C54CA0.1060904@oracle.com>
Date: Tue, 15 Jul 2014 11:45:36 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86_64,xen,espfix: Initialize espfix on secondary CPUs
References: <195642a5e9fd4515ad8ca4cd8bcffd4900df5790.1405437568.git.luto@amacapital.net> <20140715153801.GX3403@laptop.dumpdata.com>
In-Reply-To: <20140715153801.GX3403@laptop.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 11:38 AM, Konrad Rzeszutek Wilk wrote:
> On Tue, Jul 15, 2014 at 08:26:41AM -0700, Andy Lutomirski wrote:
>> Xen doesn't call start_secondary.
> Duh!
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>
>> espfix still doesn't seem to work on Xen (it goes boom in some way that
>> I don't understand right now), but initializing all CPUs instead of just
>> one of them seems like a good start.
>>
>> ISTM the right fix is probably to shove the espfix logic into
>> native_iret and to tweak the paravirt logic so that native_iret always
>> gets invoked.  I suspect that Xen will need its own implementation of
>> espfix64 in the hypervisor and that, ultimately, someone may want to
>> stop initializing espfix64 at all on Xen guests.
> I think just disallowing would be preferrable.

I've been looking at sigreturn_64 and it seems to be crashing dom0 (with 
both mine and your patches). In kprobe_int3_handler().


-boris

>
> Thanks for posting this patch!
>>   arch/x86/xen/smp.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
>> index 7005974..eea9bcc 100644
>> --- a/arch/x86/xen/smp.c
>> +++ b/arch/x86/xen/smp.c
>> @@ -23,6 +23,7 @@
>>   #include <asm/desc.h>
>>   #include <asm/pgtable.h>
>>   #include <asm/cpu.h>
>> +#include <asm/espfix.h>
>>   
>>   #include <xen/interface/xen.h>
>>   #include <xen/interface/vcpu.h>
>> @@ -85,6 +86,13 @@ static void cpu_bringup(void)
>>   
>>   	xen_setup_cpu_clockevents();
>>   
>> +	/*
>> +	 * Enable the espfix hack for this CPU
>> +	 */
>> +#ifdef CONFIG_X86_ESPFIX64
>> +	init_espfix_ap();
>> +#endif
>> +
>>   	notify_cpu_starting(cpu);
>>   
>>   	set_cpu_online(cpu, true);
>> -- 
>> 1.9.3
>>


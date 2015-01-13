Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbbAMPmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:42:44 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:20132 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbbAMPmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:42:43 -0500
Message-ID: <54B53CDD.7070400@oracle.com>
Date: Tue, 13 Jan 2015 10:42:21 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, Imre Palik <imrep.amz@gmail.com>,
        xen-devel@lists.xenproject.org
CC: "Palik, Imre" <imrep@amazon.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Anthony Liguori <aliguori@amazon.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] xen-time: decreasing the rating of the xen
 clocksource below that of the tsc clocksource for dom0's
References: <1421136862-15083-1-git-send-email-imrep.amz@gmail.com> <54B4EAC7.2080105@citrix.com>
In-Reply-To: <54B4EAC7.2080105@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 04:52 AM, David Vrabel wrote:
> On 13/01/15 08:14, Imre Palik wrote:
>> From: "Palik, Imre" <imrep@amazon.de>
>>
>> In Dom0's the use of the TSC clocksource (whenever it is stable enough to
>> be used) instead of the Xen clocksource should not cause any issues, as
>> Dom0 VMs never live-migrated.  The TSC clocksource is somewhat more
>> efficient than the Xen paravirtualised clocksource, thus it should have
>> higher rating.
>>
>> This patch decreases the rating of the Xen clocksource in Dom0s to 275.
>> Which is half-way between the rating of the TSC clocksource (300) and the
>> hpet clocksource (250).
> I'm happy with this but would like to see acks from those who objected
> to v1.
>
> David
>
>> --- a/arch/x86/xen/time.c
>> +++ b/arch/x86/xen/time.c
>> @@ -487,6 +487,10 @@ static void __init xen_time_init(void)
>>   	int cpu = smp_processor_id();
>>   	struct timespec tp;
>>   
>> +	/* As Dom0 is never moved, no penalty on using TSC there */

Again, why not any PV guest with TSC_MODE_NEVER_EMULATE?

And I am not sure I understood the argument about unsynchronized TSCs. 
You mentioned you can't find a platform to test on. I think you may be 
able to unsynchronize TSCs by writing something to MSR 0x10 early during 
Xen boot and then migrate dom0's vcpu to that pcpu later (making sure 
this vcpu was not running there while dom0 was booting)

-boris

>> +	if (xen_initial_domain())
>> +		xen_clocksource.rating = 275;
>> +
>>   	clocksource_register_hz(&xen_clocksource, NSEC_PER_SEC);
>>   
>>   	if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL) == 0) {
>>


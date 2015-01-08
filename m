Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbbAHPGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:06:38 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:62152 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbbAHPGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:06:36 -0500
Message-ID: <54AE9CF0.8060907@gmail.com>
Date: Thu, 08 Jan 2015 16:06:24 +0100
From: Imre Palik <imrep.amz@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: xen-devel@lists.xenproject.org, "Palik, Imre" <imrep@amazon.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, David Vrabel <david.vrabel@citrix.com>,
        Anthony Liguori <aliguori@amazon.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH RFC] xen-time: decreasing the rating of the
 xen clocksource below that of the tsc clocksource for dom0's
References: <1420647398-20207-1-git-send-email-imrep.amz@gmail.com> <1420648234.18631.117.camel@citrix.com>
In-Reply-To: <1420648234.18631.117.camel@citrix.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/15 17:30, Ian Campbell wrote:
> On Wed, 2015-01-07 at 17:16 +0100, Imre Palik wrote:
>> From: "Palik, Imre" <imrep@amazon.de>
>>
>> In Dom0's the use of the TSC clocksource (whenever it is stable enough to
>> be used) instead of the Xen clocksource should not cause any issues, as
>> Dom0 VMs never live-migrated.
> 
> Is this still true given that dom0's vcpus are migrated amongst pcpus on
> the host? The tsc are not synchronised on some generations of hardware
> so the result there would be the TSC appearing to do very odd things
> under dom0's feet. Does Linux cope with that or does it not matter for
> some other reason?

First of all, if the initial pcpus are not synchronised, linux won't consider
TSC as a viable clocksource.

If the initial pcpus are synchronised, but then the dom0 vcpus are migrated to
unsynchronised pcpus, then hopefully the tsc watchdog catches the issue, and
the kernel falls back to the xen clocksource.  The issue here is that the
watchdog can only detect clock skews bigger than 0.0625s/0.5s.  Hopefully this
is enough to avoid the weirdest things.

Also, some parts of the kernel (e.g., scheduling) will always use the paravirt
clock.  No matter what priorities are set.

So it should be safe for some definition of safe.
But I was unable to test it on a hardware platform that would hit the problematic
case described above.

> 
>>
>> Cc: Anthony Liguori <aliguori@amazon.com>
>> Signed-off-by: Imre Palik <imrep@amazon.de>
>> ---
>>  arch/x86/xen/time.c |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
>> index f473d26..c768726 100644
>> --- a/arch/x86/xen/time.c
>> +++ b/arch/x86/xen/time.c
>> @@ -487,6 +487,10 @@ static void __init xen_time_init(void)
>>  	int cpu = smp_processor_id();
>>  	struct timespec tp;
>>  
>> +	/* As Dom0 is never moved, no penalty on using TSC there */
>> +	if (xen_initial_domain())
>> +		xen_clocksource.rating = 275;
>> +
>>  	clocksource_register_hz(&xen_clocksource, NSEC_PER_SEC);
>>  
>>  	if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL) == 0) {
> 
> 


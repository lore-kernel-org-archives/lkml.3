Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab3EOITt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:19:49 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41889 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab3EOITr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Wed, 15 May 2013 04:19:47 -0400
Message-Id: <5193613E02000078000D64E9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 15 May 2013 09:19:42 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>,
        "John Stultz" <john.stultz@linaro.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] x86/xen: sync the CMOS RTC as well
 as the Xen wallclock
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com>
 <1368467768-2316-4-git-send-email-david.vrabel@citrix.com>
 <51927339.5070402@linaro.org>
In-Reply-To: <51927339.5070402@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.05.13 at 19:24, John Stultz <john.stultz@linaro.org> wrote:
> On 05/13/2013 10:56 AM, David Vrabel wrote:
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> If NTP is used in dom0 and it is synchronized to its clock source,
>> then the kernel will periodically synchronize the Xen wallclock with
>> the system time.  Updates to the Xen wallclock do not persist across
>> reboots, so also synchronize the CMOS RTC (as on bare metal).
>>
>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
>> ---
>>   arch/x86/xen/time.c |   11 ++++++++++-
>>   1 files changed, 10 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
>> index a1947ac..4656165 100644
>> --- a/arch/x86/xen/time.c
>> +++ b/arch/x86/xen/time.c
>> @@ -14,6 +14,7 @@
>>   #include <linux/kernel_stat.h>
>>   #include <linux/math64.h>
>>   #include <linux/gfp.h>
>> +#include <linux/mc146818rtc.h>
>>   
>>   #include <asm/pvclock.h>
>>   #include <asm/xen/hypervisor.h>
>> @@ -199,17 +200,25 @@ static void xen_get_wallclock(struct timespec *now)
>>   static int xen_set_wallclock(const struct timespec *now)
>>   {
>>   	struct xen_platform_op op;
>> +	int ret;
>>   
>>   	/* do nothing for domU */
>>   	if (!xen_initial_domain())
>>   		return -1;
>>   
>> +	/* Set the Xen wallclock. */
>>   	op.cmd = XENPF_settime;
>>   	op.u.settime.secs = now->tv_sec;
>>   	op.u.settime.nsecs = now->tv_nsec;
>>   	op.u.settime.system_time = xen_clocksource_read();
>>   
>> -	return HYPERVISOR_dom0_op(&op);
>> +	ret = HYPERVISOR_dom0_op(&op);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Set the hardware RTC. */
>> +	return mach_set_rtc_mmss(now);
> 
> Sorry, just noticed one more thing while applying this. Do all Xen 
> systems run on hardware that has the conventional CMOS clock?
> 
> What happens if the bare-metal needs to use efi_set_rtc() or 
> vrtc_set_mmss() ?

There's no EFI support in the upstream kernel yet when running
on Xen (the code that's in the kernel can't be used, as Dom0
can't directly invoke EFI runtime service functions).

And I don't think Xen is in any way prepared to run on
Moorestown, which afaict is where vrtc_set_mmss() comes into
the picture.

Jan


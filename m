Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab3EOSNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 14:13:40 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:39583 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919Ab3EOSNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 14:13:38 -0400
Message-ID: <5193D04F.9090204@linaro.org>
Date: Wed, 15 May 2013 11:13:35 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, xen-devel@lists.xen.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 3/3] x86/xen: sync the CMOS RTC as well as
 the Xen wallclock
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com> <1368467768-2316-4-git-send-email-david.vrabel@citrix.com> <51927339.5070402@linaro.org> <5193613E02000078000D64E9@nat28.tlf.novell.com>
In-Reply-To: <5193613E02000078000D64E9@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 01:19 AM, Jan Beulich wrote:
>>>> On 14.05.13 at 19:24, John Stultz <john.stultz@linaro.org> wrote:
>> On 05/13/2013 10:56 AM, David Vrabel wrote:
>>> From: David Vrabel <david.vrabel@citrix.com>
>>>
>>> If NTP is used in dom0 and it is synchronized to its clock source,
>>> then the kernel will periodically synchronize the Xen wallclock with
>>> the system time.  Updates to the Xen wallclock do not persist across
>>> reboots, so also synchronize the CMOS RTC (as on bare metal).
>>>
>>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
>>> ---
>>>    arch/x86/xen/time.c |   11 ++++++++++-
>>>    1 files changed, 10 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
>>> index a1947ac..4656165 100644
>>> --- a/arch/x86/xen/time.c
>>> +++ b/arch/x86/xen/time.c
>>> @@ -14,6 +14,7 @@
>>>    #include <linux/kernel_stat.h>
>>>    #include <linux/math64.h>
>>>    #include <linux/gfp.h>
>>> +#include <linux/mc146818rtc.h>
>>>    
>>>    #include <asm/pvclock.h>
>>>    #include <asm/xen/hypervisor.h>
>>> @@ -199,17 +200,25 @@ static void xen_get_wallclock(struct timespec *now)
>>>    static int xen_set_wallclock(const struct timespec *now)
>>>    {
>>>    	struct xen_platform_op op;
>>> +	int ret;
>>>    
>>>    	/* do nothing for domU */
>>>    	if (!xen_initial_domain())
>>>    		return -1;
>>>    
>>> +	/* Set the Xen wallclock. */
>>>    	op.cmd = XENPF_settime;
>>>    	op.u.settime.secs = now->tv_sec;
>>>    	op.u.settime.nsecs = now->tv_nsec;
>>>    	op.u.settime.system_time = xen_clocksource_read();
>>>    
>>> -	return HYPERVISOR_dom0_op(&op);
>>> +	ret = HYPERVISOR_dom0_op(&op);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	/* Set the hardware RTC. */
>>> +	return mach_set_rtc_mmss(now);
>> Sorry, just noticed one more thing while applying this. Do all Xen
>> systems run on hardware that has the conventional CMOS clock?
>>
>> What happens if the bare-metal needs to use efi_set_rtc() or
>> vrtc_set_mmss() ?
> There's no EFI support in the upstream kernel yet when running
> on Xen (the code that's in the kernel can't be used, as Dom0
> can't directly invoke EFI runtime service functions).
>
> And I don't think Xen is in any way prepared to run on
> Moorestown, which afaict is where vrtc_set_mmss() comes into
> the picture.

Ok.

David: Would you resubmit this patch, adding this additional context in 
a comment?

thanks
-john


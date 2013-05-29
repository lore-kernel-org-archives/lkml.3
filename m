Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964962Ab3E2HnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:43:04 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:46350 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935105Ab3E2HnB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 29 May 2013 03:43:01 -0400
Message-Id: <51A5CDA002000078000D979B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 29 May 2013 08:42:56 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>,
        "John Stultz" <john.stultz@linaro.org>
Cc: <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/2] x86/xen: sync the wallclock when
 the system time changes
References: <1369765368-10823-1-git-send-email-david.vrabel@citrix.com>
 <1369765368-10823-3-git-send-email-david.vrabel@citrix.com>
 <51A4FD47.2030301@linaro.org>
In-Reply-To: <51A4FD47.2030301@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.05.13 at 20:53, John Stultz <john.stultz@linaro.org> wrote:
> On 05/28/2013 11:22 AM, David Vrabel wrote:
>>   	op.cmd = XENPF_settime;
>> -	op.u.settime.secs = now->tv_sec;
>> -	op.u.settime.nsecs = now->tv_nsec;
>> +	op.u.settime.secs = now.tv_sec;
>> +	op.u.settime.nsecs = now.tv_nsec;
>>   	op.u.settime.system_time = xen_clocksource_read();
>>   
>>   	ret = HYPERVISOR_dom0_op(&op);
>>   	if (ret)
>> -		return ret;
>> +		return 0;
>>   
>> -	/* Set the hardware RTC. */
>> -	return mach_set_rtc_mmss(now);
>> +	last = now;
>> +	next = timespec_add(now, ns_to_timespec(NSEC_PER_SEC / 2));
>>   
> 
> Am I missing the xen_set_wallclock hook here? Your previous patch wanted 
> to call the dom0 op and then set the hardware RTC.

That ought to be intentional: We should update the hypervisor's
software wall clock here, but limit updating of the RTC to whenever
a native kernel would do this (i.e. among other things subject to
CONFIG_RTC_SYSTOHC).

Jan


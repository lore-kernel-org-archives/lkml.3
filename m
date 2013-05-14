Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab3ENJr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:47:29 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:33506 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766Ab3ENJr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:47:27 -0400
X-IronPort-AV: E=Sophos;i="4.87,669,1363132800"; 
   d="scan'208";a="23881440"
Message-ID: <5192082D.4020400@citrix.com>
Date: Tue, 14 May 2013 10:47:25 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] timekeeping: sync persistent clock and RTC on system
 time step changes
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com> <1368467768-2316-3-git-send-email-david.vrabel@citrix.com> <5191880F.3030308@linaro.org>
In-Reply-To: <5191880F.3030308@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/13 01:40, John Stultz wrote:
> On 05/13/2013 10:56 AM, David Vrabel wrote:
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> The persistent clock or the RTC is only synchronized with system time
>> every 11 minutes if NTP is running.  This gives a window where the
>> persistent clock may be incorrect after a step change in the time
>> (such as on first boot).
>>
>> This particularly affects Xen guests as until an update to the control
>> domain's persistent clock, new guests will start with the incorrect
>> system time.
>>
>> When there is a step change in the system time, call
>> update_persistent_clock or rtc_set_ntp_time() to synchronize the
>> persistent clock or RTC to the new system time.
> 
> I'm sorry, this isn't quite making sense to me. Could you further 
> describe the exact problematic behavior you're seeing here, and why its 
> a problem?

The Xen wallclock is used as the persistent clock for Xen guests.  This
is initialized (by Xen) with the CMOS RTC at the start of day.  If the
RTC is incorrect then guests will see an incorrect wallclock time until
dom0 has corrected it.

Currently dom0 only updates the Xen wallclock with the 11 min periodic
work when NTP is synced.  This leaves a window where newly started
guests will see an incorrect wallclock time.  This can cause guests to
fail to start correctly if the wallclock is now behind what it was when
the guest last started. (e.g., fsck of its disk fails as its last mount
time appears to be far into the future).

Similarly (but less problematic), if a bare metal system is rebooted
before the RTC is updated it will still have the incorrect time.

> You seem to be saying we should always set the RTC any time settimeofday 
> is called (regardless of the NTP sync state), which doesn't seem right 
> to me. Also I worry that this would cause the RTC to be set when the RTC 
> hctosys() code (or hwclock) sets the time to the RTC clock, which is a 
> bit circular.

I'm not too concerned about the behaviour of manual syncs of the RTC
because: a) if the kernel does this automatically then the use of manual
syncs is no longer necessary; and b) the RTC will still end up with the
correct time.

> I suspect once the problem is better understood, there will be a better 
> solution then trying to always set the RTC on any settimeofday() call.

David

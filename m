Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3E1Ua1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:30:27 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49943 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3E1UaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:30:25 -0400
Message-ID: <51A513DE.8010108@linaro.org>
Date: Tue, 28 May 2013 13:30:22 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>, Jan Beulich <JBeulich@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/3] timekeeping: sync persistent clock and
 RTC on system time step changes
References: <5192082D.4020400@citrix.com> <5192711B.1070607@linaro.org> <5193606502000078000D64E2@nat28.tlf.novell.com> <5193CFA2.8010008@linaro.org> <51A4F6C6.8080808@citrix.com> <20130528183137.GA23213@phenom.dumpdata.com> <51A500DA.9000708@linaro.org> <20130528194849.GA25032@phenom.dumpdata.com> <51A50D86.2080200@linaro.org> <51A50F75.7040703@linaro.org> <20130528202527.GB23266@phenom.dumpdata.com>
In-Reply-To: <20130528202527.GB23266@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 01:25 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, May 28, 2013 at 01:11:33PM -0700, John Stultz wrote:
>> On 05/28/2013 01:03 PM, John Stultz wrote:
>>> On 05/28/2013 12:48 PM, Konrad Rzeszutek Wilk wrote:
>>>> On Tue, May 28, 2013 at 12:09:14PM -0700, John Stultz wrote:
>>>>> On 05/28/2013 11:31 AM, Konrad Rzeszutek Wilk wrote:
>>>>>> On Tue, May 28, 2013 at 07:26:14PM +0100, David Vrabel wrote:
>>>>>>> On 15/05/13 19:10, John Stultz wrote:
>>>>>>>> Ok, so really, as soon as the Dom0 time is set by NTP,
>>>>>>>> all guests will
>>>>>>>> see the right time? That makes more sense, and means the window for
>>>>>>>> these sorts of issues is reasonably quite small.
>>>>>>> It's a small window but it's occurring in our automated test system.
>>>>>>>
>>>>>>>> David: So I'm less inclined to merge this individual
>>>>>>>> change, but if you
>>>>>>>> still feel strongly about it, let me know and we can
>>>>>>>> circle around on it
>>>>>>>> after you've addressed the specific issues I pointed out earlier.
>>>>>>> This patch was the actual bug fix but I've reworked it to use the
>>>>>>> pvclock_gtod notifier chain as this seemed to be what KVM hosts were
>>>>>>> using to maintain a clock for guests.  Please review the
>>>>>>> new series, thanks.
>>>>>> Looks good.
>>>>>>
>>>>>> John if you are OK I am thinking to push this to Linus
>>>>>> shortly as it is
>>>>>> fixing a bug.
>>>>> I'm really not sure I'd call this a bug.  That seems like an
>>>>> over-reaction to a misconfigured system.
>>>>>
>>>>> Or if there is a bug, I'm not sure its been clearly explained.
>>>> The #1 patch - b/c you try to set the RTC time and it actually
>>>> never takes. Meaning
>>>> on the next time the machine is booted the time is again off.
>>> Ok. Yea, that one I'm fine with and have queued for 3.11.
>>>
>>> If you want to push it as a bug fix for 3.10, I'll leave it to you
>>> to push to Linus.
>> Probably obvious, but just in case its not clear:
>>
>> Though if that one patch goes to linus for 3.10, it needs to be
>> reworked to not depend on the mach_set_rtc_mmss() interface change
>> it currently depends on. The interface change is not bugfix
>> material.
> You are referring to commit 3195ef59cb42cda3aeeb24a7fd2ba1b900c4a3cc
> Author: Prarit Bhargava <prarit@redhat.com>
> Date:   Thu Feb 14 12:02:54 2013 -0500
>
>      x86: Do full rtc synchronization with ntp

No. I mean David's patch:
     x86: Increase precision of x86_platform.get/set_wallclock()

That one should be held back for 3.11.

But the calling of mach_set_rtc_mmss() from the Xen set_wallclock hook 
would still be reasonable to go in 3.10 (limited impact to only Xen, 
fixing a bug), but it would have to limit the call to the second 
granular mach_set_rtc_mmss() in 3.10.

thanks
-john

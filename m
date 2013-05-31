Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab3EaUVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:21:16 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:34779 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3EaUVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:21:08 -0400
Message-ID: <51A90631.3060502@linaro.org>
Date: Fri, 31 May 2013 13:21:05 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/xen: sync the wallclock when the system time
 changes
References: <1369923919-26981-1-git-send-email-david.vrabel@citrix.com> <1369923919-26981-2-git-send-email-david.vrabel@citrix.com> <51A7EF3A.6060705@linaro.org> <51A87238.8090402@citrix.com>
In-Reply-To: <51A87238.8090402@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 02:49 AM, David Vrabel wrote:
> On 31/05/13 01:30, John Stultz wrote:
>> On 05/30/2013 07:25 AM, David Vrabel wrote:
>>> From: David Vrabel <david.vrabel@citrix.com>
>>>
>>> Currently the Xen wallclock is only updated every 11 minutes if NTP is
>>> synchronized to its clock source.  If a guest is started before NTP is
>>> synchronized it may see an incorrect wallclock time.
>> Ok.. So this is maybe starting to make a little more sense.
>>
>> I was under the mistaken impression domN guests referenced dom0's system
>> time when they called xen_get_wallclock(), but looking at this a bit
>> closer, its starting to make a bit more sense that xen_get_wallclock()
>> is just shared hypervisor data that is updated by dom0, and guests can
>> access this data without interacting with dom0.
>>
>> Thus I can finally see the 11 minute update interval for dom0 to update
>> the hypervisor wallclock data causes guests to get invalid time values
>> when they initialize, reading the unset by dom0 hypervisor wallclock
>> data. And thus I finally see the need for dom0 to more frequently update
>> the hypervisor wallclock data.
> This is correct.  I'll add an explanatory paragraph about the Xen
> wallclock to the changelog.

Thanks! I appreciate it!


>
>>> Use the pvclock_gtod notifier chain to receive a notification when the
>>> system time has changed and update the wallclock to match.
>>>
>>> This chain is called on every timer tick and we want to avoid an extra
>>> (expensive) hypercall on every tick.  Because dom0 has historically
>>> never provided a very accurate wallclock and guests do not expect one,
>>> we can do this simply.  The wallclock is only updated if the
>>> difference between now and the last update is more than 0.5 s.
>>
>> So given (at least I think ) I get why this is needed, is there a reason
>> you're using the notifier chain instead of a regular timer in dom0 to
>> update the hypervisor's wallclock data?
> Using the notifier allows step changes to be noticed immediately, using
> just a timer would leave a window after any step change where the Xen
> wallclock is wrong.
>
> Ideally, I would like a notification of step changes and a long period
> timer (to correct for drift).  Can you think of a good way to do this?

So we have the clock_was_set() hook that we use to notify the hrtimer 
code and we use that for the timerfd notification as well (which allows 
userland to detect changes to CLOCK_REALTIME).

Maybe that hook should get extended for this use?

>
>>> --- a/arch/x86/xen/time.c
>>> +++ b/arch/x86/xen/time.c
>>> @@ -212,6 +213,48 @@ static int xen_set_wallclock(const struct
>>> timespec *now)
>>>        return HYPERVISOR_dom0_op(&op);
>>>    }
>>>    +static int xen_pvclock_gtod_notify(struct notifier_block *nb,
>>> unsigned long unused,
>>> +                   void *priv)
>>> +{
>>> +    static struct timespec last, next;
>>> +    struct timespec now;
>>> +    struct xen_platform_op op;
>>> +    int ret;
>>> +
>>> +    /*
>>> +     * Set the Xen wallclock from Linux system time.
>>> +     *
>>> +     * dom0 hasn't historically maintained a very accurate
>>> +     * wallclock so guests don't expect it. We can therefore
>>> +     * reduce the number of expensive hypercalls by only updating
>>> +     * the wallclock every 0.5 s.
>> This comment needs some improvement. It doesn't explain why Xen needs to
>> set the virtual RTC so frequently, but then goes on to say it can be
>> done every half second because guests don't really expect it anyway.
> This would probably be better done as:
>
> if abs(current_wallclock - current_kernel_time) > threshold)
>      update_wallclock();
>
> i.e., we're correcting the wallclock if it is wrong.

Yea, this makes more sense (though reading the current_wallclock may be 
too expensive each time?).


>>> +     */
>>> +
>>> +    now = __current_kernel_time();
>> You don't seem to be holding the timekeeping lock here, so why are you
>> calling the internal __ prefixed current_kernel_time() accessor?
> The notifier chain is called from timekeeping_update() which is called
> in a write_seqcount_begin/end(&timekeeper_seq) block.

Ok. Please add a comment just to be clear.

While I was ok with it when it was merged, calling the pvclock notifier 
chain while holding the timekeeping locks is striking me as not the 
smartest approach. So this may need to change in the future.

>>> +
>>> +    if (timespec_compare(&now, &last) > 0
>> Not sure I understand why you're bothering with the last value? Aren't
>> you just wanting to trigger when now is greater then next?
> This is to handle step changes that go backwards.

Ok, thanks for the clarification.

Send me the next revision and we can get it queued up unless you want to 
look at doing something with clock_was_set instead.

thanks
-john


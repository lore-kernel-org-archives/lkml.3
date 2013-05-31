Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3EaJtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:49:52 -0400
Received: from smtp.citrix.com ([66.165.176.89]:13478 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab3EaJtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:49:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,778,1363132800"; 
   d="scan'208";a="28476778"
Message-ID: <51A87238.8090402@citrix.com>
Date: Fri, 31 May 2013 10:49:44 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: <xen-devel@lists.xen.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86/xen: sync the wallclock when the system time
 changes
References: <1369923919-26981-1-git-send-email-david.vrabel@citrix.com> <1369923919-26981-2-git-send-email-david.vrabel@citrix.com> <51A7EF3A.6060705@linaro.org>
In-Reply-To: <51A7EF3A.6060705@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/13 01:30, John Stultz wrote:
> On 05/30/2013 07:25 AM, David Vrabel wrote:
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> Currently the Xen wallclock is only updated every 11 minutes if NTP is
>> synchronized to its clock source.  If a guest is started before NTP is
>> synchronized it may see an incorrect wallclock time.
> 
> Ok.. So this is maybe starting to make a little more sense.
> 
> I was under the mistaken impression domN guests referenced dom0's system
> time when they called xen_get_wallclock(), but looking at this a bit
> closer, its starting to make a bit more sense that xen_get_wallclock()
> is just shared hypervisor data that is updated by dom0, and guests can
> access this data without interacting with dom0.
> 
> Thus I can finally see the 11 minute update interval for dom0 to update
> the hypervisor wallclock data causes guests to get invalid time values
> when they initialize, reading the unset by dom0 hypervisor wallclock
> data. And thus I finally see the need for dom0 to more frequently update
> the hypervisor wallclock data.

This is correct.  I'll add an explanatory paragraph about the Xen
wallclock to the changelog.

>> Use the pvclock_gtod notifier chain to receive a notification when the
>> system time has changed and update the wallclock to match.
>>
>> This chain is called on every timer tick and we want to avoid an extra
>> (expensive) hypercall on every tick.  Because dom0 has historically
>> never provided a very accurate wallclock and guests do not expect one,
>> we can do this simply.  The wallclock is only updated if the
>> difference between now and the last update is more than 0.5 s.
> 
> 
> So given (at least I think ) I get why this is needed, is there a reason
> you're using the notifier chain instead of a regular timer in dom0 to
> update the hypervisor's wallclock data?

Using the notifier allows step changes to be noticed immediately, using
just a timer would leave a window after any step change where the Xen
wallclock is wrong.

Ideally, I would like a notification of step changes and a long period
timer (to correct for drift).  Can you think of a good way to do this?

>> --- a/arch/x86/xen/time.c
>> +++ b/arch/x86/xen/time.c
>> @@ -212,6 +213,48 @@ static int xen_set_wallclock(const struct
>> timespec *now)
>>       return HYPERVISOR_dom0_op(&op);
>>   }
>>   +static int xen_pvclock_gtod_notify(struct notifier_block *nb,
>> unsigned long unused,
>> +                   void *priv)
>> +{
>> +    static struct timespec last, next;
>> +    struct timespec now;
>> +    struct xen_platform_op op;
>> +    int ret;
>> +
>> +    /*
>> +     * Set the Xen wallclock from Linux system time.
>> +     *
>> +     * dom0 hasn't historically maintained a very accurate
>> +     * wallclock so guests don't expect it. We can therefore
>> +     * reduce the number of expensive hypercalls by only updating
>> +     * the wallclock every 0.5 s.
> 
> This comment needs some improvement. It doesn't explain why Xen needs to
> set the virtual RTC so frequently, but then goes on to say it can be
> done every half second because guests don't really expect it anyway.

This would probably be better done as:

if abs(current_wallclock - current_kernel_time) > threshold)
    update_wallclock();

i.e., we're correcting the wallclock if it is wrong.

>> +     */
>> +
>> +    now = __current_kernel_time();
> 
> You don't seem to be holding the timekeeping lock here, so why are you
> calling the internal __ prefixed current_kernel_time() accessor?

The notifier chain is called from timekeeping_update() which is called
in a write_seqcount_begin/end(&timekeeper_seq) block.

>> +
>> +    if (timespec_compare(&now, &last) > 0
> 
> Not sure I understand why you're bothering with the last value? Aren't
> you just wanting to trigger when now is greater then next?

This is to handle step changes that go backwards.

> So again, apologies for some of the runaround in the discussion! Lets
> sort out the above minor issues and I'll be fine to queue this (given
> Xen maintainer acks) without grumbling.

No problem.

David

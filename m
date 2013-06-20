Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965282Ab3FTKuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:50:24 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:9635 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab3FTKuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:50:23 -0400
X-IronPort-AV: E=Sophos;i="4.87,904,1363132800"; 
   d="scan'208";a="30794540"
Message-ID: <51C2DE6C.2000601@citrix.com>
Date: Thu, 20 Jun 2013 11:50:20 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: <xen-devel@lists.xen.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/4] time: add a notifier chain for when the system time
 is stepped
References: <1371655523-15609-1-git-send-email-david.vrabel@citrix.com> <1371655523-15609-3-git-send-email-david.vrabel@citrix.com> <51C1E1B6.8090203@linaro.org>
In-Reply-To: <51C1E1B6.8090203@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/06/13 17:52, John Stultz wrote:
> On 06/19/2013 08:25 AM, David Vrabel wrote:
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> The high resolution timer code gets notified of step changes to the
>> system time with clock_was_set() or clock_was_set_delayed() calls.  If
>> other parts of the kernel require similar notification there is no
>> clear place to hook into.
>>
>> Add a clock_was_set atomic notifier chain
>> (clock_was_set_notifier_list) and call this in place of
>> clock_was_set().  If the timekeeping locks are held, the calls are
>> deferred to a new tasklet.
>>
>> The hrtimer code adds a notifier block to this chain and uses it to
>> call (the now internal) clock_was_set().  Since the timekeeping code
>> does not call the chain from the timer irq clock_was_set_delayed() and
>> associated code can be removed.
> 
> So on my initial quick review, this *looks* pretty reasonable. I get a
> little worried about interface abuse (ie: random drivers trying to hook
> into clock_was_set_notifier_list), but we can move that into
> timekeeper_internal.h or something similar to limit that.

I can move the actual list to time.c but we still need to provide a
register_clock_was_set_notifier() call in linux/time.h as the two
current users (Xen and hrtimers) don't include and probably should not
include timekeeper_internal.h.

> The other issue here is we've been burned pretty badly in the past with
> changes to clock_was_set(), as its key to keeping timers in line with
> timekeeping.  So this will need a fair amount of testing and run time
> before this gets merged, so 3.12 is what we'd be targeting at the
> earliest (its getting a bit late for taking changes for 3.11 anyway).

hrtimer's clock_was_set() is called at the same point in the non-delayed
case.

For the delayed case, it used to be called at the beginning of the
hrtimer softirq and now it is called from a tasklet, but if I understand
this correctly, the tasklet softirq will be called before the hrtimer
one so this should give the same behaviour.

> If you want to try to push patch 1/4 in for 3.11 via the Xen tree, I'll
> see about queuing the other three for hopefully 3.12.

3.12 is fine.  I'd prefer to have a correct and well-tested fix merged.

David

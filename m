Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab3E3X4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 19:56:05 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:46533 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3E3Xz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 19:55:56 -0400
Message-ID: <51A7E709.9080309@linaro.org>
Date: Thu, 30 May 2013 16:55:53 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv3 0/2] xen: maintain an accurate persistent clock in more
 cases
References: <1369923919-26981-1-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1369923919-26981-1-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 07:25 AM, David Vrabel wrote:
> The kernel has limited support for updating the persistent clock or
> RTC when NTP is synced.  This has the following limitations:
>
> * The persistent clock is not updated on step changes.  This leaves a
>    window where it will be incorrect (while NTP resyncs).
>
> * Xen guests use the Xen wallclock as their persistent clock.  dom0
>    maintains this clock so it is persistent for domUs and not dom0
>    itself.


So I'm still skeptical of the urgency to the first patch in this series, 
as I feel its a little overzealous in trying to enforce strict 
RTC/system-time synchronization.  But that said, these patches are now 
done in a way that doesn't affect the timekeeping core, so I'm ok with 
stepping out of the way and leaving the decision to merge it up to the 
Xen maintainers (Modulo a few nits I still have).


> These series fixes the above limitations and depends on "x86: increase
> precision of x86_platform.get/set_wallclock()" which was previously
> posted.

This is the only area that will need some coordination cross the Xen 
tree and tip/timers/core (once that patch and the fix for it I have 
queued lands in -tip). The options here are:

* I queue these two patches with proper Xen maintainer's acks/review 
(possibly adding my grumbles to the commit)
* Wait until the requried patch lands tip/timers/core, then Xen 
maintainers merge tip/timers/core into their tree as well
* These patches get rewritten so they don't depend on the "increase 
precision" patch, then we sort out the merge in -next


The first is probably the easiest, but I do want to make sure that Xen 
maintainers agree that Xen really needs to be special here compared to 
every other platform and always enforce the RTC is synced with system time.


> [ On a related note, with CONFIG_HZ=1000 sync_cmos_clock() is always
>    scheduled ~3ms too late which causes it to repeatedly try to
>    reschedule in ~997 ms and ends up never calling
>    updated_persistent_clock().  With HZ=250, the error is ~1ms too late
>    which is close enough.
>
>    It is not clear where this systematic error comes from or whether
>    this is only a Xen specific bug.  I don't have time to investigate
>    right now. ]

I'd be very interested in hearing more about this issue!

thanks
-john


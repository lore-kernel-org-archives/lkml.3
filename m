Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbaGDKjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:39:47 -0400
Received: from ms93773.hosts.iptox.net ([95.128.200.132]:49694 "EHLO
	ms93773.hosts.iptox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaGDKjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:39:44 -0400
Message-ID: <53B6846A.4030201@goldelico.com>
Date: Fri, 04 Jul 2014 12:39:38 +0200
From: Lukas Maerdian <lukas@goldelico.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, stern@rowland.harvard.edu,
        Neil Brown <neilb@suse.de>, Lukas Maerdian <lukas@goldelico.com>
Subject: Re: [PATCH] gpio_keys, twl4030-pwrbutton: stay awake for 1sec on
 resume
References: <1403906118-23517-1-git-send-email-lukas@goldelico.com> <20140628170820.GF23634@xo-6d-61-c0.localdomain> <BD5D0538-BD03-4CD8-8E12-2344AD7ED669@goldelico.com> <20140628200410.GA7561@amd.pavel.ucw.cz>
In-Reply-To: <20140628200410.GA7561@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

On 28.06.2014 22:04 UTC+0200, Pavel Machek wrote:
>> And the msec parameter is described as:
>>
>> @msec: Anticipated event processing time (in milliseconds).
>>
>> Isn't calling pm_wakeup_event() with a non-zero msec the standard
>> method to handle this situation? And it is used in other drivers. E.g. in
>> _mmc_detect_change() or hub_suspend().
> 
>  * Notify the PM core of a wakeup event whose source is @ws that will
>    take                    
>  * approximately @msec milliseconds to be processed by the kernel.  If
>    @ws is                 
>  * not active, activate it.  If @msec is nonzero, set up the @ws'
>    timer to                    
>  * execute pm_wakeup_timer_fn() in future.                                                    
> 
> Will take @msec milliseconds to be processed by the _kernel_. Yes, USB
> probing takes a lot of time in kernel. But you are using this
> parameter to wait for userspace...

Well, it's not exactly waiting for userspace: The kernel goes to
suspend, before even being fully resumed.

In any case, 0 msec (i.e. nothing) seems to be insufficient, even for
just the in kernel processing. And I think that's exactly the root cause
of this race condition between the device drivers and the autosleep
module. Of course this only materializes if CONFIG_PM_AUTOSLEEP and
CONFIG_PM_WAKELOCKS are enabled, which is rarely used up to now, I guess.

I think we either need some way of signaling that the kernel has fully
finished resuming, before autosleep sets the system to suspend state
again, or we need to set appropriate delays in the individual device
drivers, to give them enough time to process the resume event.

As the pm_wakeup_event() call is already in place, I assume, that
setting appropriate processing times for each individual driver was the
intended way to go...

I've CCed Neil Brown, who inserted the pm_wakeup_even() call with a
0msec argument in both of the discussed drivers, so maybe he can shed
some light in this discussion?

Best regards,
  Lukas

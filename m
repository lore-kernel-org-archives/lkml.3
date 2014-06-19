Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965006AbaFSTZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:25:20 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:42620 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964957AbaFSTZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:25:17 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Allen Yu <alleny@nvidia.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled and device suspended.
References: <Pine.LNX.4.44L0.1406191049240.1247-100000@iolanthe.rowland.org>
Date: Thu, 19 Jun 2014 12:25:14 -0700
In-Reply-To: <Pine.LNX.4.44L0.1406191049240.1247-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Thu, 19 Jun 2014 10:56:30 -0400 (EDT)")
Message-ID: <7h61jwwvl1.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Thu, 19 Jun 2014, Allen Yu wrote:
>
>> So what's the exact state of device if dev->power.is_suspended flag
>> is set and runtime_status is RPM_ACTIVE? Is it a state like
>> "suspended but still can be accessed"?
>> 
>> I'm just afraid the existing code would cause a device hang if we
>> allow it to be accessed even though it's suspended (at this point
>> RPM_ACTIVE could be meaningless). I don't understand the original
>> motivation of these code. If it's a valid case, most likely it should
>> be handled in the specific device driver instead of the PM core.
>
> You should read the Changelog for commit 6f3c77b040f (PM / Runtime:  
> let rpm_resume() succeed if RPM_ACTIVE, even when disabled, v2).  It
> explains why the code looks the way it does.
>
> However, I'm starting to think the reasoning in that commit may not be
> valid.  While perhaps it is okay for some I2C devices (mentioned in the
> commit log), it probably isn't okay in general.

Why not?

> Kevin, do have any comments on this matter?  What do you think about 
> making the following change to rpm_resume():
>
>  repeat:
> 	if (dev->power.runtime_error)
> 		retval = -EINVAL;
> -	else if (dev->power.disable_depth == 1 && dev->power.is_suspended
> +	else if (dev->power.disable_depth > 0
> 	    && dev->power.runtime_status == RPM_ACTIVE)
> 		retval = 1;
> 	else if (dev->power.disable_depth > 0)
>
> Or even:
>
> +	else if (dev->power.disable_depth > 0 && !dev->power.is_suspended
>
> although this would require the I2C driver you mentioned in your commit 
> to change.

My change was introduced to catch a very specific case.  Namely, when we
know that the core has successfully asked the device to do a system suspend
(dev->power.is_suspended == true) *and* we know that runtime PM was
disabled *only* by the PM core (disable_depth == 0) while the device was
still active (runtime_status == RPM_ACTIVE.)

In your first idea above, it would allow a _get() to succeed even if
someone other than the core (including the driver itself) had called
pm_runtime_disable().  I don't think we want that.

In the second idea above, we'd completely miss the case where runtime PM
has been disabled by the core (because the core would have set
dev->power.is_suspended)

In both cases, we're no longer just checking for that specific condition
I was after, so I'd have to spend more time thinking about any other
possible consequences as well.

I think part of the confusion here is coming from what
dev->power.is_suspended means.  From the core's perspective, it just
means that the core has called the ->suspend callback, and didn't detect
any errors.  

Depending on the driver though, it doesn't have to mean that the device
is actually fully suspended.  For example, there are several cases of
"runtime PM centric" drivers are may be needed by other devices during
the system suspend/resume process and so are runtime PM resumed during
system suspend.

Kevin

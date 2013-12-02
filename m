Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab3LBPvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:51:05 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:62464 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3LBPvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:51:03 -0500
MIME-Version: 1.0
In-Reply-To: <4994754.y6gINBtP7i@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1311291014020.27250-100000@netrider.rowland.org>
	<4994754.y6gINBtP7i@vostro.rjw.lan>
Date: Mon, 2 Dec 2013 16:50:59 +0100
Message-ID: <CAPDyKFpf58CRKUhFPKHyg4S9oaUR=XHJQs=hK7p63Hkv8gnbbw@mail.gmail.com>
Subject: Re: [PATCH 0/5] PM: Enable option of re-use runtime PM callbacks at
 system suspend
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> That would be kind of OK, if the driver's .suspend_late() only invoked its own
> .runtime_suspend(), what you did below.
>
> But, in the Ulf's approach the driver calls .runtime_suspend() from
> its *subsystem* in the hope that it will all work out properly (or
> perhaps based on the knowledge about this particular subsystem).

Correct assumption.

>
> As I said, that may lead to problems when the same driver is attempted to
> be used with a different subsystem-level code (for example, a different PM
> domain).

I don't think this is an issue we need to consider.

I assume the reason for having a PM domain is typically because you
have a PM domain regulator to handle. Certainly the PM domain,
controls it by using the runtime PM callbacks.

Thus it does not make sense to bypass the PM domain callbacks, and
just letting the driver call it's own runtime PM callbacks during
system suspend. It will only do parts of the work then.

>
>> The amount of code needed is quite small; basically nothing more than:
>>
>>       if (!pm_runtime_status_suspended(dev))
>>               dev->driver->pm->runtime_suspend(dev);
>>
>> The problems are:
>>
>>      1. Which callback does this code belong in?
>>
>>      2. Which runtime_suspend callback should be invoked?  The example
>>       above uses dev->driver->pm->runtime_suspend, but this may not
>>       always be the right one.
>
> Well, none of them may always be the right one, which is my point.
>
> I don't think we can come up with a really generic set of routines that will
> be generally useful regardless of the subsystem/driver combination in question,
> so in my opinion the PM core is not the right place to put such routines into.
>
> I wouldn't have problems with them being defined in the OMAP PM code.  As part
> of that code they are free to do whatever they like if that code's maintainers
> are fine with that.  But I don't want to see such confusing stuff in the core.

As I just replied in my other email, having the code to be available
and used in the PM domain code is not an option that we will gain
from. The OMAP PM domain already does this, though in a slightly other
form  - and side effects is not what we want.

The drivers need to re-use and invoke the runtime PM callbacks, that
is to me the only option that makes sense.

At the same time, I somewhat agree with you that the new functions I
propose to be added is not so "generic". What if we think of them as
pm_runtime helper functions instead, would that make more sense?

Kind regards
Uffe

>
> Anyway, I'd like to understand what problems in particular those things would
> be useful to solve, as I suspect that they may be addressed differently and
> more cleanly.
>
> Thanks,
> Rafael
>

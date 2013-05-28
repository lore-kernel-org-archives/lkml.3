Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab3E1S0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:26:14 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43922 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3E1S0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:26:11 -0400
MIME-Version: 1.0
In-Reply-To: <3006354.hOxNuWCXu4@vostro.rjw.lan>
References: <1368221329-1841-1-git-send-email-zoran.markovic@linaro.org>
	<29127567.mTXaJOMILH@vostro.rjw.lan>
	<CAMbhsRSweH-gwq4yettOnw9bDQebYR8A2o71nWRjY4aN=1+++w@mail.gmail.com>
	<3006354.hOxNuWCXu4@vostro.rjw.lan>
Date: Tue, 28 May 2013 11:26:09 -0700
Message-ID: <CAME+o4kJYD2K_aL4xNi-jNP1Q8R+seDNZDwsGBhvU00ArR0Skg@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/2] drivers: power: Add watchdog timer to catch
 drivers which lockup during suspend/resume.
From: Zoran Markovic <zoran.markovic@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Colin Cross <ccross@android.com>, lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What about this:
>  - Add one more list_head to struct dev_pm_info.
>  - Make dpm_prepare() create a new list for the next steps instead of moving
>    devices out of dpm_list.
>  - Start an async work to carry out dpm_suspend() and make the main thread
>    do wait_for_completion_timeout() for every device in dpm_list (in the
>    reverse order).
>  - If it times out, mark the device in question as unusable, possibly resume
>    the already suspended devices (except for descendants of the failed one)
>    and abort the suspend.  Return a specific error code to user space so that
>    it knows what happened.  [You can make this step configurable to BUG()
>    instead of doing all those things if you think that will be more useful for
>    platforms you care about.]
>  - Disable future suspends.
> And analogously for resume.
>
> That should allow people to investigate what happened on a system that
> (hopefully) is not completely dead and you still can have your "reboot if
> suspend hangs" feature if you like.

I looked into implementing this. The problem that I encountered is
that there is no reliable way of canceling an async task, and hence
the asynchronous __device_suspend() would be left racing with a
recovery from a suspend timeout. We could do cancel_work_sync() as a
recovery, but that call blocks until the running async task is
flushed, which might never happen. So doing a panic() is pretty much
the only option for recovering.
- Zoran

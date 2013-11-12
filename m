Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3KLTYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:24:07 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:34334 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3KLTYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:24:06 -0500
MIME-Version: 1.0
In-Reply-To: <7789635.0eeyCxz2tM@vostro.rjw.lan>
References: <1384192591-20916-1-git-send-email-amit.pundir@linaro.org>
	<7789635.0eeyCxz2tM@vostro.rjw.lan>
Date: Tue, 12 Nov 2013 11:24:05 -0800
Message-ID: <CALAqxLXL_rE=1BanFyR=4iTLsSoZttAu72aXraQnWBRr9HxYvw@mail.gmail.com>
Subject: Re: [RFC][PATCH] epoll: allow EPOLLWAKEUP flag if PM_SLEEP is enabled
From: John Stultz <john.stultz@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Amit Pundir <amit.pundir@linaro.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 1:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, November 11, 2013 11:26:31 PM Amit Pundir wrote:
>> While looking into the problem, I found that ep_create_wakeup_source()
>> reports ENOMEM if wakeup_source_register() returns NULL.
>> ep_create_wakeup_source() assumes that NULL is only returned if we run
>> into ENOMEM but NULL is also returned when CONFIG_PM_SLEEP is disabled.
>
> So the error value should not be ENOMEM.

Right, ENOMEM is clearly wrong. I think its just not clear what the
right thing to do is.


>> If CONFIG_PM_SLEEP is disabled, stripping the EPOLLWAKEUP flag seems to
>> be a reasonable solution here, allowing the call to succeed, while
>> dropping the wakeup logic.  While returning EINVAL might also be a good
>> solution, stripping the flag seems to follow the established behavior,
>> as is done when the process doesn't have sufficient capabilities to
>> block suspend.
>
> Which is a different thing.

Well, in the case of the process not having sufficient capabilities,
-EPERM seems like a reasonable return value.  But instead the wakeup
flag is silently dropped.  That's why Amit is asking if dropping the
wakeup flag is also the right approach for the !PM_SLEEP case instead
of returning EINVAL.

Dropping the wakeup flag is the easier solution, since we don't have
to then go through all the userspace code and have it handle the error
and resubmit without the wakeup flag.  I suspect this was the same
consideration for the decision in the insufficient capabilities case,
but I don't really know.

thanks
-john

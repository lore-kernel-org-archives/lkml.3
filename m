Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaCZRXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 13:23:07 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:54258 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaCZRXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 13:23:04 -0400
MIME-Version: 1.0
In-Reply-To: <CADHgK6uXg0CXZC5s5Z5Kpy6dYH58UChL-p9ozCCcoUU=-0KJYw@mail.gmail.com>
References: <1395348795-8554-1-git-send-email-sebastian.capella@linaro.org>
	<1395348795-8554-2-git-send-email-sebastian.capella@linaro.org>
	<20140320212336.GA17368@amd.pavel.ucw.cz>
	<20140320213502.795a5d3c@alan.etchedpixels.co.uk>
	<CADHgK6uXg0CXZC5s5Z5Kpy6dYH58UChL-p9ozCCcoUU=-0KJYw@mail.gmail.com>
Date: Wed, 26 Mar 2014 10:22:29 -0700
Message-ID: <CADHgK6sh6TUc4jBQFQHTQuhze9=r2FBzF6aULUc_c+bbWYjp5w@mail.gmail.com>
Subject: Re: [PATCH RFC] PM / Hibernate: no kernel_power_off when pm_power_off NULL
From: Sebastian Capella <sebastian.capella@linaro.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 20 March 2014 14:35, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:
>>>       if (pm_power_off)
>>>                 pm_power_off();
>>> ## It really should do while (1) here.
>>         while(1)
>>                 cpu_relax();
>> or similar at minimum.

Hi Alan, Pavel,

I prepared the changes suggested for ARM, but Russell disagrees that
this code must block, and points to the kernel/reboot.c function from
which I'd taken the original change.

> On Mar 26, Russell King - ARM Linux wrote:
>> I don't see why we should make this change.  kernel/reboot.c handles
>> this function returning, so other places should do too.
>> Even on x86, this function can return:
>>
>> Therefore, I'd say... it's a bug in the hibernation code - or we probably
>> have many buggy architectures.  I'd suggest fixing the hibernation code
>> rather than stuffing some workaround like an endless loop into every
>> architecture.

In this case, the hibernation code would need to changed prevent
calling both sets of notifiers.

The discussions are very short, but the details are here:

https://lkml.org/lkml/2014/3/25/554  -- linux-arm discussion
https://lkml.org/lkml/2014/3/20/649  -- linux-pm discussion

It doesn't appear definitive that the machine_power_off should block,
since the reboot call is working around the possibility.

If we go the route Russell proposes, the change would basically be
this patch.  Are you ok with me trying to adjust the hibernation
handling here?  Do you have any further thoughts on this?

Thanks!

Sebastian

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646Ab3EBS3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:29:07 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:49750 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760289Ab3EBS3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:29:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130502122747.GA22618@amd.pavel.ucw.cz>
References: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
	<1367360914-23389-2-git-send-email-zoran.markovic@linaro.org>
	<20130501002929.GA20042@amd.pavel.ucw.cz>
	<CAMbhsRRisa15fH9AodepfRJUv6t6dipqb6CMbOOrtzVsMUCoxQ@mail.gmail.com>
	<20130502122747.GA22618@amd.pavel.ucw.cz>
Date: Thu, 2 May 2013 11:29:03 -0700
X-Google-Sender-Auth: q4w5QnHZP2yQAkClMO6swgkZEgs
Message-ID: <CAMbhsRQ4tCQtSxA-5tqydKp-xQf1bnrsq7GNw5q0gk3NdPZyaA@mail.gmail.com>
Subject: Re: [RFC PATCH] power: Add option to log time spent in suspend
From: Colin Cross <ccross@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        Benoit Goby <benoit@android.com>, John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 5:27 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >> +#include <linux/debugfs.h>
>> >> +#include <linux/err.h>
>> >> +#include <linux/init.h>
>> >> +#include <linux/kernel.h>
>> >> +#include <linux/seq_file.h>
>> >> +#include <linux/syscore_ops.h>
>> >> +#include <linux/time.h>
>> >> +
>> >> +static struct timespec suspend_time_before;
>> >> +static unsigned int time_in_suspend_bins[32];
>> >> +
>> >> +#ifdef CONFIG_DEBUG_FS
>> >> +static int suspend_time_debug_show(struct seq_file *s, void *data)
>> >> +{
>> >> +     unsigned int bin;
>> >> +     seq_printf(s, "      time (secs)        count\n");
>> >> +     seq_printf(s, "------------------------------\n");
>> >> +     for (bin = 0; bin < 32; bin++) {
>> >> +             if (time_in_suspend_bins[bin] == 0)
>> >> +                     continue;
>> >> +             seq_printf(s, "%10u - %-10u %4u\n",
>> >> +                     bin ? 1 << (bin - 1) : 0, 1 << bin,
>> >> +                             time_in_suspend_bins[bin]);
>> >> +     }
>> >> +     return 0;
>> >> +}
>> >> +
>> >> +static int suspend_time_debug_open(struct inode *inode, struct file *file)
>> >> +{
>> >> +     return single_open(file, suspend_time_debug_show, NULL);
>> >> +}
>> >
>> > Ok, whole new driver to get timing info... As we already have times in
>> > printk, can't existing printks() get the same info? Maybe
>> > Documentation/ file describing how to get that info from dmesg would
>> > be enough?
>>
>> If this were to be merged I assume it would be rewritten directly into
>> kernel/power/suspend.c instead of using syscore ops.  That was just
>> done to ease future merges while it was out of tree.
>>
>> dmesg is not the solution, it's not a stable api, it would require
>> constant parsing to make sure you didn't miss data before it fell out
>> of the ringbuffer, and sched_clock often does not (and should not)
>> tick during suspend, so printk times don't show the time spent
>> suspended.
>
> If timing info printed is invalid, that should be fixed.

It's not invalid, its just not measuring the time that is useful here.
 printk is measuring something similar to (but not exactly the same
as) CLOCK_MONOTONIC, but this is measuring something similar to
CLOCK_BOOTTIME.

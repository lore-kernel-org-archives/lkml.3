Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107Ab3EAA3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 20:29:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49221 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933840Ab3EAA3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 20:29:31 -0400
Date: Wed, 1 May 2013 02:29:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zoran Markovic <zoran.markovic@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        Benoit Goby <benoit@android.com>, John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: Re: [RFC PATCH] power: Add option to log time spent in suspend
Message-ID: <20130501002929.GA20042@amd.pavel.ucw.cz>
References: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
 <1367360914-23389-2-git-send-email-zoran.markovic@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367360914-23389-2-git-send-email-zoran.markovic@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Colin Cross <ccross@android.com>
> 
> Below is a patch from android kernel that maintains a histogram of
> suspend times. Please review and provide feedback.
> 
> Prints the time spent in suspend in the kernel log, and keeps statistics
> on the time spent in suspend in /sys/kernel/debug/suspend_time
> 
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: Colin Cross <ccross@android.com>
> Cc: Todd Poynor <toddpoynor@google.com>
> Cc: San Mehat <san@google.com>
> Cc: Benoit Goby <benoit@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Len Brown <len.brown@intel.com>
> Signed-off-by: Colin Cross <ccross@android.com>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> [zoran.markovic@linaro.org: Re-formatted suspend time table to better fit
> expected values, tweaked commit message]
> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>

> +++ b/kernel/power/suspend_time.c
> @@ -0,0 +1,111 @@
> +/*
> + * debugfs file to track time spent in suspend
> + *
> + * Copyright (c) 2011, Google, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#include <linux/debugfs.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/seq_file.h>
> +#include <linux/syscore_ops.h>
> +#include <linux/time.h>
> +
> +static struct timespec suspend_time_before;
> +static unsigned int time_in_suspend_bins[32];
> +
> +#ifdef CONFIG_DEBUG_FS
> +static int suspend_time_debug_show(struct seq_file *s, void *data)
> +{
> +	unsigned int bin;
> +	seq_printf(s, "      time (secs)        count\n");
> +	seq_printf(s, "------------------------------\n");
> +	for (bin = 0; bin < 32; bin++) {
> +		if (time_in_suspend_bins[bin] == 0)
> +			continue;
> +		seq_printf(s, "%10u - %-10u %4u\n",
> +			bin ? 1 << (bin - 1) : 0, 1 << bin,
> +				time_in_suspend_bins[bin]);
> +	}
> +	return 0;
> +}
> +
> +static int suspend_time_debug_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, suspend_time_debug_show, NULL);
> +}

Ok, whole new driver to get timing info... As we already have times in
printk, can't existing printks() get the same info? Maybe
Documentation/ file describing how to get that info from dmesg would
be enough?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3FNUzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 16:55:05 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38233 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751126Ab3FNUzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 16:55:04 -0400
Message-ID: <1371243301.31941.61.camel@joe-AO722>
Subject: Re: [PATCH v2] power: Include additional information in
 pm_print_times
From: Joe Perches <joe@perches.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com, gregkh@linuxfoundation.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Date: Fri, 14 Jun 2013 13:55:01 -0700
In-Reply-To: <1371242124-11452-1-git-send-email-shuah.kh@samsung.com>
References: <1371242124-11452-1-git-send-email-shuah.kh@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 14:35 -0600, Shuah Khan wrote:
> Change __device_suspend() path to include driver name and the ops that
> get run for a device. This additional information helps associate the
> driver and the type of pm_ops the device uses in the suspend path very
> quickly which will aid in debugging problems in suspend and resume paths.
> Changed both start and end debug messages to include pm_ops information
> and use dev_info() instead of pr_info().
> 
> dmesg output before the change:
> 
> [  164.390032] calling  1-1+ @ 69, parent: usb1
> [  164.390035] call 1-1+ returned 0 after 0 usecs

> dmesg output after the change:
> 
> [   58.707002] usb usb1: calling type pm ops @ 57, parent: 0000:00:1d.0
> [   58.707641] usb usb1: call type pm ops returned 0 after 611 usecs

> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
[]
> +static ktime_t initcall_debug_start(struct device *dev, char *info)
[]
> +		/* string in info has an extra space at the end */
> +		dev_info(dev, "calling %s@ %i, parent: %s\n",
> +			info, task_pid_nr(current),
>  			dev->parent ? dev_name(dev->parent) : "none");

>  static void initcall_debug_report(struct device *dev, ktime_t calltime,
[]
> -		pr_info("call %s+ returned %d after %Ld usecs\n", dev_name(dev),
> +		/* string in info has an extra space at the end */
> +		dev_info(dev, "call %sreturned %d after %llu usecs\n", info,
>  			error, (unsigned long long)ktime_to_ns(delta) >> 10);

Perhaps align the "calling and "call" and include
task_pid_nr(current)?

[   58.707002] usb usb1: calling type pm ops @ 57, parent: 0000:00:1d.0
[   58.707641] usb usb1: call type pm ops returned 0 after 611 usecs

so it's:

[   58.707002] usb usb1: enter 'type pm ops' @ 57, parent: 0000:00:1d.0
[   58.707641] usb usb1: exit  'type pm ops' @ 57, parent: 0000:00:1d.0, error: 0 (611 usecs)

or:

[   58.707002] usb usb1: enter 'type pm ops' @ 57, parent: 0000:00:1d.0
[   58.707641] usb usb1: exit  'type pm ops' @ 57, error:  0 (611 usecs)



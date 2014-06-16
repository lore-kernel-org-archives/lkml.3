Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbaFPRkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:40:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54314 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932243AbaFPRkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:40:06 -0400
Date: Mon, 16 Jun 2014 13:40:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Allen Yu <alleny@nvidia.com>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled
 and device suspended.
In-Reply-To: <1402740209-16432-1-git-send-email-alleny@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1406161329350.1292-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jun 2014, Allen Yu wrote:

> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -608,7 +608,7 @@ static int rpm_resume(struct device *dev, int rpmflags)
>   repeat:
>  	if (dev->power.runtime_error)
>  		retval = -EINVAL;
> -	else if (dev->power.disable_depth == 1 && dev->power.is_suspended
> +	else if (dev->power.disable_depth == 1 && !dev->power.is_suspended
>  	    && dev->power.runtime_status == RPM_ACTIVE)
>  		retval = 1;

For reasons having nothing to do with Allen's suggested change, I
wonder if we shouldn't replace this line with something like:

-	else if (dev->power.disable_depth == 1 && dev->power.is_suspended
+	else if (dev->power.disable > 0 && !dev->power.is_suspended
	    && dev->power.runtime_status == RPM_ACTIVE)
		retval = 1;

It seems that I've been bitten by this several times in the past.  
When a device is disabled for runtime PM, and more or less permanently
stuck in the RPM_ACTIVE state, calls to pm_runtime_resume() or
pm_runtime_get_sync() shouldn't fail.

For example, suppose some devices of a certain type support runtime 
power management but others don't.  We naturally want to call 
pm_runtime_disable() for the ones that don't.  But we also want the 
same driver to work for all the devices, which means that 
pm_runtime_get_sync() should return success -- otherwise the driver 
will think that something has gone wrong.

Rafael, what do you think?

Alan Stern


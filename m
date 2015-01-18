Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbbARDO2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 22:14:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbbARDO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 22:14:27 -0500
Date: Sat, 17 Jan 2015 19:11:26 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: Re: [PATCH] sysfs: group: allow is_visible to drop permissions
Message-ID: <20150118031126.GA8929@kroah.com>
References: <526250410.74266.1421532551922.JavaMail.root@mail>
 <54BB102B.1060606@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BB102B.1060606@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 05:45:15PM -0800, Guenter Roeck wrote:
> On 01/17/2015 02:09 PM, Vivien Didelot wrote:
> >Hi Guenter, Greg,
> >
> [ .. ]
> 
> >
> >BTW Guenter, does this patch make sense to you?
> >
> 
> It does make sense to me to only use the return value from is_visible
> for the mode.
> 
> As for which bits to use, I am not entirely sure. I think it would be
> more important to first decide which bits should be acceptable to start with.
> 
> Then I would _always_ only use the bits from mode, masked against the
> valid bits, whatever they are.
> 
> 	umode_t mode = (*attr)->mode;
> 	...
> 	if (grp->is_visible) {
> 		mode = grp->is_visible(kobj, *attr, i);
> 		if (!mode)
> 			continue;
> 	}
> 
> 	WARN(mode & ~(S_IRUGO | S_IWUGO | SYSFS_PREALLOC),	/* optional */
> 	     "Attribute %s: Invalid permission 0x%x\n", (*attr)->name, mode);
> 
> 	mode &= S_IRUGO | S_IWUGO | SYSFS_PREALLOC;
> 	error = sysfs_add_file_mode_ns(parent, *attr, false, mode, NULL);
> 	...
> 
> >
> >My assumption here was that the attribute group is_visible function
> >should just be able to adjust the UGO bits. Am I correct?
> >
> I would think so.
> 
> >I'm not even sure about the execute permission though. Only one driver
> >uses it for an attribute and it seems wrong, in drivers/hid/hid-lg4ff.c:
> >
> >static DEVICE_ATTR(range, S_IRWXU | S_IRWXG | S_IROTH, lg4ff_range_show, lg4ff_range_store);
> >
> That seems wrong.
> 
> >
> >The actual behavior seems wrong to me. Again, what happens is you return
> >SYSFS_PREALLOC, that the underlying sysfs_add_file_mode_ns() function is
> >actually checking?
> >
> Ultimately, the implementor asked for it.
> 
> >IMHO, if we want an attribute group to only be able to "hide or show" an
> >attribute, then is_visible (as the name suggests) should return a
> >boolean. If we want it be able to adjust permissions (as it seems
> >correct, given the examples), we should identify which permissions are
> >OK to change, deprecate is_visible function (to avoid code break) in
> >favor of a new one which limits the bits to that scope.
> >
> 
> Up to Greg to decide. From my perspective, we have lived with is_visible
> for several years and overall it seems to work. Sure, it lacks a clear
> API, but that can be fixed without changing a lot of code just to replace
> the function name.

If someone wants to submit a "cleaner" patch, I'm always willing to
review it, but the one submitted here I can't take for the reasons I
gave at the least.

thanks,

greg k-h

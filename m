Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab3CPQUe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 12:20:34 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:52697 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3CPQUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 12:20:33 -0400
Date: Sat, 16 Mar 2013 09:21:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] fs: sysfs: Add devres support
Message-ID: <20130316162140.GB2630@kroah.com>
References: <1363317887-24009-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363317887-24009-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 08:24:45PM -0700, Guenter Roeck wrote:
> Provide devres functions for device_create_file, sysfs_create_file,
> and sysfs_create_group plus the respective remove functions.
> 
> Idea is to be able to drop calls to the remove functions from the various
> drivers using those calls.

Hm, despite the fact that almost every driver that makes these calls is
broken?  :)

> Potential savings are substantial. There are more than 700 calls to
> device_remove_file in the kernel, more than 500 calls to sysfs_remove_group,
> and some 50 calls to sysfs_remove_file (though not all of those use dev->kobj
> as parameter). Expanding the API to sysfs_create_bin_file would add another 80+
> opportunities, and adding sysfs_create_link would create another 100 or so.

The idea is nice, but why are these drivers adding sysfs files on their
own?  Are they doing this in a way that is race-free with userspace
(i.e. creating them before userspace is told about the device), or are
they broken and need to have these calls added to the "default
device/driver/bus" attribute list for them instead?

I think the "we need to fix the drivers" option is the correct one :(

Ideally, I could get rid of those files from being exported at all, but
some busses do do things correctly, so I can't.  But they seem to be in
the minority...

So how about we fix up the drivers first, then, if there are valid users
for this type of interface (which I do think there is), we can add it
then?

thanks,

greg k-h

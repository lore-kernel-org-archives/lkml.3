Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3IXWKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 18:10:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3IXWKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 18:10:13 -0400
Date: Tue, 24 Sep 2013 15:10:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Benson Leung <bleung@chromium.org>
Cc: ming.lei@canonical.com, linux-kernel@vger.kernel.org, olofj@chromium.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] driver core : Fix use after free of dev->parent in
 device_shutdown
Message-ID: <20130924221011.GA3837@kroah.com>
References: <1380058748-9347-1-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380058748-9347-1-git-send-email-bleung@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 02:39:08PM -0700, Benson Leung wrote:
> The put_device(dev) at the bottom of the loop of device_shutdown
> may result in the dev being cleaned up. In device_create_release,
> the dev is kfreed.
> 
> However, device_shutdown attempts to use the dev pointer again after
> put_device by referring to dev->parent.
> 
> Copy the parent pointer instead to avoid this condition.
> 
> This bug was found on Chromium OS's chromeos-3.8, which is based on v3.8.11.
> See bug report : https://code.google.com/p/chromium/issues/detail?id=297842
> This can easily be reproduced when shutting down with
> hidraw devices that report battery condition.
> Two examples are the HP Bluetooth Mouse X4000b and the Apple Magic Mouse.
> For example, with the magic mouse :
> The dev in question is "hidraw0"
> dev->parent is "magicmouse"
> 
> In the course of the shutdown for this device, the input event cleanup calls
> a put on hidraw0, decrementing its reference count.
> When we finally get to put_device(dev) in device_shutdown, kobject_cleanup
> is called and device_create_release does kfree(dev).
> dev->parent is no longer valid, and we may crash in
> put_device(dev->parent).
> 
> This change should be applied on any kernel with this change :
> d1c6c030fcec6f860d9bb6c632a3ebe62e28440b
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Benson Leung <bleung@chromium.org>

The patch makes sense, but I wonder why no one has ever seen this
problem before.

Odd...

thanks for the fix, I'll queue it up for 3.12-final soon.

greg k-h

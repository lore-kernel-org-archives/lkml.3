Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3CKPdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:33:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50231 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753864Ab3CKPct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:32:49 -0400
Date: Mon, 11 Mar 2013 11:32:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <tom.leiming@gmail.com>
cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] usb/core/devio.c: Don't use GFP_KERNEL while we cannot
 reset a storage device
In-Reply-To: <CACVXFVNuJa0i9gtUWP2tVexwjKF0k1MJ2bA9V5M28LUWFJt5DQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1303111127030.2246-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Mar 2013, Ming Lei wrote:

> On Sat, Mar 9, 2013 at 12:50 AM, Alexey Khoroshilov
> <khoroshilov@ispras.ru> wrote:
> > As it was described by Oliver Neukum in commit acbe2fe
> > "USB: Don't use GFP_KERNEL while we cannot reset a storage device":
> >
> >   Memory allocations with GFP_KERNEL can cause IO to a storage device
> >   which can fail resulting in a need to reset the device. Therefore
> >   GFP_KERNEL cannot be safely used between usb_lock_device()
> >   and usb_unlock_device(). Replace by GFP_NOIO.
> >
> > The patch fixes the same issue in usb/core/devio.c.
> > All the allocations fixed are under usb_lock_device() from usbdev_do_ioctl().
> 
> I am wondering why the device lock is needed for usbdev_do_ioctl()? Looks
> device lock isn't required for USB transfer of kernel driver.

Of course you have to lock the device before changing its driver.  What 
would happen if two different threads tried to change a device's driver 
at the same time?

usbdev_do_ioctl() needs to acquire the device lock in order to prevent 
races with driver_disconnect() and usbdev_remove().

Alan Stern


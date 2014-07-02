Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbaGBSY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 14:24:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49589 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754483AbaGBSYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 14:24:55 -0400
Date: Wed, 2 Jul 2014 14:24:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Klug <stefan.klug@baslerweb.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] USB: zerocopy support for usbfs
In-Reply-To: <53B42B14.7010303@baslerweb.com>
Message-ID: <Pine.LNX.4.44L0.1407021355060.874-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014, Stefan Klug wrote:

> Hi everybody,
> in short: The attached patch adds zerocopy support to the usbfs driver.
> I tested it on x86 and on a globalscale mirabox ARM board. Until now it 
> works
> quite nice and I'd love to get some comments and feedback on the patch.
> 
> Longer version: The usbfs driver does not support direct data transfers 
> from the controller
> to user-memory. For several use-cases (in my case USB3 Vision cameras 
> pushing up to 360MB/s)
> the copy operation from kernel to user-space results in a lot of 
> unnecessary CPU overhead
> especially on small embedded devices. I measured a decrease in CPU usage 
> from 44% to 22% on
> a the mirabox.
> 
> This patch implements zerocopy beside the existing code paths, so it is 
> easy to disable
> zerocopy at runtime and to directly compare the CPU usage.
> To disable zerocopy just do an
>      echo 1 > /sys/module/usbcore/parameters/usbfs_disable_zerocopy
> and to reenable it
>      echo 0 > /sys/module/usbcore/parameters/usbfs_disable_zerocopy
> 
> On modern desktop systems the change in CPU usage is quite low so this 
> mostly affects
> smaller embedded devices.
> 
> Implementation details:
> The patch only touches drivers/usb/core/devio.c.
> In procy_do_submiturb(), it is checked if zerocopy is allowed. This is 
> currently a rough
> check which compares the number of required pages to 
> ps->dev->bus->sg_tablesize.
> I don't know if there is more to check there.
> Then the user memory provided inside the usbdevfs_urb structure is 
> pinned to
> physical memory using get_user_pages_fast().
> All the user pages are added to the scatter-gather list and the logic 
> continues as before.
> In copy_urb_data_to_user() the pages are marked with 
> set_page_dirty_lock() if the transfer
>   was a zerocopy one.
> In free_async() the pinned pages are released, if the transfer was a 
> zerocopy one.

Overall this implementation seems quite straightforward.  However, it
appears that your email client has mangled the whitespace in the patch.

The patch contains many style violations; you should run it through
checkpatch.pl.  It also has one or two mistakes, such as the
calculation of u for the amount of memory used.

> Questions/Notes:
> - I'm quite unhappy with the added member async::is_user_mem. Is there a 
> better place
>    where I could store this information?

No, async is the right place.  Why are you unhappy about it?

> - I had a look at some other drivers using the get_user_pages -> 
> sg_set_page -> page_cache_release
>    technique and didn't see any special code to handle corner cases.
>    Are there corner cases? - Like usb controllers not supporting the 
> whole memory etc. ?

Indeed yes.  The page addresses have to be checked against the DMA
mask.  Also, many host controllers cannot handle arbitrary alignment.  
It would be best to require that the buffer start at a page boundary.

> - In the kernel log I see messages like:
>    xhci_hcd 0000:00:14.0: WARN Event TRB for slot 4 ep 8 with no TDs queued?
>    after enabling zerocopy. Any idea where this might come from?

Not directly related; that's a bug in xhci-hcd.

Using a global module parameter to control the use of zerocopy (for
anything other than debugging or testing) is a bad idea.  If you think
people will have a reason for avoiding zerocopy then you should make it
possible to decide for each URB, by adding a new flag to struct
usbdevfs_urb.

People will want to use zerocopy with isochronous transfers as well as 
bulk.  Implementing that isn't going to be quite so easy; it will be 
necessary for the user to set up a memory mapping.  In fact, once 
that's done the same mechanism could be used for bulk transfers too.

Alan Stern


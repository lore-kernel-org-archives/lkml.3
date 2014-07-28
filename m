Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaG1OWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:22:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49483 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752380AbaG1OWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:22:53 -0400
Date: Mon, 28 Jul 2014 10:22:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Sergey Klyaus <Sergey.Klyaus@Tune-IT.Ru>, <linux-kernel@vger.kernel.org>
Subject: Re: Race condition between userland and USB device attachment
In-Reply-To: <1406539881.17754.17.camel@linux-fkkt.site>
Message-ID: <Pine.LNX.4.44L0.1407281020180.1183-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2014, Oliver Neukum wrote:

> On Fri, 2014-07-25 at 17:43 +0400, Sergey Klyaus wrote:
> > Hello.
> > 
> > I am currently working on a project with Thin clients with Citrix 
> > Receiver 13 for Linux and encountered interesting problem with USB 
> > device redirection.
> > ctxusb/ctxusbd process from Citrix Receiver are using inotify mechanism 
> > to monitor /dev/bus/usb filesystem, and when device arrives, tries to 
> > open it, but get ENODEV status:
> > Jul 25 11:36:13 myaut-desktop ctxusbd[2664]: Failed to open device: No 
> > such device
> > Jul 25 11:36:13 myaut-desktop ctxusb[2751]: Failed to open device 
> > 001:003 (error 19 - No such device), bad id?
> > 
> > It is caused by design of device_add() function: it calls 
> > devtmpfs_create_node before bus_add_device. Here are sequence of events:
> > 1. device_add() calls devtmpfs_create_node(). That leads to inotify 
> > event that.
> > 2. ctxusb is awoken because inotify event arises, and calls ctxusbd daemon.
> > 3. ctxusbd daemon opens /dev/bus/usb/new-device, so usbdev_open() 
> > routine is called
> > 4. usbdev_open() calls  usbdev_lookup_by_devt(). Because device is not 
> > yet attached to "usb bus", it returns NULL, and thus usbdev_open() 
> > returns -ENODEV
> > 5. Finally, device_add() calls bus_add_device(), and all subsequent 
> > calls of usbdev_open() will succeed. However, ctxusb/ctxusbd already 
> > reported an error and abandon device. User is unsatisfied.
> > 
> > I was able to reproduce that issue on Ubuntu 10.04 with 2.6.32 and 3.13 
> > kernels.
> > However, it only occur on uni-processor systems (!)
> > 
> > I see three ways to solve that issue:
> > 1. Leave it to userland applications (i.e. using loop with retries and 
> > timeouts). However, I feel that it is a kernel issue (application is 
> > notified before device is ready).
> > 2. Call bus_add_device() before devtmpfs_create_node(). Very rough, and 
> > probably breaks a lot of other kernel code.
> > 3. Wait in usbdev_open() until reconfiguration is finished (i.e. by 
> > using some global lock between usb_new_device() and usbdev_open(), or 
> > add completion and special state USB_STATE_CONNECTING to a device).
> 
> No to your third option. This is no USB problem. The issue is in the
> generic code. The only clean fix is your suggestion (2)

I agree.  That whole "if (MAJOR(dev->devt)) {" thing in device_add()  
should come at the end, not in the middle.

Alan Stern


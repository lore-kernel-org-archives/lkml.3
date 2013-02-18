Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab3BRRtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:49:22 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41133 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab3BRRtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:49:21 -0500
Date: Mon, 18 Feb 2013 09:49:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SYSFS "errors"
Message-ID: <20130218174916.GA2070@kroah.com>
References: <20130218153316.GA2663@arwen.pp.htv.fi>
 <20130218155012.GA30974@kroah.com>
 <20130218155215.GB2663@arwen.pp.htv.fi>
 <20130218171334.GA31329@kroah.com>
 <20130218172700.GH2663@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130218172700.GH2663@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 07:27:00PM +0200, Felipe Balbi wrote:
> On Mon, Feb 18, 2013 at 09:13:34AM -0800, Greg KH wrote:
> > On Mon, Feb 18, 2013 at 05:52:15PM +0200, Felipe Balbi wrote:
> > > Hi,
> > > 
> > > On Mon, Feb 18, 2013 at 07:50:12AM -0800, Greg KH wrote:
> > > > > If it helps in any way, I have printed below only the filenames
> > > > > (without path) so I could pipe it through uniq:
> > > > > 
> > > > > act_mask
> > > > > audit
> > > > > autosuspend_delay_ms
> > > > > bind
> > > > 
> > > > This one the driver core creates, I'll fix that up.
> > > > 
> > > > The rest need paths to determine who to blame :)
> > > 
> > > wanna see the full list ? It's 1602 lines :-p
> > 
> > You must have more devices in your system than I do:
> > 	$ ruby ./sysfs_test.ruby  | wc -l
> > 	626
> > 
> > What kernel version did you run this on?  I don't see any "bind" file in
> > the list on 3.8.0-rc7+:
> 
> running on -rc6:
> 
> $ uname -r
> 3.8.0-rc6+
> 
> > 	$ ls -l /sys/bus/platform/drivers/pcspkr/bind
> > 	--w------- 1 root root 4096 Feb 18 09:09 /sys/bus/platform/drivers/pcspkr/bind
> > 	$ ls -l /sys/bus/serio/drivers/atkbd/unbind
> > 	--w------- 1 root root 4096 Feb 18 09:09 /sys/bus/serio/drivers/atkbd/unbind
> > 
> > So the full list might be necessary here, thanks.
> 
> yeah, I figured one thing later. Ruby is stupid, if you run it as root,
> it File.readable? will return true even if there's no read permission.
> So I'm running only as a normal user, full output attached
> 
> -- 
> balbi

> Input/output error - /sys/devices/cpu/power/autosuspend_delay_ms

The issue with this file is, if the power.use_autosuspend flag is not
set for the device, then it can't be read or written to.  This flag
changes dynamically with the system state
(__pm_runtime_use_autosuspend() can change it), so we can't just not
show the file if the flag is not set properly, sorry.

So the "error" is correct here, as is the 0644 file value.

Take that sysfs file out of your results, reduces it to a mere handful
of files:

> No such device - /sys/devices/pci0000:00/0000:00:03.0/0000:02:00.0/graphics/fb0/bl_curve

I don't really have a framebuffer in this box either it seems, so
reading this file correctly returns -ENODEV.

> No such device or address - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/block/sdc/trace/pid
> No such device or address - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/block/sdc/trace/end_lba
> No such device or address - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/block/sdc/trace/enable
> No such device or address - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/block/sdc/trace/act_mask
> No such device or address - /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-5/2-5.1/2-5.1.1/2-5.1.1:1.0/host100/target100:0:0/100:0:0:0/block/sdc/trace/start_lba
> Invalid argument - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/scsi_host/host1/em_buffer
> Invalid argument - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/sw_activity
> Operation not supported - /sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/unload_heads

SCSI fun, go poke the SCSI developers about these files, I know nothing
about them, nor do I really want to :)

> No such device - /sys/devices/system/edac/mc/mc0/sdram_scrub_rate

Odd, go ask the edac developers

> Input/output error - /sys/devices/system/memory/soft_offline_page
> Input/output error - /sys/devices/system/memory/hard_offline_page

These both should be mode 0400, not 0644, they have no 'show' attribute,
that's a bug, care to make up a patch that I can take?  Or I can, let me
know.

> Invalid argument - /sys/devices/virtual/net/lo/speed
> Invalid argument - /sys/devices/virtual/net/lo/duplex

Ask the network developers, odds are, the loopback device doesn't really
have a speed :)

> No such device or address - /sys/devices/virtual/block/loop0/trace/pid
> No such device or address - /sys/devices/virtual/block/loop0/trace/end_lba
> No such device or address - /sys/devices/virtual/block/loop0/trace/enable
> No such device or address - /sys/devices/virtual/block/loop0/trace/act_mask
> No such device or address - /sys/devices/virtual/block/loop0/trace/start_lba

Hm, these show up for virtual block devices as well, maybe they aren't
scsi specific, but rather block specific, go poke the block developers
then.

So the list is much more reasonable now, with at least 2 bugs found,
nice.

thanks,

greg k-h

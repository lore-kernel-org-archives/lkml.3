Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab3ANCjg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:39:36 -0500
Received: from netrider.rowland.org ([192.131.102.5]:35721 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752862Ab3ANCjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:39:35 -0500
Date: Sun, 13 Jan 2013 21:39:34 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Alex Riesen <raa.lkml@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more
 than 120 seconds"
In-Reply-To: <1406914.PAZOOLqX4X@linux-5eaq.site>
Message-ID: <Pine.LNX.4.44L0.1301132125530.25830-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2013, Oliver Neukum wrote:

> On Sunday 13 January 2013 18:42:49 Alex Riesen wrote:
> > On Sun, Jan 13, 2013 at 5:56 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > > On Sun, 13 Jan 2013, Alex Riesen wrote:
> > >>
> > >> Yes, almost. What about khubd hanging when machine is shutdown?
> > >
> > > What about it?  I have trouble understanding all the descriptions you
> > > have provided so far, because you talk about several different things
> > > and change your mind a lot.  Can you provide a single, simple scenario
> > > that illustrates this problem?
> > 
> > 1. Compile a kernel with deadline elevator as module
> > 2. Boot into it, make sure the elevator is selected
> >   (I used "elevator=deadline" in the kernel command line)
> > 3. Insert a FAT formatted mass storage device in an USB2 port
> >    Observe "io scheduler deadline registered"
> > 4. Pull the stick out, wait a moment, and either shutdown or just
> >    and press alt-sysrq-W:

Indeed.  I just tried booting into a kernel that has the deadline
elevator built-in, not a module.  Even then, when I specified
"elevator=deadline" on the boot command line, the system hung up
partway through booting.  Hard to tell exactly where, because it
occurred shortly after the switching from VGA to the framebuffer
driver, so the screen was completely blank.

When I get a chance, I'll try it on another machine where I can use a 
serial console.

> That makes it clear. The elevator probably has scheduled work
> which cannot finish waiting on a lock and scsi_remove_host()
> wants to flush work.

What is the work and why can't it finish?  Or rather, how can we 
figure these things out?  According to what Alex wrote, the blocked 
task doesn't show up in the Alt-SysRq-W listing.

And don't forget that the listing shows scsi_remove_host() blocks
waiting to acquire the host's scan_mutex.  Not waiting for work to be
flushed.  This casts doubt on your explanation.

> This is not a USB problem. You need to involve the SCSI people.
> khubd just stops working because disconnects are processed
> in its context and the removal deadlocks.

The why whould building the deadline elevator as a module make any
difference?  Or does it make a difference?

Alex, if the elevator is made static instead, do you still see the same 
behavior when the USB drive is removed?

Also, are there any mounted filesystems on the drive when you unplug
it?

Alan Stern


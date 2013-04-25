Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab3DYWNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:13:48 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:45501 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999Ab3DYWNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:13:47 -0400
Date: Thu, 25 Apr 2013 17:12:20 -0500
From: scameron@beardog.cce.hp.com
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, neilb@suse.de, hch@infradead.org, jmoyer@redhat.com,
        hare@suse.de, vgoyal@redhat.com, stephenmcameron@gmail.com,
        linux-kernel@vger.kernel.org, lsorense@csclub.uwaterloo.ca,
        scameron@beardog.cce.hp.com
Subject: Re: [RFC PATCH] block: Add new generic block device naming interface
Message-ID: <20130425221220.GM7917@beardog.cce.hp.com>
References: <20130425202215.20557.75283.stgit@beardog.cce.hp.com> <20130425204033.GB10990@mtj.dyndns.org> <20130425210726.GL7917@beardog.cce.hp.com> <20130425211459.GC10990@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130425211459.GC10990@mtj.dyndns.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 02:14:59PM -0700, Tejun Heo wrote:
> Hello,
[...]
> > 
> > Right now, if you add a new block driver, if you want grub to be able
> > to boot it, you also have to modify grub.  This is true for each new
> > block driver that comes along.  This is not the case for SCSI HBA
> > drivers, because they all get to share the sd driver and its device
> > name space, and grub already knows about that.  You can add all kinds
> > of SCSI HBA drivers and never have to worry about needing to modify
> > grub to get boot support.
> 
> So, the question, I suppose, is why grub needs to be changed when the
> stem of device names changes.  Why does it need to do that?  Is it
> just an implementation detail or is it something more fundamental?
> 

I don't know.  I do know that it looks like a lot of the the various block
device name schemes are more or less hard coded into grub with bits of code
like this:

	static void
	get_ide_disk_name (char *name, int unit)
	{
	#if defined(__linux__)
	  /* GNU/Linux */
	  sprintf (name, "/dev/hd%c", unit + 'a');
	#elif defined(__GNU__)
	  /* GNU/Hurd */
	  sprintf (name, "/dev/hd%d", unit);
	#elif defined(__FreeBSD_kernel__)
	[...]

	static void
	get_scsi_disk_name (char *name, int unit)
	{
	#if defined(__linux__)
	  /* GNU/Linux */
	  sprintf (name, "/dev/sd%c", unit + 'a');
	#elif defined(__GNU__)
	  /* GNU/Hurd */
	  sprintf (name, "/dev/sd%d", unit);
	#elif defined(__FreeBSD_kernel__)

there are about 9 different get_blah_disk_name() type functions in there
for the various device naming schemes.

It looks like these are called from a function called init_device_map() 
that is called from grub_stage2() at least in the version of grub I looked
at (0.97, from rhel6).

So my assumption is that adding a new block driver with yet another name space
would require adding another bit of code into grub like those above.  When I
asked about "best practices" for new block driver device names on the grub devel
mailing list to minimize required changes to grub, nobody argued against that
assumption. 

-- steve



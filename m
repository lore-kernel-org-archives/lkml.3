Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761810Ab3DBQej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:34:39 -0400
Received: from pequod.mess.org ([46.65.169.142]:54535 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab3DBQei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:34:38 -0400
Date: Tue, 2 Apr 2013 17:34:35 +0100
From: Sean Young <sean@mess.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Josh Boyer <jwboyer@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        tkil@scrye.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Stable kernel 3.8.4/3.9-rc3 breaks PNP serial port
Message-ID: <20130402163435.GA27371@pequod.mess.org>
References: <20130402155344.GA29980@hansolo.jdub.homelinux.org>
 <20130402162336.GB318@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402162336.GB318@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 09:23:36AM -0700, Greg Kroah-Hartman wrote:
> On Tue, Apr 02, 2013 at 11:53:44AM -0400, Josh Boyer wrote:
> > Hi All,
> > 
> > We've had a report [1] that the 3.8.4 stable kernel makes a PNP serial
> > port stop working.  After testing 3.8.3, the reporter narrowed it down
> > to stable commit eec98f82c637 (tty/8250_pnp: serial port detection
> > regression since v3.7) (upstream commit 77e372a3d82).  Reverting that
> > single commit from 3.8.5 allows the serial port to continue working.
> > 
> > The machine in question is using an AMI UEFI implementation as the
> > firmware, and on 3.8.3 the serial port has the following in
> > /sys/bus/pnp/devices/00:0a/resources
> > 
> > 	state = active
> > 	io disabled
> > 	irq 4
> > 	dma disabled
> > 
> > With 3.8.[45], the same file has:
> > 
> > 	state = disabled
> > 	io disabled
> > 	irq 4
> > 	dma disabled
> > 
> > In both cases, the io and dma resources are disabled, and an IRQ is
> > assigned.  However, the state remains active for the port on 3.8.3.
> > 
> > The offending commit mentions this is a BIOS bug from InsydeH2O and that
> > the port is bogus in that case, but we have something similar here with
> > an AMI UEFI implementation (Version: 0406 Release Date: 06/06/2012)
> > where the port isn't bogus.
> > 
> > I'm not sure exactly what the solution should be here.  Any thoughts?
> 
> Sean, should I just revert this patch now, and wait for a better fix
> later?

Looks like although the pnp io is disabled, it does contain a valid port 
number, else pnp detection would fail in 3.8.3. We're a little stricter
in 3.8.4, but it should fall back to legacy port detection -- the port
and irq are standard.

I don't understand why the legacy port detection (see SERIAL_PORT_DFNS)
isn't working. Since the fallback isn't working properly maybe this 
patch should be reverted for now.

If the pnp information had some virtue we wouldn't have these problems.


Sean

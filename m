Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3EHCCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:02:09 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57498 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab3EHCCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:02:03 -0400
Date: Tue, 7 May 2013 19:02:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Wang YanQing <udknight@gmail.com>, jslaby@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]TTY: Fix tty can't be restarted by TCXONC ioctl request
Message-ID: <20130508020200.GA15695@kroah.com>
References: <20130507184734.GA2459@udknight>
 <20130507185800.GA10713@kroah.com>
 <20130508015545.GA1937@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508015545.GA1937@udknight>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 09:55:45AM +0800, Wang YanQing wrote:
> On Tue, May 07, 2013 at 11:58:00AM -0700, Greg KH wrote:
> > On Wed, May 08, 2013 at 02:47:34AM +0800, Wang YanQing wrote:
> > > The reason is before emacs takeover control the tty,
> > > we use CTRL-S to XOFF it. Then when emacs takeover the
> > > control, it may don't use the flow-control, so emacs hang.
> > > But after search the emacs's startup codes, I find they use TCXONC
> > > to workaround this situation:
> > > 
> > >   /* This code added to insure that, if flow-control is not to be used,
> > >      we have an unlocked terminal at the start. */
> > >   if (!tty_out->flow_control) ioctl (fileno (tty_out->input), TCXONC, 1);
> > >   ioctl (fileno (tty_out->input), TCXONC, 1);
> 
> The second line of ioctl:
> "ioctl (fileno (tty_out->input), TCXONC, 1);"
> 
> It is not there in emacs' code, I add it for debuging, and forget to
> delete it.
> Greg KH, could you delete it from ChangeLog if you accept this patch?

Yes, I can.

> > > But this workaround never work due the kernel's current code.
> > > This patch fix it.
> > > 
> > > Below is the ChangeLog introduce the tty->flow_stopped flag:
> > > 
> > > Thu Nov 21 10:05:22 1996  Theodre Ts'o  <tytso@localhost.mit.edu>
> > > 
> > >        * tty_ioctl.c (tty_wait_until_sent): Always check the driver
> > >                wait_until_ready routine, even if there are no characters
> > >                in the xmit buffer.  (There may be charactes in the device
> > >                FIFO.)
> > >                (n_tty_ioctl): Add new flag tty->flow_stopped which
> > >                indicates whether the tty is stopped due to a request by
> > >                the TCXONC ioctl (used by tcflow).  If so, don't let an
> > >                incoming XOFF character restart the tty.  The tty can only
> > >                be restarted by another TCXONC request.
> > > 
> > > So I think this patch make TCXONC can restart tty which stopped by
> > > STOP_CHAR don't break the original meaning.
> > > 
> > > This patch will fix some strange tty relation hang problem,
> > > I believe I meet it with vim in ssh, and also see below bug report:
> > > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=465823
> > 
> > So this has been a problem since 1996?  Or is it newly introduced due to
> > some changes in this area in a newer kernel?
> 
> I have tested the v2.6.32.45, and have the same issue, my current environment
> can't compile and test v2.6.24/v2.6.25, due make version maybe.
> 
> But after explore history codes, I want to say,
> yes, this issue since 1996 that we can't use TCXONC 
> to restart tty which be stopped by STOP_CHAR.
> 
> Kernel process the STOP_CHAR/START_CHAR to implement 
> flow control, but userspace should have methold to 
> START/STOP it by ioctl or others' similar positive method
> which don't depend on another side, that's TCXONC.
> 
> According http://en.wikibooks.org/wiki/Serial_Programming/termio
> 
> "
> TCXONC
>     Start or stop the output. 
> "

What about Peter's comments on this patch?

thanks,

greg k-h

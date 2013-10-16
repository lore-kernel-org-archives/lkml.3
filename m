Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207Ab3JPJEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:04:49 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:54126 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281Ab3JPJEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:04:45 -0400
Date: Wed, 16 Oct 2013 11:04:32 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@au1.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>, jslaby@suse.cz,
        gregkh@linuxfoundation.org, brueckner@linux.vnet.com,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 1/2] tty/hvc_console: Add DTR/RTS callback to handle
 HUPCL control
Message-ID: <20131016090432.GA6053@linux.vnet.ibm.com>
Mail-Followup-To: Benjamin Herrenschmidt <benh@au1.ibm.com>, jslaby@suse.cz,
	gregkh@linuxfoundation.org, brueckner@linux.vnet.com,
	heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org
References: <1372777635-10423-1-git-send-email-brueckner@linux.vnet.ibm.com>
 <1372777635-10423-2-git-send-email-brueckner@linux.vnet.ibm.com>
 <1381475711.5630.67.camel@pasglop>
 <20131011124707.GA6082@linux.vnet.ibm.com>
 <1381524204.5630.91.camel@pasglop>
 <20131015153626.GA6129@linux.vnet.ibm.com>
 <1381870070.17841.24.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381870070.17841.24.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101609-1948-0000-0000-0000069A1EC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 03:47:50PM -0500, Benjamin Herrenschmidt wrote:
> On Tue, 2013-10-15 at 17:36 +0200, Hendrik Brueckner wrote:
> > On Sat, Oct 12, 2013 at 07:43:24AM +1100, Benjamin Herrenschmidt wrote:
> > > On Fri, 2013-10-11 at 14:47 +0200, Hendrik Brueckner wrote:
> > > > The tiocmget/tiocmset callbacks are used to set and get modem status and
> > > > triggered through an tty ioctl.
> > > > 
> > > > The dtr_rts() callback is different and it is used for DTS/RTS handshaking
> > > > between the hvc_console (or any other tty_port) and the tty layer.  The tty
> > > > port layer uses this callback to signal the hvc_console whether to raise or
> > > > lower the DTR/RTS lines.  This is different than the ioctl interface to
> > > > controls the modem status.
> > > 
> > > Well, DTR at least is the same via both callbacks... Also normal handshaking
> > > is normally RTS/CTS, only some HW setups "hijacks" DTR for RTS (old Macs come
> > > to mind).
> > 
> > Yep. DTR is changed in both callbacks but from different layers.  The
> > tiocmget/tiocmset are triggered through the ioctl.  The dtr_rts() callback is
> > called in hvc_close() to properly handle HUPCL to lower modem control lines
> > after last process closes the device (hang up).
> > 
> > This is also done in the hvsilib_close() in hvsi_lib.c:
> > 
> > 	/* Clear our own DTR */
> > 	if (!pv->tty || (pv->tty->termios.c_cflag & HUPCL))
> > 		hvsilib_write_mctrl(pv, 0); 
> > 
> > This is actually what the dtr_rts() callback should trigger and I wonder
> > whether it would be worth to introduce the dtr_rts() callback to encapsulate
> > the "hvsilib_write_mctrl(pv, 0);" call from above.
> > 
> > On the other hand, the dtr_rts() callback is a good encapsulation to not
> > directly access the hp->tty to potentially prevent a layering violation. At
> > least for the hvc_iucv() I do not want to deal with the "underlying" tty layer
> > and introduce additional reference accounting.
> > 
> > I hope this helps you to understand my rational for introducing the dtr_rts()
> > callback.
> 
> I'm not sure :) We still end up basically with 2 callbacks to do the
> same thing ... change the DTR line. It's odd at best, I still don't
> quite see why hvc_console couldn't just use mctrl...
> 
Indeed, two callbacks change the DTR line.  The main difference is that
tiocmget/tiocmset can be called from user space by ioctl.  That's not the case
for the dtr_cts callback.  Also, tiocmget/tiocmset provide more flags that can
be changed (ST, SR, CTS, CD, RNG, RI,  ...)

Assume we would like to unify them have a single callback to change DTR, then
we have to take care of these differences.  So the question to you now is
whether you plan for a) other modem flags to be changed and b) if changing the
DTR line (or other control flags) through an ioctl?

Depending on your results, I could work on sth that helps us both and reduces
the callbacks.

Thanks and kind regards,
  Hendrik


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804Ab3JOUsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:48:07 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:60963 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759774Ab3JOUsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:48:05 -0400
Message-ID: <1381870070.17841.24.camel@pasglop>
Subject: Re: [PATCH 1/2] tty/hvc_console: Add DTR/RTS callback to handle
 HUPCL control
From: Benjamin Herrenschmidt <benh@au1.ibm.com>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: jslaby@suse.cz, gregkh@linuxfoundation.org, brueckner@linux.vnet.com,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Date: Tue, 15 Oct 2013 15:47:50 -0500
In-Reply-To: <20131015153626.GA6129@linux.vnet.ibm.com>
References: <1372777635-10423-1-git-send-email-brueckner@linux.vnet.ibm.com>
	 <1372777635-10423-2-git-send-email-brueckner@linux.vnet.ibm.com>
	 <1381475711.5630.67.camel@pasglop>
	 <20131011124707.GA6082@linux.vnet.ibm.com>
	 <1381524204.5630.91.camel@pasglop>
	 <20131015153626.GA6129@linux.vnet.ibm.com>
Organization: IBM Australia
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101520-9264-0000-0000-000004B86A2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 17:36 +0200, Hendrik Brueckner wrote:
> Hi Benjamin,
> 
> On Sat, Oct 12, 2013 at 07:43:24AM +1100, Benjamin Herrenschmidt wrote:
> > On Fri, 2013-10-11 at 14:47 +0200, Hendrik Brueckner wrote:
> > > The tiocmget/tiocmset callbacks are used to set and get modem status and
> > > triggered through an tty ioctl.
> > > 
> > > The dtr_rts() callback is different and it is used for DTS/RTS handshaking
> > > between the hvc_console (or any other tty_port) and the tty layer.  The tty
> > > port layer uses this callback to signal the hvc_console whether to raise or
> > > lower the DTR/RTS lines.  This is different than the ioctl interface to
> > > controls the modem status.
> > 
> > Well, DTR at least is the same via both callbacks... Also normal handshaking
> > is normally RTS/CTS, only some HW setups "hijacks" DTR for RTS (old Macs come
> > to mind).
> 
> Yep. DTR is changed in both callbacks but from different layers.  The
> tiocmget/tiocmset are triggered through the ioctl.  The dtr_rts() callback is
> called in hvc_close() to properly handle HUPCL to lower modem control lines
> after last process closes the device (hang up).
> 
> This is also done in the hvsilib_close() in hvsi_lib.c:
> 
> 	/* Clear our own DTR */
> 	if (!pv->tty || (pv->tty->termios.c_cflag & HUPCL))
> 		hvsilib_write_mctrl(pv, 0); 
> 
> This is actually what the dtr_rts() callback should trigger and I wonder
> whether it would be worth to introduce the dtr_rts() callback to encapsulate
> the "hvsilib_write_mctrl(pv, 0);" call from above.
> 
> On the other hand, the dtr_rts() callback is a good encapsulation to not
> directly access the hp->tty to potentially prevent a layering violation. At
> least for the hvc_iucv() I do not want to deal with the "underlying" tty layer
> and introduce additional reference accounting.
> 
> I hope this helps you to understand my rational for introducing the dtr_rts()
> callback.

I'm not sure :) We still end up basically with 2 callbacks to do the
same thing ... change the DTR line. It's odd at best, I still don't
quite see why hvc_console couldn't just use mctrl...

Cheers,
Ben.



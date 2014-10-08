Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaJHOwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:52:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58858 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754951AbaJHOwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:52:22 -0400
Date: Wed, 8 Oct 2014 10:52:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mina86@mina86.com>
cc: Felipe Balbi <balbi@ti.com>, Krzysztof Opasiak <k.opasiak@samsung.com>,
        "'Robert Baldyga'" <r.baldyga@samsung.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <andrzej.p@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
In-Reply-To: <xa1toatny765.fsf@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1410081049400.1633-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2014, Michal Nazarewicz wrote:

> > On Tue, 7 Oct 2014, Felipe Balbi wrote:
> >> Right, but if we allow this, I can already see folks abusing to
> >> connect to the host early and only when necessary do some trickery to
> >> e.g. start adbd (not saying Android will do this, just using it as an
> >> easy example).
> 
> I don't really see that happening.  For the gadget to start all
> descriptors need to be known.  Functionfs  will know the descriptors
> only once the user space daemon provides them.  Therefore, with the
> current features (or even with addition of Robert's feature) there is no
> way to let the gadget start without having the daemon running.
> 
> On Tue, Oct 07 2014, Alan Stern <stern@rowland.harvard.edu> wrote:
> > We can still keep the pullup turned off until all the functions are
> > ready.  That's a part of normal behavior -- unlike what happens when a
> > userspace component crashes or is killed.
> 
> >> Then how do we differentiate a normal close() from a "oh-crap-I-died"
> >> close() ?
> 
> > We can't, so why worry about it?
> 
> We actually might be able to distinguish those cases with another ioctl
> which daemon must issue on the ep0 prior to closing it.  I'm not saying
> that we should implement that though.
> 
> > If a file handle was closed for normal reasons then userspace probably 
> > in the middle of shutting down the gadget anyway.  If not then the 
> > user will get what they deserve.
> >
> > If the file handle was closed for abnormal reasons, we can behave like 
> > crashed firmware.  Which means, in the end, doing the same thing as in 
> > the normal-reason case -- i.e., do nothing.  In particular, don't 
> > disconnect.
> >
> > If you want to allow for the possibility of orderly shutdown (and maybe 
> > even possible restart) of a userspace handler, the function library 
> > should first tell the kernel explicitly to disconnect.  Then function 
> > components can be changed around completely, and when everything is 
> > ready, userspace can tell the kernel to connect again.
> 
> I'm wondering if it would be possible to support user-space daemon
> restarts with O_APPEND flag.  This is probably looking too far to the
> future though.

Actually, we shouldn't need to consider the case where the descriptors
change.  That _always_ requires a disconnect, and the user can cause a
disconnect simply by killing the daemon and starting it again.  No
separate restart capability is needed.

Alan Stern


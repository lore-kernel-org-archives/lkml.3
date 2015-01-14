Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbbANUGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 15:06:43 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38999 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752309AbbANUGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 15:06:40 -0500
Date: Wed, 14 Jan 2015 15:06:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Robert Baldyga <r.baldyga@samsung.com>, <paulz@synopsys.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dinguyen@opensource.altera.com>,
        <yousaf.kaukab@intel.com>, <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] usb: dwc2: call dwc2_is_controller_alive() under
 spinlock
In-Reply-To: <20150114193754.GQ16533@saruman>
Message-ID: <Pine.LNX.4.44L0.1501141504420.1464-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015, Felipe Balbi wrote:

> On Wed, Jan 14, 2015 at 07:45:31AM +0100, Robert Baldyga wrote:
> > This patch fixes bug described here:
> > https://lkml.org/lkml/2014/12/22/185
> > 
> > Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> > ---
> > 
> > Changelog:
> > 
> > v2:
> > - fixed comment from Paul Zimmerman
> > 
> > v1: https://lkml.org/lkml/2015/1/13/186
> > 
> >  drivers/usb/dwc2/core_intr.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
> > index ad43c5b..02e3e2d 100644
> > --- a/drivers/usb/dwc2/core_intr.c
> > +++ b/drivers/usb/dwc2/core_intr.c
> > @@ -476,13 +476,13 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
> >  	u32 gintsts;
> >  	irqreturn_t retval = IRQ_NONE;
> >  
> > +	spin_lock(&hsotg->lock);
> > +
> >  	if (!dwc2_is_controller_alive(hsotg)) {
> 
> This is really, really odd. Register accesses are atomic, so the lock
> isn't really doing anything. Besides, you're calling
> dwc2_is_controller_alive() from within the IRQ handler, so IRQs are
> already disabled.

Spinlocks sometimes do more than you think.  For instance, here the 
lock prevents the register access from happening while some other CPU 
is holding the lock.  If a silicon quirk causes the register access to 
interfere with other activities, this could be important.

Alan Stern


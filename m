Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbbANVl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:41:27 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39093 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754373AbbANVlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:41:24 -0500
Date: Wed, 14 Jan 2015 16:41:23 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Robert Baldyga <r.baldyga@samsung.com>, <paulz@synopsys.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dinguyen@opensource.altera.com>,
        <yousaf.kaukab@intel.com>, <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] usb: dwc2: call dwc2_is_controller_alive() under
 spinlock
In-Reply-To: <20150114211434.GT16533@saruman>
Message-ID: <Pine.LNX.4.44L0.1501141636590.1464-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015, Felipe Balbi wrote:

> > > This is really, really odd. Register accesses are atomic, so the lock
> > > isn't really doing anything. Besides, you're calling
> > > dwc2_is_controller_alive() from within the IRQ handler, so IRQs are
> > > already disabled.
> > 
> > Spinlocks sometimes do more than you think.  For instance, here the 
> > lock prevents the register access from happening while some other CPU 
> > is holding the lock.  If a silicon quirk causes the register access to 
> > interfere with other activities, this could be important.
> 
> readl() (which is used by dwc2_is_controller_alive()) adds a memory
> barrier to the register accesses, that should force all register
> accesses the be correctly ordered.

Memory barriers will order accesses that are all made on the same CPU
with respect to each other.  They do not order these accesses against
accesses made from another CPU -- that's why we have spinlocks.  :-)

>  I fail to see how a silicon quirk
> could cause this and if, indeed, it does, I'd be more comfortable with a
> proper STARS tickect number from synopsys :-s

Maybe accessing this register somehow resets something else.  I don't 
know.  It seems unlikely, but at least it explains how adding a 
spinlock could fix the problem.

> Then again, I don't even have a device with this controller and it seems
> to only be a problem with Robert's setup, so maybe it's a silicon bug
> caused by whoever integrated dwc2 in his silicon.

Alan Stern


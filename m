Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbbANWpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:45:30 -0500
Received: from smtprelay4.synopsys.com ([198.182.47.9]:34622 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbbANWp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:45:28 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Robert Baldyga <r.baldyga@samsung.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yousaf.kaukab@intel.com" <yousaf.kaukab@intel.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
Subject: RE: [PATCH v2] usb: dwc2: call dwc2_is_controller_alive() under
 spinlock
Thread-Topic: [PATCH v2] usb: dwc2: call dwc2_is_controller_alive() under
 spinlock
Thread-Index: AQHQL8W5lMCdaYrjlUuC2oTfEkhvI5zAib4AgAAICYCAABL6AIAAB36AgAABTYD//4F/UIAAjX6A//96v7A=
Date: Wed, 14 Jan 2015 22:45:26 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E03048450774D@US01WEMBX2.internal.synopsys.com>
References: <20150114211434.GT16533@saruman>
 <Pine.LNX.4.44L0.1501141636590.1464-100000@iolanthe.rowland.org>
 <20150114214603.GU16533@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E03048450771B@US01WEMBX2.internal.synopsys.com>
 <20150114223941.GV16533@saruman>
In-Reply-To: <20150114223941.GV16533@saruman>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.184.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Wednesday, January 14, 2015 2:40 PM
> 
> On Wed, Jan 14, 2015 at 10:28:54PM +0000, Paul Zimmerman wrote:
> > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > Sent: Wednesday, January 14, 2015 1:46 PM
> > >
> > > On Wed, Jan 14, 2015 at 04:41:23PM -0500, Alan Stern wrote:
> > > > > > > This is really, really odd. Register accesses are atomic, so the lock
> > > > > > > isn't really doing anything. Besides, you're calling
> > > > > > > dwc2_is_controller_alive() from within the IRQ handler, so IRQs are
> > > > > > > already disabled.
> > > > > >
> > > > > > Spinlocks sometimes do more than you think.  For instance, here the
> > > > > > lock prevents the register access from happening while some other CPU
> > > > > > is holding the lock.  If a silicon quirk causes the register access to
> > > > > > interfere with other activities, this could be important.
> > > > >
> > > > > readl() (which is used by dwc2_is_controller_alive()) adds a memory
> > > > > barrier to the register accesses, that should force all register
> > > > > accesses the be correctly ordered.
> > > >
> > > > Memory barriers will order accesses that are all made on the same CPU
> > > > with respect to each other.  They do not order these accesses against
> > > > accesses made from another CPU -- that's why we have spinlocks.  :-)
> > >
> > > a fair point :-) The register is still read-only, so that shouldn't
> > > matter either :-)
> > >
> > > > >  I fail to see how a silicon quirk
> > > > > could cause this and if, indeed, it does, I'd be more comfortable with a
> > > > > proper STARS tickect number from synopsys :-s
> > > >
> > > > Maybe accessing this register somehow resets something else.  I don't
> > > > know.  It seems unlikely, but at least it explains how adding a
> > > > spinlock could fix the problem.
> > >
> > > I would really need Paul (or someone at Synopsys) to confirm this
> > > somehow. Maybe it has something to do with how the register is
> > > implemented, dunno.
> > >
> > > Paul, do you have any idea what could cause this ? Could the HW into
> > > some weird state if we read GSNPSID at random locations or when data is
> > > being transferred, or anything like that ?
> >
> > Only thing I can think of is that there is some silicon bug in Robert's
> > platform. But I am not aware of any STARs that mention accesses to the
> > GSNPSID register as being problematic.
> >
> > Funny thing is, this code has been basically the same since at least
> > November 2013. So I think some other recent change must have modified
> > the timing of the register accesses, or something like that. But that's
> > just handwaving, really.
> 
> Alright, I'll apply this patch but for 3.20 with a stable tag as I have
> already sent my last pull request to Greg. Unless someone has a really
> big complaint about doing things as such.

It should go to 3.19-rc shouldn't it? It's a fix, and Robert's platform
is broken without it, IIUC.

-- 
Paul


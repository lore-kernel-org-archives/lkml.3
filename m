Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaBZJFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:05:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:9873 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbaBZJFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:05:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,546,1389772800"; 
   d="scan'208";a="462466090"
Date: Wed, 26 Feb 2014 11:11:53 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] gpio / ACPI: Add support for ACPI GPIO operation
 regions
Message-ID: <20140226091153.GY5018@intel.com>
References: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com>
 <1393257611-18031-7-git-send-email-mika.westerberg@linux.intel.com>
 <2863081.yf9Ke2teV0@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2863081.yf9Ke2teV0@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 03:55:02PM +0100, Rafael J. Wysocki wrote:
> On Monday, February 24, 2014 06:00:11 PM Mika Westerberg wrote:
> > GPIO operation regions is a new feature introduced in ACPI 5.0
> > specification. This feature adds a way for platform ASL code to call back
> > to OS GPIO driver and toggle GPIO pins.
> > 
> > An example ASL code from Lenovo Miix 2 tablet with only relevant part
> > listed:
> > 
> >  Device (\_SB.GPO0)
> >  {
> >      Name (AVBL, Zero)
> >      Method (_REG, 2, NotSerialized)
> >      {
> >          If (LEqual (Arg0, 0x08))
> >          {
> >              // Marks the region available
> >              Store (Arg1, AVBL)
> >          }
> >      }
> > 
> >      OperationRegion (GPOP, GeneralPurposeIo, Zero, 0x0C)
> >      Field (GPOP, ByteAcc, NoLock, Preserve)
> >      {
> >          Connection (
> >              GpioIo (Exclusive, PullDefault, 0, 0, IoRestrictionOutputOnly,
> >                      "\\_SB.GPO0", 0x00, ResourceConsumer,,)
> >              {
> >                  0x003B
> >              }
> >          ),
> >          SHD3,   1,
> >      }
> >  }
> > 
> >  Device (SHUB)
> >  {
> >      Method (_PS0, 0, Serialized)
> >      {
> >          If (LEqual (\_SB.GPO0.AVBL, One))
> >          {
> >              Store (One, \_SB.GPO0.SHD3)
> >              Sleep (0x32)
> >          }
> >      }
> >      Method (_PS3, 0, Serialized)
> >      {
> >          If (LEqual (\_SB.GPO0.AVBL, One))
> >          {
> >              Store (Zero, \_SB.GPO0.SHD3)
> >          }
> >      }
> >  }
> > 
> > The sensor hub (SHUB) device uses GPIO connection SHD3 to power the device
> > whenever the GPIO operation region is available.
> 
> I would add more explanation of the ASL above here.  Basically, how it is
> supposed to work and what's the handler's role in it.

OK, I will do that in the next revision.

> > Implement the support by registering GPIO operation region handlers for all
> > GPIO devices that have an ACPI handle. First time the GPIO is used by the
> > ASL code we make sure that the GPIO stays requested until the GPIO chip
> > driver itself is unloaded. If we find out that the GPIO is already
> > requested we just toggle it according to the value got from ASL code.
> 
> The patch itself looks good to me.

Thanks for reviewing this :)

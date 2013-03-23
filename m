Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422788Ab3CWA2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 20:28:08 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56214 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422749Ab3CWA2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 20:28:06 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 22 Mar 2013 17:28:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Subject: Re: [PATCH v2 0/8] watchdog: w83627hf: Convert to watchdog
 infrastructure
Message-ID: <20130323002810.GA26245@roeck-us.net>
References: <1362957300-18223-1-git-send-email-linux@roeck-us.net>
 <20130322205258.GE7867@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322205258.GE7867@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 09:52:58PM +0100, Wim Van Sebroeck wrote:
> Hi Guenter,
> 
> > Convert to watchdog infrastructure, cleanup, add support for additional
> > chips, and merge with W83697HF and W83697UG watchdog drivers.
> > 
> > Tested with W83627UHG, NCT6775, NCT6776. Additional test feedback
> > for other chips would be appreciated.
> > 
> > Original idea was to prepare the driver for use as a client to an MFD driver,
> > but I found that requesting memory with request_muxed_region works just as well
> > and has less impact. v2 includes the knowledge gained from converting the
> > driver to an MFD client driver, but without the actual conversion.
> > 
> > v2: Tested with W83627UHG
> >     Retain timeout module parameter; use watchdog_init_timeout to set it
> >     Eliminate some cosmetic changes
> >     Drop spinlock.h include
> >     Keep "initialized" message
> >     Don't try to configure WDTO for W83627UHG and W83627EHF
> >     Don't report the nowayout option with the 'initializing' message
> >     Use request_muxed_region to reserve memory range only while needed
> >     Add support for W83627S, W83627DHG-P, W83667HG, and NCT6779
> 
> In 2011 I started something similar but then with the MFD approach in mind.
> Goal was also to clean-up the w836* watchdog drivers and get a clean driver that
> supports all Winbond super-I/O based watchdog drivers.
> 
> I dug op the development code again. I'll post it in a next e-mail so that we can
> see what the best way forward is. Note: I took the MFD approach because:
> 1) all superio shares the similar functions for using the Super-I/O registers.
> 2) Goal is to have low-level driver that support the specific super-I/O chipsets
> and that does the platform stuff for hwmon, watchdog, gpio, ...
> 
Hi Wim,

I started with a similar approach, only I used mfd cells to pass on platform
specific information such as the device type and the superio base address.
I still have the patchset for the mfd driver, in case you are interested.
My code is based on the patches submitted by Rodolfo Giometti a couple
of years ago. Want me to post it ?

What I noticed in my testing is that the superio address range (2e or 4e),
which the drivers currently take as granted, is at least on my systems
(all three of them) reserved by ACPI. Unfortunately that means one can not
use the mfd infrastructure to pass on the superio memory region,
since it checks for acpi conflicts. With that I gave up on the idea and
reverted to using request_muxed_region. That seemed simpler and accomplish
the same as long as all drivers actually use it.

Ultimately, I am open to either approach.

Thanks,
Guenter

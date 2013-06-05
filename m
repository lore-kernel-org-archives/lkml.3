Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab3FEVHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:07:21 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:49194 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab3FEVHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:07:20 -0400
Date: Wed, 5 Jun 2013 14:07:15 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
Message-ID: <20130605210715.GA16013@core.coreip.homeip.net>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk>
 <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com>
 <51AF8730.4010507@itdev.co.uk>
 <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com>
 <51AFA02B.3000604@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AFA02B.3000604@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 09:31:39PM +0100, Nick Dyer wrote:
> Dmitry Torokhov wrote:
> >> We have made a deliberate choice to implement this via sysfs rather than
> >> debugfs since it needs to work on devices that don't have debugfs enabled.
> > 
> > Then they will have to enable it. Re-implementing something because
> > someone might not enable needed subsystem is not a good idea. Let's
> > say somebody disabled I2C - will you write your own implementation because
> > of that? Of course not, you just say that for given functionality it
> > is a prerequisite.
> 
> debugfs is a debug filesystem. This interface is useful for purposes which
> are not debug.

What other purposes does it serve? I'd expect you need it during new
board bringup.

> I have to be pragmatic: I don't see debugfs enabled on most
> shipping Android devices, and however much I tell them to enable debugfs
> doesn't seem to hold much weight.

You do not need to have debugfs enabled on shipping kernels, just the
ones you use for integration work.

> 
> It's partly path dependence - it was implemented like this because regmap
> wasn't in mainline at the point when I wrote it. Having a dependency on
> regmap would now be a API break complicating support of customers using
> older kernels than mainline. I would also have to update a bunch of
> software and documentation and people to know about the two different APIs.
> The existing implementation already appears in shipping devices, so it is
> well tested.

This was never a good argument for introducing an interface into the
kernel.

> 
> >> In addition, there are some quirks about the way in which we have to
> >> read/write registers which means regmap isn't a good fit.
> > 
> > Could you please elaborate more on this?
> 
> - the mxt chip caches the I2C read pointer, so you can get a performance
> optimisation by not sending the address on every read/write (I haven't
> implemented this yet but plan to)
> - the address pointer can wrap around when you read the T5 message
> processor, which would confuse regmap
> - we require I2C retries in some cases due to way the chip handles sleep states
> - I can't see how to map the object protocol (used on mxt chips) into the
> way regmap treats register ranges
> 
> I can look into porting on top of regmap. But it seems a pity to pepper
> regmap with atmel_mxt_ts quirks just to save on three small functions in
> the driver.

This is not about saving 3 functions but rather the fact that individual
register access is desired by many parties and instead of each driver
implementing it's own solution (via a char device, sysfs, debugfs, etc)
we should try to standardize on common userspace interface.

Thanks.

-- 
Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074Ab3BVSYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:24:38 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:37509 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723Ab3BVSYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:24:37 -0500
Date: Fri, 22 Feb 2013 10:24:32 -0800
From: "'Tejun Heo'" <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>
Subject: Re: Dangerous devm_request_irq() conversions
Message-ID: <20130222182432.GP3570@htj.dyndns.org>
References: <20130222065345.GA30816@core.coreip.homeip.net>
 <000c01ce10cb$fdd4a4a0$f97dede0$%han@samsung.com>
 <20130222072635.GB30816@core.coreip.homeip.net>
 <001301ce10d2$42e8e960$c8babc20$%han@samsung.com>
 <20130222080548.GA2401@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222080548.GA2401@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, guys.

On Fri, Feb 22, 2013 at 12:05:48AM -0800, Dmitry Torokhov wrote:
> > Please, argue that it would be better to deprecate devm_request_irq()
> > or devm_request_threaded_irq().
> 
> No, they do have their use. But probably people doing the conversion
> should be required to put $100 in escrow ;)

So, what devm does is simple - it records resources being allocated
using devm and releases them in the reverse order when the driver
detaches from the device.  If all or most resources are covered by
devm, this is the right thing to do most of the time and there's
nothing much to worry about.

However, singling out one resource and converting only that one to
devm is likely to break something if the resource in question has
release ordering dependency and irqs do definitely have ordering
requirements while tearing down, so, no, one can't single out
request_irq() and change only that one to devm_request_irq().  It's
like mixing managed objects with manual new/delete objects.  You can't
do that willy-nilly and it generaly isn't a good idea as evidenced by
only c++ doing it.

The recommended way to do devm conversion is doing it all the way.
Look at the whole subsystem, identify resources used by various
drivers (they usually aren't that diverse in a single subsystem),
identify the pattern and implement helpers in the subsystem as
appropriate and convert the whole thing, preferably to the point where
->remove() almost doesn't have to worry about freeing resources other
than shutting down devices or doing one-off cleanups not covered by
devm.

If there are resources which are frequently used by a group of drivers
but devm interface doesn't currently exist, add a devm interface
either as a generic or subsystem-specific helper.  devm is
specifically designed to allow such extensions.

So, in summary, no, please don't single out irq requests and convert
only those to devm.  That's bound to break stuff.

Thanks.

-- 
tejun

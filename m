Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaIXWMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 18:12:35 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41431 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750725AbaIXWMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 18:12:34 -0400
Date: Wed, 24 Sep 2014 23:12:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "drake@endlessm.com" <drake@endlessm.com>,
        "loeliger@gmail.com" <loeliger@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v5 4/7] ARM: l2c: Add support for overriding prefetch
	settings
Message-ID: <20140924221220.GJ12379@n2100.arm.linux.org.uk>
References: <1411556741-5810-1-git-send-email-m.szyprowski@samsung.com> <1411556741-5810-5-git-send-email-m.szyprowski@samsung.com> <20140924111446.GE5729@leverpostej> <5422A8D1.1000507@gmail.com> <20140924121051.GF5729@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924121051.GF5729@leverpostej>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 01:10:51PM +0100, Mark Rutland wrote:
> On Wed, Sep 24, 2014 at 12:19:45PM +0100, Tomasz Figa wrote:
> > On 24.09.2014 13:14, Mark Rutland wrote:
> > > I'm not too keen on tristate properties. Is this level of flexibility
> > > really required?

I would say that we need a way to enable _and_ disable these features,
because:

1. When we converted the L2 code to DT, no one thought about creating
   a full and proper DT specification for the L2 code.  So, we have the
   situation today where platform code (and firmware code) enables or
   disables these features depending on platform knowledge.

2. If we are going to specify these options as a boolean-enable value,
   this implies that the lack of the boolean disables the option.
   We have pre-existing DT files which do not contain this option, but
   the platform may rely on the feature being enabled.

This is precisely the kind of mess that happens when incomplete DT
bindings are accepted.  DT bindings for any device should be _full_
bindings from the start, and not a half-hearted attempt at the job.

As much as we don't like tristate properties, we only have ourselves to
blame for them becoming a necessity in cases like this.

> With the lack of warnings for present but empty properties, I can forsee
> people placing empty properties (as the names make them sound like
> booleans which enable features).
> 
> Surely for enabling/disabling options we should only need to override
> one-way, disabling a feature that causes breakage for some reason?
> Otherwise we can keep the reset value (which might be sub-optimal).

What if enabling prefetching on an existing platform causes a failure?
That's a regression on a previously working DT file, and needing a DT
update to resolve.

The obvious alternative is we have two properties per feature - one
boolean to enable, and one boolean to disable the feature.  We already
have a number of negative properties because of exactly the same
problem I mention above (where the driver has assumed defaults for one
platform which are not appropriate for all platforms.)

> > As for why they cause crashes, I'm not an expert if it is about L2C
> > internals, so I can't really tell, but apparently the cache can work
> > correctly only on certain settings.
> 
> Likewise, I'm no expert on the l2x0 family. It would be nice to know if
> this justs masks an issue elsewhere in Linux, is required for some
> reason by the interconnect, etc. I guess we don't have enough
> information to figure that out.

No, it would be nice to have some errata information...

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

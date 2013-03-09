Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119Ab3CIAHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 19:07:24 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59222 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab3CIAHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 19:07:20 -0500
Date: Sat, 9 Mar 2013 00:01:57 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: drop "select MACH_NOKIA_RM696"
Message-ID: <20130309000157.GE30923@n2100.arm.linux.org.uk>
References: <1362738596.5994.48.camel@x61.thuisdomein> <20130308161159.GE14552@blackmetal.musicnaut.iki.fi> <20130308163507.GC26093@atomide.com> <1362763232.5994.75.camel@x61.thuisdomein> <20130308175539.GG26093@atomide.com> <1362765764.5994.87.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362765764.5994.87.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 07:02:44PM +0100, Paul Bolle wrote:
> On Fri, 2013-03-08 at 09:55 -0800, Tony Lindgren wrote:
> > * Paul Bolle <pebolle@tiscali.nl> [130308 09:24]:
> > > Should I draft a patch?
> > 
> > Sure that would be nice.
> 
> One thing I couldn't determine is how the generated mach-types.h header
> handles multiple CONFIG_MACH_* macros.
> 
> If both CONFIG_MACH_FOO and CONFIG_MACH_BAR are defined, and these both
> have a line in */mach-types, will the machine_is_foo() and
> machine_is_bar() macros both behave as one would expect?

It's actually quite clever.  There's two levels to it.

The first is that CONFIG_MACH_xxx result in their machine_is_xxx() macros
being defined to constant zero if the CONFIG option is not enabled.  That
allows the compiler to throw away code for disabled platforms because
the expression is always false.

Otherwise, they end up as (machine_arch_type == MACH_TYPE_xxx).

The second is the magic which happens when two CONFIG_MACH_xxx are
selected.  If only one is selected, then machine_arch_type is defined
to the appropriate MACH_TYPE_xxx.  This means that the above expression
becomes constant-true, and the conditional is eliminated.

If more than one is selected, then machine_arch_type is defined to a
variable which is appropriately set to one of the MACH_TYPE_xxx values.

So, the result is that:
- de-selected platforms have their if (machine_is_xxx()) { } optimised
  out of the kernel.
- for a kernel built targetting one platform, all the
  if (machine_is_xxx()) tests are optimised away, leaving only the
  relevant code behind.
- otherwise, we get the _appropriate_ conditional code for the
  configuration generated.

However, going back to that MACH_NOKIA_RM696.  If there exists only a
select of this symbol and no "config MACH_NOKIA_RM696" entry, then the
symbol will never be generated in the output .config file.

I too can find no trace of any use of machine_is_nokia_rm696 in the
mainline kernel.  So, if there's nothing using the machine_is_()
symbol, and nothing using the CONFIG_MACH_NOKIA_RM696 symbol, then
any select of that is entirely superfluous.

Well, I did this:

$ git grep -i nokia_rm696
arch/arm/mach-omap2/Kconfig:    select MACH_NOKIA_RM696
arch/arm/mach-omap2/board-rm680.c:MACHINE_START(NOKIA_RM696, "Nokia RM-696 board")
arch/arm/tools/mach-types:nokia_rm696           MACH_NOKIA_RM696        NOKIA_RM696             3522

So, there exists platform support for this device, provided by the RM680
support, but there's no use of the machine_is_xxx() symbol - and if there
was, it would always be false.

My conclusion is... it's a mess.

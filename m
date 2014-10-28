Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaJ1Oxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:53:32 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47334 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752205AbaJ1Oxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:53:30 -0400
Date: Tue, 28 Oct 2014 14:53:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Xia Kaixu <kaixu.xia@linaro.org>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] ARM: restrict CPU_BIG_ENDIAN configuration option
Message-ID: <20141028145319.GJ27405@n2100.arm.linux.org.uk>
References: <1414503095-25986-1-git-send-email-kaixu.xia@linaro.org>
 <1414503095-25986-4-git-send-email-kaixu.xia@linaro.org>
 <20141028140021.GD27405@n2100.arm.linux.org.uk>
 <3137318.QMDnWOWDgo@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3137318.QMDnWOWDgo@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 03:37:52PM +0100, Arnd Bergmann wrote:
> On Tuesday 28 October 2014 14:00:22 Russell King - ARM Linux wrote:
> > On Tue, Oct 28, 2014 at 09:31:33PM +0800, Xia Kaixu wrote:
> > > Some platforms don't work when CPU_BIG_ENDIAN is enabled.
> > > So It can get a dependency on !ARCH_MULTIPLATFORM_STRICT.
> > 
> > What if big endian wants to build a multiplatform kernel?
> 
> They can turn off ARCH_MULTIPLATFORM_STRICT easily.

Why should they?  Building a kernel for a group of big endian platforms
is no different from building the kernel for a group of little endian
platforms.

Look, think about the set.  There are three distinct possibilities.

1. The group of platforms which can be big endian.
2. The group of platforms which can be little endian.
3. The intersection of both groups which can be either endian.

Why should ARCH_MULTIPLATFORM_STRICT effectively platforms falling in
set 1 from being built?  What's special about them?  The answer is,
absolutely nothing.  This has /nothing/ what so ever to do with
multiplatform-ness.

What it does have to do with is whether the platforms can be built with
one endian-ness or the other.  That's why I said:

> > This doesn't look right to me.  Instead, we should be arranging for
> > those which do not work in BE mode to depend on !CPU_BIG_ENDIAN.
> > Yes, it's a larger patch but IMHO is a much more correct solution.

which means that the platforms which are part of a multiplatform kernel
need to depend on CPU_BIG_ENDIAN, !CPU_BIG_ENDIAN, or nothing depending
on which of the three groups above they belong to.

Making them depend on some weird new "strict" idea is soo absurd it's
broken.  It's not looking at the real picture here.

> I've also asked Kaixu to put this one in, mostly for the side-effect
> of getting an allmodconfig kernel to be little-endian, but also
> because we don't really know which platforms are ok to run on
> big-endian.

Why should an allmodconfig kernel be little endian?  It's just as valid
to have an allmodconfig big endian kernel.

> I would assume that most platforms have at least some
> platform-specific drivers that are not endian-clean, and even if
> the platform works big-endian in principle, it's unclear if
> everything works.

Right, which means we start off with everything falling into sets (1) or
(2) initially, and if people care about the "either" case, that's up for
them to sort out.  Generally, what people care about are the first two
cases, because they specifically intend to run their platform in BE or
LE mode.

It is /very/ rare to decide to switch endianness on a platform from day
to day.

> The most important aspect is probably user space though: If you
> build a multiplatform kernel (or one for ARMv4/5 and one for ARMv6/7)
> that runs on all sorts of machines, you can have a common user space
> that is built for ARMv4 little-endian and that will run everywhere.
> As soon as you enable big-endian, you have a fundamental ABI change
> and nothing works unless you replace the entire user space side.

Correct, which is why people would want to build a _single_ ARMv6/v7
big endian kernel covering multiple platforms, in exactly the same
way that they would build a _single_ ARMv6/v7 little endian kernel
covering multiple platforms.

There's nothing "strict" about either case.

Look at it from the opposite point of view.  If you want to build a 
multiplatform ARMv6/v7 BE kernel, and you turn off the big endian
option, is that no different from wanting to build a multiplatform
ARMv6/v7 LE kernel, and turning on the big endian option.

There's really no difference between these two cases.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

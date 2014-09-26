Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaIZIky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:40:54 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43593 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754354AbaIZIkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:40:52 -0400
Date: Fri, 26 Sep 2014 09:40:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "deller@gmx.de" <deller@gmx.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "jesper.nilsson@axis.com" <jesper.nilsson@axis.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "starvik@axis.com" <starvik@axis.com>,
        "takata@linux-m32r.org" <takata@linux-m32r.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
Subject: Re: [PATCH v3 00/17] Cross-architecture definitions of relaxed
	MMIO accessors
Message-ID: <20140926084019.GJ5182@n2100.arm.linux.org.uk>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com> <4240583.SJ4jiIW6Zy@wuerfel> <54243395.902@linaro.org> <201409252117.19754.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201409252117.19754.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 09:17:19PM +0200, Arnd Bergmann wrote:
> On Thursday 25 September 2014, Daniel Thompson wrote:
> > > +
> > > +#ifndef readq_relaxed
> > > +#define readq_relaxed readq
> > > +#endif
> > 
> > Not really sure if it matters but this gives a rather surprising
> > behaviour to #ifdef readq_relaxed given that readq may not be defined.
> > 
> 
> It was intentional. I could have written this as
> 
> #if !defined(readq_relaxed) && defined(readq)
> 
> but the effect would be almost the same, and the version I picked looks
> simpler. Note that 32-bit architectures could provide readq, it's just
> the generic code that doesn't, because most you typically don't get
> atomic 64-bit accesses from dereferencing a 64-bit pointer as the
> generic readq() function does.

32-bit architectures should *not* provide readq().  Remember, we are
talking about devices here, and reading registers on devices *may* have
side effects.

Side effects such as clearing the pending interrupt status.

How would a 32-bit architecture know whether it should read the least
significant 32-bit or the most significant 32-bit part of the 64-bit
register first.  What would be right for one driver may not ben correct
for another.  Hence, this decision should only be made by the driver
wanting the accessor, and not having the accessor symbol defined should
be the trigger for the driver to handle the problem themselves.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

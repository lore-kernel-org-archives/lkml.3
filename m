Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399Ab3GRUsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:48:12 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:27529 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934424Ab3GRUsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 16:48:04 -0400
Date: Thu, 18 Jul 2013 22:47:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, celinux-dev@lists.celinuxforum.org,
        linux-arm-kernel@lists.infradead.org, hyojun.im@lge.com,
        chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, Borislav Petkov <bp@alien8.de>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the
	new streaming format
Message-ID: <20130718204755.GA7900@merkur.ravnborg.org>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com> <20130716004727.b60b2c96.akpm@linux-foundation.org> <20130716005611.e4ccab02.akpm@linux-foundation.org> <201307161008.07643.yann.morin.1998@free.fr> <20130716180408.GA19863@merkur.ravnborg.org> <20130717211649.GA5619@merkur.ravnborg.org> <20130717223033.GF3385@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130717223033.GF3385@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 12:30:33AM +0200, Yann E. MORIN wrote:
> Sam, All,
> 
> Well, while I was fighting on this on my side... ;-)
> 
> On 2013-07-17 23:16 +0200, Sam Ravnborg spake thusly:
> > > We could extend the symbol option part to retreive values from a binary.
> > > Something like this:
> > > 
> > > config FOOBAR
> > >         bool
> > >         option exec="true"
> > > 
> > > FOOBAR would assume the value "y" if the command true has exit code == 0, otherwise "n".
> > > And similar conversions for other types.
> > > 
> > > This only extendt Kconfig slightly - using an already present method to import
> > > external values.
> > > 
> > > The drawback I see with this approach is that we may execute a lot of small programs
> > > where the value is never used.
> > 
> > Following is a quick patch implmenting this idea.
> > You need to run gperf manually to enable this.
> > 
> > "gperf -C scripts/kconfig/zconf.gperf > scripts/kconfig/zconf.hash.c"
> > 
> > I did not figure out how to use the built-in rules to generate this file :-(
> 
> make REGENERATE_PARSERS=y menuconfig
Thanks!

> 
> > I have tested this lightly - as we should discuss if this is a viable way forward.
> 
> Instead of extending the Kconfig language, I was thinking (as initially
> suggested by Andrew) of generating a Kconfig file before all config
> targets, and source that Kconfig file from $(TOPDIR)/Kconfig.
> 
> I'm not a fan od extending the Kconfig language in this way. It feels
> weird to me. Especially when we have a way to solve this specific issue
> with a script that generates the needed Kconfig symbols before any
> config target is called.

The problem we want to solve is that we want some external state to influence
the Kconfig symbols.
In this case if we support lz4.
In other cases if we support a specific gcc feature or whatever.

The relevant external state may not be relevant in all cases.
We may have something that is arm specific - and we do not want to waste
time on this when we are building for sparc.

We can consider two general cases.
- Where the external state is static and independent on any other config symbols.
  lz4 is such a case.
- Where the external state depends on a config symbol.
  As we specify CROSS_COMPILE as a config symbol this may influence if gcc
  support a specific feature or not.

Both approaches suggested (generate Kconfig and exec option) supports that
we only execute relevant stuff. When we generate Kconfig we can call arch specific
scripts and for exec option we include the arch specific stuff in the arch specific
Kconfig files.

None of the approaches presented so far can handle the fact that a config symbol
may influence the external state.
But I think the exec option can be updated to support this which is why
that is my preference.

This extends the Kconfig language - but at least it is a very minor extension.

	Sam

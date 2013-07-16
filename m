Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637Ab3GPSEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:04:12 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:59095 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988Ab3GPSEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:04:10 -0400
Date: Tue, 16 Jul 2013 20:04:08 +0200
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
Message-ID: <20130716180408.GA19863@merkur.ravnborg.org>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com> <20130716004727.b60b2c96.akpm@linux-foundation.org> <20130716005611.e4ccab02.akpm@linux-foundation.org> <201307161008.07643.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201307161008.07643.yann.morin.1998@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 10:08:07AM +0200, Yann E. MORIN wrote:
> Andrew, All,
> 
> On Tuesday 16 July 2013 09:56:11 Andrew Morton wrote:
> > On Tue, 16 Jul 2013 00:47:27 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Mon, 15 Jul 2013 15:08:20 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
> > > > On 07/15/2013 03:03 PM, Andrew Morton wrote:
> [--SNIP--]
> > > > We keep running over the need to be able to have kconfig run tests on
> > > > the build system (for toolchain support or for optional tools needed);
> > > > running them in the Makefiles (i.e. at Kbuild time) is simply too late.
> > > > 
> > > 
> > > Would it make sense to extend Kconfig's `depends'?
> > > 
> > > 	depends on $(shell-command)
> > > 
> > > I don't know how practical that would be to implement...
> 
> I'm afraid this will get rather ugly and not trivial.
> 
> Can we mix 'depends on SYMBOL' and 'depends on $(command)' ?
> Can we mix both in a boolean expression such as 'depends on SYMBOL
> && $(command)' ?
> 
> What would be the condition for evaluating the dependency rule? Evaluation
> at Kconfig read-time might not be enough, given this construct:
> 
>     config FOO
>         depends on $(foo)
>     comment "'foo' is missing, please install it"
>         depends on !$(foo)
> 
> Also, I believe Kconfig should stay a config-only language, without
> much esoteric features.

We could extend the symbol option part to retreive values from a binary.
Something like this:

config FOOBAR
        bool
        option exec="true"

FOOBAR would assume the value "y" if the command true has exit code == 0, otherwise "n".
And similar conversions for other types.

This only extendt Kconfig slightly - using an already present method to import
external values.

The drawback I see with this approach is that we may execute a lot of small programs
where the value is never used.
Implementing lazy evaluation of a symbol value will not be easy I think.

	Sam

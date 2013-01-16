Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3APOzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:55:33 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41927 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab3APOzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:55:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: enable common clk on x86
Date: Wed, 16 Jan 2013 16:01:20 +0100
Message-ID: <28908583.J70dQJd3BK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130116052054.GT13897@intel.com>
References: <1358174788-24439-1-git-send-email-mika.westerberg@linux.intel.com> <1474259.FsoB54Sm0k@vostro.rjw.lan> <20130116052054.GT13897@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 16, 2013 07:20:54 AM Mika Westerberg wrote:
> On Wed, Jan 16, 2013 at 12:59:17AM +0100, Rafael J. Wysocki wrote:
> > On Monday, January 14, 2013 04:46:26 PM Mika Westerberg wrote:
> > > We are starting to see traditional SoC peripherals also in the x86 world,
> > > things like UART, I2C and SPI controllers that might already have a working
> > > device driver. These drivers typically take advantage of the Linux clk
> > > framework to control and retrieve information about the peripheral clock.
> > > 
> > > There hasn't been a standard way on x86 to pass the clock rate from
> > > whatever configuration system is used to the driver, but instead different
> > > variations have emerged, like adding this information to the platform data.
> > > 
> > > In order to use the standard Linux way we enable the common clk subsystem
> > > also on x86. This allows us to re-use the drivers with little or no
> > > modification wrt. clock API usage.
> > > 
> > > This patch was originally proposed by Mark Brown.
> > 
> > Are there any side effects of selecting COMMON_CLK by an arch and if so then
> > what are they?
> 
> Selecting COMMON_CLK also selects HAVE_CLK, so drivers that are dependent
> on that option become available when you run make config.

Well, that's not very nice.  Do you know how many of them there are?

Distros often build all drivers available regardless of whether or not they
are going to be used and it would be kind of wasteful for them to build drivers
that aren't even going to work.

> It also makes clk_get() and friends to return errors if the clock is not
> found (instead of returning NULL as in case with !HAVE_CLK). This means
> that if there is a driver that counted on the stubbed out clocks on x86 it
> will fail to get the clock after this patch. However, the patch that adds
> the stub functions was merged only lately:
> 
> 	commit 93abe8e4b13ae9a0428ce940a8a03ac72a7626f1
> 	Author: Viresh Kumar <viresh.kumar@st.com>
> 	Date:   Mon Jul 30 14:39:27 2012 -0700
> 
> 	    clk: add non CONFIG_HAVE_CLK routines
> 	    
> 	    Many drivers are shared between architectures that may or may not have
> 	    HAVE_CLK selected for them.  To remove compilation errors for them we
> 	    enclose clk_*() calls in these drivers within #ifdef CONFIG_HAVE_CLK,
> 	    #endif.
> 	    
> 	    This patch removes the need of these CONFIG_HAVE_CLK statements, by
> 	    introducing dummy routines when HAVE_CLK is not selected by platforms.
> 	    So, definition of these routines will always be available.  These calls
> 	    will return error for platforms that don't select HAVE_CLK.
> --

That should be fine, then.

Peter, what do you think?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

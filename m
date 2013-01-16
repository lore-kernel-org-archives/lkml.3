Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab3APFR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 00:17:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:43905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab3APFR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 00:17:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,476,1355126400"; 
   d="scan'208";a="272605725"
Date: Wed, 16 Jan 2013 07:20:54 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: enable common clk on x86
Message-ID: <20130116052054.GT13897@intel.com>
References: <1358174788-24439-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358174788-24439-2-git-send-email-mika.westerberg@linux.intel.com>
 <1474259.FsoB54Sm0k@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1474259.FsoB54Sm0k@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 12:59:17AM +0100, Rafael J. Wysocki wrote:
> On Monday, January 14, 2013 04:46:26 PM Mika Westerberg wrote:
> > We are starting to see traditional SoC peripherals also in the x86 world,
> > things like UART, I2C and SPI controllers that might already have a working
> > device driver. These drivers typically take advantage of the Linux clk
> > framework to control and retrieve information about the peripheral clock.
> > 
> > There hasn't been a standard way on x86 to pass the clock rate from
> > whatever configuration system is used to the driver, but instead different
> > variations have emerged, like adding this information to the platform data.
> > 
> > In order to use the standard Linux way we enable the common clk subsystem
> > also on x86. This allows us to re-use the drivers with little or no
> > modification wrt. clock API usage.
> > 
> > This patch was originally proposed by Mark Brown.
> 
> Are there any side effects of selecting COMMON_CLK by an arch and if so then
> what are they?

Selecting COMMON_CLK also selects HAVE_CLK, so drivers that are dependent
on that option become available when you run make config.

It also makes clk_get() and friends to return errors if the clock is not
found (instead of returning NULL as in case with !HAVE_CLK). This means
that if there is a driver that counted on the stubbed out clocks on x86 it
will fail to get the clock after this patch. However, the patch that adds
the stub functions was merged only lately:

	commit 93abe8e4b13ae9a0428ce940a8a03ac72a7626f1
	Author: Viresh Kumar <viresh.kumar@st.com>
	Date:   Mon Jul 30 14:39:27 2012 -0700

	    clk: add non CONFIG_HAVE_CLK routines
	    
	    Many drivers are shared between architectures that may or may not have
	    HAVE_CLK selected for them.  To remove compilation errors for them we
	    enclose clk_*() calls in these drivers within #ifdef CONFIG_HAVE_CLK,
	    #endif.
	    
	    This patch removes the need of these CONFIG_HAVE_CLK statements, by
	    introducing dummy routines when HAVE_CLK is not selected by platforms.
	    So, definition of these routines will always be available.  These calls
	    will return error for platforms that don't select HAVE_CLK.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab3GOWsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:48:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36973 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab3GOWsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:48:45 -0400
Date: Mon, 15 Jul 2013 23:47:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Chen Gang <gang.chen@asianux.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH, re-send] Always trap on BUG()
Message-ID: <20130715224759.GZ24642@n2100.arm.linux.org.uk>
References: <201307051738.35930.arnd@arndb.de> <20130715151612.9499c2b2ad40e88d183a4600@linux-foundation.org> <20130715222755.GY24642@n2100.arm.linux.org.uk> <51E47924.9030005@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E47924.9030005@zytor.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 03:35:16PM -0700, H. Peter Anvin wrote:
> On 07/15/2013 03:27 PM, Russell King - ARM Linux wrote:
> > On Mon, Jul 15, 2013 at 03:16:12PM -0700, Andrew Morton wrote:
> >> I've been thinking for a while that CONFIG_BUG=n is a pretty dumb thing
> >> to do, and that maintaining it (and trying to fix the warnings it
> >> produces) aren't worth the effort and that we should remove the whole
> >> thing.  Perhaps your patch changes that calculus, dunno.  Please discuss.
> > 
> > This isn't about introducing "CONFIG_BUG=n" - this is about making a
> > kernel with CONFIG_BUG=n build without producing tonnes and tonnes of
> > warnings, as it does today.  It makes building randconfig pretty
> > useless to find what could be more important warnings.
> > 
> 
> Well, there are three alternatives here, right:

There's many more than three alternatives - some of them may not pass
your taste filter.

> 1. We can use unreachable(), which means that the compiler can assume it
> never happens.

Arnd tried that... see the commit message for the build results from
that.  Arnd included a whole boat-load of other solutions to this
problem and documented the build results there too.

What this actually means in reality is that you're giving permission for
the CPU to run off the end of a function and start executing whatever it
finds there - which could be literal tables.  That might cause some
memory to be corrupted but otherwise go by unnoticed until very much
later.

Infinite while loops on the other hand... probably a single instruction,
but if we're using a single instruction why not make it trap with an
exception anyway so that the system can panic() and maybe reboot without
needing to wait for the watchdog?

> 2. We can trap without metadata.
> 
> 3. We can trap with metadata (current CONFIG_BUG=y).
> 
> I am *guessing* this does 2, but it isn't clear.

That is what this paragraph in Arnd's mail conveys to me:

  This basically loses any of the BUG() reporting, but leaves the
  logic to trap and kill the task in place when CONFIG_BUG is disabled.

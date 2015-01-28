Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbbA1Vjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:39:48 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60818 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759522AbbA1Ulj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:41:39 -0500
Date: Wed, 28 Jan 2015 17:01:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Rob Herring <robherring2@gmail.com>, Nicolas Pitre <nico@fluxnic.net>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Sebastian Reichel <sre@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Message-ID: <20150128170136.GT26493@n2100.arm.linux.org.uk>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <20150127174818.GM26493@n2100.arm.linux.org.uk>
 <20150128005032.GK28663@atomide.com>
 <201501281458.22088@pali>
 <alpine.LFD.2.11.1501280925400.1322@knanqh.ubzr>
 <CAL_Jsq+rESm8q44ABRbh9hqMsfcMNx0kcXJ5ONbn1=ue-RvHFg@mail.gmail.com>
 <20150128161316.GS26493@n2100.arm.linux.org.uk>
 <20150128161913.GU1569@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128161913.GU1569@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 04:19:13PM +0000, Will Deacon wrote:
> On Wed, Jan 28, 2015 at 04:13:17PM +0000, Russell King - ARM Linux wrote:
> > On Wed, Jan 28, 2015 at 09:57:18AM -0600, Rob Herring wrote:
> > > I'm fine with that, but we just need to have a standard kernel
> > > userspace interface in addition to something like
> > > /proc/device-tree/bootreason. Perhaps this can be the default
> > > implementation for the watchdog dev. Someday when we decide DT is crap
> > > and have a new boot interface, we'll have people relying on
> > > /proc/device-tree. I hope to be retired when that happens...
> > 
> > Anyone who thinks that DT can be replaced in the same way that we made
> > the mistake with ATAGs would really need their head examined.
> > 
> > As you point out, removing DT removes the /proc/device-tree/ sub-tree.
> > Whether we like it or not, that is a userspace API, one which we have
> > users of already.  That pretty much means that we can't remove DT for
> > existing platforms or any platform we have now converted to DT.
> 
> <ok, I'll go there!>
> 
> ... and for platforms that can also be booted via ACPI? If we have to
> convert the ACPI tables into a device-tree purely for /proc/device-tree,
> then we may as well boot with the thing too :)
> 
> Seriously though, I don't see how we can maintain this directory for
> ACPI, regardless of whether or not it's ABI.

Welcome to the problem that exporting information to userspace creates.
The same problem is also true where ACPI is exported to userspace too.
As soon as ACPI is exported to userspace, it also becomes part of the
userspace API that the kernel provides - even if it is merely passing
through the data that it received from the firmware.

(I'm not saying that the kernel is ultimately responsible for the
contents of the blob.)

If we took the idea that the kernel receives a blob from the firmware,
and it parses it to discover whatever it needs using the appropriate
parser for that blob, and then passes the blob to userspace, then it's
pretty clear that where a platform switches between providing DT or
ACPI tables is neither here nor there, and can't cause a kernel
regression.  The specification for such an API is that the kernel
provides userspace with whatever data the firmware provided it.

If we take the idea that the kernel receives a blob from the firmware,
decodes it, and then provides the decoded form to userspace, then we're
vulnerable to changes in firmware providers causing regressions for us
because they've changed the way that that information is provided to us.

That's the difference, and this is why I feel that a lack of thought has
been put into stuff like the /sys/firmware/device-tree and similar which
provides the decoded forms of the "blob".  It's far too easy to export
a string or number to userspace, which then becomes part of the user API,
and which can then later become quite a headache later.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.

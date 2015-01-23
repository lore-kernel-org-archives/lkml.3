Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbbAWRmC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:42:02 -0500
Received: from smtp2.ore.mailhop.org ([54.186.57.195]:60644 "EHLO
	smtp2.ore.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbbAWRmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:42:00 -0500
X-Greylist: delayed 1455 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jan 2015 12:42:00 EST
X-Mail-Handler: DuoCircle Outbound SMTP
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@duocircle.com (see https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information for abuse reporting information)
X-MHO-User: U2FsdGVkX19pFSJbuOtKlksqH7UjUVu/
Date: Fri, 23 Jan 2015 09:14:05 -0800
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-kernel@lists.linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>, spear-devel@list.st.com,
        Paul Bolle <pebolle@tiscali.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v12 00/15] arm: Fix DEBUG_LL for multi-platform kernels
 (without PL01X)
Message-ID: <20150123171404.GQ7696@atomide.com>
References: <1414148076-12685-1-git-send-email-daniel.thompson@linaro.org>
 <CAMuHMdUpNtL+K28DdC8xJ3vUPZGmviWcYGOVUNuhKQoobdL00Q@mail.gmail.com>
 <20150123130837.GE26493@n2100.arm.linux.org.uk>
 <1940932.WxFESz5SgZ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1940932.WxFESz5SgZ@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [150123 05:32]:
> On Friday 23 January 2015 13:08:37 Russell King - ARM Linux wrote:
> > > Hi Arnd,
> > > 
> > > On Fri, Oct 24, 2014 at 5:46 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > > There is still a related bug that we should also fix, but I'd say let's
> > > > take your current patches first and then add whatever is missing
> > > > on top. Specifically, a snippet like this
> > > >
> > > >         default 0xd4017000 if DEBUG_MMP_UART2
> > > >         default 0xd4018000 if DEBUG_MMP_UART3
> > > >         default 0xe0000000 if ARCH_SPEAR13XX
> > > >         default 0xe4007000 if DEBUG_HIP04_UART
> > > >         default 0xf0000be0 if ARCH_EBSA110
> > > >
> > > > still means you get the wrong default when you build a multiplatform
> > > > kernel that you want to boot on HIP04 and you set DEBUG_HIP04_UART
> > > > but you happen to also have ARCH_SPEAR13XX enabled.
> > > >
> > > > I have a patch that I use locally for randconfig builds that tries
> > > > to fix this. It has some overlaps with your work but most parts are
> > > > distinct. See below.
> > > 
> > > This is still desperately needed for anyone who wants to enable DEBUG_LL
> > > on other platforms using multi_v7_defconfig.
> > 
> > I'd actually prefer to kill all these defaults and let people enter the
> > value they want - for exactly this reason.
> 
> I think it almost works right and seems fixable, but I agree with your
> long-term direction.
> 
> > However, I realise that would not be popular, because removing them
> > means that people have to refer to some kind of documentation to find
> > the correct value, and that's hassle.
> > 
> > So, the existing defaulting behaviour is my compromise, but as I say,
> > I'd much prefer the unpopular move of killing the entire set of defaults.
> 
> We can probably remove the defaults after we have had working earlycon
> support for at least one kernel release. My feeling is that a lot of
> people just enable debug_ll for normal kernels (and pass earlyprintk
> in the DTB-provided command line!) because the normal console support
> is just too late to spot when things go wrong, and debug_ll is
> convenient enough despite the downsides.
> 
> earlycon avoids the need for hard configuration and mostly solves the
> problem of the normal console being initialized too late, so I think
> we should migrate platforms to use that over time. It's not a
> problem for backwards compatibility because old dtbs will still work,
> just without working earlycon when there is no "stdout-path" property.
> 
> With that in place, we can put debug_ll back into its destined place,
> which is to debug the extremely early boot stages before earlycon,
> and anyone who needs to do that can pick the correct physical addresses
> themselves. Picking the right virtual address seems to be harder
> for a lot of people, and everyone gets stuck on this when they first
> try it. Maybe we can avoid this problem by finding a page into which
> to put the mapping by default. The fixmap support we need for earlycon
> should make this easier too.

Totally agree, let's make debug_ll use super limited.

The reasons for why people need debug_ll are currently because of all
the custom initcall levels. So far for all the cases I've seen, there
should not be any need for custom initcall levels any longer with the
deferred probe. The existing cases are all for legacy reasons and
should not be needed at all on anything done over past five years
or so.

The solution to removing the dependency to debug_ll is SoC specific
earlyprintk support. And to initialize everything else later, not
earlier.

Cheers,

Tony

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbbAWN3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:29:17 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:53031 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbbAWN3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:29:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>, spear-devel@list.st.com,
        Paul Bolle <pebolle@tiscali.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v12 00/15] arm: Fix DEBUG_LL for multi-platform kernels (without PL01X)
Date: Fri, 23 Jan 2015 14:28:24 +0100
Message-ID: <1940932.WxFESz5SgZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150123130837.GE26493@n2100.arm.linux.org.uk>
References: <1414148076-12685-1-git-send-email-daniel.thompson@linaro.org> <CAMuHMdUpNtL+K28DdC8xJ3vUPZGmviWcYGOVUNuhKQoobdL00Q@mail.gmail.com> <20150123130837.GE26493@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:OFWpIcVZ64O9JTiDb6K6KU07XZlp06yHzP2Gkt7BUoqvEDZBXKn
 EBymxdfuXIyg6O2MvdnFrb3a/+z4hbFulIihlds/eCaMJSJxw0rbF1ORknGZDhVBSQM/WMb
 0tR2AVzwH/upK3DkAqiBTHw4A6PygXp+6hQkS4QUrDMz0nSyWTeuv2ufTPhaXh8grR5AHG3
 UeRqEdrw+McHjQsB4d/Xg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 January 2015 13:08:37 Russell King - ARM Linux wrote:
> > Hi Arnd,
> > 
> > On Fri, Oct 24, 2014 at 5:46 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > There is still a related bug that we should also fix, but I'd say let's
> > > take your current patches first and then add whatever is missing
> > > on top. Specifically, a snippet like this
> > >
> > >         default 0xd4017000 if DEBUG_MMP_UART2
> > >         default 0xd4018000 if DEBUG_MMP_UART3
> > >         default 0xe0000000 if ARCH_SPEAR13XX
> > >         default 0xe4007000 if DEBUG_HIP04_UART
> > >         default 0xf0000be0 if ARCH_EBSA110
> > >
> > > still means you get the wrong default when you build a multiplatform
> > > kernel that you want to boot on HIP04 and you set DEBUG_HIP04_UART
> > > but you happen to also have ARCH_SPEAR13XX enabled.
> > >
> > > I have a patch that I use locally for randconfig builds that tries
> > > to fix this. It has some overlaps with your work but most parts are
> > > distinct. See below.
> > 
> > This is still desperately needed for anyone who wants to enable DEBUG_LL
> > on other platforms using multi_v7_defconfig.
> 
> I'd actually prefer to kill all these defaults and let people enter the
> value they want - for exactly this reason.

I think it almost works right and seems fixable, but I agree with your
long-term direction.

> However, I realise that would not be popular, because removing them
> means that people have to refer to some kind of documentation to find
> the correct value, and that's hassle.
> 
> So, the existing defaulting behaviour is my compromise, but as I say,
> I'd much prefer the unpopular move of killing the entire set of defaults.

We can probably remove the defaults after we have had working earlycon
support for at least one kernel release. My feeling is that a lot of
people just enable debug_ll for normal kernels (and pass earlyprintk
in the DTB-provided command line!) because the normal console support
is just too late to spot when things go wrong, and debug_ll is
convenient enough despite the downsides.

earlycon avoids the need for hard configuration and mostly solves the
problem of the normal console being initialized too late, so I think
we should migrate platforms to use that over time. It's not a
problem for backwards compatibility because old dtbs will still work,
just without working earlycon when there is no "stdout-path" property.

With that in place, we can put debug_ll back into its destined place,
which is to debug the extremely early boot stages before earlycon,
and anyone who needs to do that can pick the correct physical addresses
themselves. Picking the right virtual address seems to be harder
for a lot of people, and everyone gets stuck on this when they first
try it. Maybe we can avoid this problem by finding a page into which
to put the mapping by default. The fixmap support we need for earlycon
should make this easier too.

	Arnd

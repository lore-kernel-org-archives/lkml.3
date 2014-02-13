Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaBMSda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:33:30 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44929 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233AbaBMSd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:33:28 -0500
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Feb 2014 13:33:28 EST
X-Sasl-enc: FDqKuzSz5Jt5v82F/CBsxzgaBzMqYXvutnyA5aF6sTaz 1392316011
Date: Thu, 13 Feb 2014 10:28:09 -0800
From: Greg KH <greg@kroah.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: linux-next: build failure after merge of the wireless-next tree
Message-ID: <20140213182809.GB32578@kroah.com>
References: <20140213131923.4a0b79959e0b27399c021aa7@canb.auug.org.au>
 <CAP=VYLrGdsJawCU3u5VZN192TptCOKZp-hO9cR7PtuspZui4uA@mail.gmail.com>
 <CAP=VYLpa7yOZb4bgT6jNkLaEmDVHpKkwm07x8--URvUFEb+E2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP=VYLpa7yOZb4bgT6jNkLaEmDVHpKkwm07x8--URvUFEb+E2Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 01:22:15PM -0500, Paul Gortmaker wrote:
> On Thu, Feb 13, 2014 at 12:31 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
> > On Wed, Feb 12, 2014 at 9:19 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >> Hi John,
> >>
> >> After merging the wireless-next tree, today's linux-next build (x86_64
> >> allmodconfig) failed like this:
> >>
> >> drivers/staging/rtl8821ae/rc.c:289:2: error: unknown field 'module' specified in initializer
> >>   .module = NULL,
> >>   ^
> >>
> >> Caused by commit cc01f9b55fe7 ("mac80211: remove module handling from
> >> rate control ops") interacting with commit 3c05bedb5fef ("Staging:
> >> rtl8812ae: Add Realtek 8821 PCI WIFI driver") which entered Linus' tree
> >> before v3.14-rc1.
> >
> > It seems this new driver has multiple issues; I'm seeing this on sparc32
> > allmodconfig builds.
> >
> > In file included from drivers/staging/rtl8821ae/btcoexist/halbt_precomp.h:31:0,
> >                  from drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c:14:
> > drivers/staging/rtl8821ae/btcoexist/../pci.h:290:15: error: expected
> > '=', ',', ';', 'asm' or '__attribute__' before 'rtl_pci_probe'
> > make[3]: *** [drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.o] Error 1
> > make[3]: *** Waiting for unfinished jobs....
> >
> > It looks like a mangled version check which is allowing it to try and use
> > __devinit on the rtl_pci_probe function, but of course __devinit is gone.
> >
> > Ideally all that version check stuff should be gutted.
> 
> While it still should be gutted, I tracked down the source of the version
> skew.  If a person is bisecting and if you go back to pre-UAPI days,
> you will create an include/linux/version.h  -- then if you checkout a
> post-UAPI kernel, and run "make distclean" it won't delete that file.
> So you get a situation like this:
> 
> $ grep -R LINUX_VERSION_CODE include/
> include/generated/uapi/linux/version.h:#define LINUX_VERSION_CODE 200192
> include/linux/version.h:#define LINUX_VERSION_CODE 132646
> 
> Note the presence of a v2.6.38 version.  And it will be sourced/used,
> hence the fail above.  We might want to unconditionally clobber the
> old file in new kernels to avoid this trap, since it is subtle.

Yeah, I've run into that problem a number of times before, a 'git clean
-fdx' usually fixes it up for me, and is why I do it all the time when
switching major kernel versions.

thanks,

greg k-h

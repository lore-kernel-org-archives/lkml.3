Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab3LKWwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:52:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab3LKWww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:52:52 -0500
Message-ID: <1386802416.17188.69.camel@dcbw.foobar.com>
Subject: Re: Re: [PATCH v2 15/16] wl1251: Add sysfs file address for setting
 permanent mac address
From: Dan Williams <dcbw@redhat.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Kalle Valo <kvalo@adurom.com>, Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>
Date: Wed, 11 Dec 2013 16:53:36 -0600
In-Reply-To: <1386800135.1516.296.camel@bwh-desktop.uk.level5networks.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <201312101814.35112@pali> <1386697762.30202.6.camel@dcbw.foobar.com>
	 <201312101852.17030@pali>
	 <1386796654.1516.268.camel@bwh-desktop.uk.level5networks.com>
	 <52A8DA9A.50501@gmail.com>
	 <1386800135.1516.296.camel@bwh-desktop.uk.level5networks.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 22:15 +0000, Ben Hutchings wrote:
> On Wed, 2013-12-11 at 23:35 +0200, Ivajlo Dimitrov wrote:
> > On 11.12.2013 23:17, Ben Hutchings wrote:
> > > I think that's an even worse idea.  This is not firmware and it already
> > > exists in separate storage.
> > >
> > > I think that rx51_init_wl1251() in
> > > arch/arm/mach-omap2/board-rx51-peripherals.c should either copy the MAC
> > > address out of NVRAM, or if it's too early to do that, then schedule a
> > > function to run later and only then set up wl1251 platform data.
> > >
> > > Ben.
> > >
> > 
> > And how will that work with DT when board files will be in the history?
> 
> 1. Boot loader reads the MAC address from NVRAM and puts it in the DT
> node.
> or
> 2. NVRAM reading is done by a tiny driver that is loaded based on the
> platform name and updates the DT node in memory.  (But I don't know how
> wl1251 should decide to defer probing if it's probed before that other
> driver.)

I'm uncomfortable with it too, and yes the permanent MAC should really
be known before the interface is even registered, but...

Imagine if the MAC address for your ethernet device was stored
in /etc/my-mac-addr.txt, except that /etc was a read-only protected
partition from a very small SSD.  That's essentially the N900; it's
stored in a file in a normal ext2/ext3 (?) filesystem on a partition of
the internal flash.  It seems like overkill to write a small driver that
duplicates the ext3 + MTD drivers just to read the MAC.

There's got to be a better way to do this than having it set from
userspace though, but I don't know what that is.  The request_firmware()
method would probably run into race conditions, since who knows if the
partition gets mounted before the WiFi gets initialized?  I suppose the
firmware helper could block until it did, and while that's ugly, it's
the best approach I've seen yet that doesn't violate the "permanent"
idea here.

Dan


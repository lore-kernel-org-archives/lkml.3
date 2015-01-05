Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbbAEKFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:05:14 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:53472 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbbAEKFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:05:12 -0500
Message-ID: <1420452301.9459.3.camel@sipsolutions.net>
Subject: Re: [PATCH] Revert "ipw2200: select CFG80211_WEXT"
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 05 Jan 2015 11:05:01 +0100
In-Reply-To: <1420324124.9624.60.camel@x220> (sfid-20150103_232852_400842_25360CE9)
References: <1420297188.2397.3.camel@tiscali.nl>
	 <CD467A59-F563-439B-BA82-954AB27AD9CC@holtmann.org>
	 <CA+55aFzYSiUkntraMrHEhMzkt35Ft2p9E3cT7ejwQOBDwKvcOg@mail.gmail.com>
	 <1420324124.9624.60.camel@x220> (sfid-20150103_232852_400842_25360CE9)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2015-01-03 at 23:28 +0100, Paul Bolle wrote:
> On Sat, 2015-01-03 at 10:07 -0800, Linus Torvalds wrote:
> > On Sat, Jan 3, 2015 at 10:02 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
> > >
> > > why would you revert this? It is obviously the correct change to actually select CFG80211_WEXT.
> > 
> > I don't know about obvious, but yeah, I think the select in this case
> > is actually the better idea anyway.
> 
> Obviously it wasn't obvious to me!
> 
> My reasoning was that the "ipw2200: select CFG80211_WEXT" commit was
> _solely_ a workaround for the breakage introduced by that other patch.
> And since that one is now reverted the workaround wasn't needed anymore.

Well, you thought of it only as a workaround - but it makes sense. You
shouldn't have to 

> Besied, I thought we try to avoid select-ing symbols that can also be
> set manually. As that makes it more likely to trigger circular
> dependency problems in the kconfig tools, doesn't it?

I don't think that has much to do with whether or not they can be set
manually - it's more a question of what the dependencies of the selected
symbol are. In this case it's a bool leaf symbol with the only
dependency being something ipw already needs, so it's pretty much
guaranteed to be safe.

> Side note: am I correct in thinking that there's some successor to
> CFG80211_WEXT and that the ipw2200 driver could, at least in theory, be
> ported to that successor? (ipw2200 hardware appears to be a bit old, so
> probably no one would care enough to actually do that.)
> net/wireless/kconfig doesn't mention anything like that, so probably I'm
> just confused.

Well, see the big thread over there with the revert that I'm tempted to
not even read ...

The real successor, for various reasons (like simply always being able
to connect to a single AP, no matter how many others can be found by
scanning!), is nl80211.

Many drivers have been converted to the new framework by using mac80211,
but some drivers cannot use mac80211 because they do more in the
device/firmware. Among those are many of the old 11b/11g ones that still
exist in the tree, but also a few new ones (like mwifiex) that were
already written to cfg80211 APIs.

It should definitely be possible to convert all the drivers (*) to pure
cfg80211 instead of having direct userspace wext to driver calls - but
nobody has gone and done it.

johannes

(*) caveat - at least the playstation3 driver will require some new
nl80211 API


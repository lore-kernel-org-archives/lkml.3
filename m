Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab3KXALM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 19:11:12 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41037 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab3KXALL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 19:11:11 -0500
Date: Sun, 24 Nov 2013 00:10:33 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
Message-ID: <20131124001033.56252143@alan.etchedpixels.co.uk>
In-Reply-To: <528FB71C.5020304@profihost.ag>
References: <528CA73B.9070604@profihost.ag>
	<20131120125446.GA6284@infradead.org>
	<CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com>
	<528CC36A.7080003@profihost.ag>
	<CAK-9PRDyGhXPef-Vbt83Os-oowFZ2HzSZVY9PH3rSdnTwNmf2w@mail.gmail.com>
	<20131120153703.GA23160@thunk.org>
	<20131120155507.GA5380@fieldses.org>
	<528FB71C.5020304@profihost.ag>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And the 520 doesn't claim this feature (look for "enhanced power loss
> > protection" at http://ark.intel.com/products/66248), so that wouldn't
> > explain these results anyway.
> 
> Correct i think intel simply ignores CMD_FLUSH on that drive - no idea 
> why an they fixed this for their 330, 530, DC S3500 (all tested)

You are not as I read the standard allowed to "ignore" it. In fact if you
advertise the property you are obliged to implement it. The late Andre
Hedrick made sure the standard was phrased the way it was to stop it
being abused for benchmarketing. The goal was that anyone cheating would
be non-compliant.

Now its entirely possible to do clever stuff and treat it merely as a
write barrier, providing you can't lose what is queued up. What the actual
drives do I don't know.. all deep magic and not my department.

A second thing to be careful about is that certain kinds of I/O barriers
and atomic write patterns that force lots of commits to flash and erase
cycles are going to wear the drive out faster and I've been told by
manufacturers that drives do respond to such patterns by limiting the
transaction rate in self defence (and presumably in the hope the OS will
then begin to block stuff up better).

Pavel - what is lost/kept over the reset of a device is also fairly
clearly defined in the standard. Much is lost because if you committed a
permanent configuration change that the controller couldnt support you
would be a bit screwed!

If you are driving an SSD I'd work very hard to avoid the need for any
kind of O_SYNC or O_DSYNC type behaviour for exactly the same reason you
avoid uncached memory accesses - the hardware can't do its job properly
without the needed freedom. Use minimal barriers and proper sync points
and your performance will be far higher.

Alan

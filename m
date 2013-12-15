Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3LOCAs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:00:48 -0500
Received: from dmz-mailsec-scanner-8.mit.edu ([18.7.68.37]:59233 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596Ab3LOCAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:00:47 -0500
X-AuditID: 12074425-b7fd96d000000c39-fb-52ad0d4efdfd
Date: Sat, 14 Dec 2013 21:00:43 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 00/14] random: rework reseeding
Message-ID: <cover.1387067223.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsUixCmqrevHuzbI4P8sIYtpG8UtLu+aw+bA
	5PF5k5zHiZYvrAFMUVw2Kak5mWWpRfp2CVwZ7Qc1Cs6LV8x5dpmlgXGScBcjJ4eEgInEpJsT
	2SBsMYkL99YD2VwcQgKzmSS2TljIDOFsZJR4/7MPyvnFKHH8zWkmkBYWAVWJZ7O6WEFsNgEF
	iR/z1zGD2CICyhKrZm4Cq2EWcJJ4uOgSC4gtLKAvsWPOTbB6XgEDia7bT5ggbEGJkzOfsEDU
	a0nc+PcSKM4BZEtLLP/HARIWFVCRmHJyG9sERv5ZSDpmIemYhdCxgJF5FaNsSm6Vbm5iZk5x
	arJucXJiXl5qka6FXm5miV5qSukmRlAgsruo7mCccEjpEKMAB6MSD68E29ogIdbEsuLK3EOM
	khxMSqK8UpxAIb6k/JTKjMTijPii0pzU4kOMEhzMSiK8O86vCRLiTUmsrEotyodJSXOwKInz
	3uKwDxISSE8sSc1OTS1ILYLJynBwKEnwavMADRUsSk1PrUjLzClBSDNxcIIM5wEaLgZSw1tc
	kJhbnJkOkT/FqCglzssGkhAASWSU5sH1whLFK0ZxoFeEeSVAqniASQau+xXQYCagwd57VoEM
	LklESEk1MCZxfWmQfs4WcuNJVu01jprM+S9K5brmHVPfUcIvsOj9pgOarxf8PaXMvOGAywTj
	U4n7X2mLmr/b97N4i2qC1hGHtytTXsU0+spG5hT80zeInnI7ZFtg25Y1L0P/VKi+dumxNn7x
	Rd6068gS6U1p39jnMPyyOPg58qBzFEvZVrfsihPTzK/+zFNiKc5INNRiLipOBACXzIVc7wIA
	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted, hi all,

This series reworks the way we handle reseeding the nonblocking pool,
which supplies /dev/urandom and the kernel's internal randomness
needs.  The most important change is to make sure that the input
entropy always comes in large chunks, what we've called a
"catastrophic reseed", rather than a few bits at a time with the
possibility of producing output after every few bits.  If we do the
latter, we risk that an attacker could see the output (e.g. by
watching us use it, or by constantly reading /dev/urandom), and then
brute-force the few bits of entropy before each output in turn.

Patches 1-9 prepare us to do this while keeping the benefit of 3.13's
advances in getting entropy into the nonblocking pool quickly at boot,
by making several changes to the workings of xfer_secondary_pool() and
account().  Then patch 10 accomplishes the goal by sending all routine
input through the input pool, so that our normal mechanisms for
catastrophic reseed always apply.

Patches 11-13 change the accounting for the 'initialized' flag to
match, so that it gives credit only for a single large reseed (of
128 bits, by default), rather than many reseeds adding up to 129 bits.
This is the flag that means we no longer warn about insufficient
entropy, we allow /dev/random to consume entropy, and other changes.

Patch 14 adds an extra stage after setting 'initialized', where we go
for still larger reseeds, of up to 512 bits estimated entropy by
default.  This isn't integral to achieving catastrophic reseeds, but
it serves as a hedge against situations where our entropy estimates
are too high.

After the whole series, our behavior at boot is to seed with whatever
we have when first asked for random bytes, then hold out for seeds of
doubling size until we reach the target (by default 512b estimated.)
Until we first reach the minimum reseed size (128b by default), all
input collected is exclusively for the nonblocking pool and
/dev/random readers must wait.

Cheers,
Greg


Greg Price (14):
  random: fix signedness bug
  random: fix a (harmless) overflow
  random: reserve for /dev/random only once /dev/urandom seeded
  random: accept small seeds early on
  random: move transfer accounting into account() helper
  random: separate quantity of bytes extracted and entropy to credit
  random: exploit any extra entropy too when reseeding
  random: rate-limit reseeding only after properly seeded
  random: reserve entropy for nonblocking pool early on
  random: direct all routine input via input pool
  random: separate entropy since auto-push from entropy_total
  random: separate minimum reseed size from minimum /dev/random read
  random: count only catastrophic reseeds for initialization
  random: target giant reseeds, to be conservative

 drivers/char/random.c         | 198 ++++++++++++++++++++++++++++--------------
 include/trace/events/random.h |  27 +++---
 2 files changed, 150 insertions(+), 75 deletions(-)

-- 
1.8.3.2

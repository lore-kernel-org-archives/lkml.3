Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942AbaABKPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:15:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44305 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaABKPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:15:05 -0500
Date: Thu, 2 Jan 2014 11:14:55 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Willy Tarreau <w@1wt.eu>, John Stultz <john.stultz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: v3.13-rc6+ regression (ARM board)
Message-ID: <20140102101455.GG10158@pengutronix.de>
References: <m3mwjhux0e.fsf@t19.piap.pl>
 <20131231104511.GA9688@1wt.eu>
 <m3txdmu2ez.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3txdmu2ez.fsf@t19.piap.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On Thu, Jan 02, 2014 at 11:02:44AM +0100, Krzysztof Hałasa wrote:
> >> There seems to be a regression in v3.13-rc6+ (up to current tip =
> >> 71ce176ee6ed1735b9a1160a5704a915d13849b1).
> >>
> >> Board is Gateworks Cambria, CPU Intel IXP435 ARM big endian, gcc 4.7.3.
> >> The board boots correctly and works (shell mostly, and SSHD) for about
> >> 50 seconds. After 52-54 seconds, it frozes dead without any console
> >> (UART) output.
> >>
> >> Bisecting shows 5e30025a319910695f5010dc0fb53a23299da14d as the first
> >> bad commit. Interestingly it's a merge:
> 
> Reverting 1ca7d67cf5d5a2aef26a8d9afd789006fa098347 on top of current tip
> (9a0bb2966efbf30a71c128c3af63307d8b5f5fc0) fixes my issue.
> 
> What now?
> 
> 1ca7d67cf5d5a2aef26a8d9afd789006fa098347:
>     seqcount: Add lockdep functionality to seqcount/seqlock structures
> 
>     Currently seqlocks and seqcounts don't support lockdep.
> 
>     After running across a seqcount related deadlock in the timekeeping
>     code, I used a less-refined and more focused variant of this patch
>     to narrow down the cause of the issue.
> 
>     This is a first-pass attempt to properly enable lockdep functionality
>     on seqlocks and seqcounts.
> 
>     Since seqcounts are used in the vdso gettimeofday code, I've provided
>     non-lockdep accessors for those needs.
> 
>     I've also handled one case where there were nested seqlock writers
>     and there may be more edge cases.
> 
>     Comments and feedback would be appreciated!
So it seems to be that 1ca7d67cf5d5a2aef26a8d9afd789006fa098347 doesn't
like to be combined with some other commit from
5e30025a319910695f5010dc0fb53a23299da14d^2..5e30025a319910695f5010dc0fb53a23299da14d^.
What you can do is:

	git bisect start 5e30025a319910695f5010dc0fb53a23299da14d^ b8a216269ec0ce2e961d32e6d640d7010b8a818e

The bad commit is the tip of Linus' tree when he created the bad merge
commit. The good one is the base of the merged tree. To check if a tree
is good or bad do:

	git merge --no-commit 5e30025a319910695f5010dc0fb53a23299da14d^2
	test test test
	git reset --hard
	git bisect good ... or ... git bisect bad

That should find the commit that makes your board break in combination
with 1ca7d67cf5d5a2aef26a8d9afd789006fa098347.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3LJKU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:20:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab3LJKUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:20:55 -0500
Date: Tue, 10 Dec 2013 11:20:51 +0100
From: Miroslav Lichvar <mlichvar@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
Message-ID: <20131210102051.GO22878@localhost>
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
 <528A7C88.1030801@linaro.org>
 <20131120183900.GA25735@localhost>
 <529D2BA6.5020005@linaro.org>
 <529D5805.20903@linaro.org>
 <20131206142602.GH22878@localhost>
 <52A27D51.1040805@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A27D51.1040805@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 05:43:45PM -0800, John Stultz wrote:
> Being that the bigadjust code, and specifically this lookahead bit, has
> always been the most opaque logic to me, I figured I'd spend some time
> looking at alternatives, and came up with one approach that tries to
> mimic your patch, but tries to be more in line with the existing logic.
> 
> It seems to do fairly well in the simulator:
> n: 30, slope: 1.00 (1.00 GHz), dev: 3.2 ns, max: 3.6 ns, freq: -99.95677 ppm

Hm, this shows a 0.043ppm error in the frequency. It doesn't seem to go
away even when I use a long sampling interval or give it more time to
settle down. Is that an expected side effect of the patch?

> Basically in the big-error case, we calculate the adjustment from the
> current tick error (and the assumption is that is where the majority of
> the large error is coming from), leaving the normal +1/-1 adjustments to
> the cumulative error.

The normal +1/-1 adjustment doesn't seem to be active in the
simulation, at least in the default settings with 100ppm offset. When
I print the error variable in timekeeping_adjust() I can see its
absolute value stays above interval*2, so timekeeping_bigadjust() is
called on every update. The bigadjust correction seems too weak to
bring the error down to activate the normal +1/-1 adjustment, the
error keeps increasing and the frequency is slighly off.

What does the following line from your patch mean?

        tick_error -= tk->xtime_interval;

-- 
Miroslav Lichvar

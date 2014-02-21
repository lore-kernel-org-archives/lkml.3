Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaBUJjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 04:39:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38941 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754491AbaBUJi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 04:38:58 -0500
Date: Fri, 21 Feb 2014 09:38:55 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: lee.jones@linaro.org, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm5102: Remove cache_bypass from manual register
	patching
Message-ID: <20140221093855.GC5438@opensource.wolfsonmicro.com>
References: <1392913608-23479-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140220233058.GC12197@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220233058.GC12197@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 08:30:58AM +0900, Mark Brown wrote:
> On Thu, Feb 20, 2014 at 04:26:48PM +0000, Charles Keepax wrote:
> 
> > As the cache_bypass is not strictly necessary for applying the patches
> > (the device is always powered on whilst it is applied) remove the calls
> > to regcache_cache_bypass to avoid this situation.
> 
> That's not why the cache bypass is there, the cache bypass is there to
> make sure we don't cache the writes and hence reapply them while
> restoring the cache.  This would cause breakage with writes which change
> register defaults (where it would overwrite previously cached writes) or
> need to be done in that specific sequence.  A bypassed write goes
> straight to the hardware so it can't work if the device is powered off.

I guess there are two parts here applying the hardware patch and
the manual application of the register patch. Applying the
hardware patch restores registers once it is finished anyway, and
the actual patch is applied by the write sequencer so will go
straight to the hardware. So that really doesn't need the
cache_bypass.

Good point on the manual patch application it could potentially
clobber some user setup. Although the current register patch
should not cause any issues on this front.

> Given that this is happening on resume I expect you can achieve
> sufficient exclusion by making sure that everything that writes to the
> device holds a runtim PM reference which you ought to be doing anyway,
> the PM infrastructure makes sure that only one resume can run at once.
> However I expect that's going to be annoying with ASoC where you don't
> really want to boot the device just to change controls (but perhaps with
> autosuspend it's not too bad, most likely the device will be getting
> powered up shortly anyway if userspace is fiddling with the controls).

Yeah I had considered this and I agree it should work but I had
decided against it because of the powering up for each control
write.

> Being able to use the regular patch infrastructure would of course be
> nicer but you're going to need to add a callback to allow you to run the
> hardware patch in that case.

I had considered adding bypassed versions of regmap_write and
read. That way you could ensure that the bypass was only active
whilst the regmap lock was held and avoid the problem that way.
What do you think to that idea?

> You probably also want to be applying the patch using async writes to
> improve performance but that's separate and just an optimisation.

Good point I shall have a look at this.

Thanks,
Charles


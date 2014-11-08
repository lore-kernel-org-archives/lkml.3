Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaKHAqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:46:22 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48209 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaKHAqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:46:21 -0500
MIME-Version: 1.0
In-Reply-To: <20141108002334.GT4042@n2100.arm.linux.org.uk>
References: <1415386312-23741-1-git-send-email-dianders@chromium.org>
	<20141107185844.GR4042@n2100.arm.linux.org.uk>
	<CAD=FV=WhWqMB=-ErD-59-z=y7OCZx4r7REkr3DpyYR=76SEJ6A@mail.gmail.com>
	<20141107233607.GS4042@n2100.arm.linux.org.uk>
	<CAD=FV=WCwGjuLNFPANqqq-+rEN_jhqi+Bfss2ugDJEgjf3z_Gg@mail.gmail.com>
	<20141108002334.GT4042@n2100.arm.linux.org.uk>
Date: Fri, 7 Nov 2014 16:46:20 -0800
X-Google-Sender-Auth: ba0SxbaQ7fGteluHBDSZ8gSONUI
Message-ID: <CAD=FV=V3RVrHR=T+_+7CP1jGBAR48MmV062_Xj=8bj00E_2VUA@mail.gmail.com>
Subject: Re: [PATCH] clk: Propagate prepare and enable when reparenting orphans
From: Doug Anderson <dianders@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Fri, Nov 7, 2014 at 4:23 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Nov 07, 2014 at 04:14:23PM -0800, Doug Anderson wrote:
>> Russell,
>> I guess I'm still confused.  My patch continues to be about orphans
>> and I don't see the bug you are pointing to.
>
> Ah, in which case, the question changes: how can an orphaned clock be
> succesfully prepared and enabled?
>
> Drivers expect that a clock for which clk_enable() has returned
> successfully _will_ at that point be supplying the clock.  If we don't
> yet know it's parent, how do we know that it will be supplying that
> clock?
>
> What about a driver calling clk_set_rate() on an orphaned clock?
>
> From what I can see (__clk_reparent will re-set the child's clock when
> reparenting) having a driver able to claim an orphaned clock, let
> alone prepare and enable it, looks rather buggy to me.

Yes, it is pretty questionable.  I discussed some of this in my
comment message in this patch.  Specifically, I said:

> NOTE: this does bring up the question about whether the enable of the
> orphan actually made sense.  If the orphan's parent wasn't enabled by
> default (by the bootloader or the default state of the hardware) then
> the original enable of the orphan probably didn't do what the caller
> though it would.  Some users of the orphan might have preferred an
> EPROBE_DEFER be returned until we had a full path to a root clock.
> This patch doesn't address those concerns and really just syncs up the
> state.

I'm not sure I want to go all the way doing the above and adding the
EPROBE_DEFER because I think that there are probably lots of users out
there that are assuming that they can enable/disable an orphaned clock
and I can't myself commit to fixing all of them.  If you want to
propose such a patch and can get it landed then my patch would
certainly not be necessarily.

Also see the note in the original commit message:

> Note that xin32k on rk808 is a clock that cannot be disabled in
> hardware (it's an always on clock), so really all we needed to do was
> to sync up the state.

-Doug

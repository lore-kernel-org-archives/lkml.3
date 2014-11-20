Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbaKTHpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:45:21 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:40225 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaKTHpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:45:19 -0500
Date: Wed, 19 Nov 2014 23:45:14 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] clk: Propagate prepare and enable when reparenting
 orphans
Message-ID: <20141120074514.GB30434@dtor-ws>
References: <1415408818-28028-1-git-send-email-dianders@chromium.org>
 <20141120023050.12298.26964@quantum>
 <CAD=FV=VZJ_iSFoW39kbahFSZ_Ta4Qf7zxaCnJMWFVWhXzsLrWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=VZJ_iSFoW39kbahFSZ_Ta4Qf7zxaCnJMWFVWhXzsLrWw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 09:15:41PM -0800, Doug Anderson wrote:
> Mike,
> 
> On Wed, Nov 19, 2014 at 6:30 PM, Mike Turquette <mturquette@linaro.org> wrote:
> > Quoting Doug Anderson (2014-11-07 17:06:58)
> >> With the existing code, if you find a parent for an orhpan that has
> >> already been prepared / enabled, you won't enable the parent.  That
> >> can cause later problems since the clock tree isn't in a consistent
> >> state.  Fix by propagating the prepare and enable.
> >>
> >> NOTE: this does bring up the question about whether the enable of the
> >> orphan actually made sense.  If the orphan's parent wasn't enabled by
> >> default (by the bootloader or the default state of the hardware) then
> >> the original enable of the orphan probably didn't do what the caller
> >> though it would.  Some users of the orphan might have preferred an
> >> EPROBE_DEFER be returned until we had a full path to a root clock.
> >> This patch doesn't address those concerns and really just syncs up the
> >> state.
> >
> > -ECANOFWORMS
> >
> > I'm thinking about this patch but I haven't quite made up my mind. It is
> > reasonable, but also some nice kind of error might be preferable when
> > preparing/enabling an orphaned clock.
> >
> > Under what conditions might a clock be orphaned? An obvious example is
> > just bad luck during the thundering herd of clock registrations from a
> > driver. In this case deferring the probe might be a good idea.
> >
> > However what about the case where a loadable module provides the parent
> > clock? It might be a long time before the orphan clocks gets picked up
> > from the orphanage. Is deferring probe the right thing here as well?
> 
> I will defer to your wisdom here.  I agree that these are the two
> primary solutions and I've picked one, but I have no idea which will
> be more of a PITA in the long run.
> 
> Note: I'm not sure that anyone expects EPROBE_DEFER to be returned
> from a clk_enable() (do they?).  It almost seems like the right answer
> is to fail to allow anyone to clk_get() any clock that doesn't have a
> path to root.

EPROBE_DEFER only makes sense in driver's probe paths and so I would be
very against adding it to clk_enable() which is called from many places
in the kernel. If we decide to go with EPROBE_DEFER then returning it
from clk_get() seems like a much better choice since it is normally
called during probing.

Thanks.

-- 
Dmitry

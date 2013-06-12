Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626Ab3FLBBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 21:01:05 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:53945 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3FLBBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 21:01:03 -0400
MIME-Version: 1.0
In-Reply-To: <519AFBB6.90700@codeaurora.org>
References: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com>
	<1369056507-32521-6-git-send-email-james.hogan@imgtec.com>
	<519AFBB6.90700@codeaurora.org>
Date: Tue, 11 Jun 2013 18:01:01 -0700
X-Google-Sender-Auth: 48FLSsT75D6iMdul9kasCSGcgXk
Message-ID: <CAD=FV=VFqTzqLc3+UOHD21NiTqtu84DzwYD1Qag-RxiD0qcFDA@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] clk: clk-mux: implement remuxing on set_rate
From: Doug Anderson <dianders@chromium.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: James Hogan <james.hogan@imgtec.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mike pointed me at this series since I'm running into parenting
problems at the moment as well...

On Mon, May 20, 2013 at 9:44 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> While writing a similar code for our internal tree, I quickly came to the
> realization that, "all parents are equal, but some are more equal than
> others". The simplest example is a clock tree like this:
>
> Source -> Divider -> Mux
> Source -> Mux
>
> A rate of Y can be achieved for Mux by either running Source at Y and
> picking that input or running Source at Y * 2 and Divider set to div-2 and
> picking the Divider input.
>
> The solution seems to be a priority list of parents. I'm sure there would be
> other reason (jitter, clock quality, etc) for a mux to pick one parent vs.
> another when both of them can provide the required rate.
>
> I think this loop should loop over parents based on their priority order.
> So, parents should become a struct of { clk, index } and have the parents
> listed in the order of priority. Well, at least in that long run that would
> be better to avoid messing up parent/index values. But for now, you could
> just have a priority array of index or parents.
>
> It might not fit 100% of the cases where two parents can provide the same
> rate, but it should fit most use cases.

I'm slightly worried about similar problems, but I don't have a really
great solution.

In my case I'm working on exynos5 hardware which has a bunch of PLLs
and a crazy number of muxing options.  Many of the muxing options are
not really meant to be used but seem to have been added to the SoC as
a "backup plan" of some sort.  :-/  Most of the PLLs are intended to
be used for one purpose and one purpose only though muxing options
allow them to be used all over the place.

For instance if I look at my current bootup of exynos5250-snow, I see:

fout_apll/clk_rate:1700000000
fout_bpll/clk_rate:800000000
fout_cpll/clk_rate:333000000
fout_epll/clk_rate:45158401
fout_gpll/clk_rate:533000000
fout_mpll/clk_rate:1600000000

* APLL is intended to be the parent of the 2 ARM cores and changes due
to cpu load
* EPLL is intended to be the parent for audio and changes dpending on
audio playback rates.
* GPLL is intended to be the parent of the GPU and changes due to gpu load
* VPLL is intended to be the parent for video related things and could
change depending on the LCD.
* MPLL doesn't change a lot and is intended to be the parent for most things.
* In some systems BPLL can be used for memory or GPU

My main concern here is the CCF will end up deciding at some point
that it should reparent some clock onto a PLL that is going to change
a whole lot.  Maybe the user will plug in an SD card that requests a
frequency of 52MHz and at the moment we'll be running EPLL at 104 MHz
so it will be a perfect match!  ...but then the user wants to play
audio at a different rate.  The audio code assumes that it can mess
with its clock and we've got code setup to call CLK_SET_RATE_PARENT
all the way up to EPLL.  That will really mess with the SD card.
Really we'd rather just have the SD card clock always parented on the
stable MPLL and it's OK if 52MHz gets rounded down to 50MHz.

Of course, on another board maybe they don't have an audio codec and
aren't using epll for audio and have realized that EPLL would be a
perfect way to get their SD card to run 4% faster.  It ought to work.


I guess to summarize the above:

* It seems like much of the muxing on exynos5250 is just too
complicated to leave it to an simple automated algorithm.
* It seems like we can't make muxing decisions on the SoC level.
* Your automatic muxing patches don't hurt me and could be useful for
_some_ of the muxing options, just not the top PLL ones.

...but the only place that leaves me for my muxing needs is the device
tree.  ...and as Mike pointed out on IRC the device tree should
describe hardware, not policy.  Ick.

-Doug

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbbAQXwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:52:34 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34865 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbbAQXwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:52:31 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Ulf Hansson <ulf.hansson@linaro.org>,
        "Krzysztof Kozlowski" <k.kozlowski@samsung.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAPDyKFqe7UxSrQxuvGw7UWFQhvX0NZ83rvLrAEMZFpA4n0GcNg@mail.gmail.com>
Cc: "Chris Ball" <chris@printf.net>, "Jaehoon Chung" <jh80.chung@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc" <linux-mmc@vger.kernel.org>,
        "Kukjin Kim" <kgene@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc" <linux-samsung-soc@vger.kernel.org>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Stephen Boyd" <sboyd@codeaurora.org>
References: <1421054585-9032-1-git-send-email-k.kozlowski@samsung.com>
 <CAPDyKFpGiaDJ3zjCSSbcia6iLS2+FLBRjGAheQAzvFsAkJax+A@mail.gmail.com>
 <1421313626.19448.8.camel@AMDC1943>
 <CAPDyKFqe7UxSrQxuvGw7UWFQhvX0NZ83rvLrAEMZFpA4n0GcNg@mail.gmail.com>
Message-ID: <20150117235222.22722.904@quantum>
User-Agent: alot/0.3.5
Subject: Re: [RFC 0/3] mmc: Add dynamic frequency scaling
Date: Sat, 17 Jan 2015 15:52:22 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ulf Hansson (2015-01-15 02:04:04)
> On 15 January 2015 at 10:20, Krzysztof Kozlowski
> <k.kozlowski@samsung.com> wrote:
> > On czw, 2015-01-15 at 09:20 +0100, Ulf Hansson wrote:
> >> + Mike, Stephen (Clock maintainers)
> >>
> >> On 12 January 2015 at 10:23, Krzysztof Kozlowski
> >> <k.kozlowski@samsung.com> wrote:
> >> > Hi,
> >> >
> >> >
> >> > I would like to hear some comments about idea of scaling MMC clock
> >> > frequency. The basic idea is to lower the clock when device is
> >> > completely idle or not busy enough.
> >>
> >> We already have host drivers that implements runtime PM support.
> >> Typically that would mean the clock will be gated once the device
> >> becomes runtime PM suspended.
> >>
> >> Why should we decrease the frequency of an already gated clock?
> >
> > In case of idle state you're right that clkgate would be better. But
> > what about finding a compromise between high performance (high
> > frequency) and energy saving for different loads on MMC?
> 
> I guess a compromise could be beneficial for some SOC and use cases.
> At least I remember, ST-Ericsson's UX500 SOC had such an out of tree
> hack to track MMC load.

It is very important to model when resources are not needed, since this
has some system-wide effects. There are two main use-cases I have in
mind:

1) MMC clk is a leaf clock of some complex hierarchy (e.g. a PLL at the
top of a clock sub-tree). If MMC is always "locked" at some fast rate
(e.g. 48MHz instead of 24MHz or 12MHz) then that constraint prevents
the rest of the hierarchy from transitioning to a lower frequency. Even
if the MMC clock is aggressively gating, maximum system-level power
savings may not be achieved since the rest of the clock sub-tree
(starting at the PLL) will be "stuck" at a higher frequency than
necessary. Thus, aggressive clock gating might give good power savings
for the MMC case, but may be a blocker for other system components.

2) Wake-up latency constraints might make it impossible to clock gate,
and thus the only power-saving option is to run at a lower frequency.
This is not quite what is described above, but the point is that clock
frequency scaling and clock gating are complementary power saving
options, but we rely on the driver to model resource requirements
accurately to get the best results.

Regards,
Mike

> 
> >
> > The frequency scaling could help in that case. Anyway I should prepare
> > some more benchmarks for such conditions.
> 
> Seems reasonable and please do!
> 
> Kind regards
> Uffe

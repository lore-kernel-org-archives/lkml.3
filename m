Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbaKRS6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:58:36 -0500
Received: from gloria.sntech.de ([95.129.55.99]:42639 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860AbaKRS6f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:58:35 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] clk: add property for force to update clock setting
Date: Tue, 18 Nov 2014 20:01:56 +0100
Message-ID: <4405473.vT6u1E3Q1r@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <CAD=FV=VZ+qPRdeTaAXxBU0aSObBRdY5TDmREYviuh8h3dUs5fQ@mail.gmail.com>
References: <1415884826-7877-1-git-send-email-kever.yang@rock-chips.com> <20141117211410.25314.99324@quantum> <CAD=FV=VZ+qPRdeTaAXxBU0aSObBRdY5TDmREYviuh8h3dUs5fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 18. November 2014, 09:59:56 schrieb Doug Anderson:
> Hi,
> 
> On Mon, Nov 17, 2014 at 1:14 PM, Mike Turquette <mturquette@linaro.org> 
wrote:
> > Quoting Heiko Stübner (2014-11-14 10:06:47)
> > 
> >> Hi Mike,
> >> 
> >> Am Donnerstag, 13. November 2014, 17:41:02 schrieb Mike Turquette:
> >> > Quoting Doug Anderson (2014-11-13 15:27:32)
> >> 
> >> [...]
> >> 
> >> > All of the above is to say that perhaps the solution to this problem
> >> > belongs in the driver. In the end we're talking about details for
> >> > correctly programming hardware, which sounds an awful lot like what
> >> > drivers are supposed to do.
> >> > 
> >> > Let me know if the ->init() callback holds any promise for you. If not
> >> > we can figure something out.
> >> 
> >> From my theoretical musings, ->init() sounds like a nice idea - but of
> >> course it comes with a "but".
> >> 
> >> I guess the general idea would be to have the pll clk-type simply reset
> >> to the same rate but forcing it to use the parameters from its parameter
> >> table - when the rate params differ [0].
> >> 
> >> The only problem would be the apll supplying the cpu cores. After all
> >> clocks are registered, our armclk makes sure that the core clock gets
> >> reparented before changing the underlying apll [dpll is safe, as it is
> >> read-only currently].
> DPLL probably won't be read only forever...
> 
> >> At the moment the order would be
> >> clk_register(apll)
> >> apll->init()
> >> clk_register(armclk);
> > 
> > Sorry, but I don't understand the problem. The at registration-time,
> > apll is re-programmed to a correct value for its current rate. Then
> > armclk is registered which might change apll's rate. Any change to the
> > apll which is issued from armclk should insure that apll is programmed
> > correctly.
> 
> I think Heiko is worried that until the "armclk" is registered that
> nobody is there to reparent the ARM core to GPLL while APLL changes
> (that's armclk's job).  This is potentially unsafe.
> 
> NOTE: it actually might not be unsafe, just slow.  I think we'll
> actually swap the PLL into "slow" mode before changing it (24MHz) so
> we won't die we'll just run at 24MHz at boot time while we wait for
> APLL to re-lock.

that is correct, we switch the pll to slow-mode (which simply passes through 
the xin24m) before touching its params, which is also the behaviour described 
in the manual for this.


> One option would be to just add yet another per-pll parameter.  We'll
> only cleanup CPLL, GPLL, and NPLL.  If APLL (ARM clock) and DPLL
> (memory clock) are set differently by firmware then we're just SOL.
> Of course if firmware boots us on GPLL then I guess we're back to
> square one (would firmware really be that malicious?)

I was talking with Kever about the same thing today. My best idea would be to 
give our plls a flag property - like all the other clocks have (divider_flags, 
mux_flags, etc) - because who knows if later pll designs will need other 
smaller adjustments. Then adding a ROCKCHIP_PLL_FLAG_SYNC_RATE triggering the 
init function to check the rate params.


Heiko

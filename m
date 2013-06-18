Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761Ab3FRPWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:22:45 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:62208 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab3FRPWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:22:42 -0400
MIME-Version: 1.0
In-Reply-To: <51BFE754.6000909@samsung.com>
References: <1370580406-10254-1-git-send-email-dianders@chromium.org>
	<1370626110-1731-1-git-send-email-dianders@chromium.org>
	<1370626110-1731-2-git-send-email-dianders@chromium.org>
	<51BFE754.6000909@samsung.com>
Date: Tue, 18 Jun 2013 08:15:37 -0700
X-Google-Sender-Auth: gzAYjSxyB74Rfp5xH78MUoZawCE
Message-ID: <CAD=FV=Wy5X9C=NOUVyAzZK5+BKD1w4FTmoTHzKipq2j_Y9rdtg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mmc: dw_mmc: Add the ability to set the ciu clock frequency
From: Doug Anderson <dianders@chromium.org>
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Andrew Bresticker <abrestic@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Will Newton <will.newton@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaehoon,

On Mon, Jun 17, 2013 at 9:51 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
> Hi Doug,
>
> I have one question for using <clock-frequency>.
> I found the fixed-rate-clocks feature.
> If we want to set <clock-frequency>, then can we use the fixed-rate-clocks?
> i'm not sure how use the fixed-rate-clocks. but it seems to set fixed-rate value for clock frequency.
>
> clk_set_rate() didn't ensure to set the <clock-frequency> value.

I'm not sure I understand the question.  I don't think that the
fixed-rate-clocks have a close relation to the clock-frequency or the
ciu clock.  The fixed-rate-clock entries for a board usually specify
the root clock source for a board.  For instance in exynos5250-snow
you can see:

fixed-rate-clocks {
  xxti {
    compatible = "samsung,clock-xxti";
    clock-frequency = <24000000>;
  };
};

Other clocks in the board are derived from this clock through PLLs,
muxes, dividers, gates, etc.  On 5250 we have:

 fin_pll (xxti) -> fout_mpll -> fout_mplldiv2 -> mout_mpll_fout ->
 sclk_mpll -> sclk_mpll_user -> mout_mmc1 -> div_mmc1
 div_mmc_pre1 -> sclk_mmc1

In 5250 the ciu clock for mmc1 is sclk_mmc1, which is a simple gate.
When you "enable" this clock it, ungates it.  The sclk_mmc1 has the
flag CLK_SET_RATE_PARENT on it.  That means when you try to set the
rate it will involve the parent clock (div_mmc_pre1).  The parent
clock also has CLK_SET_RATE_PARENT, so it can also involve div_mmc1.
I haven't dug through to see how the clock framework splits up divides
between div_mmc1 and div_mmc_pre1, but it's supposed to handle that.

We don't allow clk_set_rate to percolate any higher (no
CLK_SET_RATE_PARENT at mout_mmc1).

-Doug

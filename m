Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaGaVIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:08:36 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:57851 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaGaVId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:08:33 -0400
Message-ID: <53DAB04A.90005@gmail.com>
Date: Thu, 31 Jul 2014 23:08:26 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Humberto Naves <hsnaves@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Thomas Abraham <ta.omasab@gmail.com>,
        Andreas Farber <afaerber@suse.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCHv2 4/5] clk: samsung: exynos5410: Add fixed rate clocks
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com> <1406805732-17372-5-git-send-email-hsnaves@gmail.com> <53DA2C74.3010101@samsung.com> <CAEe5pB8wzECi=4Eoa_xZYuw7NRPuRmizBNm5mXYMjYY_hWBy9Q@mail.gmail.com>
In-Reply-To: <CAEe5pB8wzECi=4Eoa_xZYuw7NRPuRmizBNm5mXYMjYY_hWBy9Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Humberto,

On 31.07.2014 23:01, Humberto Naves wrote:
> Hi,
> 
> On Thu, Jul 31, 2014 at 1:45 PM, Sylwester Nawrocki
> <s.nawrocki@samsung.com> wrote:
>> Can you explain what is rationale behind this change ? Is it related to
>> suspend/resume ordering ?
> 
> I had forgotten, but now remember the reason why I did this. If you
> see the current implementation of clk-exynos5410, you will notice it
> heavily depends on the clock "fin_pll". On the other hand, this clock
> exists because in the current dtb (exynos5410-smdk5410.dts), there is
> a node fin_pll such as
> 
>        fin_pll: xxti {
>                compatible = "fixed-clock";
>                clock-frequency = <24000000>;
>                clock-output-names = "fin_pll";
>                #clock-cells = <0>;
>        };
> 
> So far so good. But the real problem comes in when I check the rate of
> fin_pll to determine if I should install the rate table or not (and I
> really need this for my patch). More specifically
> 
>        if (_get_rate("fin_pll") == 24 * MHZ) {
>                exynos5410_plls[apll].rate_table = apll_24mhz_tbl;
>                exynos5410_plls[cpll].rate_table = cpll_24mhz_tbl;
>                exynos5410_plls[kpll].rate_table = kpll_24mhz_tbl;
>                exynos5410_plls[dpll].rate_table = dpll_24mhz_tbl;
>                exynos5410_plls[epll].rate_table = epll_24mhz_tbl;
>                exynos5410_plls[ipll].rate_table = ipll_24mhz_tbl;
>        }
> 
> I *have* to determine if the rate of fin_pll is 24MHz, and this is
> impossible to do if fin_pll is not available. Moreover, there is no
> way I can ensure that the fixed clock provider for fin_pll was
> initialized before mine, so there is chance that _get_rate won't work.
> The only way I fix that is to set the dependency explicitly in the
> dtb, by adding the fin_pll clock as required resource.
> 
>               clock: clock-controller@10010000 {
>                       compatible = "samsung,exynos5410-clock";
>                       reg = <0x10010000 0x30000>;
>                       #clock-cells = <1>;
>                       /* Add the parent clock */
>                       clocks = <&fin_pll>;
>                       clock-names = "fin_pll";
>               };

This is the correct solution to your problem. The clocks and clock-names
properties should have been there from the beginning but apparently this
has been missed in review. Also see below.

> 
> But in any case, the bindings with the DTB must be changed one way or
> another, because I *really* need to use fin_pll on my driver
> registration.

This is a backwards compatible change. On DTBs without clocks and
clock-names properties the PLL tables simply won't be registered which
is exactly the same behavior we have now without any tables in the
driver at all.

> If you agree with this alternative solution I previously
> described, I can change that in the next version of the patch series.

Please update the dts instead, in the way you pointed above.

Best regards,
Tomasz

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbaLINSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:18:41 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9163 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669AbaLINSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:18:39 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
X-AuditID: cbfec7f4-b7f126d000001e9a-c9-5486f6adf1a1
Content-transfer-encoding: 8BIT
Message-id: <5486F69B.6020005@samsung.com>
Date: Tue, 09 Dec 2014 14:18:19 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Kukjin Kim <kgene@kernel.org>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] clk: samsung: Fix Exynos 5420 pinctrl setup and clock
 disable failure due to domain being gated
References: <1417788934-23447-1-git-send-email-k.kozlowski@samsung.com>
 <1418129982.19339.6.camel@AMDC1943>
In-reply-to: <1418129982.19339.6.camel@AMDC1943>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xq7prv7WFGNxdyWexccZ6Voujvwss
	Xr8wtOh//JrZ4unmx0wWZ5vesFtsenyN1eLyrjlsFjPO72OyWHvkLrvF0wkX2Sx+nOlmsVi1
	6w+jA6/H5b5eJo+/z6+zeOycdZfdY9OqTjaPO9f2sHlsXlLv0bdlFaPH501yARxRXDYpqTmZ
	ZalF+nYJXBm/nh1hLFjGV9HzOLqBcTN3FyMnh4SAicTbDXPYIGwxiQv31gPZXBxCAksZJf7v
	ugSW4BUQlPgx+R5LFyMHB7OAvMSRS9kQprrElCm5IBVCAp8YJWZ+jYGo1pK4frudFcRmEVCV
	uHS3iR3EZhMwlOg92scIYosKREicvLsHLC4iEC1x6cdkFpC1zAJnmSWOf7nJBDJfWKBMYvMf
	sFVCArkSZ3r0QMo5BQwk9u15yDKBUWAWkttmIdw2C+G2BYzMqxhFU0uTC4qT0nMN9YoTc4tL
	89L1kvNzNzFCouXLDsbFx6wOMQpwMCrx8JortoYIsSaWFVfmHmKU4GBWEuGdcrQtRIg3JbGy
	KrUoP76oNCe1+BAjEwenVAOjWzjHzLzFatn6W7tdI7Mi/R8pXhL7/X3hVdYX2Xd+ZTiInggw
	+vnoL4PqB9uVZQeyV93O+n476eHJove3Gfq+ba4pv6twdfaJ5EAfS+4H5XvXKS5b+YaReU7g
	qeDM7iO7VvvnK/Z+fyyteyHgh7PnUpldYWY1Ty9Mn+RiUZU4caHHJdUDMiXzlFiKMxINtZiL
	ihMBk/73eHQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/14 13:59, Krzysztof Kozlowski wrote:
> On pią, 2014-12-05 at 15:15 +0100, Krzysztof Kozlowski wrote:
>> > Audio subsystem clocks are located in separate block. On Exynos 5420 if
>> > clock for this block (from main clock domain) 'mau_epll' is gated then
>> > any read or write to audss registers will block.
>> > 
>> > This kind of boot hang was observed on Arndale Octa and Peach Pi/Pit
>> > after introducing runtime PM to pl330 DMA driver. After that commit the
>> > 'mau_epll' was gated, because the "amba" clock was disabled and there
>> > were no more users of mau_epll.
>> > 
>> > The system hang on one of steps:
>> > 1. Disabling unused clocks from audss block.
>> > 2. During audss GPIO setup (just before probing i2s0 because
>> >    samsung_pinmux_setup() tried to access memory from audss block which was
>> >    gated.
>> > 
>> > Add a workaround for this by enabling the 'mau_epll' clock in probe.
>> > 
>> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> > ---
>> >  drivers/clk/samsung/clk-exynos-audss.c | 29 ++++++++++++++++++++++++++++-
>> >  1 file changed, 28 insertions(+), 1 deletion(-)
>
> Sorry for pinging so quick but merge window is open and it looks like
> booting Exynos542x boards will be broken (because pl330 will no longer
> hold adma clock enabled so whole audss domain will be gated).
> 
> This is a non-intrusive workaround for that issue, as wanted by
> Sylwester:
> https://lkml.org/lkml/2014/12/5/223
> 
> Any comments on this?

The patch looks OK to me, it would be good though if someone else
has confirmed it fixes the bug. I don't have any clock patches queued
at the moment. Perhaps you could apply it directly, Mike ?

>From my side:

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

-- 
Thanks,
Sylwester

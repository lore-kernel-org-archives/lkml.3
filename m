Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab3KGOTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:19:10 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25791 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3KGOTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:19:05 -0500
X-AuditID: cbfec7f5-b7ef66d00000795a-ad-527ba157a6e1
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: Re: [PATCH] thermal: exynos: handle gate clock for misplaced TRIMINFO
 register
Date: Thu, 07 Nov 2013 15:18:57 +0100
Message-id: <1695605.pk9l7dqkqm@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <1383828154-428-1-git-send-email-ch.naveen@samsung.com>
References: <1383828154-428-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xy7rhC6uDDFYv0LFouBpisXHGelaL
	u88PM1q8PKRpMf/IOVaLNft/Mln0LrjKZnF51xw2i8+9RxgtZpzfx2SxaNt/ZosnD/vYHHg8
	ds66y+6xeM9LJo++LasYPY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfG5HdHmQq+8FV8unqe
	sYFxGU8XIyeHhICJxJ0di1khbDGJC/fWs4HYQgJLGSUOPw/sYuQCsruYJDrv/QMrYhNQk/jc
	8AisSASo+firM+wgRcwCS5kk5i9bxAySEBaIlNiz9yQTiM0ioCrx9dgGsAZeAU2Ju/MPMoLY
	/ALqEu+2PQWrERVwk5j+4yBYL6eAi0TPh0ZmiCucJTbsOcIE0Sso8WPyPRYQm1lAXmLf/qms
	ELaWxPqdx5kmMArOQlI2C0nZLCRlCxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKERMvX
	HYxLj1kdYhTgYFTi4Z1RUxUkxJpYVlyZe4hRgoNZSYTXdl51kBBvSmJlVWpRfnxRaU5q8SFG
	Jg5OqQbGBu3AIE+7zWLrE3emem9quMJY8Ff//4ez7MYis7zSv00X2vNvwhFv450T+HinXT6q
	0BAXPfWMo+x5PzVPMe/1Hd82fFJdeKCC/93+qJutn19pb1DMeqBrVLf5++OYI+4exjKSVvdM
	Dk4Ql2/iMl5vFVtek9uTI313auGs0r/vm/mVGFQzj2xRYinOSDTUYi4qTgQAWTNWPXQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On Thursday 07 of November 2013 18:12:34 Naveen Krishna Chatradhi wrote:
> On Exynos5420 the TMU(4) for GPU has a seperate clock enable bit from
> the other TMU channels(0 ~ 3). Hence, accessing TRIMINFO for base_second
> should be acompanied by enabling the respective clock.
> 
> This patch which allow for a "clk_sec" clock to be specified in the
> device-tree which will be ungated when accessing the TRIMINFO register.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c |   24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)

This patch modifies the device binding, but fails to mention anything
about the modification in respective documentation. Please do not do that.

In addition, since the series adding support for Exynos 5420 has not been
merged yet, I would rather make this patch a part of that series.

Also please see my comment below.

> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> index b54825a..33edd1a 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
[snip]
> @@ -641,6 +650,15 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>  	if (ret)
>  		return ret;
>  
> +	data->clk_sec = devm_clk_get(&pdev->dev, "tmu_apbif_sec");
> +	if (!IS_ERR(data->clk_sec)) {

This code does not check if the clock was specified for TMU channels that
require it, i.e. the driver will not fail if you don't specify this clock.

Instead, it would be better create a separate compatible value for such
channels, like "samsung,exynos5420-tmu-broken-triminfo", for which this
clock would be mandatory and for which, if this clock is not specified,
the driver would fail.

Best regards,
Tomasz


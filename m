Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab3JUJmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:42:43 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17896 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3JUJml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 05:42:41 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-bd-5264f70f02f4
Message-id: <5264F709.2000409@samsung.com>
Date: Mon, 21 Oct 2013 11:42:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] spi/s3c64xx: Fix doubled clock disable on suspend
References: <1382348117-6666-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1382348117-6666-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xK7r831OCDF6/ZrOYtO4Ak8XUh0/Y
	LF6/MLToXXCVzeJs0xt2i02Pr7FaXN41h81ixvl9TBaNH2+yO3B6/F31gtlj06pONo/NS+o9
	+rasYvT4vEkugDWKyyYlNSezLLVI3y6BK+Pj14tsBU94Kk40/mVsYLzA1cXIwSEhYCIxe4lX
	FyMnkCkmceHeerYuRi4OIYGljBKHrj9gh3A+MUrMXrqKFaSKV0BL4vXMnYwgNouAqsT0o0/Y
	QWw2AUOJ3qN9YHFRgTCJo00/oeoFJX5MvscCMkhEYDajxNQ/axhBHGaBzYwSE06dYgOpEhZw
	k/j3dxUjyElCQPbWY9UgYU4Bd4l7Dc/BFjAL6Ejsb53GBmHLS2xe85Z5AqPALCQ7ZiEpm4Wk
	bAEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkLD/soNx8TGrQ4wCHIxKPLwBLilBQqyJ
	ZcWVuYcYJTiYlUR4P38ECvGmJFZWpRblxxeV5qQWH2Jk4uCUamC08+zgv7dQgsfr2YnapPj1
	9ktW3leoai09l9dUJHH7R8xuB47XOz87hJ48VR1strnr0ecM9U7T+9fLTP9fE5YV9Xh2oHRG
	yPuDFlMLRKJilAxNFS4KMzvtdvJb2795Z2va0e+sTzSLjWxtFTedNJm8yT0m/fbXnICzThvU
	EjQ4TC6WvJ/k7KHEUpyRaKjFXFScCADA9LmTWQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/10/13 11:35, Krzysztof Kozlowski wrote:
> Fix doubled clock disable and unprepare during PM suspend which triggered
> the warnings:
[...]
> The clocks are already disabled before suspending.
> 
> Additionally add PM runtime get() and put() during resume so device
> won't sleep for the time of s3c64xx_spi_hwinit().
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/spi/spi-s3c64xx.c |   15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
> index a80376d..374be7d 100644
> --- a/drivers/spi/spi-s3c64xx.c
> +++ b/drivers/spi/spi-s3c64xx.c
> @@ -1482,10 +1482,6 @@ static int s3c64xx_spi_suspend(struct device *dev)
>  
>  	spi_master_suspend(master);
>  
> -	/* Disable the clock */
> -	clk_disable_unprepare(sdd->src_clk);
> -	clk_disable_unprepare(sdd->clk);
> -
>  	sdd->cur_speed = 0; /* Output Clock is stopped */
>  
>  	return 0;
> @@ -1496,16 +1492,19 @@ static int s3c64xx_spi_resume(struct device *dev)
>  	struct spi_master *master = dev_get_drvdata(dev);
>  	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(master);
>  	struct s3c64xx_spi_info *sci = sdd->cntrlr_info;
> +	int ret;
>  
> +	ret = pm_runtime_get_sync(dev);

pm_runtime_{get,put}* must not be called from drivers's system suspend/resume
callbacks. Please use pm_runtime_suspended() to check device runtime PM status
in s3c64xx_spi_{suspend,resume} callbacks and handle the clocks appropriately.

Thanks,
Sylwester

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbaF3SBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:01:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18735 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbaF3SBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:01:22 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-8b-53b1a5ef272a
Message-id: <53B1A5D4.6050904@samsung.com>
Date: Mon, 30 Jun 2014 20:00:52 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>, Wolfram Sang <wsa@the-dreams.de>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, javier.martinez@collabora.co.uk,
        Vincent Palatin <vpalatin@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: s3c2410: resume the I2C controller earlier
References: <1403654214-25072-1-git-send-email-dianders@chromium.org>
In-reply-to: <1403654214-25072-1-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xy7rvl24MNti2n89i0roDTBZnlx1k
	szj6u8Cid8FVNotNj6+xWnT8/cJocXnXHDaLGef3MVms2vWH0WLbtzssFitPzGJ24PaY3XCR
	xePv8+tAYtULZo+ds+6ye2xeUu/Rt2UVo8fJU09YPD5vkgvgiOKySUnNySxLLdK3S+DKmLxg
	MltBA3/FywtLWRsY9/J0MXJwSAiYSKz6mNrFyAlkiklcuLeerYuRi0NIYCmjxMcZx5ggnM+M
	Em0vmlhBqngFtCT61z5nBLFZBFQljnf9ZwOx2QTUJD43PAKz+YFq1jRdZwFZICoQIfH4ghBE
	q6DEj8n3WEBmighMYpTYdmk92AJmgZ+MEpu3nmcGqRIWcJdYs/EHmC0k4CoxufUK2FBOATeJ
	hSc3s4DYzAI6Evtbp7FB2PISm9e8ZZ7AKDgLyZJZSMpmISlbwMi8ilE0tTS5oDgpPddIrzgx
	t7g0L10vOT93EyMkgr7uYFx6zOoQowAHoxIPr8WWDcFCrIllxZW5hxglOJiVRHiPzdsYLMSb
	klhZlVqUH19UmpNafIiRiYNTqoFxcea8Cxsei6Y4nONiEG99vibwan6SF4/bdq+TvkGKVS8c
	uhuZfm0Rn7+LweH3NNO/oYXFDe7b5h6fK2u7be+732L9r0Lu2N/yK+i+0y3DfVZZqvWw46/P
	XjsKuxmb1/2Y/v4K22RD6e5OdsunrVt0I/ZObZWs2SD3gu/J3ukq4uU8bv/1bngrsRRnJBpq
	MRcVJwIALk2WKH4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 25.06.2014 01:56, Doug Anderson wrote:
> From: Vincent Palatin <vpalatin@chromium.org>
> 
> When the wake-up is triggered by the PMIC RTC, the RTC driver is trying
> to read the PMIC interrupt status over I2C and fails because the I2C
> controller is not resumed yet.
> Let's resume the I2C controller earlier in the _noirq phase
> (as other hardwares are doing), so we can properly get the wake-up
> condition.
> 
> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v2:
> - Added missing freeze/thaw/poweroff/restore
> 
>  drivers/i2c/busses/i2c-s3c2410.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
> index e828a1d..ecb389c 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -1267,7 +1267,7 @@ static int s3c24xx_i2c_suspend_noirq(struct device *dev)
>  	return 0;
>  }
>  
> -static int s3c24xx_i2c_resume(struct device *dev)
> +static int s3c24xx_i2c_resume_noirq(struct device *dev)
>  {
>  	struct platform_device *pdev = to_platform_device(dev);
>  	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
> @@ -1285,7 +1285,11 @@ static int s3c24xx_i2c_resume(struct device *dev)
>  static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
>  #ifdef CONFIG_PM_SLEEP
>  	.suspend_noirq = s3c24xx_i2c_suspend_noirq,
> -	.resume = s3c24xx_i2c_resume,
> +	.resume_noirq = s3c24xx_i2c_resume_noirq,
> +	.freeze_noirq = s3c24xx_i2c_suspend_noirq,
> +	.thaw_noirq = s3c24xx_i2c_resume_noirq,
> +	.poweroff_noirq = s3c24xx_i2c_suspend_noirq,
> +	.restore_noirq = s3c24xx_i2c_resume_noirq,
>  #endif
>  };

Also fixes certain issues on Exynos4-based boards.

Acked-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz

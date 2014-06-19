Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbaFSFXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 01:23:55 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:36209 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347AbaFSFXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 01:23:52 -0400
MIME-Version: 1.0
In-Reply-To: <1403153691-15606-1-git-send-email-dianders@chromium.org>
References: <1403153691-15606-1-git-send-email-dianders@chromium.org>
Date: Wed, 18 Jun 2014 22:23:51 -0700
X-Google-Sender-Auth: f0D7aoK864Vls55OwCLmOR7o3hQ
Message-ID: <CAD=FV=U0RAS3pi=i7smGo2rBJ+NfijXhmjX1PUs1rrwKkQewPA@mail.gmail.com>
Subject: Re: [PATCH] i2c: s3c2410: resume the I2C controller earlier
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 18, 2014 at 9:54 PM, Doug Anderson <dianders@chromium.org> wrote:
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
>  drivers/i2c/busses/i2c-s3c2410.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
> index e828a1d..b904132 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -1267,7 +1267,7 @@ static int s3c24xx_i2c_suspend_noirq(struct device *dev)
>         return 0;
>  }
>
> -static int s3c24xx_i2c_resume(struct device *dev)
> +static int s3c24xx_i2c_resume_noirq(struct device *dev)
>  {
>         struct platform_device *pdev = to_platform_device(dev);
>         struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
> @@ -1285,7 +1285,7 @@ static int s3c24xx_i2c_resume(struct device *dev)
>  static const struct dev_pm_ops s3c24xx_i2c_dev_pm_ops = {
>  #ifdef CONFIG_PM_SLEEP
>         .suspend_noirq = s3c24xx_i2c_suspend_noirq,
> -       .resume = s3c24xx_i2c_resume,
> +       .resume_noirq = s3c24xx_i2c_resume_noirq,

I looked at applying this to another i2c controller and stumbled upon
feedback from Wolfram suggesting that I should add "poweroff, thaw,
freeze, restore".  I'm happy to squash that into this patch or send a
separate patch if people would like it.  Just let me know.

-Doug

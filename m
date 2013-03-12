Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3CLGZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:25:44 -0400
Received: from londo.lunn.ch ([80.238.139.98]:57433 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3CLGZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:25:43 -0400
Date: Tue, 12 Mar 2013 07:25:09 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the akpm tree with the arm-soc tree
Message-ID: <20130312062509.GQ21478@lunn.ch>
References: <20130312144714.39749c5b0bd1aea14c4d2ff8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312144714.39749c5b0bd1aea14c4d2ff8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 02:47:14PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> drivers/rtc/rtc-mv.c between commit 89c58c198b25 ("rtc: rtc-mv: Add
> support for clk to avoid lockups") from the arm-soc tree and commit "rtc:
> rtc-mv: use devm_rtc_device_register()" from the akpm tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).

Hi Stephan

Looks O.K. to me.

Acked-by: Andrew Lunn <andrew@lunn.ch>

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/rtc/rtc-mv.c
> index f378e17,1ee8551..0000000
> --- a/drivers/rtc/rtc-mv.c
> +++ b/drivers/rtc/rtc-mv.c
> @@@ -272,16 -262,15 +272,17 @@@ static int __init mv_rtc_probe(struct p
>   
>   	if (pdata->irq >= 0) {
>   		device_init_wakeup(&pdev->dev, 1);
> - 		pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
> + 		pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
>   						 &mv_rtc_alarm_ops,
>   						 THIS_MODULE);
> - 	} else
> - 		pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
> + 	} else {
> + 		pdata->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
>   						 &mv_rtc_ops, THIS_MODULE);
> + 	}
>  -	if (IS_ERR(pdata->rtc))
>  -		return PTR_ERR(pdata->rtc);
>  +	if (IS_ERR(pdata->rtc)) {
>  +		ret = PTR_ERR(pdata->rtc);
>  +		goto out;
>  +	}
>   
>   	if (pdata->irq >= 0) {
>   		writel(0, pdata->ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
> @@@ -308,10 -292,6 +309,9 @@@ static int __exit mv_rtc_remove(struct 
>   	if (pdata->irq >= 0)
>   		device_init_wakeup(&pdev->dev, 0);
>   
> - 	rtc_device_unregister(pdata->rtc);
>  +	if (!IS_ERR(pdata->clk))
>  +		clk_disable_unprepare(pdata->clk);
>  +
>   	return 0;
>   }
>   



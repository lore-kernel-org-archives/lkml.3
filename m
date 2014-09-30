Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaI3NAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:00:44 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:35954 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbaI3NAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:00:42 -0400
Message-ID: <542AA96A.4070303@st.com>
Date: Tue, 30 Sep 2014 15:00:26 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <hliang1025@gmail.com>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <adi-linux-docs@lists.sourceforge.net>
Subject: Re: [PATCH] net: ethernet : stmicro: fixed power suspend and resume
 failure in stmmac driver
References: <1412056534-7995-1-git-send-email-hliang1025@gmail.com>
In-Reply-To: <1412056534-7995-1-git-send-email-hliang1025@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.138.72]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-30_05:2014-09-30,2014-09-30,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hao Liang

On 9/30/2014 7:55 AM, hliang1025@gmail.com wrote:
> From: Hao Liang <hliang1025@gmail.com>
>
> This is the fix for a power management issue caused by suspend and resume function in stmmac_main.c.
> After enable CONFIG_DEBUG_ATOMIC_SLEEP which enable sleep-inside atomic section checking, power
> managemet can not work normally. Board couldn't wakeup successfully after suspend. Command
> "echo mem > /sys/power/state" suspend the board.
>
> In suspend and resume function of stmmac driver, there are some sleep-inside function in atomic section
> created by spin lock. These functions will causes system warnings and wakeup issue when enable
> CONFIG_DEBUG_ATOMIC_SLEEP.
>
> This bug was fixed by:
> * replace some sleep function with non-sleep function
>    clk_disable_unprepare -> clk_disable ...
> * decrease the atomic area created by spin lock function. The original atomic area in resume function is
> too large.

I had done something in this patch:
    [PATCH (net.git)] stmmac: fix and review whole driver locking

Indeed I was not able to review it after some advice but I will do it!

So we can review your patch and then I will re-base my work on top of
yours.

I just wonder if the spinlock can be safely removed instead of
surrounding just the code to clear the descriptors that should
not be claimed by others. Maybe the only part shared is the
stmmac_hw_setup that can be invoked by open method.

peppe

> Signed-off-by: Hao Liang <hliang1025@gmail.com>
> ---
>   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 6e6ee22..2effbfe 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -2924,9 +2924,8 @@ int stmmac_suspend(struct net_device *ndev)
>   	if (priv->phydev)
>   		phy_stop(priv->phydev);
>
> -	spin_lock_irqsave(&priv->lock, flags);
> -
>   	netif_device_detach(ndev);
> +
>   	netif_stop_queue(ndev);
>
>   	napi_disable(&priv->napi);
> @@ -2935,6 +2934,8 @@ int stmmac_suspend(struct net_device *ndev)
>   	priv->hw->dma->stop_tx(priv->ioaddr);
>   	priv->hw->dma->stop_rx(priv->ioaddr);
>
> +	spin_lock_irqsave(&priv->lock, flags);
> +
>   	stmmac_clear_descriptors(priv);
>
>   	/* Enable Power down mode by programming the PMT regs */
> @@ -2945,7 +2946,7 @@ int stmmac_suspend(struct net_device *ndev)
>   		stmmac_set_mac(priv->ioaddr, false);
>   		pinctrl_pm_select_sleep_state(priv->device);
>   		/* Disable clock in case of PWM is off */
> -		clk_disable_unprepare(priv->stmmac_clk);
> +		clk_disable(priv->stmmac_clk);
>   	}
>   	spin_unlock_irqrestore(&priv->lock, flags);
>
> @@ -2977,12 +2978,14 @@ int stmmac_resume(struct net_device *ndev)
>   	} else {
>   		pinctrl_pm_select_default_state(priv->device);
>   		/* enable the clk prevously disabled */
> -		clk_prepare_enable(priv->stmmac_clk);
> +		clk_enable(priv->stmmac_clk);
>   		/* reset the phy so that it's ready */
>   		if (priv->mii)
>   			stmmac_mdio_reset(priv->mii);
>   	}
>
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
>   	netif_device_attach(ndev);
>
>   	stmmac_hw_setup(ndev);
> @@ -2991,8 +2994,6 @@ int stmmac_resume(struct net_device *ndev)
>
>   	netif_start_queue(ndev);
>
> -	spin_unlock_irqrestore(&priv->lock, flags);
> -
>   	if (priv->phydev)
>   		phy_start(priv->phydev);
>
>


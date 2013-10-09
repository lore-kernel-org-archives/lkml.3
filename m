Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3JIP2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 11:28:31 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:58441 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108Ab3JIP23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 11:28:29 -0400
Message-ID: <52557606.8030201@st.com>
Date: Wed, 9 Oct 2013 17:28:06 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
Cc: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Romain Baeriswyl <romainba@abilis.com>
Subject: Re: [RFC] net: stmmac: keep RXC running in LPI mode to avoid system
 overload
References: <1381244795-3922-1-git-send-email-romainba@abilis.com>
In-Reply-To: <1381244795-3922-1-git-send-email-romainba@abilis.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.138.186]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Romain

On 10/8/2013 5:06 PM, Romain Baeriswyl wrote:
> In order to avoid system overload, the clock RXC from the Phy should not be
> stopped when in LPI mode.
>
> With the RTL8211E PHY which support EEE mode and with Apple Airport Extreme that
> supports it also, the kernel get frozen as soon as some Ethernet transfers are


hmm, I have a board with this transceiver so I could do some tests
this could take a while, unfortunately.

> on-going. System seems to be overloaded with too many interrupts. The 'top'
> command reports often around ~80% irq.

do you mean lpi mac interrupts?

>
> By letting the RXC clock running even in LPI mode as proposed below, the issue
> seems solved. Is it the right way to proceed?

For EEE capability, RX_CLK may be halted for this reason i used it as 
default in the stmmac and never seen your issue.

>
> What is the power impact to not stop RXC in LPI mode?

I can point you to "22.2.2.8a Receive direction LPI transition"
in IEEE802-3az... where is it reported that the PHY  halt the RX_CLK
in LPI mode.

May I suspect some issues on your HW? or disable it with ethtool


peppe

>
> ---
>   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    6 ++++--
>   1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index e9eab29..d40d26b 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -314,7 +314,8 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
>   	/* MAC core supports the EEE feature. */
>   	if (priv->dma_cap.eee) {
>   		/* Check if the PHY supports EEE */
> -		if (phy_init_eee(priv->phydev, 1))
> +		/* Keeps RXC running in LPI mode to avoid stability issue */
> +		if (phy_init_eee(priv->phydev, 0))
>   			goto out;
>
>   		if (!priv->eee_active) {
> @@ -770,7 +771,8 @@ static void stmmac_adjust_link(struct net_device *dev)
>   	/* At this stage, it could be needed to setup the EEE or adjust some
>   	 * MAC related HW registers.
>   	 */
> -	priv->eee_enabled = stmmac_eee_init(priv);
> +	if (new_state)
> +		priv->eee_enabled = stmmac_eee_init(priv);

this seems out of context and not necessary

>
>   	spin_unlock_irqrestore(&priv->lock, flags);
>   }
>


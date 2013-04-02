Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761883Ab3DBVXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 17:23:00 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36120 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760045Ab3DBVW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 17:22:59 -0400
Message-ID: <515B4BE3.7060606@cogentembedded.com>
Date: Wed, 03 Apr 2013 01:21:39 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alan Ott <alan@signal11.us>
CC: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] mac802154: Use netif flow control
References: <1364928481-1813-1-git-send-email-alan@signal11.us> <1364928481-1813-4-git-send-email-alan@signal11.us>
In-Reply-To: <1364928481-1813-4-git-send-email-alan@signal11.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04/02/2013 10:47 PM, Alan Ott wrote:

> Use netif_stop_queue() and netif_wake_queue() to control the flow of
> packets to mac802154 devices.  Since many IEEE 802.15.4 devices have no
> output buffer, and since the mac802154 xmit() function is designed to
> block, netif_stop_queue() is called after each packet.
>
> Signed-off-by: Alan Ott <alan@signal11.us>
> ---
>   net/mac802154/tx.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
>
> diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> index a248246..fe3e02c 100644
> --- a/net/mac802154/tx.c
> +++ b/net/mac802154/tx.c
[...]
> @@ -71,6 +73,12 @@ static void mac802154_xmit_worker(struct work_struct *work)
>   out:
>   	mutex_unlock(&xw->priv->phy->pib_lock);
>   
> +	/* Restart the netif queue on each sub_if_data object. */
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(sdata, &xw->priv->slaves, list) {
> +		netif_wake_queue(sdata->dev);
> +	}


    Are {} really necessary here?

> @@ -108,6 +117,13 @@ netdev_tx_t mac802154_tx(struct mac802154_priv *priv, struct sk_buff *skb,
>   		return NETDEV_TX_BUSY;
>   	}
>   
> +	/* Stop the netif queue on each sub_if_data object. */
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(sdata, &priv->slaves, list) {
> +		netif_stop_queue(sdata->dev);
> +	}

    And here?

WBR, Sergei


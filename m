Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbaCJUcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:32:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47241 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaCJUcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:32:02 -0400
Date: Mon, 10 Mar 2014 16:31:59 -0400 (EDT)
Message-Id: <20140310.163159.2226500192198218961.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: add skb_cow_head
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394432551-4856-1-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
	<1394432551-4856-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Mar 2014 13:32:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 10 Mar 2014 14:22:31 +0800

> Call skb_cow_head() before editing the tx packet header. The header
> would be reallocated if it is shared.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index c7ef30d..faad39b 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -1376,6 +1376,11 @@ static int msdn_giant_send_check(struct sk_buff *skb)
>  {
>  	const struct ipv6hdr *ipv6h;
>  	struct tcphdr *th;
> +	int ret;
> +
> +	ret = skb_cow_head(skb, 0);
> +	if (ret)
> +		goto out1;
>  
>  	ipv6h = ipv6_hdr(skb);
>  	th = tcp_hdr(skb);
> @@ -1383,7 +1388,8 @@ static int msdn_giant_send_check(struct sk_buff *skb)
>  	th->check = 0;
>  	th->check = ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
>  
> -	return 0;
> +out1:
> +	return ret;
>  }
>  
>  static int r8152_tx_csum(struct r8152 *tp, struct tx_desc *desc,

Please just return directly instead of "goto out1".  There are no other
operations or pieces of state to undo if you fail at the beginning of
the function, and the label furthermore will have only one user, so
it seems completely unnecessary.  A simple "return ret" will work just
fine.

Thanks.

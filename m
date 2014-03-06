Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbaCFTa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:30:56 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60122 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaCFTaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:30:55 -0500
Date: Thu, 06 Mar 2014 14:30:52 -0500 (EST)
Message-Id: <20140306.143052.1684426326912194946.davem@davemloft.net>
To: kys@microsoft.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 2/6] Drivers: net: hyperv: Cleanup the send path
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394104390-23477-2-git-send-email-kys@microsoft.com>
References: <1394104358-23438-1-git-send-email-kys@microsoft.com>
	<1394104390-23477-1-git-send-email-kys@microsoft.com>
	<1394104390-23477-2-git-send-email-kys@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Mar 2014 11:30:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Thu,  6 Mar 2014 03:13:06 -0800

> In preparation for enabling offloads, cleanup the send path.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/hyperv/hyperv_net.h   |    7 +---
>  drivers/net/hyperv/netvsc_drv.c   |   87 +++++++++++++++++++++++++++++-------
>  drivers/net/hyperv/rndis_filter.c |   66 ----------------------------
>  3 files changed, 71 insertions(+), 89 deletions(-)
> 
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
> index 39fc230..694bf7c 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -73,7 +73,7 @@ struct hv_netvsc_packet {
>  	} completion;
>  
>  	/* This points to the memory after page_buf */
> -	void *extension;
> +	struct rndis_message *rndis_msg;
>  
>  	u32 total_data_buflen;
>  	/* Points to the send/receive buffer where the ethernet frame is */
> @@ -126,11 +126,6 @@ void rndis_filter_device_remove(struct hv_device *dev);
>  int rndis_filter_receive(struct hv_device *dev,
>  			struct hv_netvsc_packet *pkt);
>  
> -
> -
> -int rndis_filter_send(struct hv_device *dev,
> -			struct hv_netvsc_packet *pkt);
> -
>  int rndis_filter_set_packet_filter(struct rndis_device *dev, u32 new_filter);
>  int rndis_filter_set_device_mac(struct hv_device *hdev, char *mac);
>  
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index afa9c53..e812529 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -128,6 +128,28 @@ static int netvsc_close(struct net_device *net)
>  	return ret;
>  }
>  
> +
> +static void *init_ppi_data(struct rndis_message *msg, u32 ppi_size,

One empty line between functions is sufficient.

> @@ -173,7 +195,7 @@ static u32 fill_pg_buf(struct page *page, u32 offset, u32 len,
>  	return j + 1;
>  }
>  
> -static void init_page_array(void *hdr, u32 len, struct sk_buff *skb,
> +static u32 init_page_array(void *hdr, u32 len, struct sk_buff *skb,
>  				struct hv_page_buffer *pb)

When you adjust where the openning parenthesis occurs in a function
definition or call, you must adjust the indentation of arguments that
occur on the following lines.

In particular, such arguments must start at exactly the first column
after the openning parenthesis.  You must use the appropriate number
of TAB and space characters necessary to achieve this.

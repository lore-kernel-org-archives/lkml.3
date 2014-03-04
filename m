Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbaCDDKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 22:10:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021AbaCDDKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 22:10:32 -0500
Message-ID: <531543FD.7090907@redhat.com>
Date: Tue, 04 Mar 2014 11:09:49 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Haiyang Zhang <haiyangz@microsoft.com>, davem@davemloft.net,
        netdev@vger.kernel.org
CC: kys@microsoft.com, olaf@aepfle.de, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next] hyperv: Move state setting for link query
References: <1393890875-1420-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1393890875-1420-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 07:54 AM, Haiyang Zhang wrote:
> It moves the state setting for query into rndis_filter_receive_response().
> All callbacks including query-complete and status-callback are synchronized
> by channel->inbound_lock. This prevents pentential race between them.

This still looks racy to me. The problem is workqueue is not
synchronized with those here.

Consider the following case in netvsc_link_change():

    if (rdev->link_state) {
    ... receive interrupt ...
    rndis_filter_receice_response() which changes rdev->link_state
    ...
        netif_carrier_off()
    }

And also it need to schedule a work otherwise the link status is out of
sync.
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/hyperv/rndis_filter.c |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
> index f0cc8ef..6a9f602 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -240,6 +240,22 @@ static int rndis_filter_send_request(struct rndis_device *dev,
>  	return ret;
>  }
>  
> +static void rndis_set_link_state(struct rndis_device *rdev,
> +				 struct rndis_request *request)
> +{
> +	u32 link_status;
> +	struct rndis_query_complete *query_complete;
> +
> +	query_complete = &request->response_msg.msg.query_complete;
> +
> +	if (query_complete->status == RNDIS_STATUS_SUCCESS &&
> +	    query_complete->info_buflen == sizeof(u32)) {
> +		memcpy(&link_status, (void *)((unsigned long)query_complete +
> +		       query_complete->info_buf_offset), sizeof(u32));
> +		rdev->link_state = link_status != 0;
> +	}
> +}
> +
>  static void rndis_filter_receive_response(struct rndis_device *dev,
>  				       struct rndis_message *resp)
>  {
> @@ -269,6 +285,10 @@ static void rndis_filter_receive_response(struct rndis_device *dev,
>  		    sizeof(struct rndis_message) + RNDIS_EXT_LEN) {
>  			memcpy(&request->response_msg, resp,
>  			       resp->msg_len);
> +			if (request->request_msg.ndis_msg_type ==
> +			    RNDIS_MSG_QUERY && request->request_msg.msg.
> +			    query_req.oid == RNDIS_OID_GEN_MEDIA_CONNECT_STATUS)
> +				rndis_set_link_state(dev, request);
>  		} else {
>  			netdev_err(ndev,
>  				"rndis response buffer overflow "
> @@ -617,7 +637,6 @@ static int rndis_filter_query_device_link_status(struct rndis_device *dev)
>  	ret = rndis_filter_query_device(dev,
>  				      RNDIS_OID_GEN_MEDIA_CONNECT_STATUS,
>  				      &link_status, &size);
> -	dev->link_state = (link_status != 0) ? true : false;
>  
>  	return ret;
>  }


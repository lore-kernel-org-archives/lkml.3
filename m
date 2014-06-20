Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966240AbaFTImH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:42:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38136 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965748AbaFTImC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:42:02 -0400
Date: Fri, 20 Jun 2014 11:41:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, olaf@aepfle.de,
        jasowang@redhat.com, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Message-ID: <20140620084158.GR5500@mwanda>
References: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 06:34:36PM -0700, Haiyang Zhang wrote:
> @@ -589,7 +590,19 @@ void netvsc_linkstatus_callback(struct hv_device *device_obj,
>  	net_device = hv_get_drvdata(device_obj);
>  	rdev = net_device->extension;
>  
> -	rdev->link_state = status != 1;
> +	switch (indicate->status) {
> +	case RNDIS_STATUS_MEDIA_CONNECT:
> +		rdev->link_state = false;

link_state false means that we want to connect?

> +		break;
> +	case RNDIS_STATUS_MEDIA_DISCONNECT:
> +		rdev->link_state = true;

link_state true means that we are disconnecting.

> +		break;
> +	case RNDIS_STATUS_NETWORK_CHANGE:
> +		rdev->link_change = true;
> +		break;
> +	default:
> +		return;
> +	}
>  
>  	net = net_device->ndev;
>  
> @@ -597,7 +610,7 @@ void netvsc_linkstatus_callback(struct hv_device *device_obj,

> @@ -782,10 +797,17 @@ static void netvsc_link_change(struct work_struct *w)
>  	} else {
>  		netif_carrier_on(net);
>  		notify = true;
> +		if (rdev->link_change) {
> +			rdev->link_change = false;
> +			refresh = true;
> +		}

How do we know that we received a RNDIS_STATUS_MEDIA_CONNECT before we
received the RNDIS_STATUS_NETWORK_CHANGE?  In other words, why does
RNDIS_STATUS_NETWORK_CHANGE imply that the link_state is false?

>  	}
>  
>  	rtnl_unlock();
>  
> +	if (refresh)
> +		call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);

You may as well use UMH_NO_WAIT since there is no error handling if
/etc/init.d/network is not found.

regards,
dan carpenter

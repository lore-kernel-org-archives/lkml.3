Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbaKTI5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:57:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbaKTI5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:57:33 -0500
Message-ID: <546DACEC.1070200@redhat.com>
Date: Thu, 20 Nov 2014 16:57:16 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH v4 net] virtio-net: validate features during probe
References: <1416472043-9875-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1416472043-9875-1-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 04:27 PM, Jason Wang wrote:
> We currently trigger BUG when VIRTIO_NET_F_CTRL_VQ
> is not set but one of features depending on it is.
> That's not a friendly way to report errors to
> hypervisors.
> Let's check, and fail probe instead.
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
> Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes from V1:
> - Drop NETIF_F_*_UFO from checklist
> Changes from V2:
> - only check the features for ctrl vq (this fix the real bug)
> - better error message and simplify API
> Changes from V3:
> - pass dbit directly and even better error message
> - typo fix
> ---
>  drivers/net/virtio_net.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ec2a8b4..cc53ff1 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1673,6 +1673,40 @@ static const struct attribute_group virtio_net_mrg_rx_group = {
>  };
>  #endif
>  
> +static bool virtnet_fail_on_feature(struct virtio_device *vdev,
> +				    unsigned int fbit,
> +				    const char *fname, const char *dname)
> +{
> +	if (!virtio_has_feature(vdev, fbit))
> +		return false;
> +
> +	dev_err(&vdev->dev, "advertise feature %s but not %s",
> +		fname, dname);
> +
> +	return true;
> +}
> +

Michael suggest adding "device" before "advertise", will post V5

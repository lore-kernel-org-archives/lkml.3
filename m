Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab3FFLEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:04:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932567Ab3FFLEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:04:47 -0400
Date: Thu, 6 Jun 2013 14:05:15 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [net-next PATCH 4/8] macvtap: introduce macvtap_get_vlan()
Message-ID: <20130606110515.GC8626@redhat.com>
References: <1370512480-14272-1-git-send-email-jasowang@redhat.com>
 <1370512480-14272-5-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370512480-14272-5-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 05:54:36PM +0800, Jason Wang wrote:
> Factor out the device holding logic to a macvtap_get_vlan(), this will be also
> used by multiqueue API.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/macvtap.c |   27 ++++++++++++++++++++-------
>  1 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index 8949631..d18130b 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -893,6 +893,24 @@ out:
>  	return ret;
>  }
>  
> +static struct macvlan_dev *macvtap_get_vlan(struct macvtap_queue *q)
> +{
> +	struct macvlan_dev *vlan;
> +
> +	rcu_read_lock_bh();
> +	vlan = rcu_dereference_bh(q->vlan);
> +	if (vlan)
> +		dev_hold(vlan->dev);
> +	rcu_read_unlock_bh();
> +
> +	return vlan;
> +}
> +
> +static void macvtap_put_vlan(struct macvlan_dev *vlan)
> +{
> +	dev_put(vlan->dev);
> +}
> +
>  /*
>   * provide compatibility with generic tun/tap interface
>   */
> @@ -924,12 +942,7 @@ static long macvtap_ioctl(struct file *file, unsigned int cmd,
>  		return ret;
>  
>  	case TUNGETIFF:
> -		rcu_read_lock_bh();
> -		vlan = rcu_dereference_bh(q->vlan);
> -		if (vlan)
> -			dev_hold(vlan->dev);
> -		rcu_read_unlock_bh();
> -
> +		vlan = macvtap_get_vlan(q);
>  		if (!vlan)
>  			return -ENOLINK;
>  
> @@ -937,7 +950,7 @@ static long macvtap_ioctl(struct file *file, unsigned int cmd,
>  		if (copy_to_user(&ifr->ifr_name, vlan->dev->name, IFNAMSIZ) ||
>  		    put_user(q->flags, &ifr->ifr_flags))
>  			ret = -EFAULT;
> -		dev_put(vlan->dev);
> +		macvtap_put_vlan(vlan);
>  		return ret;
>  
>  	case TUNGETFEATURES:
> -- 
> 1.7.1

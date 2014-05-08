Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaEHJNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:13:11 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33813 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbaEHJNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:13:08 -0400
X-Sasl-enc: xS+dqp3fcJSgBq0Ha0AUkZ+7tdBh+r4EcvSl5TF4F//S 1399540387
Date: Thu, 8 May 2014 02:13:04 -0700
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, olaf@aepfle.de,
        jasowang@redhat.com, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] Add support for netvsc build without
 CONFIG_SYSFS flag
Message-ID: <20140508091304.GB24820@kroah.com>
References: <1399502704-18495-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399502704-18495-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 03:45:04PM -0700, Haiyang Zhang wrote:
> This change ensures the driver can be built successfully without the
> CONFIG_SYSFS flag.
> MS-TFS: 182270
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/net/hyperv/hyperv_net.h   |    2 ++
>  drivers/net/hyperv/netvsc_drv.c   |   12 +++++++++++-
>  drivers/net/hyperv/rndis_filter.c |    4 ++--
>  3 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
> index 4b7df5a..23b96bc 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -87,6 +87,8 @@ struct ndis_recv_scale_cap { /* NDIS_RECEIVE_SCALE_CAPABILITIES */
>  #define HASH_KEYLEN NDIS_RSS_HASH_SECRET_KEY_MAX_SIZE_REVISION_2
>  extern u8 netvsc_hash_key[];
>  
> +extern unsigned int netvsc_num_queue;
> +
>  struct ndis_recv_scale_param { /* NDIS_RECEIVE_SCALE_PARAMETERS */
>  	struct ndis_obj_header hdr;
>  
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index 939e3af..07896f3 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -52,6 +52,8 @@ static int ring_size = 128;
>  module_param(ring_size, int, S_IRUGO);
>  MODULE_PARM_DESC(ring_size, "Ring buffer size (# of pages)");
>  
> +unsigned int netvsc_num_queue = 1;
> +
>  static void do_set_multicast(struct work_struct *w)
>  {
>  	struct net_device_context *ndevctx =
> @@ -639,9 +641,11 @@ int netvsc_recv_callback(struct hv_device *device_obj,
>  		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
>  				       packet->vlan_tci);
>  
> +#ifdef CONFIG_SYSFS
>  	skb_record_rx_queue(skb, packet->channel->
>  			    offermsg.offer.sub_channel_index %
>  			    net->real_num_rx_queues);
> +#endif

Why is this a sysfs-only function?  It should have nothing to do with
sysfs, right?  So why would the driver care?

Don't put #ifdef in drivers, it's unmaintainable over time, if this
really is a sysfs-only function, this should already be handled
automatically in a .h file somewhere.

thanks,

greg k-h

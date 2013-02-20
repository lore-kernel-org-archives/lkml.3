Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935099Ab3BTLLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:11:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:47997 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934918Ab3BTLLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:11:23 -0500
X-IronPort-AV: E=Sophos;i="4.84,701,1355068800"; 
   d="scan'208";a="6736120"
Message-ID: <5124A157.5070800@cn.fujitsu.com>
Date: Wed, 20 Feb 2013 18:11:35 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 10/16] virtio_net: use virtqueue_add_sgs[] for command
 buffers.
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au> <1361260594-601-11-git-send-email-rusty@rustcorp.com.au>
In-Reply-To: <1361260594-601-11-git-send-email-rusty@rustcorp.com.au>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 18:11:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 18:12:45,
	Serialize complete at 2013/02/20 18:12:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 03:56 PM, Rusty Russell wrote:
> It's a bit cleaner to hand multiple sgs, rather than one big one.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/net/virtio_net.c |   50 ++++++++++++++++++++++------------------------
>  1 file changed, 24 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8ca69c0..63ac5c1 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -39,7 +39,6 @@ module_param(gso, bool, 0444);
>  #define MAX_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
>  #define GOOD_COPY_LEN	128
>  
> -#define VIRTNET_SEND_COMMAND_SG_MAX    2
>  #define VIRTNET_DRIVER_VERSION "1.0.0"
>  
>  struct virtnet_stats {
> @@ -831,32 +830,32 @@ static void virtnet_netpoll(struct net_device *dev)
>   * never fail unless improperly formated.
>   */
>  static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
> -				 struct scatterlist *data, int out, int in)
> +				 struct scatterlist *out,
> +				 struct scatterlist *in)
>  {
> -	struct scatterlist *s, sg[VIRTNET_SEND_COMMAND_SG_MAX + 2];
> +	struct scatterlist *sgs[4], hdr, stat;
>  	struct virtio_net_ctrl_hdr ctrl;
>  	virtio_net_ctrl_ack status = ~0;
> -	unsigned int tmp;
> -	int i;
> +	unsigned out_num = 0, in_num = 0, tmp;
>  
>  	/* Caller should know better */
> -	BUG_ON(!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ) ||
> -		(out + in > VIRTNET_SEND_COMMAND_SG_MAX));
> -
> -	out++; /* Add header */
> -	in++; /* Add return status */
> +	BUG_ON(!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ));
>  
> -	ctrl.class = class;
> -	ctrl.cmd = cmd;

The class and cmd assignment of ctrl header is forgotten?

Thanks,
Wanlong Gao

> +	/* Add header */
> +	sg_init_one(&hdr, &ctrl, sizeof(ctrl));
> +	sgs[out_num++] = &hdr;
>  
> -	sg_init_table(sg, out + in);
> +	if (out)
> +		sgs[out_num++] = out;
> +	if (in)
> +		sgs[out_num + in_num++] = in;
>  
> -	sg_set_buf(&sg[0], &ctrl, sizeof(ctrl));
> -	for_each_sg(data, s, out + in - 2, i)
> -		sg_set_buf(&sg[i + 1], sg_virt(s), s->length);
> -	sg_set_buf(&sg[out + in - 1], &status, sizeof(status));
> +	/* Add return status. */
> +	sg_init_one(&stat, &status, sizeof(status));
> +	sgs[out_num + in_num++] = &hdr;
>  
> -	BUG_ON(virtqueue_add_buf(vi->cvq, sg, out, in, vi, GFP_ATOMIC) < 0);
> +	BUG_ON(virtqueue_add_sgs(vi->cvq, sgs, out_num, in_num, vi, GFP_ATOMIC)
> +	       < 0);
>  
>  	virtqueue_kick(vi->cvq);
>  
> @@ -874,8 +873,7 @@ static void virtnet_ack_link_announce(struct virtnet_info *vi)
>  {
>  	rtnl_lock();
>  	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_ANNOUNCE,
> -				  VIRTIO_NET_CTRL_ANNOUNCE_ACK, NULL,
> -				  0, 0))
> +				  VIRTIO_NET_CTRL_ANNOUNCE_ACK, NULL, NULL))
>  		dev_warn(&vi->dev->dev, "Failed to ack link announce.\n");
>  	rtnl_unlock();
>  }
> @@ -893,7 +891,7 @@ static int virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
>  	sg_init_one(&sg, &s, sizeof(s));
>  
>  	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
> -				  VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET, &sg, 1, 0)){
> +				  VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET, &sg, NULL)) {
>  		dev_warn(&dev->dev, "Fail to set num of queue pairs to %d\n",
>  			 queue_pairs);
>  		return -EINVAL;
> @@ -940,7 +938,7 @@ static void virtnet_set_rx_mode(struct net_device *dev)
>  
>  	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_RX,
>  				  VIRTIO_NET_CTRL_RX_PROMISC,
> -				  sg, 1, 0))
> +				  sg, NULL))
>  		dev_warn(&dev->dev, "Failed to %sable promisc mode.\n",
>  			 promisc ? "en" : "dis");
>  
> @@ -948,7 +946,7 @@ static void virtnet_set_rx_mode(struct net_device *dev)
>  
>  	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_RX,
>  				  VIRTIO_NET_CTRL_RX_ALLMULTI,
> -				  sg, 1, 0))
> +				  sg, NULL))
>  		dev_warn(&dev->dev, "Failed to %sable allmulti mode.\n",
>  			 allmulti ? "en" : "dis");
>  
> @@ -987,7 +985,7 @@ static void virtnet_set_rx_mode(struct net_device *dev)
>  
>  	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
>  				  VIRTIO_NET_CTRL_MAC_TABLE_SET,
> -				  sg, 2, 0))
> +				  sg, NULL))
>  		dev_warn(&dev->dev, "Failed to set MAC fitler table.\n");
>  
>  	kfree(buf);
> @@ -1001,7 +999,7 @@ static int virtnet_vlan_rx_add_vid(struct net_device *dev, u16 vid)
>  	sg_init_one(&sg, &vid, sizeof(vid));
>  
>  	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_VLAN,
> -				  VIRTIO_NET_CTRL_VLAN_ADD, &sg, 1, 0))
> +				  VIRTIO_NET_CTRL_VLAN_ADD, &sg, NULL))
>  		dev_warn(&dev->dev, "Failed to add VLAN ID %d.\n", vid);
>  	return 0;
>  }
> @@ -1014,7 +1012,7 @@ static int virtnet_vlan_rx_kill_vid(struct net_device *dev, u16 vid)
>  	sg_init_one(&sg, &vid, sizeof(vid));
>  
>  	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_VLAN,
> -				  VIRTIO_NET_CTRL_VLAN_DEL, &sg, 1, 0))
> +				  VIRTIO_NET_CTRL_VLAN_DEL, &sg, NULL))
>  		dev_warn(&dev->dev, "Failed to kill VLAN ID %d.\n", vid);
>  	return 0;
>  }
> 


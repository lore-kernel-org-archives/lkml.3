Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaKSIy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:54:59 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:60104 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaKSIy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:54:58 -0500
Date: Wed, 19 Nov 2014 09:54:45 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V2 net] virtio-net: validate features during probe
Message-ID: <20141119095445.32d94d5d.cornelia.huck@de.ibm.com>
In-Reply-To: <1416381689-2025-1-git-send-email-jasowang@redhat.com>
References: <1416381689-2025-1-git-send-email-jasowang@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111908-0013-0000-0000-000001E7D3BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014 15:21:29 +0800
Jason Wang <jasowang@redhat.com> wrote:

> This patch validates feature dependencies during probe and fail the probing
> if a dependency is missed. This fixes the issues of hitting BUG()
> when qemu fails to advertise features correctly. One example is booting
> guest with ctrl_vq=off through qemu.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
> Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes from V1:
> - Drop VIRTIO_NET_F_*_UFO from the checklist, since it was disabled
> ---
>  drivers/net/virtio_net.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 91 insertions(+)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ec2a8b4..b16a761 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1673,6 +1673,93 @@ static const struct attribute_group virtio_net_mrg_rx_group = {
>  };
>  #endif
> 
> +static int virtnet_validate_features(struct virtio_device *dev,
> +				     unsigned int *table,
> +				     int table_size,
> +				     unsigned int feature)
> +{
> +	int i;
> +
> +	if (!virtio_has_feature(dev, feature)) {

Do an early return, get rid of one indentation level?

> +		for (i = 0; i < table_size; i++) {
> +			unsigned int f = table[i];
> +
> +			if (virtio_has_feature(dev, f)) {
> +				dev_err(&dev->dev,
> +					"buggy hyperviser: feature 0x%x was advertised but its dependency 0x%x was not",

s/hyperviser/hypervisor/ (also below)

> +					f, feature);
> +				return -EINVAL;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int virtnet_check_features(struct virtio_device *dev)
> +{
> +	unsigned int features_for_ctrl_vq[] = {
> +		VIRTIO_NET_F_CTRL_RX,
> +		VIRTIO_NET_F_CTRL_VLAN,
> +		VIRTIO_NET_F_GUEST_ANNOUNCE,
> +		VIRTIO_NET_F_MQ,
> +		VIRTIO_NET_F_CTRL_MAC_ADDR
> +	};
> +	unsigned int features_for_guest_csum[] = {
> +		VIRTIO_NET_F_GUEST_TSO4,
> +		VIRTIO_NET_F_GUEST_TSO6,
> +		VIRTIO_NET_F_GUEST_ECN,
> +	};
> +	unsigned int features_for_host_csum[] = {
> +		VIRTIO_NET_F_HOST_TSO4,
> +		VIRTIO_NET_F_HOST_TSO6,
> +		VIRTIO_NET_F_HOST_ECN,
> +	};

I'm wondering whether it would be easier to read if you listed all
prereqs per feature instead of all features that depend on a feature?
It would still be hard to express the v4/v6 or conditions below in
tables, though.

Or call the arrays features_depending_on_foo?

> +	int err;
> +
> +	err = virtnet_validate_features(dev, features_for_ctrl_vq,
> +					ARRAY_SIZE(features_for_ctrl_vq),
> +					VIRTIO_NET_F_CTRL_VQ);
> +	if (err)
> +		return err;

If you already print a message that a user may use to fix their
hypervisor (or bug someone about it), would it make sense to check all
dependencies and print a full list of everything that is broken in the
advertised feature bits? I usually hate it if I fix one thing only to
hit the next bug when the program could have already told me about
everything I need to fix :)

> +
> +	err = virtnet_validate_features(dev, features_for_guest_csum,
> +					ARRAY_SIZE(features_for_guest_csum),
> +					VIRTIO_NET_F_GUEST_CSUM);
> +	if (err)
> +		return err;
> +
> +	err = virtnet_validate_features(dev, features_for_host_csum,
> +					ARRAY_SIZE(features_for_host_csum),
> +					VIRTIO_NET_F_CSUM);
> +	if (err)
> +		return err;
> +
> +	if (virtio_has_feature(dev, VIRTIO_NET_F_GUEST_ECN) &&
> +	    (!virtio_has_feature(dev, VIRTIO_NET_F_GUEST_TSO4) ||
> +	     !virtio_has_feature(dev, VIRTIO_NET_F_GUEST_TSO6))) {
> +		dev_err(&dev->dev,
> +			"buggy hyperviser: feature 0x%x was advertised but its dependency 0x%x or 0x%x was not",
> +			VIRTIO_NET_F_GUEST_ECN,
> +			VIRTIO_NET_F_GUEST_TSO4,
> +			VIRTIO_NET_F_GUEST_TSO6);
> +		return -EINVAL;
> +	}
> +
> +	if (virtio_has_feature(dev, VIRTIO_NET_F_HOST_ECN) &&
> +	    (!virtio_has_feature(dev, VIRTIO_NET_F_HOST_TSO4) ||
> +	     !virtio_has_feature(dev, VIRTIO_NET_F_HOST_TSO6))) {
> +		dev_err(&dev->dev,
> +			"buggy hyperviser: feature 0x%x was advertised but its dependency 0x%x or 0x%x was not",

"Hypervisor bug: advertised feature <foo> but not <bar> or <baz>"

?

> +			VIRTIO_NET_F_HOST_ECN,
> +			VIRTIO_NET_F_HOST_TSO4,
> +			VIRTIO_NET_F_HOST_TSO6);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int virtnet_probe(struct virtio_device *vdev)
>  {
>  	int i, err;


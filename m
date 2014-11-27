Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbaK0QPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:15:52 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:40624 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaK0QPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:15:50 -0500
Date: Thu, 27 Nov 2014 17:15:42 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org,
        pbonzini@redhat.com, thuth@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Brian Swetland <swetland@google.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Pawel Moll <pawel.moll@arm.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Amit Shah <amit.shah@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        virtualization@lists.linux-foundation.org, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v5 01/45] virtio: use u32, not bitmap for struct
 virtio_device's features
Message-ID: <20141127171542.3dbb2bc2@thinkpad-w530>
In-Reply-To: <1417091078-24611-2-git-send-email-mst@redhat.com>
References: <1417091078-24611-1-git-send-email-mst@redhat.com>
	<1417091078-24611-2-git-send-email-mst@redhat.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112716-0017-0000-0000-0000020145D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> It seemed like a good idea, but it's actually a pain when we get more
> than 32 feature bits.  Just change it to a u32 for now.
> 
> Cc: Brian Swetland <swetland@google.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> Acked-by: Pawel Moll <pawel.moll@arm.com>
> Acked-by: Ohad Ben-Cohen <ohad@wizery.com>
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---

Wouldn't it be easier to turn
  test_bit(i, dev->features)

into a simple makro like
  #define test_bit(i, features) (features & (1 << i))

Similar one for clear_bit and set_bit.

if names collide with existing functions, we could simply rename them to:

set_feature_bit() ...
clear_feature_bit() ...

> diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
> index e647947..0acd564 100644
> --- a/drivers/misc/mic/card/mic_virtio.c
> +++ b/drivers/misc/mic/card/mic_virtio.c
> @@ -101,7 +101,7 @@ static void mic_finalize_features(struct virtio_device *vdev)
>  	bits = min_t(unsigned, feature_len,
>  		sizeof(vdev->features)) * 8;
>  	for (i = 0; i < bits; i++) {
> -		if (test_bit(i, vdev->features))
> +		if (vdev->features & BIT(bits))

Hm, shouldn't that also be "if (vdev->features & (1 << i))"?

>  			iowrite8(ioread8(&out_features[i / 8]) | (1 << (i % 8)),
>  				 &out_features[i / 8]);
>  	}

>  out_free:
>  	kfree(features);
>  	kfree(ccw);
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index df598dd..7814b1f 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -49,9 +49,9 @@ static ssize_t features_show(struct device *_d,
> 
>  	/* We actually represent this as a bitstring, as it could be
>  	 * arbitrary length in future. */
> -	for (i = 0; i < ARRAY_SIZE(dev->features)*BITS_PER_LONG; i++)
> +	for (i = 0; i < sizeof(dev->features)*8; i++)

... sizeof(dev->features) * 8; ...

Do we have a define for 8 ?

>  		len += sprintf(buf+len, "%c",
> -			       test_bit(i, dev->features) ? '1' : '0');
> +			       dev->features & (1ULL << i) ? '1' : '0');
>  	len += sprintf(buf+len, "\n");
>  	return len;
>  }
> @@ -168,18 +168,18 @@ static int virtio_dev_probe(struct device *_d)
>  	device_features = dev->config->get_features(dev);
> 

[...]

> @@ -483,7 +483,7 @@ int main(int argc, char *argv[])
> 
>  	/* Set up host side. */
>  	vring_init(&vrh.vring, RINGSIZE, __user_addr_min, ALIGN);
> -	vringh_init_user(&vrh, vdev.features[0], RINGSIZE, true,
> +	vringh_init_user(&vrh, vdev.features, RINGSIZE, true,
>  			 vrh.vring.desc, vrh.vring.avail, vrh.vring.used);
> 
>  	/* No descriptor to get yet... */
> @@ -652,13 +652,13 @@ int main(int argc, char *argv[])
>  	}
> 
>  	/* Test weird (but legal!) indirect. */
> -	if (vdev.features[0] & (1 << VIRTIO_RING_F_INDIRECT_DESC)) {
> +	if (vdev.features & (1 << VIRTIO_RING_F_INDIRECT_DESC)) {
>  		char *data = __user_addr_max - USER_MEM/4;
>  		struct vring_desc *d = __user_addr_max - USER_MEM/2;
>  		struct vring vring;
> 
>  		/* Force creation of direct, which we modify. */
> -		vdev.features[0] &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
> +		vdev.features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);

That could then be something like 

clear_feature_bit(VIRTIO_RING_F_INDIRECT_DESC, vdev.features);

(I would prefer such makros over repeating bit actions)

>  		vq = vring_new_virtqueue(0, RINGSIZE, ALIGN, &vdev, true,
>  					 __user_addr_min,
>  					 never_notify_host,


But on the whole this looks good to me.


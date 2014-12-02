Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbaLBLOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:14:41 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:53063 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaLBLOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:14:39 -0500
Date: Tue, 2 Dec 2014 12:14:32 +0100
From: Thomas Huth <thuth@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        cornelia.huck@de.ibm.com, rusty@au1.ibm.com, nab@linux-iscsi.org,
        pbonzini@redhat.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH v8 06/50] virtio_ccw: add support for 64 bit features.
Message-ID: <20141202121432.6ceb79b5@oc7435384737.ibm.com>
In-Reply-To: <1417449619-24896-7-git-send-email-mst@redhat.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
	<1417449619-24896-7-git-send-email-mst@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120211-0013-0000-0000-000002100A49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2014 18:03:17 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Negotiate full 64 bit features.
> Change u32 to u64, make sure to use 1ULL everywhere.
> 
> Note: devices guarantee that VERSION_1 is clear unless
> revision 1 is negotiated.
> 
> Note: We don't need to re-setup the ccw, but we do it
> for clarity.
> 
> Based on patches by Rusty, Thomas Huth and Cornelia.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: David Hildebrand <dahi@linux.vnet.ibm.com>
> ---
>  drivers/s390/kvm/virtio_ccw.c | 30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
> index 244d611..65d0c80 100644
> --- a/drivers/s390/kvm/virtio_ccw.c
> +++ b/drivers/s390/kvm/virtio_ccw.c
> @@ -664,7 +664,8 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
>  {
>  	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>  	struct virtio_feature_desc *features;
> -	int ret, rc;
> +	int ret;
> +	u64 rc;
>  	struct ccw1 *ccw;
> 
>  	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
> @@ -677,7 +678,6 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
>  		goto out_free;
>  	}
>  	/* Read the feature bits from the host. */
> -	/* TODO: Features > 32 bits */
>  	features->index = 0;
>  	ccw->cmd_code = CCW_CMD_READ_FEAT;
>  	ccw->flags = 0;
> @@ -691,6 +691,16 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
> 
>  	rc = le32_to_cpu(features->features);
> 
> +	/* Read second half of the feature bits from the host. */
> +	features->index = 1;
> +	ccw->cmd_code = CCW_CMD_READ_FEAT;
> +	ccw->flags = 0;
> +	ccw->count = sizeof(*features);
> +	ccw->cda = (__u32)(unsigned long)features;
> +	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_FEAT);
> +	if (ret == 0)
> +		rc |= (u64)le32_to_cpu(features->features) << 32;
> +
>  out_free:
>  	kfree(features);
>  	kfree(ccw);
> @@ -714,12 +724,18 @@ static void virtio_ccw_finalize_features(struct virtio_device *vdev)
>  	/* Give virtio_ring a chance to accept features. */
>  	vring_transport_features(vdev);
> 
> -	/* Make sure we don't have any features > 32 bits! */
> -	BUG_ON((u32)vdev->features != vdev->features);
> -
>  	features->index = 0;
> -	features->features = cpu_to_le32(vdev->features);
> -	/* Write the feature bits to the host. */
> +	features->features = cpu_to_le32((u32)vdev->features);
> +	/* Write the first half of the feature bits to the host. */
> +	ccw->cmd_code = CCW_CMD_WRITE_FEAT;
> +	ccw->flags = 0;
> +	ccw->count = sizeof(*features);
> +	ccw->cda = (__u32)(unsigned long)features;
> +	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
> +
> +	features->index = 1;
> +	features->features = cpu_to_le32(vdev->features >> 32);
> +	/* Write the second half of the feature bits to the host. */
>  	ccw->cmd_code = CCW_CMD_WRITE_FEAT;
>  	ccw->flags = 0;
>  	ccw->count = sizeof(*features);

Looks fine!

Reviewed-by: Thomas Huth <thuth@linux.vnet.ibm.com>


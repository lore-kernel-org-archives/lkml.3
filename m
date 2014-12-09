Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbaLIKrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:47:14 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:49367 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbaLIKrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:47:11 -0500
Date: Tue, 9 Dec 2014 11:46:59 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, dahi@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, Ohad Ben-Cohen <ohad@wizery.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 3/6] virtio: allow finalize_features to fail
Message-ID: <20141209114659.5b0fdea0.cornelia.huck@de.ibm.com>
In-Reply-To: <1418042769-25539-4-git-send-email-mst@redhat.com>
References: <1418042769-25539-1-git-send-email-mst@redhat.com>
	<1418042769-25539-4-git-send-email-mst@redhat.com>
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
x-cbid: 14120910-0021-0000-0000-000002115B47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2014 15:05:58 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> This will make it easy for transports to validate features and return
> failure.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio_config.h          |  3 ++-
>  drivers/lguest/lguest_device.c         |  4 +++-
>  drivers/misc/mic/card/mic_virtio.c     |  4 +++-
>  drivers/remoteproc/remoteproc_virtio.c |  4 +++-
>  drivers/s390/kvm/kvm_virtio.c          |  4 +++-
>  drivers/s390/kvm/virtio_ccw.c          |  6 ++++--
>  drivers/virtio/virtio.c                | 21 ++++++++++++++-------
>  drivers/virtio/virtio_mmio.c           |  4 +++-
>  drivers/virtio/virtio_pci.c            |  4 +++-
>  9 files changed, 38 insertions(+), 16 deletions(-)
> 

> diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
> index c792b5f..789275f 100644
> --- a/drivers/s390/kvm/virtio_ccw.c
> +++ b/drivers/s390/kvm/virtio_ccw.c
> @@ -752,7 +752,7 @@ out_free:
>  	return rc;
>  }
> 
> -static void virtio_ccw_finalize_features(struct virtio_device *vdev)
> +static int virtio_ccw_finalize_features(struct virtio_device *vdev)
>  {
>  	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
>  	struct virtio_feature_desc *features;
> @@ -760,7 +760,7 @@ static void virtio_ccw_finalize_features(struct virtio_device *vdev)
> 
>  	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
>  	if (!ccw)
> -		return;
> +		return 0;

I think we'll want to return an error in this case as well to fail
probing. Also for the other places where something can go wrong.
Something like this:

diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index 789275f..bc6e671 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -757,15 +757,17 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct virtio_feature_desc *features;
 	struct ccw1 *ccw;
+	int ret;
 
 	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
 	if (!ccw)
-		return 0;
+		return -ENOMEM;
 
 	features = kzalloc(sizeof(*features), GFP_DMA | GFP_KERNEL);
-	if (!features)
+	if (!features) {
+		ret = -ENOMEM;
 		goto out_free;
-
+	}
 	/* Give virtio_ring a chance to accept features. */
 	vring_transport_features(vdev);
 
@@ -776,7 +778,9 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
 	ccw->cda = (__u32)(unsigned long)features;
-	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
+	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
+	if (ret)
+		goto out_free;
 
 	if (vcdev->revision == 0)
 		goto out_free;
@@ -788,13 +792,13 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
 	ccw->cda = (__u32)(unsigned long)features;
-	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
+	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
 
 out_free:
 	kfree(features);
 	kfree(ccw);
 
-	return 0;
+	return ret;
 }
 
 static void virtio_ccw_get_config(struct virtio_device *vdev,


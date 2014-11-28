Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaK1KCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:02:35 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:35714 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaK1KCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:02:32 -0500
Date: Fri, 28 Nov 2014 11:02:20 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 01/46] virtio: add low-level APIs for feature bits
Message-ID: <20141128110220.741c11af.cornelia.huck@de.ibm.com>
In-Reply-To: <1417118789-18231-2-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
	<1417118789-18231-2-git-send-email-mst@redhat.com>
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
x-cbid: 14112810-0021-0000-0000-000001F26BA6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014 22:07:36 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Add low level APIs to test/set/clear feature bits.
> For use by transports, to make it easier to
> write code independent of feature bit array format.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio_config.h | 53 ++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 50 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index 7f4ef66..249fcd6 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -77,11 +77,47 @@ void virtio_check_driver_offered_feature(const struct virtio_device *vdev,
>  					 unsigned int fbit);
> 
>  /**
> - * virtio_has_feature - helper to determine if this device has this feature.
> + * __virtio_test_bit - helper to test feature bits. For use by transports.
> + *                     Devices should normally use virtio_has_feature,
> + *                     which includes more checks.
>   * @vdev: the device
>   * @fbit: the feature bit
>   */
> -static inline bool virtio_has_feature(const struct virtio_device *vdev,
> +static inline bool __virtio_test_bit(const struct virtio_device *vdev,
> +				     unsigned int fbit)
> +{
> +	/* Did you forget to fix assumptions on max features? */
> +	if (__builtin_constant_p(fbit))
> +		BUILD_BUG_ON(fbit >= 32);
> +	else
> +		BUG_ON(fbit >= 32);

Does this want to be a helper? Might be overkill, but I'm always wary
of changes that need to be applied manually in many different places :)

> +
> +	return test_bit(fbit, vdev->features);
> +}
> +
> +/**
> + * __virtio_set_bit - helper to set feature bits. For use by transports.
> + * @vdev: the device
> + * @fbit: the feature bit
> + */
> +static inline void __virtio_set_bit(struct virtio_device *vdev,
> +				    unsigned int fbit)
> +{
> +	/* Did you forget to fix assumptions on max features? */
> +	if (__builtin_constant_p(fbit))
> +		BUILD_BUG_ON(fbit >= 32);
> +	else
> +		BUG_ON(fbit >= 32);
> +
> +	set_bit(fbit, vdev->features);
> +}
> +
> +/**
> + * __virtio_clear_bit - helper to set feature bits. For use by transports.

s/set/clear/

> + * @vdev: the device
> + * @fbit: the feature bit
> + */
> +static inline void __virtio_clear_bit(struct virtio_device *vdev,
>  				      unsigned int fbit)
>  {
>  	/* Did you forget to fix assumptions on max features? */
> @@ -90,10 +126,21 @@ static inline bool virtio_has_feature(const struct virtio_device *vdev,
>  	else
>  		BUG_ON(fbit >= 32);
> 
> +	clear_bit(fbit, vdev->features);
> +}
> +
> +/**
> + * virtio_has_feature - helper to determine if this device has this feature.
> + * @vdev: the device
> + * @fbit: the feature bit
> + */
> +static inline bool virtio_has_feature(const struct virtio_device *vdev,
> +				      unsigned int fbit)
> +{
>  	if (fbit < VIRTIO_TRANSPORT_F_START)
>  		virtio_check_driver_offered_feature(vdev, fbit);
> 
> -	return test_bit(fbit, vdev->features);
> +	return __virtio_test_bit(vdev, fbit);
>  }
> 
>  static inline


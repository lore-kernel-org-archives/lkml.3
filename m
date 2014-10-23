Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbaJWM2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:28:20 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:59055 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbaJWM2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:28:16 -0400
Date: Thu, 23 Oct 2014 14:28:08 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC v3 09/16] virtio: set FEATURES_OK
Message-ID: <20141023142808.377551d8.cornelia.huck@de.ibm.com>
In-Reply-To: <1414003404-505-10-git-send-email-mst@redhat.com>
References: <1414003404-505-1-git-send-email-mst@redhat.com>
	<1414003404-505-10-git-send-email-mst@redhat.com>
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
x-cbid: 14102312-0021-0000-0000-000001836EF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014 21:44:44 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> set FEATURES_OK as per virtio 1.0 spec
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/uapi/linux/virtio_config.h |  2 ++
>  drivers/virtio/virtio.c            | 29 ++++++++++++++++++++++-------
>  2 files changed, 24 insertions(+), 7 deletions(-)
> 

>  	dev->config->finalize_features(dev);
> 
> +	if (virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> +		add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
> +		status = dev->config->get_status(dev);
> +		if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
> +			printk(KERN_ERR "virtio: device refuses features: %x\n",
> +			       status);
> +			err = -ENODEV;
> +			goto err;
> +		}
> +	}
> +

Ugh, I just realize that virtio-ccw has a problem with that mechanism :(

Up to now, the driver only propagated status to the device: For
virtio-ccw, this was easily implemented via a ccw that transmitted
"status" to the device. However, the "read back status" part now
actually requires that the driver can get "status" from the device, or
has a comparable way to find out that the device won't accept the
status it tried to write.

I can think of two solutions:

(1) Introduce a new ccw that actually reads the device status.
(2) Make the WRITE_STATUS ccw fail (with a unit check) if the driver
    sets FEATURES_OK after it tried to set features the device won't
    accept.

(1) is probably more generic, while (2) is more straightforward to
implement.

Good thing we actually try to finally implement this, I did not notice
this problem during the review :(


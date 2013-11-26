Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab3KZTP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:15:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab3KZTP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:15:27 -0500
Date: Tue, 26 Nov 2013 11:15:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Siva Krishna Kumar Reddy Yerramreddy 
	<siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH char-misc-linus 4/5] misc: mic: Fix sparse warnings and
 other endianness issues.
Message-ID: <20131126191525.GA29279@kroah.com>
References: <cover.1385487752.git.ashutosh.dixit@intel.com>
 <e5bcd02bd49b111e2d4f885655461e889b8049a3.1385487752.git.ashutosh.dixit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5bcd02bd49b111e2d4f885655461e889b8049a3.1385487752.git.ashutosh.dixit@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:14:21AM -0800, Ashutosh Dixit wrote:
> Endianness issues are now consistent as per the documentation in
> host/mic_virtio.h. Note that the host can be both BE or LE whereas the
> card is always LE.
> 
> Memory space sparse warnings are fixed for now by using __force. This is
> sufficient for now since the driver depends on x86 but will need to be
> revisited if we support other architectures which treat I/O memory
> differently from system memory.

There's no need for this for 3.13-final, right?  No bug fixes are here
that I can tell.

And don't use __force, really, can't you fix this some other way?

> diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
> index 4dce912..c975c36 100644
> --- a/drivers/misc/mic/card/mic_virtio.c
> +++ b/drivers/misc/mic/card/mic_virtio.c
> @@ -248,17 +248,17 @@ static struct virtqueue *mic_find_vq(struct virtio_device *vdev,
>  	/* First assign the vring's allocated in host memory */
>  	vqconfig = mic_vq_config(mvdev->desc) + index;
>  	memcpy_fromio(&config, vqconfig, sizeof(config));
> -	_vr_size = vring_size(config.num, MIC_VIRTIO_RING_ALIGN);
> +	_vr_size = vring_size(le16_to_cpu(config.num), MIC_VIRTIO_RING_ALIGN);
>  	vr_size = PAGE_ALIGN(_vr_size + sizeof(struct _mic_vring_info));
> -	va = mic_card_map(mvdev->mdev, config.address, vr_size);
> +	va = mic_card_map(mvdev->mdev, le64_to_cpu(config.address), vr_size);
>  	if (!va)
>  		return ERR_PTR(-ENOMEM);
>  	mvdev->vr[index] = va;
>  	memset_io(va, 0x0, _vr_size);
> -	vq = vring_new_virtqueue(index,
> -				config.num, MIC_VIRTIO_RING_ALIGN, vdev,
> -				false,
> -				va, mic_notify, callback, name);
> +	vq = vring_new_virtqueue(index, le16_to_cpu(config.num),
> +				 MIC_VIRTIO_RING_ALIGN, vdev, false,
> +				 (void __force *)va, mic_notify, callback,
> +				 name);

Why __force a void * here?  That feels wrong.

Can you split the endian fixes up from the user pointer fixes to make it
easier to review/apply?

thanks,

greg k-h

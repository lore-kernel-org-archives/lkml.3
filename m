Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaKYR3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:29:53 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:32810 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaKYR3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:29:51 -0500
Date: Tue, 25 Nov 2014 18:29:42 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Pawel Moll <pawel.moll@arm.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 04/42] virtio: disable virtio 1.0 in transports
Message-ID: <20141125182942.3890fe7b.cornelia.huck@de.ibm.com>
In-Reply-To: <1416933600-21398-5-git-send-email-mst@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-5-git-send-email-mst@redhat.com>
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
x-cbid: 14112517-0013-0000-0000-000001FC1F31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 18:41:35 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> disable virtio 1.0 in transports that don't
> support it yet.

I'd prefer if you disabled it for _every_ transport in this patch,
until the needed infrastructure is in place. Else this is a bit
confusing.

> We will gradually re-enable as support is added.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/lguest/lguest_device.c     | 3 ++-
>  drivers/misc/mic/card/mic_virtio.c | 2 ++
>  drivers/s390/kvm/virtio_ccw.c      | 3 ++-
>  drivers/virtio/virtio_mmio.c       | 2 ++
>  4 files changed, 8 insertions(+), 2 deletions(-)

Why do you disable ccw but not pci? (Doesn't pci need any changes
transport-side?) And you missed the old s390 virtio transport in
drivers/s390/kvm/kvm_virtio.c :)

> diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
> index abba04d..08536f0 100644
> --- a/drivers/s390/kvm/virtio_ccw.c
> +++ b/drivers/s390/kvm/virtio_ccw.c
> @@ -704,7 +704,8 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
>  out_free:
>  	kfree(features);
>  	kfree(ccw);
> -	return rc;
> +	/* TODO: enable virtio 1.0 */
> +	return rc & ~BIT_ULL(VIRTIO_F_VERSION_1);;

double ';'

FWIW, as negotiating a revision >= 1 is a pre-req for virtio 1.0
support on ccw, virtio 1.0 is already implicitly disabled.

>  }
> 
>  static void virtio_ccw_finalize_features(struct virtio_device *vdev)


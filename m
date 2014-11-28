Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbaK1M4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:56:10 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:32786 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaK1M4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:56:08 -0500
Date: Fri, 28 Nov 2014 13:56:00 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH v6 06/46] virtio_ccw: add support for 64 bit features.
Message-ID: <20141128135600.594dd74e.cornelia.huck@de.ibm.com>
In-Reply-To: <1417118789-18231-7-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
	<1417118789-18231-7-git-send-email-mst@redhat.com>
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
x-cbid: 14112812-0025-0000-0000-000002A30D99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014 22:08:09 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Negotiate full 64 bit features.
> Change u32 to u64, make sure to use 1ULL everywhere.
> 
> Note: devices guarantee that VERSION_1 is clear unless
> revision 1 is negotiated.
> 
> Based on patches by Rusty, Thomas Huth and Cornelia.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/s390/kvm/virtio_ccw.c | 30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
> 

> @@ -691,6 +691,16 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
> 
>  	rc = le32_to_cpu(features->features);
> 
> +	/* Read second half feature bits from the host. */

s/half feature bits/half of the feature bits/

> +	features->index = 1;
> +	ccw->cmd_code = CCW_CMD_READ_FEAT;
> +	ccw->flags = 0;
> +	ccw->count = sizeof(*features);
> +	ccw->cda = (__u32)(unsigned long)features;

We don't need to re-setup the ccw, but it probably doesn't hurt for
clarity.

> +	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_FEAT);
> +	if (ret == 0)
> +		rc |= (u64)le32_to_cpu(features->features) << 32;
> +
>  out_free:
>  	kfree(features);
>  	kfree(ccw);

Looks good.


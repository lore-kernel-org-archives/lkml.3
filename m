Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaKYVkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:40:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaKYVkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:40:03 -0500
Date: Tue, 25 Nov 2014 23:39:42 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, Pawel Moll <pawel.moll@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 11/42] virtio: add legacy feature table support
Message-ID: <20141125213942.GD22343@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
 <1416933600-21398-12-git-send-email-mst@redhat.com>
 <20141125185342.761bf72e.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125185342.761bf72e.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 06:53:42PM +0100, Cornelia Huck wrote:
> On Tue, 25 Nov 2014 18:42:09 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > virtio blk has some legacy feature bits that modern drivers
> 
> virtio-blk
> 
> > must not negotiate, but are needed for old legacy hosts
> > (e.g. that dn't support virtio scsi).
> 
> (that e.g. don't support virtio-scsi)
> 
> > Allow a separate legacy feature table for such cases.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/linux/virtio.h  |  4 ++++
> >  drivers/virtio/virtio.c | 25 ++++++++++++++++++++++++-
> >  2 files changed, 28 insertions(+), 1 deletion(-)
> > 
> 
> > @@ -177,7 +185,22 @@ static int virtio_dev_probe(struct device *_d)
> >  		driver_features |= (1ULL << f);
> >  	}
> > 
> > -	dev->features = driver_features & device_features;
> > +	/* Some drivers have a separate feature tables for virtio v1.0 */
> 
> /* some drivers have a separate feature table for legacy virtio */
> 
> ?

I prefer have separate feature tables:  drivers (plural) have tables
(plural).

Agree?

> > +	if (drv->feature_table_legacy) {
> > +		driver_features_legacy = 0;
> > +		for (i = 0; i < drv->feature_table_size_legacy; i++) {
> > +			unsigned int f = drv->feature_table_legacy[i];
> > +			BUG_ON(f >= 64);
> > +			driver_features_legacy |= (1ULL << f);
> > +		}
> > +	} else {
> > +		driver_features_legacy = driver_features;
> > +	}
> (...)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaA1CGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 21:06:51 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:53984 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaA1CGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 21:06:49 -0500
Date: Tue, 28 Jan 2014 02:06:31 +0000
From: Leandro Dorileo <l@dorileo.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com
Subject: Re: [PATCH] virtio_balloon: don't call virtio_has_feature() twice on
 init_vqs()
Message-ID: <20140128020631.GA27529@dorilex>
References: <1390679972-1406-1-git-send-email-l@dorileo.org>
 <87ppndyn54.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppndyn54.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Tue, Jan 28, 2014 at 10:48:31AM +1030, Rusty Russell wrote:
> Leandro Dorileo <l@dorileo.org> writes:
> > Cchange init_vqs() to avoid calling twice the virtio_has_feature()
> > - attempting to find out if VIRTIO_BALLOON_F_STATS_VQ feature was negotiated -
> > consequently we prevent unnecessarily running the drivers' feature_table more
> > than needed.
> >
> > Signed-off-by: Leandro Dorileo <l@dorileo.org>
> 
> Hi Leandro,
> 
>         This seems like a premature optimization.  The current code is
> fairly clear, and there's no performance issue with init_vqs.
> 

Indeed, rethinking the patch and reviewing the code path it seems to be no gain,
It's just called on probe and restore operations. As you said a premature optimization.

Thanks...


> Am I missing something?
> Rusty.
> 
> > ---
> >  drivers/virtio/virtio_balloon.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > index 34bdaba..41771c1 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -320,19 +320,21 @@ static int init_vqs(struct virtio_balloon *vb)
> >  	vq_callback_t *callbacks[] = { balloon_ack, balloon_ack, stats_request };
> >  	const char *names[] = { "inflate", "deflate", "stats" };
> >  	int err, nvqs;
> > +	bool stats;
> >  
> >  	/*
> >  	 * We expect two virtqueues: inflate and deflate, and
> >  	 * optionally stat.
> >  	 */
> > -	nvqs = virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ) ? 3 : 2;
> > +	stats = virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ);
> > +	nvqs = stats ? 3 : 2;
> >  	err = vb->vdev->config->find_vqs(vb->vdev, nvqs, vqs, callbacks, names);
> >  	if (err)
> >  		return err;
> >  
> >  	vb->inflate_vq = vqs[0];
> >  	vb->deflate_vq = vqs[1];
> > -	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> > +	if (stats) {
> >  		struct scatterlist sg;
> >  		vb->stats_vq = vqs[2];
> >  
> > -- 
> > 1.8.5.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Leandro Dorileo

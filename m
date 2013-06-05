Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab3FEXIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:08:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580Ab3FEXIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:08:47 -0400
Date: Wed, 5 Jun 2013 19:08:44 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio_balloon: leak_balloon(): only tell host if we
 got pages deflated
Message-ID: <20130605190844.1e96bbde@redhat.com>
In-Reply-To: <20130605212449.GB19617@optiplex.redhat.com>
References: <20130605171031.7448deea@redhat.com>
	<20130605212449.GB19617@optiplex.redhat.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jun 2013 18:24:49 -0300
Rafael Aquini <aquini@redhat.com> wrote:

> On Wed, Jun 05, 2013 at 05:10:31PM -0400, Luiz Capitulino wrote:
> > The balloon_page_dequeue() function can return NULL. If it does for
> > the first page being freed, then leak_balloon() will create a
> > scatter list with len=0. Which in turn seems to generate an invalid
> > virtio request.
> > 
> > Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
> > ---
> > 
> > PS: I didn't get this in practice. I found it by code review. On the other
> >     hand, automatic-ballooning was able to put such invalid requests in
> >     the virtqueue and QEMU would explode...
> >
> 
> Nice catch! The patch looks sane and replicates the check done at
> fill_balloon(). I think we also could use this P.S. as a commentary 
> to let others aware of this scenario. Thanks Luiz!

Want me to respin?

> Acked-by: Rafael Aquini <aquini@redhat.com>

Thanks for your review!

> 
>  
> > PPS: Very lightly tested
> >
> >  drivers/virtio/virtio_balloon.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > index bd3ae32..71af7b5 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -191,7 +191,8 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
> >  	 * virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
> >  	 * is true, we *have* to do it in this order
> >  	 */
> > -	tell_host(vb, vb->deflate_vq);
> > +	if (vb->num_pfns != 0)
> > +		tell_host(vb, vb->deflate_vq);
> >  	mutex_unlock(&vb->balloon_lock);
> >  	release_pages_by_pfn(vb->pfns, vb->num_pfns);
> >  }
> > -- 
> > 1.8.1.4
> > 
> 


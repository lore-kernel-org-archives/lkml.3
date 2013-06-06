Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab3FFOT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:19:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab3FFOTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:19:55 -0400
Date: Thu, 6 Jun 2013 10:19:52 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2] virtio_balloon: leak_balloon(): only tell host if we
 got pages deflated
Message-ID: <20130606101952.5f2c7988@redhat.com>
In-Reply-To: <20130606141357.GD30387@optiplex.redhat.com>
References: <20130605211837.1fc9b902@redhat.com>
	<20130606141357.GD30387@optiplex.redhat.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jun 2013 11:13:58 -0300
Rafael Aquini <aquini@redhat.com> wrote:

> On Wed, Jun 05, 2013 at 09:18:37PM -0400, Luiz Capitulino wrote:
> > The balloon_page_dequeue() function can return NULL. If it does for
> > the first page being freed, then leak_balloon() will create a
> > scatter list with len=0. Which in turn seems to generate an invalid
> > virtio request.
> > 
> > I didn't get this in practice, I found it by code review. On the other
> > hand, such an invalid virtio request will cause errors in QEMU and
> > fill_balloon() also performs the same check implemented by this commit.
> > 
> > Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
> > Acked-by: Rafael Aquini <aquini@redhat.com>
> > ---
> > 
> > o v2
> > 
> >  - Improve changelog
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
> 
> Luiz, sorry for not being clearer before. I was referring to add a commentary on
> code, to explain in short words why we should not get rid of this check point.

Oh.

> > +	if (vb->num_pfns != 0)
> > +		tell_host(vb, vb->deflate_vq);
> >  	mutex_unlock(&vb->balloon_lock);
> 
> If the comment is regarded as unnecessary, then just ignore my suggestion. I'm
> OK with your patch. :)

IMHO, the code is clear enough.

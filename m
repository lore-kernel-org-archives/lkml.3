Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab3FFOOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 10:14:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab3FFOOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 10:14:04 -0400
Date: Thu, 6 Jun 2013 11:13:58 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2] virtio_balloon: leak_balloon(): only tell host if we
 got pages deflated
Message-ID: <20130606141357.GD30387@optiplex.redhat.com>
References: <20130605211837.1fc9b902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605211837.1fc9b902@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 09:18:37PM -0400, Luiz Capitulino wrote:
> The balloon_page_dequeue() function can return NULL. If it does for
> the first page being freed, then leak_balloon() will create a
> scatter list with len=0. Which in turn seems to generate an invalid
> virtio request.
> 
> I didn't get this in practice, I found it by code review. On the other
> hand, such an invalid virtio request will cause errors in QEMU and
> fill_balloon() also performs the same check implemented by this commit.
> 
> Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
> Acked-by: Rafael Aquini <aquini@redhat.com>
> ---
> 
> o v2
> 
>  - Improve changelog
> 
>  drivers/virtio/virtio_balloon.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index bd3ae32..71af7b5 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -191,7 +191,8 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
>  	 * virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
>  	 * is true, we *have* to do it in this order
>  	 */
> -	tell_host(vb, vb->deflate_vq);

Luiz, sorry for not being clearer before. I was referring to add a commentary on
code, to explain in short words why we should not get rid of this check point.

> +	if (vb->num_pfns != 0)
> +		tell_host(vb, vb->deflate_vq);
>  	mutex_unlock(&vb->balloon_lock);

If the comment is regarded as unnecessary, then just ignore my suggestion. I'm
OK with your patch. :)

Cheers!
-- Rafael


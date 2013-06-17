Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab3FQRRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:17:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab3FQRRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:17:45 -0400
Date: Mon, 17 Jun 2013 13:17:41 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        aquini@redhat.com
Subject: Re: [PATCH v2] virtio_balloon: leak_balloon(): only tell host if we
 got pages deflated
Message-ID: <20130617131741.3489b85d@redhat.com>
In-Reply-To: <20130605211837.1fc9b902@redhat.com>
References: <20130605211837.1fc9b902@redhat.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jun 2013 21:18:37 -0400
Luiz Capitulino <lcapitulino@redhat.com> wrote:

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

Andrew, can you pick this one?

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
> +	if (vb->num_pfns != 0)
> +		tell_host(vb, vb->deflate_vq);
>  	mutex_unlock(&vb->balloon_lock);
>  	release_pages_by_pfn(vb->pfns, vb->num_pfns);
>  }


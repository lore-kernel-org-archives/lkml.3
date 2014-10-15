Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaJOGdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 02:33:37 -0400
Received: from ozlabs.org ([103.22.144.67]:59650 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbaJOGct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 02:32:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Petr Mladek <pmladek@suse.cz>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: Re: [PATCH] virtio_balloon: Convert "vballon" kthread into a workqueue
In-Reply-To: <1411662041-10986-1-git-send-email-pmladek@suse.cz>
References: <1411662041-10986-1-git-send-email-pmladek@suse.cz>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 15 Oct 2014 15:40:41 +1030
Message-ID: <87lhohc3zi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Mladek <pmladek@suse.cz> writes:
> Workqueues have clean and rich API for all basic operations. The code is usually
> easier and better readable. It can be easily tuned for the given purpose.

OK, sure.

> -static void fill_balloon(struct virtio_balloon *vb, size_t num)
> +static void fill_balloon(struct virtio_balloon *vb, size_t diff)
>  {
>  	struct balloon_dev_info *vb_dev_info = vb->vb_dev_info;
> +	size_t num;
> +	bool done;
>  
>  	/* We can only do one array worth at a time. */
> -	num = min(num, ARRAY_SIZE(vb->pfns));
> +	num = min(diff, ARRAY_SIZE(vb->pfns));
> +	done = (num == diff) ? true : false;
>  
>  	mutex_lock(&vb->balloon_lock);
>  	for (vb->num_pfns = 0; vb->num_pfns < num;
> @@ -143,6 +143,7 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
>  					     VIRTIO_BALLOON_PAGES_PER_PAGE);
>  			/* Sleep for at least 1/5 of a second before retry. */
>  			msleep(200);
> +			done = false;
>  			break;
>  		}
>  		set_page_pfns(vb->pfns + vb->num_pfns, page);
> @@ -154,6 +155,9 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
>  	if (vb->num_pfns != 0)
>  		tell_host(vb, vb->inflate_vq);
>  	mutex_unlock(&vb->balloon_lock);
> +
> +	if (!done)
> +		queue_work(vb->wq, &vb->wq_work);
>  }

Hmm, this is a bit convoluted.  I would spell it out by keeping a
num_done counter:

        if (num_done < diff)
                queue_work(vb->wq, &vb->wq_work);

>  static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
> @@ -168,20 +172,25 @@ static void release_pages_by_pfn(const u32 pfns[], unsigned int num)
>  	}
>  }
>  
> -static void leak_balloon(struct virtio_balloon *vb, size_t num)
> +static void leak_balloon(struct virtio_balloon *vb, size_t diff)
>  {
>  	struct page *page;
>  	struct balloon_dev_info *vb_dev_info = vb->vb_dev_info;
> +	size_t num;
> +	bool done;
>  
>  	/* We can only do one array worth at a time. */
> -	num = min(num, ARRAY_SIZE(vb->pfns));
> +	num = min(diff, ARRAY_SIZE(vb->pfns));
> +	done = (num == diff) ? true : false;
>  
>  	mutex_lock(&vb->balloon_lock);
>  	for (vb->num_pfns = 0; vb->num_pfns < num;
>  	     vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
>  		page = balloon_page_dequeue(vb_dev_info);
> -		if (!page)
> +		if (!page) {
> +			done = false;
>  			break;
> +		}
>  		set_page_pfns(vb->pfns + vb->num_pfns, page);
>  		vb->num_pages -= VIRTIO_BALLOON_PAGES_PER_PAGE;
>  	}
> @@ -195,6 +204,9 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
>  		tell_host(vb, vb->deflate_vq);
>  	mutex_unlock(&vb->balloon_lock);
>  	release_pages_by_pfn(vb->pfns, vb->num_pfns);
> +
> +	if (!done)
> +		queue_work(vb->wq, &vb->wq_work);
>  }

Here too.

> @@ -471,11 +469,13 @@ static int virtballoon_probe(struct virtio_device *vdev)
>  	if (err)
>  		goto out_free_vb_mapping;
>  
> -	vb->thread = kthread_run(balloon, vb, "vballoon");
> -	if (IS_ERR(vb->thread)) {
> -		err = PTR_ERR(vb->thread);
> +	vb->wq = alloc_workqueue("vballoon_wq",
> +				 WQ_FREEZABLE | WQ_MEM_RECLAIM, 0);
> +	if (!vb->wq) {
> +		err = -ENOMEM;
>  		goto out_del_vqs;
>  	}
> +	INIT_WORK(&vb->wq_work, balloon);

That looks racy to me; shouldn't we init vq-work before allocating wq?

Otherwise, looks good!

Thanks,
Rusty.

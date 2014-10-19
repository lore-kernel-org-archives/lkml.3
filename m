Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaJTAen (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 20:34:43 -0400
Received: from ozlabs.org ([103.22.144.67]:36252 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbaJTAem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 20:34:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Denis V. Lunev" <den@openvz.org>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Raushaniya Maksudova <rmaksudova@parallels.com>,
        "Denis V. Lunev" <den@openvz.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 2/2] virtio_balloon: free some memory from balloon on OOM
In-Reply-To: <1413388064-5354-3-git-send-email-den@openvz.org>
References: <1413388064-5354-1-git-send-email-den@openvz.org> <1413388064-5354-3-git-send-email-den@openvz.org>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 20 Oct 2014 10:01:37 +1030
Message-ID: <87d29nab6u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Denis V. Lunev" <den@openvz.org> writes:

> From: Raushaniya Maksudova <rmaksudova@parallels.com>
>
> Excessive virtio_balloon inflation can cause invocation of OOM-killer,
> when Linux is under severe memory pressure. Various mechanisms are
> responsible for correct virtio_balloon memory management. Nevertheless
> it is often the case that these control tools does not have enough time
> to react on fast changing memory load. As a result OS runs out of memory
> and invokes OOM-killer. The balancing of memory by use of the virtio
> balloon should not cause the termination of processes while there are
> pages in the balloon. Now there is no way for virtio balloon driver to
> free some memory at the last moment before some process will be get
> killed by OOM-killer.
>
> This does not provide a security breach as balloon itself is running
> inside guest OS and is working in the cooperation with the host. Thus
> some improvements from guest side should be considered as normal.
>
> To solve the problem, introduce a virtio_balloon callback which is
> expected to be called from the oom notifier call chain in out_of_memory()
> function. If virtio balloon could release some memory, it will make
> the system to return and retry the allocation that forced the out of
> memory killer to run.
>
> Allocate virtio  feature bit for this: it is not set by default,
> the the guest will not deflate virtio balloon on OOM without explicit
> permission from host.
>
> Signed-off-by: Raushaniya Maksudova <rmaksudova@parallels.com>
> Signed-off-by: Denis V. Lunev <den@openvz.org>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/virtio/virtio_balloon.c     | 52 +++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/virtio_balloon.h |  1 +
>  2 files changed, 53 insertions(+)
>
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 66cac10..88d73a0 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -28,6 +28,7 @@
>  #include <linux/slab.h>
>  #include <linux/module.h>
>  #include <linux/balloon_compaction.h>
> +#include <linux/oom.h>
>  
>  /*
>   * Balloon device works in 4K page units.  So each page is pointed to by
> @@ -36,6 +37,12 @@
>   */
>  #define VIRTIO_BALLOON_PAGES_PER_PAGE (unsigned)(PAGE_SIZE >> VIRTIO_BALLOON_PFN_SHIFT)
>  #define VIRTIO_BALLOON_ARRAY_PFNS_MAX 256
> +#define OOM_VBALLOON_DEFAULT_PAGES 256
> +#define VIRTBALLOON_OOM_NOTIFY_PRIORITY 80
> +
> +static int oom_pages = OOM_VBALLOON_DEFAULT_PAGES;
> +module_param(oom_pages, int, S_IRUSR | S_IWUSR);
> +MODULE_PARM_DESC(oom_pages, "pages to free on OOM");
>  
>  struct virtio_balloon
>  {
> @@ -71,6 +78,9 @@ struct virtio_balloon
>  	/* Memory statistics */
>  	int need_stats_update;
>  	struct virtio_balloon_stat stats[VIRTIO_BALLOON_S_NR];
> +
> +	/* To register callback in oom notifier call chain */
> +	struct notifier_block nb;
>  };
>  
>  static struct virtio_device_id id_table[] = {
> @@ -290,6 +300,38 @@ static void update_balloon_size(struct virtio_balloon *vb)
>  		      &actual);
>  }
>  
> +/*
> + * virtballoon_oom_notify - release pages when system is under severe
> + *			    memory pressure (called from out_of_memory())
> + * @self : notifier block struct
> + * @dummy: not used
> + * @parm : returned - number of freed pages
> + *
> + * The balancing of memory by use of the virtio balloon should not cause
> + * the termination of processes while there are pages in the balloon.
> + * If virtio balloon manages to release some memory, it will make the
> + * system return and retry the allocation that forced the OOM killer
> + * to run.
> + */
> +static int virtballoon_oom_notify(struct notifier_block *self,
> +				  unsigned long dummy, void *parm)
> +{
> +	struct virtio_balloon *vb;
> +	unsigned long *freed;
> +	unsigned num_freed_pages;
> +
> +	vb = container_of(self, struct virtio_balloon, nb);
> +	if (!virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
> +		return NOTIFY_OK;
> +
> +	freed = parm;
> +	num_freed_pages = leak_balloon(vb, oom_pages);
> +	update_balloon_size(vb);
> +	*freed += num_freed_pages;
> +
> +	return NOTIFY_OK;
> +}
> +
>  static int balloon(void *_vballoon)
>  {
>  	struct virtio_balloon *vb = _vballoon;

OK, I applied these.  I thought it a bit weird that you're checking the
feature in the callback, rather than only registering the callback
if the feature exists.  But it's clear enough.

Thanks,
Rusty.

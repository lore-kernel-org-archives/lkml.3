Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaLAMeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:34:09 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:57023 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbaLAMeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:34:07 -0500
Date: Mon, 1 Dec 2014 13:33:53 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v7 31/46] vhost: virtio 1.0 endian-ness support
Message-ID: <20141201133353.0bbaa2e1.cornelia.huck@de.ibm.com>
In-Reply-To: <1417359787-10138-32-git-send-email-mst@redhat.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-32-git-send-email-mst@redhat.com>
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
x-cbid: 14120112-0029-0000-0000-000001F53895
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2014 17:11:49 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/vhost.c | 93 +++++++++++++++++++++++++++++++--------------------
>  1 file changed, 56 insertions(+), 37 deletions(-)
> 

> @@ -1113,18 +1120,19 @@ static int get_indirect(struct vhost_virtqueue *vq,
>  {
>  	struct vring_desc desc;
>  	unsigned int i = 0, count, found = 0;
> +	u32 len = vhost32_to_cpu(vq, indirect->len);
>  	int ret;
> 
>  	/* Sanity check */
> -	if (unlikely(indirect->len % sizeof desc)) {
> +	if (unlikely(len % sizeof desc)) {
>  		vq_err(vq, "Invalid length in indirect descriptor: "
>  		       "len 0x%llx not multiple of 0x%zx\n",
> -		       (unsigned long long)indirect->len,
> +		       (unsigned long long)vhost32_to_cpu(vq, indirect->len),

Can't you use len here?

>  		       sizeof desc);
>  		return -EINVAL;
>  	}
> 
> -	ret = translate_desc(vq, indirect->addr, indirect->len, vq->indirect,
> +	ret = translate_desc(vq, vhost64_to_cpu(vq, indirect->addr), len, vq->indirect,
>  			     UIO_MAXIOV);
>  	if (unlikely(ret < 0)) {
>  		vq_err(vq, "Translation failure %d in indirect.\n", ret);


> @@ -1404,7 +1422,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
> 
>  	/* Make sure buffer is written before we update index. */
>  	smp_wmb();
> -	if (put_user(vq->last_used_idx, &vq->used->idx)) {
> +	if (__put_user(cpu_to_vhost16(vq, vq->last_used_idx), &vq->used->idx)) {

Why s/put_user/__put_user/ - I don't see how endianness conversions
should have an influence there?

>  		vq_err(vq, "Failed to increment used idx");
>  		return -EFAULT;
>  	}

> @@ -1449,11 +1468,11 @@ static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
>  	if (unlikely(!v))
>  		return true;
> 
> -	if (get_user(event, vhost_used_event(vq))) {
> +	if (__get_user(event, vhost_used_event(vq))) {

Dito: why the change?

>  		vq_err(vq, "Failed to get used event idx");
>  		return true;
>  	}
> -	return vring_need_event(event, new, old);
> +	return vring_need_event(vhost16_to_cpu(vq, event), new, old);
>  }
> 
>  /* This actually signals the guest, using eventfd. */


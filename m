Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbaISKfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:35:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbaISKfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:35:51 -0400
Message-ID: <541C06FF.2030003@redhat.com>
Date: Fri, 19 Sep 2014 18:35:43 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
CC: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] vhost: support urgent descriptors
References: <1404203661-7521-1-git-send-email-mst@redhat.com> <1404203661-7521-2-git-send-email-mst@redhat.com>
In-Reply-To: <1404203661-7521-2-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 06:49 PM, Michael S. Tsirkin wrote:
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/vhost.h | 19 +++++++++++++------
>  drivers/vhost/net.c   | 30 +++++++++++++++++++++---------
>  drivers/vhost/scsi.c  | 23 +++++++++++++++--------
>  drivers/vhost/test.c  |  5 +++--
>  drivers/vhost/vhost.c | 23 ++++++++++++++++-------
>  5 files changed, 68 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 3eda654..61ca542 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -96,6 +96,9 @@ struct vhost_virtqueue {
>  	/* Last used index value we have signalled on */
>  	bool signalled_used_valid;
>  
> +	/* Urgent descriptor was used */
> +	bool urgent;
> +
>  	/* Log writes to used structure. */
>  	bool log_used;
>  	u64 log_addr;
> @@ -138,20 +141,24 @@ long vhost_vring_ioctl(struct vhost_dev *d, int ioctl, void __user *argp);
>  int vhost_vq_access_ok(struct vhost_virtqueue *vq);
>  int vhost_log_access_ok(struct vhost_dev *);
>  
> -int vhost_get_vq_desc(struct vhost_virtqueue *,
> +int vhost_get_vq_desc(struct vhost_virtqueue *, bool *urgent,
>  		      struct iovec iov[], unsigned int iov_count,
>  		      unsigned int *out_num, unsigned int *in_num,
>  		      struct vhost_log *log, unsigned int *log_num);
>  void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
>  
>  int vhost_init_used(struct vhost_virtqueue *);
> -int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
> -int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
> -		     unsigned count);
> -void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
> +int vhost_add_used(struct vhost_virtqueue *, bool urgent,
> +		   unsigned int head, int len);
> +int vhost_add_used_n(struct vhost_virtqueue *, bool urgent,
> +		     struct vring_used_elem *heads, unsigned count);
> +void vhost_add_used_and_signal(struct vhost_dev *,
> +			       struct vhost_virtqueue *,
> +			       bool urgent,
>  			       unsigned int id, int len);
>  void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
> -			       struct vring_used_elem *heads, unsigned count);
> +				 bool urgent,
> +				 struct vring_used_elem *heads, unsigned count);
>  void vhost_signal(struct vhost_dev *, struct vhost_virtqueue *);
>  void vhost_disable_notify(struct vhost_dev *, struct vhost_virtqueue *);
>  bool vhost_enable_notify(struct vhost_dev *, struct vhost_virtqueue *);
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 8dae2f7..5f0567f 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -48,9 +48,11 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
>   * status internally; used for zerocopy tx only.
>   */
>  /* Lower device DMA failed */
> -#define VHOST_DMA_FAILED_LEN	3
> +#define VHOST_DMA_FAILED_LEN	4
>  /* Lower device DMA done */
> -#define VHOST_DMA_DONE_LEN	2
> +#define VHOST_DMA_DONE_LEN	3
> +/* Lower device DMA in progress, urgent bit set */
> +#define VHOST_DMA_URGENT	2
>  /* Lower device DMA in progress */
>  #define VHOST_DMA_IN_PROGRESS	1
>  /* Buffer unused */
> @@ -284,11 +286,13 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
>  		container_of(vq, struct vhost_net_virtqueue, vq);
>  	int i, add;
>  	int j = 0;
> +	bool urgent = false;
>  
>  	for (i = nvq->done_idx; i != nvq->upend_idx; i = (i + 1) % UIO_MAXIOV) {
>  		if (vq->heads[i].len == VHOST_DMA_FAILED_LEN)
>  			vhost_net_tx_err(net);
>  		if (VHOST_DMA_IS_DONE(vq->heads[i].len)) {
> +			urgent = urgent || vq->heads[i].len == VHOST_DMA_URGENT;

A problem is len was either VHOST_DMA_DONE_LEN or VHOST_DMA_FAILED_LEN
here. Looks like we need another new VHOST_DMA_DONE_LEN_URGENT and
change the len to this value if it was an urgent descriptor in zerocopy
callback.
>  			vq->heads[i].len = VHOST_DMA_CLEAR_LEN;
>  			++j;
>  		} else
> @@ -296,7 +300,7 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
>  	}
>  	while (j) {
>  		add = min(UIO_MAXIOV - nvq->done_idx, j);
> -		vhost_add_used_and_signal_n(vq->dev, vq,
> +		vhost_add_used_and_signal_n(vq->dev, vq, urgent,
>  					    &vq->heads[nvq->done_idx], add);
>  		nvq->done_idx = (nvq->done_idx + add) % UIO_MAXIOV;
>  		j -= add;
> @@ -363,6 +367,7 @@ static void handle_tx(struct vhost_net *net)
>  	zcopy = nvq->ubufs;
>  
>  	for (;;) {
> +		bool urgent;
>  		/* Release DMAs done buffers first */
>  		if (zcopy)
>  			vhost_zerocopy_signal_used(net, vq);
> @@ -374,7 +379,7 @@ static void handle_tx(struct vhost_net *net)
>  			      % UIO_MAXIOV == nvq->done_idx))
>  			break;
>  
> -		head = vhost_get_vq_desc(vq, vq->iov,
> +		head = vhost_get_vq_desc(vq, &urgent, vq->iov,
>  					 ARRAY_SIZE(vq->iov),
>  					 &out, &in,
>  					 NULL, NULL);
> @@ -417,7 +422,8 @@ static void handle_tx(struct vhost_net *net)
>  			ubuf = nvq->ubuf_info + nvq->upend_idx;
>  
>  			vq->heads[nvq->upend_idx].id = head;
> -			vq->heads[nvq->upend_idx].len = VHOST_DMA_IN_PROGRESS;
> +			vq->heads[nvq->upend_idx].len = urgent ?
> +				VHOST_DMA_IN_PROGRESS : VHOST_DMA_URGENT;

I think you mean VHOST_DMA_URGENT : VHOST_DMA_IN_PROGRESS here.

With all the changes above, zercopy mode works as expected. I will post
the driver part code and result next week for early review.

Thanks
>  			ubuf->callback = vhost_zerocopy_callback;
>  			ubuf->ctx = nvq->ubufs;
>  			ubuf->desc = nvq->upend_idx;
> @@ -445,7 +451,7 @@ static void handle_tx(struct vhost_net *net)
>  			pr_debug("Truncated TX packet: "
>  				 " len %d != %zd\n", err, len);
>  		if (!zcopy_used)
> -			vhost_add_used_and_signal(&net->dev, vq, head, 0);
> +			vhost_add_used_and_signal(&net->dev, vq, urgent, head, 0);
>  		else
>  			vhost_zerocopy_signal_used(net, vq);
>  		total_len += len;
[...]

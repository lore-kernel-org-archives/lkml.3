Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbaC0J6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 05:58:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbaC0J6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 05:58:36 -0400
Date: Thu, 27 Mar 2014 11:58:54 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] vhost: fix total length when packets are too short
Message-ID: <20140327095854.GA30696@redhat.com>
References: <1395912759-30435-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395912759-30435-1-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 11:38:41AM +0200, Michael S. Tsirkin wrote:
> When mergeable buffers are disabled, and the
> incoming packet is too large for the rx buffer,
> get_rx_bufs returns success.
> 
> This was intentional in order for make recvmsg
> truncate the packet and then handle_rx would
> detect err != sock_len and drop it.
> 
> Unfortunately we pass the original sock_len to
> recvmsg - which means we use parts of iov not fully
> validated.
> 
> Fix this up by detecting this overrun and doing packet drop
> immediately.
> 
> CVE-2014-0055

Ouch wrong CVE#. It's  CVE-2014-0077  actually.
Will resend V2 with the corrected commit log now.


> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Note: this is needed for -stable.
> 
> I wonder if this can still make the release.
> 
>  drivers/vhost/net.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index a0fa5de..026be58 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -532,6 +532,12 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
>  	*iovcount = seg;
>  	if (unlikely(log))
>  		*log_num = nlogs;
> +
> +	/* Detect overrun */
> +	if (unlikely(datalen > 0)) {
> +		r = UIO_MAXIOV + 1;
> +		goto err;
> +	}
>  	return headcount;
>  err:
>  	vhost_discard_vq_desc(vq, headcount);
> @@ -587,6 +593,14 @@ static void handle_rx(struct vhost_net *net)
>  		/* On error, stop handling until the next kick. */
>  		if (unlikely(headcount < 0))
>  			break;
> +		/* On overrun, truncate and discard */
> +		if (unlikely(headcount > UIO_MAXIOV)) {
> +			msg.msg_iovlen = 1;
> +			err = sock->ops->recvmsg(NULL, sock, &msg,
> +						 1, MSG_DONTWAIT | MSG_TRUNC);
> +			pr_debug("Discarded rx packet: len %zd\n", sock_len);
> +			continue;
> +		}
>  		/* OK, now we need to know about added descriptors. */
>  		if (!headcount) {
>  			if (unlikely(vhost_enable_notify(&net->dev, vq))) {
> -- 
> MST

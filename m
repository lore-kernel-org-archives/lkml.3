Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3GHMwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:52:31 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:36423 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3GHMwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:52:30 -0400
Message-ID: <51DAB60A.5080305@cogentembedded.com>
Date: Mon, 08 Jul 2013 16:52:26 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] virtio_net: fix race in RX VQ processing
References: <1373274069-4301-1-git-send-email-mst@redhat.com> <1373274069-4301-3-git-send-email-mst@redhat.com>
In-Reply-To: <1373274069-4301-3-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08-07-2013 13:04, Michael S. Tsirkin wrote:

> virtio net called virtqueue_enable_cq on RX path after napi_complete, so
> with NAPI_STATE_SCHED clear - outside the implicit napi lock.
> This violates the requirement to synchronize virtqueue_enable_cq wrt
> virtqueue_add_buf.  In particular, used event can move backwards,
> causing us to lose interrupts.
> In a debug build, this can trigger panic within START_USE.

> Jason Wang reports that he can trigger the races artificially,
> by adding udelay() in virtqueue_enable_cb() after virtio_mb().

> However, we must call napi_complete to clear NAPI_STATE_SCHED before
> polling the virtqueue for used buffers, otherwise napi_schedule_prep in
> a callback will fail, causing us to lose RX events.

> To fix, call virtqueue_enable_cb_prepare with NAPI_STATE_SCHED
> set (under napi lock), later call virtqueue_poll with
> NAPI_STATE_SCHED clear (outside the lock).

> Reported-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/net/virtio_net.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 5305bd1..fbdd79a 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -622,8 +622,9 @@ again:
>
>   	/* Out of packets? */
>   	if (received < budget) {
> +		unsigned r = virtqueue_enable_cb_prepare(rq->vq);

    Empty line wouldn't hurt here, after declaration.

WBR, Sergei


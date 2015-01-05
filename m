Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbbAETvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:51:45 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:52821 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbbAETvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:51:43 -0500
MIME-Version: 1.0
In-Reply-To: <1420437898-32419-1-git-send-email-famz@redhat.com>
References: <1420437898-32419-1-git-send-email-famz@redhat.com>
Date: Mon, 5 Jan 2015 11:51:43 -0800
Message-ID: <CAHdzE-9eu3a3_j1X59hfHKJ0=xhmEnZmPq58=BGgj4Ve3Yxbig@mail.gmail.com>
Subject: Re: [PATCH] virtio-scsi: Fix the race condition in virtscsi_handle_event
From: Venkatesh Srinivas <venkateshs@google.com>
To: Fam Zheng <famz@redhat.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2015 at 10:04 PM, Fam Zheng <famz@redhat.com> wrote:
>
> There is a race condition in virtscsi_handle_event, when many device
> hotplug/unplug events flush in quickly.
>
> The scsi_remove_device in virtscsi_handle_transport_reset may trigger
> the BUG_ON in scsi_target_reap, because the state is altered behind it,
> probably by scsi_scan_host of another event. I'm able to reproduce it by
> repeatedly plugging and unplugging a scsi disk with the same lun number.
>
> To make is safe, the mutex added in struct virtio_scsi is held in
> virtscsi_handle_event, so that all the events are processed in a
> synchronized way. With this lock, the panic goes away.
>
> Signed-off-by: Fam Zheng <famz@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index c52bb5d..7f194d4 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -110,6 +110,9 @@ struct virtio_scsi {
>         /* CPU hotplug notifier */
>         struct notifier_block nb;
>
> +       /* Protect the hotplug/unplug event handling */
> +       struct mutex scan_lock;
> +
>         /* Protected by event_vq lock */
>         bool stop_events;
>
> @@ -377,6 +380,7 @@ static void virtscsi_handle_event(struct work_struct *work)
>         struct virtio_scsi *vscsi = event_node->vscsi;
>         struct virtio_scsi_event *event = &event_node->event;
>
> +       mutex_lock(&vscsi->scan_lock);
>         if (event->event &
>             cpu_to_virtio32(vscsi->vdev, VIRTIO_SCSI_T_EVENTS_MISSED)) {
>                 event->event &= ~cpu_to_virtio32(vscsi->vdev,
> @@ -397,6 +401,7 @@ static void virtscsi_handle_event(struct work_struct *work)
>                 pr_err("Unsupport virtio scsi event %x\n", event->event);
>         }
>         virtscsi_kick_event(vscsi, event_node);
> +       mutex_unlock(&vscsi->scan_lock);
>  }
>
>  static void virtscsi_complete_event(struct virtio_scsi *vscsi, void *buf)
> @@ -894,6 +899,7 @@ static int virtscsi_init(struct virtio_device *vdev,
>         const char **names;
>         struct virtqueue **vqs;
>
> +       mutex_init(&vscsi->scan_lock);
>         num_vqs = vscsi->num_queues + VIRTIO_SCSI_VQ_BASE;
>         vqs = kmalloc(num_vqs * sizeof(struct virtqueue *), GFP_KERNEL);
>         callbacks = kmalloc(num_vqs * sizeof(vq_callback_t *), GFP_KERNEL);
> --
> 1.9.3


Nice find.

This fix does have the effect of serializing all event handling via
scan_lock; perhaps you want to instead create a singlethreaded
workqueue in virtio_scsi and queue handle_event there, rather than
waiting on scan_lock on the system workqueue?

Reviewed-by: Venkatesh Srinivas <venkateshs@google.com>

-- vs;

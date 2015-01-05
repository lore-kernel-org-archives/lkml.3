Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbbAEWLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:11:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbbAEWLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:11:08 -0500
Date: Tue, 6 Jan 2015 00:10:59 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: Fam Zheng <famz@redhat.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio-scsi: Fix the race condition in
 virtscsi_handle_event
Message-ID: <20150105221059.GB23518@redhat.com>
References: <1420437898-32419-1-git-send-email-famz@redhat.com>
 <CAHdzE-_QmNZVhmChHmy3FgRjJ692Apw2Va-SGoTz25s0fLjbvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHdzE-_QmNZVhmChHmy3FgRjJ692Apw2Va-SGoTz25s0fLjbvQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 11:48:47AM -0800, Venkatesh Srinivas wrote:
> On Sun, Jan 4, 2015 at 10:04 PM, Fam Zheng <famz@redhat.com> wrote:
> 
>     There is a race condition in virtscsi_handle_event, when many device
>     hotplug/unplug events flush in quickly.
> 
>     The scsi_remove_device in virtscsi_handle_transport_reset may trigger
>     the BUG_ON in scsi_target_reap, because the state is altered behind it,
>     probably by scsi_scan_host of another event. I'm able to reproduce it by
>     repeatedly plugging and unplugging a scsi disk with the same lun number.
> 
>     To make is safe, the mutex added in struct virtio_scsi is held in
>     virtscsi_handle_event, so that all the events are processed in a
>     synchronized way. With this lock, the panic goes away.
> 
>     Signed-off-by: Fam Zheng <famz@redhat.com>
>     ---
>      drivers/scsi/virtio_scsi.c | 6 ++++++
>      1 file changed, 6 insertions(+)
> 
>     diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>     index c52bb5d..7f194d4 100644
>     --- a/drivers/scsi/virtio_scsi.c
>     +++ b/drivers/scsi/virtio_scsi.c
>     @@ -110,6 +110,9 @@ struct virtio_scsi {
>             /* CPU hotplug notifier */
>             struct notifier_block nb;
> 
>     +       /* Protect the hotplug/unplug event handling */
>     +       struct mutex scan_lock;
>     +
>             /* Protected by event_vq lock */
>             bool stop_events;
> 
>     @@ -377,6 +380,7 @@ static void virtscsi_handle_event(struct work_struct
>     *work)
>             struct virtio_scsi *vscsi = event_node->vscsi;
>             struct virtio_scsi_event *event = &event_node->event;
> 
>     +       mutex_lock(&vscsi->scan_lock);
>             if (event->event &
>                 cpu_to_virtio32(vscsi->vdev, VIRTIO_SCSI_T_EVENTS_MISSED)) {
>                     event->event &= ~cpu_to_virtio32(vscsi->vdev,
>     @@ -397,6 +401,7 @@ static void virtscsi_handle_event(struct work_struct
>     *work)
>                     pr_err("Unsupport virtio scsi event %x\n", event->event);
>             }
>             virtscsi_kick_event(vscsi, event_node);
>     +       mutex_unlock(&vscsi->scan_lock);
>      }
> 
>      static void virtscsi_complete_event(struct virtio_scsi *vscsi, void *buf)
>     @@ -894,6 +899,7 @@ static int virtscsi_init(struct virtio_device *vdev,
>             const char **names;
>             struct virtqueue **vqs;
> 
>     +       mutex_init(&vscsi->scan_lock);
>             num_vqs = vscsi->num_queues + VIRTIO_SCSI_VQ_BASE;
>             vqs = kmalloc(num_vqs * sizeof(struct virtqueue *), GFP_KERNEL);
>             callbacks = kmalloc(num_vqs * sizeof(vq_callback_t *), GFP_KERNEL);
>     --
>     1.9.3
> 
> 
> Nice find.
> 
> This fix does have the effect of serializing all event handling via scan_lock;
> perhaps you want to instead create a singlethreaded workqueue in virtio_scsi
> and queue handle_event there, rather than waiting on scan_lock on the system
> workqueue?

Or use the system single-threaded wq.


> Reviewed-by: Venkatesh Srinivas <venkateshs@google.com>
> 
> -- vs;

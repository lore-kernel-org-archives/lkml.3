Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab3J1NiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:38:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037Ab3J1NiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:38:22 -0400
Date: Mon, 28 Oct 2013 14:41:13 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        kvm-devel <kvm@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, Asias He <asias@redhat.com>
Subject: Re: [PATCH] vhost/scsi: Fix incorrect usage of get_user_pages_fast
 write parameter
Message-ID: <20131028124113.GB19131@redhat.com>
References: <1382724436-28478-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382724436-28478-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 06:07:16PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch addresses a long-standing bug where the get_user_pages_fast()
> write parameter used for setting the underlying page table entry permission
> bits was incorrectly set to write=1 for data_direction=DMA_TO_DEVICE, and
> passed into get_user_pages_fast() via vhost_scsi_map_iov_to_sgl().
> 
> However, this parameter is intended to signal WRITEs to pinned userspace
> PTEs for the virtio-scsi DMA_FROM_DEVICE -> READ payload case, and *not*
> for the virtio-scsi DMA_TO_DEVICE -> WRITE payload case.
> 
> This bug would manifest itself as random process segmentation faults on
> KVM host after repeated vhost starts + stops and/or with lots of vhost
> endpoints + LUNs.
> 
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Asias He <asias@redhat.com>
> Cc: <stable@vger.kernel.org> # 3.6+
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/vhost/scsi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index ce5221f..e663921 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1056,7 +1056,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>  		if (data_direction != DMA_NONE) {
>  			ret = vhost_scsi_map_iov_to_sgl(cmd,
>  					&vq->iov[data_first], data_num,
> -					data_direction == DMA_TO_DEVICE);
> +					data_direction == DMA_FROM_DEVICE);
>  			if (unlikely(ret)) {
>  				vq_err(vq, "Failed to map iov to sgl\n");
>  				goto err_free;
> -- 
> 1.7.2.5

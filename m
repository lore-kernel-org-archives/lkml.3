Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967521Ab3E3Fey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 01:34:54 -0400
Received: from ozlabs.org ([203.10.76.45]:47105 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967474Ab3E3Fed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 01:34:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_pci: fix capability format, comments
In-Reply-To: <20130528080816.GA23399@redhat.com>
References: <20130528080816.GA23399@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 30 May 2013 11:03:38 +0930
Message-ID: <8738t5metp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> - queue size can actually be 0 which is not a power of 2

Actually, that points to a flaw in the code.  When we shut down the
queue, we should ideally reset it to what the device started with,
rather than 0.

See below.

> - fix capability format. PCI spec says:
> 	The layout of the information is vendor specific, except that the byte
> 	immediately following the “Next” pointer in the capability structure is
> 	defined to be a length field.
> 	This length field provides the number of bytes in the capability
> 	structure (including the ID and Next pointer bytes).

That part's definitely correct: applied.

Thanks,
Rusty.

Subjet: virtio_pci: save the desired ringsize.

MST points out that 0 isn't a power of 2.  This means we can't re-open
a virtio device once we write 0 into the queue length.

We should restore the amount the device originally asked for.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/virtio/virtio_pci-common.h b/drivers/virtio/virtio_pci-common.h
index ba1bf81..0e3143b 100644
--- a/drivers/virtio/virtio_pci-common.h
+++ b/drivers/virtio/virtio_pci-common.h
@@ -82,6 +82,9 @@ struct virtio_pci_vq_info {
 
 	/* MSI-X vector (or none) */
 	unsigned msix_vector;
+
+	/* What size did the device *want* this to be? */
+	u16 desired_num;
 };
 
 /* the notify function used when creating a virt queue */
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 0f0e3a6..8b35c2e 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -230,6 +230,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 		return ERR_PTR(-ENOMEM);
 
 	info->msix_vector = msix_vec;
+	info->desired_num = num;
 
 	/* get offset of notification word for this vq (shouldn't wrap) */
 	off = ioread16(&vp_dev->common->queue_notify_off);
@@ -350,7 +351,7 @@ static void del_vq(struct virtqueue *vq)
 	vring_del_virtqueue(vq);
 
 	/* This is for our own benefit, not the device's! */
-	iowrite16(0, &vp_dev->common->queue_size);
+	iowrite16(info->desired_num, &vp_dev->common->queue_size);
 	iowrite64_twopart(0, &vp_dev->common->queue_desc);
 	iowrite64_twopart(0, &vp_dev->common->queue_avail);
 	iowrite64_twopart(0, &vp_dev->common->queue_used);

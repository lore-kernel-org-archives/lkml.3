Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaJNGx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 02:53:59 -0400
Received: from ozlabs.org ([103.22.144.67]:52939 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbaJNGxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 02:53:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 04/25] virtio: defer config changed notifications
In-Reply-To: <1413114332-626-5-git-send-email-mst-v4@redhat.com>
References: <1413114332-626-1-git-send-email-mst-v4@redhat.com> <1413114332-626-5-git-send-email-mst-v4@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 14 Oct 2014 11:01:12 +1030
Message-ID: <87lhojcx0v.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> Defer config changed notifications that arrive during
> probe/scan/freeze/restore.
>
> This will allow drivers to set DRIVER_OK earlier, without worrying about
> racing with config change interrupts.
>
> This change will also benefit old hypervisors (before 2009)
> that send interrupts without checking DRIVER_OK: previously,
> the callback could race with driver-specific initialization.
>
> This will also help simplify drivers.

But AFAICT you never *read* dev->config_changed.

You unconditionally trigger a config_changed event in
virtio_config_enable().  That's a bit weird, but probably OK.

How about the following change (on top of your patch).  I
think the renaming is clearer, and note the added if() test in
virtio_config_enable().

If you approve, I'll fold it in.

Cheers,
Rusty.

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 2536701b098b..df598dd8c5c8 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -122,7 +122,7 @@ static void __virtio_config_changed(struct virtio_device *dev)
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
 
 	if (!dev->config_enabled)
-		dev->config_changed = true;
+		dev->config_change_pending = true;
 	else if (drv && drv->config_changed)
 		drv->config_changed(dev);
 }
@@ -148,8 +148,9 @@ static void virtio_config_enable(struct virtio_device *dev)
 {
 	spin_lock_irq(&dev->config_lock);
 	dev->config_enabled = true;
-	__virtio_config_changed(dev);
-	dev->config_changed = false;
+	if (dev->config_change_pending)
+		__virtio_config_changed(dev);
+	dev->config_change_pending = false;
 	spin_unlock_irq(&dev->config_lock);
 }
 
@@ -253,7 +254,7 @@ int register_virtio_device(struct virtio_device *dev)
 
 	spin_lock_init(&dev->config_lock);
 	dev->config_enabled = false;
-	dev->config_changed = false;
+	dev->config_change_pending = false;
 
 	/* We always start by resetting the device, in case a previous
 	 * driver messed it up.  This also tests that code path a little. */
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 5636b119dc25..65261a7244fc 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -80,7 +80,7 @@ bool virtqueue_is_broken(struct virtqueue *vq);
  * @index: unique position on the virtio bus
  * @failed: saved value for CONFIG_S_FAILED bit (for restore)
  * @config_enabled: configuration change reporting enabled
- * @config_changed: configuration change reported while disabled
+ * @config_change_pending: configuration change reported while disabled
  * @config_lock: protects configuration change reporting
  * @dev: underlying device.
  * @id: the device type identification (used to match it with a driver).
@@ -94,7 +94,7 @@ struct virtio_device {
 	int index;
 	bool failed;
 	bool config_enabled;
-	bool config_changed;
+	bool config_change_pending;
 	spinlock_t config_lock;
 	struct device dev;
 	struct virtio_device_id id;

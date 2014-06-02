Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaFBV34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:29:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbaFBV3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:29:52 -0400
Date: Tue, 3 Jun 2014 00:30:18 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PULL 2/2] vhost: replace rcu with mutex
Message-ID: <1401744482-17764-3-git-send-email-mst@redhat.com>
References: <1401744482-17764-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401744482-17764-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All memory accesses are done under some VQ mutex.
So lock/unlock all VQs is a faster equivalent of synchronize_rcu()
for memory access changes.
Some guests cause a lot of these changes, so it's helpful
to make them faster.

Reported-by: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 78987e4..1c05e60 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -593,6 +593,7 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 {
 	struct vhost_memory mem, *newmem, *oldmem;
 	unsigned long size = offsetof(struct vhost_memory, regions);
+	int i;
 
 	if (copy_from_user(&mem, m, size))
 		return -EFAULT;
@@ -619,7 +620,14 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 	oldmem = rcu_dereference_protected(d->memory,
 					   lockdep_is_held(&d->mutex));
 	rcu_assign_pointer(d->memory, newmem);
-	synchronize_rcu();
+
+	/* All memory accesses are done under some VQ mutex.
+	 * So below is a faster equivalent of synchronize_rcu()
+	 */
+	for (i = 0; i < d->nvqs; ++i) {
+		mutex_lock(&d->vqs[i]->mutex);
+		mutex_unlock(&d->vqs[i]->mutex);
+	}
 	kfree(oldmem);
 	return 0;
 }
-- 
MST


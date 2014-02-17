Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaBQUYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:24:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbaBQUYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:24:15 -0500
Subject: [PATCH 4/4] kvm/vfio: Support for DMA coherent IOMMUs
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com, kvm@vger.kernel.org
Cc: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 17 Feb 2014 13:24:12 -0700
Message-ID: <20140217202412.22775.77911.stgit@bling.home>
In-Reply-To: <20140217201324.22775.31904.stgit@bling.home>
References: <20140217201324.22775.31904.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO now has support for using the IOMMU_CACHE flag and a mechanism
for an external user to test the current operating mode of the IOMMU.
Add support for this to the kvm-vfio pseudo device so that we only
register noncoherent DMA when necessary.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/vfio.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index b4f9507..ba1a93f 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -59,6 +59,22 @@ static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
 	symbol_put(vfio_group_put_external_user);
 }
 
+static bool kvm_vfio_group_is_coherent(struct vfio_group *vfio_group)
+{
+	long (*fn)(struct vfio_group *, unsigned long);
+	long ret;
+
+	fn = symbol_get(vfio_external_check_extension);
+	if (!fn)
+		return false;
+
+	ret = fn(vfio_group, VFIO_DMA_CC_IOMMU);
+
+	symbol_put(vfio_external_check_extension);
+
+	return ret > 0;
+}
+
 /*
  * Groups can use the same or different IOMMU domains.  If the same then
  * adding a new group may change the coherency of groups we've previously
@@ -75,13 +91,10 @@ static void kvm_vfio_update_coherency(struct kvm_device *dev)
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
-		/*
-		 * TODO: We need an interface to check the coherency of
-		 * the IOMMU domain this group is using.  For now, assume
-		 * it's always noncoherent.
-		 */
-		noncoherent = true;
-		break;
+		if (!kvm_vfio_group_is_coherent(kvg->vfio_group)) {
+			noncoherent = true;
+			break;
+		}
 	}
 
 	if (noncoherent != kv->noncoherent) {


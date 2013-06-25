Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3FYTG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:06:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3FYSdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 37/95] drm/radeon: do not try to uselessly update virtual memory pagetable
Date: Tue, 25 Jun 2013 11:32:24 -0700
Message-Id: <20130625182157.851388424@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 3813f5ca9ab7a00e80a17aab34f155453c66c78a upstream.

If a buffer is never bound to a virtual memory pagetable than don't try
to unbind it. Only drawback is that we don't update the pagetable when
unbinding the ib pool buffer which is fine because it only happens at
suspend or module unload/shutdown.

Fixes spurious messages about buffers without VM mappings. E.g.:
radeon 0000:01:00.0: bo ffff88020afac400 don't has a mapping in vm ffff88021ca2b900

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_gart.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -1197,11 +1197,13 @@ int radeon_vm_bo_update_pte(struct radeo
 int radeon_vm_bo_rmv(struct radeon_device *rdev,
 		     struct radeon_bo_va *bo_va)
 {
-	int r;
+	int r = 0;
 
 	mutex_lock(&rdev->vm_manager.lock);
 	mutex_lock(&bo_va->vm->mutex);
-	r = radeon_vm_bo_update_pte(rdev, bo_va->vm, bo_va->bo, NULL);
+	if (bo_va->soffset) {
+		r = radeon_vm_bo_update_pte(rdev, bo_va->vm, bo_va->bo, NULL);
+	}
 	mutex_unlock(&rdev->vm_manager.lock);
 	list_del(&bo_va->vm_list);
 	mutex_unlock(&bo_va->vm->mutex);



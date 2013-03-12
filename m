Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986Ab3CLXNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:13:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933523Ab3CLWdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Subject: [ 046/100] drm/radeon: dont set hpd, afmt interrupts when interrupts are disabled
Date: Tue, 12 Mar 2013 15:31:31 -0700
Message-Id: <20130312223127.953444908@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit cc9945bf9cac03860b2f7d59882263c965c6e3af upstream.

Avoids splatter if the interrupt handler is not registered due
to acceleration being disabled.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_irq_kms.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
@@ -400,6 +400,9 @@ void radeon_irq_kms_enable_afmt(struct r
 {
 	unsigned long irqflags;
 
+	if (!rdev->ddev->irq_enabled)
+		return;
+
 	spin_lock_irqsave(&rdev->irq.lock, irqflags);
 	rdev->irq.afmt[block] = true;
 	radeon_irq_set(rdev);
@@ -419,6 +422,9 @@ void radeon_irq_kms_disable_afmt(struct
 {
 	unsigned long irqflags;
 
+	if (!rdev->ddev->irq_enabled)
+		return;
+
 	spin_lock_irqsave(&rdev->irq.lock, irqflags);
 	rdev->irq.afmt[block] = false;
 	radeon_irq_set(rdev);
@@ -438,6 +444,9 @@ void radeon_irq_kms_enable_hpd(struct ra
 	unsigned long irqflags;
 	int i;
 
+	if (!rdev->ddev->irq_enabled)
+		return;
+
 	spin_lock_irqsave(&rdev->irq.lock, irqflags);
 	for (i = 0; i < RADEON_MAX_HPD_PINS; ++i)
 		rdev->irq.hpd[i] |= !!(hpd_mask & (1 << i));
@@ -458,6 +467,9 @@ void radeon_irq_kms_disable_hpd(struct r
 	unsigned long irqflags;
 	int i;
 
+	if (!rdev->ddev->irq_enabled)
+		return;
+
 	spin_lock_irqsave(&rdev->irq.lock, irqflags);
 	for (i = 0; i < RADEON_MAX_HPD_PINS; ++i)
 		rdev->irq.hpd[i] &= !(hpd_mask & (1 << i));



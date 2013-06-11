Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3FKQC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:02:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab3FKQBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:01:50 -0400
Subject: [PATCH 2/3] vfio: Ignore sprurious notifies
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 11 Jun 2013 10:01:48 -0600
Message-ID: <20130611160148.9995.96816.stgit@bling.home>
In-Reply-To: <20130611155848.9995.41709.stgit@bling.home>
References: <20130611155848.9995.41709.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove debugging WARN_ON if we get a spurious notify for a group that
no longer exists.  No reports of anyone hitting this, but it would
likely be a race and not a bug if they did.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 1bed313..2edfecc 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -508,13 +508,11 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
 	struct device *dev = data;
 
 	/*
-	 * Need to go through a group_lock lookup to get a reference or
-	 * we risk racing a group being removed.  Leave a WARN_ON for
-	 * debuging, but if the group no longer exists, a spurious notify
-	 * is harmless.
+	 * Need to go through a group_lock lookup to get a reference or we
+	 * risk racing a group being removed.  Ignore spurious notifies.
 	 */
 	group = vfio_group_try_get(group);
-	if (WARN_ON(!group))
+	if (!group)
 		return NOTIFY_OK;
 
 	switch (action) {


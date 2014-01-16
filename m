Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaAPQZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:25:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbaAPQYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:24:43 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, riel@redhat.com, aarcange@redhat.com,
        aquini@redhat.com, mst@redhat.com, rusty@rustcorp.com.au,
        vdavydov@parallels.com, amit.shah@redhat.com, dfediuck@redhat.com,
        agl@us.ibm.com
Subject: [RFC PATCH 4/4] virtio_balloon: skip inflation if guest is under pressure
Date: Thu, 16 Jan 2014 11:24:05 -0500
Message-Id: <1389889445-3855-5-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1389889445-3855-1-git-send-email-lcapitulino@redhat.com>
References: <1389889445-3855-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luiz capitulino <lcapitulino@redhat.com>

This is necessary for automatic ballooning. If the guest gets
under pressure while there's an on-going inflation operation,
we want the guest to do the following:

 1. Stop on-going inflation
 2. Notify the host we're under pressure
 3. Wait for host's acknowledge

While the guest is waiting the host has the opportunity to
reset num_pages to a value before the guest got into pressure.
This will cancel current inflation.

Signed-off-by: Luiz capitulino <lcapitulino@redhat.com>
---
 drivers/virtio/virtio_balloon.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 1c3ee71..7f5b7d2 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -188,8 +188,13 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
 	mutex_lock(&vb->balloon_lock);
 	for (vb->num_pfns = 0; vb->num_pfns < num;
 	     vb->num_pfns += VIRTIO_BALLOON_PAGES_PER_PAGE) {
-		struct page *page = balloon_page_enqueue(vb_dev_info);
+	     	struct page *page;
 
+	     	if (guest_under_pressure(vb)) {
+			break;
+		}
+
+		page = balloon_page_enqueue(vb_dev_info);
 		if (!page) {
 			dev_info_ratelimited(&vb->vdev->dev,
 					     "Out of puff! Can't get %u pages\n",
-- 
1.8.1.4


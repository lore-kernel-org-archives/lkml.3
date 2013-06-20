Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab3FTFJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:09:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab3FTFJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:09:27 -0400
From: Jason Wang <jasowang@redhat.com>
To: kys@microsoft.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: haiyangz@microsoft.com, Jason Wang <jasowang@redhat.com>
Subject: [PATCH] drivers: hv: check interrupt mask before read_index
Date: Thu, 20 Jun 2013 12:58:57 +0800
Message-Id: <1371704337-46108-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches add a read barriers to force the driver to check the interrupt mask
before read_index. Otherwise we may lost a kick to host.

Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/hv/ring_buffer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 791f45d..26c93cf 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -75,6 +75,8 @@ static bool hv_need_to_signal(u32 old_write, struct hv_ring_buffer_info *rbi)
 	if (rbi->ring_buffer->interrupt_mask)
 		return false;
 
+	/* check interrupt_mask before read_index */
+	rmb();
 	/*
 	 * This is the only case we need to signal when the
 	 * ring transitions from being empty to non-empty.
-- 
1.7.1


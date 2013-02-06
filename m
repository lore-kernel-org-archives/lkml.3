Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845Ab3BFUGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:06:11 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:42423 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964826Ab3BFTuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:05 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 28/77] firewire: add minor number range check to fw_device_init()
Date: Wed,  6 Feb 2013 11:40:00 -0800
Message-Id: <1360179649-22465-29-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fw_device_init() didn't check whether the allocated minor number isn't
too large.  Fail if it goes overflows MINORBITS.

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: stable@vger.kernel.org
---
 drivers/firewire/core-device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
index 3873d53..af3e8aa 100644
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -1020,6 +1020,10 @@ static void fw_device_init(struct work_struct *work)
 	ret = idr_pre_get(&fw_device_idr, GFP_KERNEL) ?
 	      idr_get_new(&fw_device_idr, device, &minor) :
 	      -ENOMEM;
+	if (minor >= 1 << MINORBITS) {
+		idr_remove(&fw_device_idr, minor);
+		minor = -ENOSPC;
+	}
 	up_write(&fw_device_rwsem);
 
 	if (ret < 0)
-- 
1.8.1


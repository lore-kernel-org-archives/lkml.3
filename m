Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaBMXdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:33:32 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:51361
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbaBMXdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:33:31 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: Ballon: Make pressure posting thread sleep interruptibly
Date: Thu, 13 Feb 2014 16:24:33 -0800
Message-Id: <1392337473-27216-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The non-interruptible sleep of the memory pressure posting thread
results in higher reported load average. Make this sleep interruptible.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/hv_balloon.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 7e17a54..7e6d78d 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1171,7 +1171,8 @@ static int dm_thread_func(void *dm_dev)
 	int t;
 
 	while (!kthread_should_stop()) {
-		t = wait_for_completion_timeout(&dm_device.config_event, 1*HZ);
+		t = wait_for_completion_interruptible_timeout(
+						&dm_device.config_event, 1*HZ);
 		/*
 		 * The host expects us to post information on the memory
 		 * pressure every second.
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965006Ab3GLNmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:42:40 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:36092
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964802Ab3GLNmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:42:37 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Stable <stable@vger.kernel.org>
Subject: [PATCH 1/2] Drivers: hv: balloon: Fix a bug in the hot-add code
Date: Fri, 12 Jul 2013 06:56:14 -0700
Message-Id: <1373637375-25936-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1373637292-25855-1-git-send-email-kys@microsoft.com>
References: <1373637292-25855-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we hot-add 128 MB chunks of memory, we wait to ensure that the memory
is onlined before attempting to hot-add the next chunk. If the udev rule for
memory hot-add is not executed within the allowed time, we would rollback the
state and abort further hot-add. Since the hot-add has succeeded and the only
failure is that the memory is not onlined within the allowed time, we should not
be rolling back the state. Fix this bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/hv/hv_balloon.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 4c605c7..bfc7be2 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -562,7 +562,7 @@ static void hv_mem_hot_add(unsigned long start, unsigned long size,
 				struct hv_hotadd_state *has)
 {
 	int ret = 0;
-	int i, nid, t;
+	int i, nid;
 	unsigned long start_pfn;
 	unsigned long processed_pfn;
 	unsigned long total_pfn = pfn_count;
@@ -608,13 +608,7 @@ static void hv_mem_hot_add(unsigned long start, unsigned long size,
 		/*
 		 * Wait for the memory block to be onlined.
 		 */
-		t = wait_for_completion_timeout(&dm_device.ol_waitevent, 5*HZ);
-		if (t == 0) {
-			pr_info("hot_add memory timedout\n");
-			has->ha_end_pfn -= HA_CHUNK;
-			has->covered_end_pfn -=  processed_pfn;
-			break;
-		}
+		wait_for_completion_timeout(&dm_device.ol_waitevent, 5*HZ);
 
 	}
 
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030234Ab3HBKKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:10:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030214Ab3HBKKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:10:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [ 56/99] Drivers: hv: balloon: Fix a bug in the hot-add code
Date: Fri,  2 Aug 2013 18:08:09 +0800
Message-Id: <20130802100233.848765575@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit ed07ec93e83ec471d365ce084e43ad90fd205903 upstream.

As we hot-add 128 MB chunks of memory, we wait to ensure that the memory
is onlined before attempting to hot-add the next chunk. If the udev rule for
memory hot-add is not executed within the allowed time, we would rollback the
state and abort further hot-add. Since the hot-add has succeeded and the only
failure is that the memory is not onlined within the allowed time, we should not
be rolling back the state. Fix this bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/hv_balloon.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -562,7 +562,7 @@ static void hv_mem_hot_add(unsigned long
 				struct hv_hotadd_state *has)
 {
 	int ret = 0;
-	int i, nid, t;
+	int i, nid;
 	unsigned long start_pfn;
 	unsigned long processed_pfn;
 	unsigned long total_pfn = pfn_count;
@@ -607,14 +607,11 @@ static void hv_mem_hot_add(unsigned long
 
 		/*
 		 * Wait for the memory block to be onlined.
+		 * Since the hot add has succeeded, it is ok to
+		 * proceed even if the pages in the hot added region
+		 * have not been "onlined" within the allowed time.
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
 



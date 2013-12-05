Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708Ab3LESAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:00:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38099 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab3LERgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:36:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaron Lu <aaron.lu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 14/90] PM / hibernate: Avoid overflow in hibernate_preallocate_memory()
Date: Thu,  5 Dec 2013 17:34:56 +0000
Message-Id: <1386264972-5399-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

commit fd432b9f8c7c88428a4635b9f5a9c6e174df6e36 upstream.

When system has a lot of highmem (e.g. 16GiB using a 32 bits kernel),
the code to calculate how much memory we need to preallocate in
normal zone may cause overflow. As Leon has analysed:

 It looks that during computing 'alloc' variable there is overflow:
 alloc = (3943404 - 1970542) - 1978280 = -5418 (signed)
 And this function goes to err_out.

Fix this by avoiding that overflow.

References: https://bugzilla.kernel.org/show_bug.cgi?id=60817
Reported-and-tested-by: Leon Drugi <eyak@wp.pl>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/power/snapshot.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 0de2857..91c04f1 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1398,7 +1398,11 @@ int hibernate_preallocate_memory(void)
 	 * highmem and non-highmem zones separately.
 	 */
 	pages_highmem = preallocate_image_highmem(highmem / 2);
-	alloc = (count - max_size) - pages_highmem;
+	alloc = count - max_size;
+	if (alloc > pages_highmem)
+		alloc -= pages_highmem;
+	else
+		alloc = 0;
 	pages = preallocate_image_memory(alloc, avail_normal);
 	if (pages < alloc) {
 		/* We have exhausted non-highmem pages, try highmem. */
-- 
1.8.3.2


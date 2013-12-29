Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab3L2CVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:21:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55641 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661Ab3L2CLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:14 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Aaron Lu" <aaron.lu@intel.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.714543931@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 031/185] PM / hibernate: Avoid overflow in
 hibernate_preallocate_memory()
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/power/snapshot.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1390,7 +1390,11 @@ int hibernate_preallocate_memory(void)
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


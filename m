Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab3LBUCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:02:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3LBTR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaron Lu <aaron.lu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.12 096/212] PM / hibernate: Avoid overflow in hibernate_preallocate_memory()
Date: Mon,  2 Dec 2013 11:14:47 -0800
Message-Id: <20131202191258.182492963@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/snapshot.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1402,7 +1402,11 @@ int hibernate_preallocate_memory(void)
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



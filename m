Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaKXErJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 23:47:09 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:56040
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaKXErI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 23:47:08 -0500
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, kys@microsoft.com
Cc: haiyangz@microsoft.com
Subject: [PATCH] hv: hv_balloon: avoid memory leak on alloc_error of 2MB memory block
Date: Sun, 23 Nov 2014 21:56:15 -0800
Message-Id: <1416808575-5383-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If num_ballooned is not 0, we shouldn't neglect the already-allocated 2MB
memory block(s).

Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/hv/hv_balloon.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 5e90c5d..cba2d3b 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -1091,6 +1091,8 @@ static void balloon_up(struct work_struct *dummy)
 	bool done = false;
 	int i;
 
+	/* The host does balloon_up in 2MB. */
+	WARN_ON(num_pages % PAGES_IN_2M != 0);
 
 	/*
 	 * We will attempt 2M allocations. However, if we fail to
@@ -1111,7 +1113,7 @@ static void balloon_up(struct work_struct *dummy)
 						bl_resp, alloc_unit,
 						 &alloc_error);
 
-		if ((alloc_error) && (alloc_unit != 1)) {
+		if (alloc_error && (alloc_unit != 1) && num_ballooned == 0) {
 			alloc_unit = 1;
 			continue;
 		}
-- 
1.9.1


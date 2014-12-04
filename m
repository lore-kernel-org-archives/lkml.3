Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbaLDRuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:50:37 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33386
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164AbaLDRuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:50:35 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 1/3] Drivers: hv: hv_balloon: Make adjustments in computing the floor
Date: Thu,  4 Dec 2014 11:00:22 -0800
Message-Id: <1417719624-7792-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1417719603-7751-1-git-send-email-kys@microsoft.com>
References: <1417719603-7751-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make adjustments in computing the balloon floor. The current computation
of the balloon floor was not appropriate for virtual machines with more than
10 GB of assigned memory - we would get into situations where the host would
agressively balloon down the guest and leave the guest in an unusable state.
This patch fixes the issue by raising the floor.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/hv_balloon.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index b958ded..9cbbb83 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -928,9 +928,8 @@ static unsigned long compute_balloon_floor(void)
 	 *     128        72    (1/2)
 	 *     512       168    (1/4)
 	 *    2048       360    (1/8)
-	 *    8192       552    (1/32)
-	 *   32768      1320
-	 *  131072      4392
+	 *    8192       768    (1/16)
+	 *   32768      1536	(1/32)
 	 */
 	if (totalram_pages < MB2PAGES(128))
 		min_pages = MB2PAGES(8) + (totalram_pages >> 1);
@@ -938,8 +937,10 @@ static unsigned long compute_balloon_floor(void)
 		min_pages = MB2PAGES(40) + (totalram_pages >> 2);
 	else if (totalram_pages < MB2PAGES(2048))
 		min_pages = MB2PAGES(104) + (totalram_pages >> 3);
+	else if (totalram_pages < MB2PAGES(8192))
+		min_pages = MB2PAGES(256) + (totalram_pages >> 4);
 	else
-		min_pages = MB2PAGES(296) + (totalram_pages >> 5);
+		min_pages = MB2PAGES(512) + (totalram_pages >> 5);
 #undef MB2PAGES
 	return min_pages;
 }
-- 
1.7.4.1


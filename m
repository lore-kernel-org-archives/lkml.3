Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab3GRLJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 07:09:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16845 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758756Ab3GRLJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:09:49 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-3c-51e7ccfb7e16
From: Piotr Sarna <p.sarna@partner.samsung.com>
To: dan.magenheimer@oracle.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        b.zolnierkie@samsung.com, Piotr Sarna <p.sarna@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] zcache: fix "zcache=" kernel parameter
Date: Thu, 18 Jul 2013 13:09:19 +0200
Message-id: <1374145759-21105-1-git-send-email-p.sarna@partner.samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t9jAd3fZ54HGmw9JmqxccZ6Voufrzey
	Wew584vd4mzTG3aLy7vmsFmsWhTlwOZxb99hFo+PT2+xeBx8t4fJo2/LKkaPz5vkAlijuGxS
	UnMyy1KL9O0SuDLm7J/JWLCBt+L6ar0Gxk7uLkZODgkBE4lTTzewQ9hiEhfurWfrYuTiEBJY
	xCgxYcsqVginnUmi88N8sCo2AX2JL9fXsIDYIgJyEkvm3GUCsZkFNjBKnHigDmILC5hLzGpa
	wghiswioSiyZ/ZgZxOYV8JZ4ungG0BwOoG0KEnMm2Uxg5F7AyLCKUTS1ILmgOCk910ivODG3
	uDQvXS85P3cTIzgsnknvYFzVYHGIUYCDUYmH9wbP80Ah1sSy4srcQ4wSHMxKIrzf9gGFeFMS
	K6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2CyTJxcEo1MDrcPT67NuDz3pj6
	bSpVU/5N2sEe9+FKwq6fC38+ybpwvefViyrF1bPzft2bflz9xaIu6Rt/Xj+XMs7rFuJITnyi
	LKvx2EZ+xkdxdoft/Pv4o56HyjNyPXxReCN0+WvtHcxzZy89sPy0XvzP+m0N/VGzow7dCWfP
	Ypx0dYpRbMfTafEbjn1tKP2sxFKckWioxVxUnAgApeDlGwcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 835f2f5 ("staging: zcache: enable zcache to be built/loaded as
a module") introduced an incorrect handling of "zcache=" parameter.

Inside zcache_comp_init() function, zcache_comp_name variable is
checked for being empty. If not empty, the above variable is tested
for being compatible with Crypto API. Unfortunately, after that
function ends unconditionally (by the "goto out" directive) and returns:
- non-zero value if verification succeeded, wrongly indicating an error
- zero value if verification failed, falsely informing that function
  zcache_comp_init() ended properly.

A solution to this problem is as following:
1. Move the "goto out" directive inside the "if (!ret)" statement
2. In case that crypto_has_comp() returned 0, change the value of ret
   to non-zero before "goto out" to indicate an error.

Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/staging/zcache/zcache-main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index dcceed2..81972fa 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1811,10 +1811,12 @@ static int zcache_comp_init(void)
 #else
 	if (*zcache_comp_name != '\0') {
 		ret = crypto_has_comp(zcache_comp_name, 0, 0);
-		if (!ret)
+		if (!ret) {
 			pr_info("zcache: %s not supported\n",
 					zcache_comp_name);
-		goto out;
+			ret = 1;
+			goto out;
+		}
 	}
 	if (!ret)
 		strcpy(zcache_comp_name, "lzo");
-- 
1.7.9.5


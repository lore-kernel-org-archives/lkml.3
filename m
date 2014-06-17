Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965432AbaFQQ1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:27:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51077 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965322AbaFQQ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:27:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sergey Popovich <popovich_sergei@mail.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 071/121] ipv4: fib_semantics: increment fib_info_cnt after fib_info allocation
Date: Tue, 17 Jun 2014 09:17:29 -0700
Message-Id: <1403021899-16708-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Popovich <popovich_sergei@mail.ru>

[ Upstream commit aeefa1ecfc799b0ea2c4979617f14cecd5cccbfd ]

Increment fib_info_cnt in fib_create_info() right after successfuly
alllocating fib_info structure, overwise fib_metrics allocation failure
leads to fib_info_cnt incorrectly decremented in free_fib_info(), called
on error path from fib_create_info().

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 4797a80..43502e6 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -820,13 +820,13 @@ struct fib_info *fib_create_info(struct fib_config *cfg)
 	fi = kzalloc(sizeof(*fi)+nhs*sizeof(struct fib_nh), GFP_KERNEL);
 	if (fi == NULL)
 		goto failure;
+	fib_info_cnt++;
 	if (cfg->fc_mx) {
 		fi->fib_metrics = kzalloc(sizeof(u32) * RTAX_MAX, GFP_KERNEL);
 		if (!fi->fib_metrics)
 			goto failure;
 	} else
 		fi->fib_metrics = (u32 *) dst_default_metrics;
-	fib_info_cnt++;
 
 	fi->fib_net = hold_net(net);
 	fi->fib_protocol = cfg->fc_protocol;
-- 
1.9.1


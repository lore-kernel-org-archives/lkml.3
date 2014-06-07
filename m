Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaFGB1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:27:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36172 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sergey Popovich" <popovich_sergei@mail.ru>,
        "David S. Miller" <davem@davemloft.net>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.159204002@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 21/92] ipv4: fib_semantics: increment fib_info_cnt
 after  fib_info allocation
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Popovich <popovich_sergei@mail.ru>

[ Upstream commit aeefa1ecfc799b0ea2c4979617f14cecd5cccbfd ]

Increment fib_info_cnt in fib_create_info() right after successfuly
alllocating fib_info structure, overwise fib_metrics allocation failure
leads to fib_info_cnt incorrectly decremented in free_fib_info(), called
on error path from fib_create_info().

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index d01f9c6..76da979 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -752,13 +752,13 @@ struct fib_info *fib_create_info(struct fib_config *cfg)
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


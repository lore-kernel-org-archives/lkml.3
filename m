Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbaHHKOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:14:39 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:7447 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756188AbaHHKLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:11:12 -0400
X-IronPort-AV: E=Sophos;i="5.01,824,1400018400"; 
   d="scan'208";a="88704751"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 7/14] cpu: delete unneeded test before of_node_put
Date: Fri,  8 Aug 2014 12:07:44 +0200
Message-Id: <1407492475-26283-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Simplify the error path to avoid calling of_node_put when it is not needed.

The semantic patch that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@

-if (e)
   of_node_put(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/powerpc/sysdev/ppc4xx_cpm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/sysdev/ppc4xx_cpm.c b/arch/powerpc/sysdev/ppc4xx_cpm.c
index 82e2cfe..ba95adf 100644
--- a/arch/powerpc/sysdev/ppc4xx_cpm.c
+++ b/arch/powerpc/sysdev/ppc4xx_cpm.c
@@ -281,7 +281,7 @@ static int __init cpm_init(void)
 		printk(KERN_ERR "cpm: could not parse dcr property for %s\n",
 		       np->full_name);
 		ret = -EINVAL;
-		goto out;
+		goto node_put;
 	}
 
 	cpm.dcr_host = dcr_map(np, dcr_base, dcr_len);
@@ -290,7 +290,7 @@ static int __init cpm_init(void)
 		printk(KERN_ERR "cpm: failed to map dcr property for %s\n",
 		       np->full_name);
 		ret = -EINVAL;
-		goto out;
+		goto node_put;
 	}
 
 	/* All 4xx SoCs with a CPM controller have one of two
@@ -330,9 +330,9 @@ static int __init cpm_init(void)
 
 	if (cpm.standby || cpm.suspend)
 		suspend_set_ops(&cpm_suspend_ops);
+node_put:
+	of_node_put(np);
 out:
-	if (np)
-		of_node_put(np);
 	return ret;
 }
 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaHKH51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 03:57:27 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:41983 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101AbaHKH50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 03:57:26 -0400
X-IronPort-AV: E=Sophos;i="5.01,839,1400018400"; 
   d="scan'208";a="88937826"
Date: Mon, 11 Aug 2014 09:56:54 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 7/14 v2] powerpc/4xx/cpm: delete unneeded test before
 of_node_put
In-Reply-To: <1407725796.4508.54.camel@pasglop>
Message-ID: <alpine.DEB.2.10.1408110956090.2316@hadrien>
References: <1407492475-26283-3-git-send-email-Julia.Lawall@lip6.fr> <1407725796.4508.54.camel@pasglop>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
v2: new subject

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



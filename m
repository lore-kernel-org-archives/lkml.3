Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3AUMDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:03:21 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:56528
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753261Ab3AUMDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:03:14 -0500
X-IronPort-AV: E=Sophos;i="4.84,506,1355094000"; 
   d="scan'208";a="169187835"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Solarflare linux maintainers <linux-net-drivers@solarflare.com>
Cc: kernel-janitors@vger.kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/15] drivers/net/ethernet/sfc/ptp.c: adjust duplicate test
Date: Mon, 21 Jan 2013 14:02:48 +0100
Message-Id: <1358773378-4700-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive tests to the same location.  rc was previously tested and
not subsequently updated.  efx_phc_adjtime can return an error code, so the
call is updated so that is tested instead.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@s exists@
local idexpression y;
expression x,e;
@@

*if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
 { ... when forall
   return ...; }
... when != \(y = e\|y += e\|y -= e\|y |= e\|y &= e\|y++\|y--\|&y\)
    when != \(XT_GETPAGE(...,y)\|WMI_CMD_BUF(...)\)
*if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
 { ... when forall
   return ...; }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.  I'm not familiar with this function, so I don't know whether it
is desirable to test its result.

 drivers/net/ethernet/sfc/ptp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 0767043..3f93624 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1439,7 +1439,7 @@ static int efx_phc_settime(struct ptp_clock_info *ptp,
 
 	delta = timespec_sub(*e_ts, time_now);
 
-	efx_phc_adjtime(ptp, timespec_to_ns(&delta));
+	rc = efx_phc_adjtime(ptp, timespec_to_ns(&delta));
 	if (rc != 0)
 		return rc;
 


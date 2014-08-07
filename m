Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbaHGNbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:31:37 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:63595 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757223AbaHGNbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:31:36 -0400
X-IronPort-AV: E=Sophos;i="5.01,818,1400018400"; 
   d="scan'208";a="88604162"
Date: Thu, 7 Aug 2014 15:31:05 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
cc: kernel-janitors@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] drivers/atm/atmtcp.c: fix error return code
In-Reply-To: <20140807091012.793ef5c7@thirdoffive.cmf.nrl.navy.mil>
Message-ID: <alpine.DEB.2.10.1408071530230.2337@hadrien>
References: <1407415749-19978-1-git-send-email-Julia.Lawall@lip6.fr> <1407415749-19978-3-git-send-email-Julia.Lawall@lip6.fr> <20140807091012.793ef5c7@thirdoffive.cmf.nrl.navy.mil>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert a zero return value on error to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
v2; changed error code to -EUNATCH

 drivers/atm/atmtcp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/atm/atmtcp.c b/drivers/atm/atmtcp.c
index 0e3f8f9..c8e4fb4 100644
--- a/drivers/atm/atmtcp.c
+++ b/drivers/atm/atmtcp.c
@@ -299,6 +299,7 @@ static int atmtcp_c_send(struct atm_vcc *vcc,struct sk_buff *skb)
 	out_vcc = find_vcc(dev, ntohs(hdr->vpi), ntohs(hdr->vci));
 	read_unlock(&vcc_sklist_lock);
 	if (!out_vcc) {
+		result = -EUNATCH;
 		atomic_inc(&vcc->stats->tx_err);
 		goto done;
 	}


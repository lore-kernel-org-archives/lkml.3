Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3AUMDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:03:18 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:41316
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752866Ab3AUMDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:03:13 -0500
X-IronPort-AV: E=Sophos;i="4.84,506,1355094000"; 
   d="scan'208";a="169187840"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: kernel-janitors@vger.kernel.org,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 9/14] drivers/ipack/devices/ipoctal.c: adjust duplicate test
Date: Mon, 21 Jan 2013 14:02:53 +0100
Message-Id: <1358773378-4700-10-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive tests to the same location.  The code tested the result
of a previous allocation, that itself was already tested.  It is changed to
test the result of the most recent allocation.

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
 drivers/ipack/devices/ipoctal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 8fb2e34..f3a83b1 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -282,7 +282,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	ipoctal->mem8_space =
 		devm_ioremap_nocache(&ipoctal->dev->dev,
 				     region->start, 0x8000);
-	if (!addr) {
+	if (!ipoctal->mem8_space) {
 		dev_err(&ipoctal->dev->dev,
 			"Unable to map slot [%d:%d] MEM8 space!\n",
 			bus_nr, slot);


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3AUMPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:15:36 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:56523
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752985Ab3AUMDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:03:11 -0500
X-IronPort-AV: E=Sophos;i="4.84,506,1355094000"; 
   d="scan'208";a="169187831"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/15] drivers/usb/chipidea/core.c: adjust duplicate test
Date: Mon, 21 Jan 2013 14:02:46 +0100
Message-Id: <1358773378-4700-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive tests to the same location.  In this case res has already
been tested for being NULL, and calling devm_request_and_ioremap will not
make it NULL.  On the other hand, devm_request_and_ioremap can return NULL
on failure.

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
This code could be improved in other ways.  The previous NULL test on res
is not needed, and the dev_err in the error-handling code for the call to
devm_request_and_ioremap is redundant with respect to the logging already
done by devm_request_and_ioremap.  But these should probably be done
separately.

 drivers/usb/chipidea/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index aebf695..57cae1f 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -411,7 +411,7 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 	}
 
 	base = devm_request_and_ioremap(dev, res);
-	if (!res) {
+	if (!base) {
 		dev_err(dev, "can't request and ioremap resource\n");
 		return -ENOMEM;
 	}


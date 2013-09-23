Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3IWSQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:16:17 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:59861 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab3IWSQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:16:08 -0400
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ashley Lai <ashley@ashleylai.com>,
        Rajiv Andrade <mail@srajiv.net>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 02/13] tpm atmel: Call request_region with the correct base
Date: Mon, 23 Sep 2013 12:14:32 -0600
Message-Id: <1379960083-8942-3-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e0dd03caf20d040a0a86b6bd74028ec9bda545f5
changed the code path here so that ateml_get_base_addr
no longer directly altered the tpm_vendor_specific
structure, and instead placed the base address on the stack.

The commit missed updating the request_region call, which
would have resulted in request_region being called with 0
as the base address.

I don't know if request_region(0, ..) will fail, if so the
driver has been broken since 2006 and we should remove it
from the tree as it has no users.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm_atmel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
index 99d6820..c9a528d 100644
--- a/drivers/char/tpm/tpm_atmel.c
+++ b/drivers/char/tpm/tpm_atmel.c
@@ -202,7 +202,7 @@ static int __init init_atmel(void)
 
 	have_region =
 	    (atmel_request_region
-	     (tpm_atmel.base, region_size, "tpm_atmel0") == NULL) ? 0 : 1;
+	     (base, region_size, "tpm_atmel0") == NULL) ? 0 : 1;
 
 	pdev = platform_device_register_simple("tpm_atmel", -1, NULL, 0);
 	if (IS_ERR(pdev)) {
-- 
1.8.1.2


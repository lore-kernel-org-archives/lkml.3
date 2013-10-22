Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab3JVRzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:55:16 -0400
Received: from mout.gmx.net ([212.227.15.19]:64315 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852Ab3JVRy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:54:27 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: james.l.morris@oracle.com, tpmdd-devel@lists.sourceforge.net,
        adlai@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 03/15] tpm atmel: Call request_region with the correct base
Date: Tue, 22 Oct 2013 19:53:48 +0200
Message-Id: <1382464440-7579-3-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1382464440-7579-1-git-send-email-peterhuewe@gmx.de>
References: <1382464440-7579-1-git-send-email-peterhuewe@gmx.de>
X-Provags-ID: V03:K0:eVjXVEbwpYb1V6MPgbFrjPY23ZJbagJ0cQeqhdIM8JQtfQa3C6u
 15kKXeJqD39Cxo8R3uCDDsMldkoGDK8gTJOwwWMgALiKSbd05sW1POZ0xMdmPJwtq+kzUzi
 OSw/dW7VPe3CFBEA+SHRdqu7ci8LSt+MmA8R/7k68TM60680efOPQF1tcgRzx1RuKRIBBFL
 xVMle7FdPT7Cqfqu3qzYw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Commit e0dd03caf20d040a0a86 ("tpm: return chip from
tpm_register_hardware") changed the code path here so that
ateml_get_base_addr no longer directly altered the tpm_vendor_specific
structure, and instead placed the base address on the stack.

The commit missed updating the request_region call, which would have
resulted in request_region being called with 0 as the base address.

I don't know if request_region(0, ..) will fail, if so the
driver has been broken since 2006 and we should remove it
from the tree as it has no users.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Joel Schopp <jschopp@linux.vnet.ibm.com>
Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/char/tpm/tpm_atmel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.7.5.4


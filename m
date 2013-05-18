Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab3ERC2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:28:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab3ERCQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:47 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=V39rdV2UDEsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1LhGZQMNcwQA:10 a=VnNF1IyMAAAA:8 a=uAS_uZ3KAAAA:8 a=VwQbUJbxAAAA:8 a=wMNdZWldAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=OEjQ10uNE_sA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021642.780325507@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 006/136 ] powerpc: Add isync to copy_and_flush
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0006-powerpc-Add-isync-to-copy_and_flush.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Michael Neuling <michael.neuling@au1.ibm.com>

[ Upstream commit 29ce3c5073057991217916abc25628e906911757 ]

In __after_prom_start we copy the kernel down to zero in two calls to
copy_and_flush.  After the first call (copy from 0 to copy_to_here:)
we jump to the newly copied code soon after.

Unfortunately there's no isync between the copy of this code and the
jump to it.  Hence it's possible that stale instructions could still be
in the icache or pipeline before we branch to it.

We've seen this on real machines and it's results in no console output
after:
  calling quiesce...
  returning from prom_init

The below adds an isync to ensure that the copy and flushing has
completed before any branching to the new instructions occurs.

Signed-off-by: Michael Neuling <mikey@neuling.org>
CC: <stable@vger.kernel.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/kernel/head_64.S |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 58bddee..8dd1841 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -489,6 +489,7 @@ _GLOBAL(copy_and_flush)
 	sync
 	addi	r5,r5,8
 	addi	r6,r6,8
+	isync
 	blr
 
 .align 8
-- 
1.7.10.4


